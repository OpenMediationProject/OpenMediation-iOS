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
        self.fillInstances = [NSMutableArray array];
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
                   OMLogD(@"%@ refresh level %zd timer interval %zd",self.pid,refreshLevel,refreshSecond);
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
    } else if (_cacheCount >= self.configCacheCount && self.configCacheCount>0) {
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
    if (!isReady && self.fillInstances.count >0) {
        self.optimalFillInstance =  self.fillInstances[0];
        OMLogD(@"%@ no cache instance ready, use preload instance %@",self.pid,self.optimalFillInstance);
        isReady = YES;
    }
    return isReady;
}


- (void)loadWithPriority:(NSArray *)insPriority {
    [super loadWithPriority:insPriority];
    
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:self.pid];
    if (!unit || unit.batchSize <= 0) {
        _maxParallelLoadCount = 2;
        OMLogD(@"%@ max parallel load use default %zd",self.pid,_maxParallelLoadCount);
    } else {
        _maxParallelLoadCount = unit.batchSize;
    }
    
    if (!unit || unit.cacheCount <= 0) {
        self.unitCacheCount = 2;
        OMLogD(@"%@ cache use default %zd",self.pid,self.configCacheCount);
    } else {
        self.unitCacheCount = unit.cacheCount;
    }
    self.configCacheCount = self.unitCacheCount;
    
    _loadingCount = 0;
    if (insPriority && [insPriority isKindOfClass:[NSArray class]]) {
        self.priorityList = insPriority;
    }
    
    NSMutableDictionary *instanceLoadState = [NSMutableDictionary dictionary];
    for (NSString *instanceID in self.instanceLoadState) {
        if ([[self.instanceLoadState objectForKey:instanceID]integerValue] >= OMInstanceLoadStateSuccess) {
            [instanceLoadState setObject:[self.instanceLoadState objectForKey:instanceID] forKey:instanceID];
        }
    }
    self.instanceLoadState = instanceLoadState;
    if (self.priorityList.count == 0 && !self.fillInstances.count) {
        OMLogD(@"%@ load priority empty",self.pid);
        [self notifyNoFill];
        [self notifyLoadEnd];
    } else {
        NSString *instancePriorityStr = [self.priorityList componentsJoinedByString:@","];
        OMLogD(@"%@ load with priority %@",self.pid,instancePriorityStr);
        if (self.priorityList.count < self.unitCacheCount) {
            self.configCacheCount = self.priorityList.count;
            OMLogD(@"%@ priority count less than cache count use min %zd ",self.pid,self.configCacheCount);
        }
        [self checkOptimalInstance];
        [self groupByBatchSize:1];
        [self addLoadingInstance];
    }
    
}

- (void)saveInstanceLoadState:(NSString*)instanceID state:(OMInstanceLoadState)loadState {
    if (loadState == OMInstanceLoadStateSuccess && [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID]) {
        [self.fillInstances addObject:instanceID];
    }else if (loadState == OMInstanceLoadStateCallShow) {
        [self.fillInstances removeObject:instanceID];
    }
    [super saveInstanceLoadState:instanceID state:loadState];
}


- (void)checkOptimalInstance {
    _loadingCount = 0;
    _cacheCount = 0;
    self.optimalFillInstance = @"";
    for (NSString *instanceID in self.priorityList) {
        OMInstanceLoadState loadState = [self.instanceLoadState[instanceID]integerValue];
        if (loadState == OMInstanceLoadStateLoading) {
            _loadingCount++;
        } else if (loadState == OMInstanceLoadStateCallShow || (loadState == OMInstanceLoadStateSuccess && [self.delegate omCheckInstanceReady:instanceID])) {
            if (![self.optimalFillInstance length]) {
                self.optimalFillInstance =  instanceID;
            }
            _cacheCount++;
        }
    }
    OMLogD(@"%@ loading configCache %zd cache %zd instance %@ loading %zd maxLoadCount %zd",self.pid,self.configCacheCount,self.cacheCount,[self.fillInstances componentsJoinedByString:@"," ],(long)self.loadingCount,self.maxParallelLoadCount);
    if (!_cacheCount) {
        if (self.fillInstances.count>0) {
            self.optimalFillInstance = self.fillInstances[0];
            OMLogD(@"%@ no cache instance,, use preload instance %@",self.pid,self.optimalFillInstance);
        }
    }
    
    if ([self.optimalFillInstance length]>0) {
        [self notifyOptimalFill];
        [self notifyFill:self.optimalFillInstance];
        self.replenishCacheNofillCount = 0;//reset replenishCacheNofillCount
        OMLogD(@"%@ reset replenish no fill count 0",self.pid);
        if (self.cacheCount >= self.configCacheCount) {
            OMLogD(@"%@ cache full,configCache %zd cache %zd instance %@",self.pid,self.configCacheCount,self.cacheCount,[self.fillInstances componentsJoinedByString:@","]);
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
    if (self.loading && (self.loadingCount + self.cacheCount < self.configCacheCount) && (self.loadingCount < self.maxParallelLoadCount)) {
        if (self.loadIndex < self.priorityList.count) {
            NSString *instanceID = self.priorityList[self.loadIndex];
            if ([[self.instanceLoadState objectForKey:instanceID]integerValue] >= OMInstanceLoadStateSuccess) {
                self.loadIndex++;
                [self checkOptimalInstance];
                [self addLoadingInstance];
            } else {
                [self loadGroupInstane];
            }
        }
    }
}

@end
