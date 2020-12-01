// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSmartLoad.h"
#import "OMLogMoudle.h"
#import "OMConfig.h"
#import "OMWeakObject.h"
#import "OMEventManager.h"

@implementation OMSmartLoad

- (instancetype)initWithPid:(NSString*)pid adFormat:(OpenMediationAdFormat)format {
    if (self = [super initWithPid:pid adFormat:format]) {
        OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:self.pid];
        if (!unit || unit.batchSize <= 0) {
            _maxParallelLoadCount = 2;
            OMLogD(@"%@ max parallel load use default %zd",self.pid,_maxParallelLoadCount);
        } else {
            _maxParallelLoadCount = unit.batchSize;
        }
        
        if (!unit || unit.cacheCount <= 0) {
            self.configCacheCount = 2;
            OMLogD(@"%@ cache use default %zd",self.pid,self.cacheCount);
        } else {
            self.configCacheCount = unit.cacheCount;
        }
        self.cacheCount = self.configCacheCount;
        [self addCheckCacheTimer];
    }
    return self;
}

- (void)addCheckCacheTimer {
    if (self.checkCacheTimer) {
        [self.checkCacheTimer invalidate];
        self.checkCacheTimer = nil;
    }
    
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:self.pid];
    if (unit) {
        NSInteger refreshLevel = 0;
        for (refreshLevel=0; (refreshLevel<unit.refreshLevels.count); refreshLevel++) {
            if (self.replenishCacheNofillCount < [unit.refreshLevels[refreshLevel] integerValue]) {
                break;
            }
        }
        refreshLevel = (refreshLevel < unit.refreshTimes.count)?refreshLevel:unit.refreshTimes.count-1;
        
        if (refreshLevel >=0 && refreshLevel < unit.refreshTimes.count) {
            NSInteger refreshSecond = [unit.refreshTimes[refreshLevel] integerValue];
               if (refreshSecond >0 ) {
                   self.checkCacheTimer = [NSTimer scheduledTimerWithTimeInterval:refreshSecond target:[OMWeakObject proxyWithTarget:self] selector:@selector(checkCache) userInfo:nil repeats:NO];
                   [[NSRunLoop currentRunLoop] addTimer:self.checkCacheTimer forMode:NSRunLoopCommonModes];
                   OMLogD(@"%@  refresh level %zd timer interval %zd",self.pid,refreshLevel,refreshSecond);
               }
        }
    }

}



- (void)checkCache {
    [self addCheckCacheTimer];
    [self addEvent:ATTEMPT_TO_BRING_NEW_FEED extraData:nil];
    [self loadWithAction:OMLoadActionTimer];
}


- (void)loadWithAction:(OMLoadAction)action {
    [super loadWithAction:action];
    [self checkOptimalInstance];
    if (self.adShow) {
         OMLogD(@"%@ smart load block: adshow",self.pid);
        [self addEvent:LOAD_BLOCKED extraData:@{@"msg":@"ad show"}];
    } else if (_cacheReadyCount >= self.cacheCount) {
        OMLogD(@"%@ smart load block: cache full",self.pid);
        [self addEvent:LOAD_BLOCKED extraData:@{@"msg":@"cache full"}];
    } else if (self.loading) {
        OMLogD(@"%@ smart load block: loading",self.pid);
        [self addEvent:LOAD_BLOCKED extraData:@{@"msg":@"smartload loading"}];
    }else {
        [self requestWaterfallWithAction:action];
    }
    
}

- (BOOL)isReady {
    BOOL isReady = NO;
    self.optimalFillInstance = @"";
    for (NSString *instanceID in self.priorityList) {
        OMInstanceLoadState loadState = [self.instanceLoadState[instanceID]integerValue];
        if (loadState == OMInstanceLoadStateSuccess && [self.delegate omCheckInstanceReady:instanceID]) {
            self.optimalFillInstance =  instanceID;
            isReady = YES;
            break;
        }
    }
    return isReady;
}


- (void)loadWithPriority:(NSArray *)insPriority {
    [super loadWithPriority:insPriority];
    _loadingCount = 0;
    _loadSuccessCount = _cacheReadyCount;
    if (insPriority && [insPriority isKindOfClass:[NSArray class]]) {
        NSMutableArray *priorityList = [NSMutableArray arrayWithArray:insPriority];
        for (NSString *instanceID in self.instanceLoadState) {
            if ([[self.instanceLoadState objectForKey:instanceID]integerValue] == OMInstanceLoadStateSuccess && ![priorityList containsObject:instanceID]) {
                [priorityList addObject:instanceID];
                OMLogD(@"%@ add ready instance %@ to priority end",self.pid,instanceID);
            }
        }
        self.priorityList = priorityList;
    }
    
    if (self.priorityList.count == 0) {
        OMLogD(@"%@ priority empty",self.pid);
        [self notifyNoFill];
        [self notifyLoadEnd];
    } else {
        NSString *instancePriorityStr = [self.priorityList componentsJoinedByString:@","];
        OMLogD(@"%@ load with priority %@",self.pid,instancePriorityStr);
        self.cacheCount = MIN(self.priorityList.count, self.configCacheCount);
        OMLogD(@"%@ priority count less than cache count use min %zd ",self.pid,self.cacheCount);
        [self checkOptimalInstance];
        [self groupByBatchSize:1];
        [self addLoadingInstance];
    }
    
}

- (void)saveInstanceLoadState:(NSString*)instanceID state:(OMInstanceLoadState)loadState {
    OMInstanceLoadState currentLoadState = [self.instanceLoadState[instanceID]integerValue];
    if ((currentLoadState == OMInstanceLoadStateLoading || currentLoadState == OMInstanceLoadStateTimeout) && loadState == OMInstanceLoadStateSuccess) {
        _loadSuccessCount ++;
        OMLogD(@"%@ load success count %zd",self.pid,_loadSuccessCount);
    }
    [super saveInstanceLoadState:instanceID state:loadState];


}


- (void)checkOptimalInstance {
    _loadingCount = 0;
    _cacheReadyCount = 0;
    self.optimalFillInstance = @"";
    for (NSString *instanceID in self.priorityList) {
        OMInstanceLoadState loadState = [self.instanceLoadState[instanceID]integerValue];
        if (loadState == OMInstanceLoadStateLoading) {
            _loadingCount++;
        } else if (loadState == OMInstanceLoadStateSuccess && [self.delegate omCheckInstanceReady:instanceID]) {
            if (![self.optimalFillInstance length]) {
                self.optimalFillInstance =  instanceID;
            }
            _cacheReadyCount++;
        }
    }
    
    OMLogD(@"%@ loading %zd success %zd ready %zd cache %zd",self.pid,_loadingCount,_loadSuccessCount,_cacheReadyCount,self.cacheCount);
    
    if ([self.optimalFillInstance length]>0) {
        [self notifyOptimalFill];
        [self notifyFill:self.optimalFillInstance];
        self.replenishCacheNofillCount = 0;//reset replenishCacheNofillCount
        OMLogD(@"%@ reset replenish no fill count 0",self.pid);
        if (_loadSuccessCount >= self.cacheCount) {
            OMLogD(@"%@ cache full,success %zd cache %zd",self.pid,_loadSuccessCount,self.cacheCount);
            [self notifyLoadEnd];
        }
    }
    
    if (_loadingCount == 0 && self.loadIndex >= self.priorityList.count) {
        if (![self.optimalFillInstance length]) {
            if (!self.notifyLoadResult) {
                self.replenishCacheNofillCount++;
            }
            [self notifyNoFill];

        }
        [self notifyLoadEnd];
    }
}


- (void)addLoadingInstance {
    OMLogD(@"%@ loading %zd success %zd ready %zd cache %zd mpc %zd",self.pid,_loadingCount,_loadSuccessCount,_cacheReadyCount,self.cacheCount,_maxParallelLoadCount);
    if ((_loadingCount + _loadSuccessCount < self.cacheCount) && (_loadingCount < _maxParallelLoadCount)) {
        if (self.loadIndex < self.priorityList.count) {
            NSString *instanceID = self.priorityList[self.loadIndex];
            if ([[self.instanceLoadState objectForKey:instanceID]integerValue] == OMInstanceLoadStateSuccess) {
                self.loadIndex++;
                [self addLoadingInstance];
            } else {
                [self loadGroupInstane];
            }
        }
    }
}

@end
