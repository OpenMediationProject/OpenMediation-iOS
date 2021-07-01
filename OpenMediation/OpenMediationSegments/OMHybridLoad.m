// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHybridLoad.h"
#import "OMConfig.h"

@implementation OMHybridLoad

- (instancetype)initWithPid:(NSString*)pid adFormat:(OpenMediationAdFormat)format {
    if (self = [super initWithPid:pid adFormat:format]) {

    }
    return self;
}

- (void)loadWithAction:(OMLoadAction)action {
    [super loadWithAction:action];
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:self.pid];
    if (!unit || unit.batchSize <= 0) {
        _batchSize = 2;
        OMLogD(@"%@ batch size use default %zd",self.pid,self.batchSize);
    } else {
        _batchSize = unit.batchSize;
        _fanoutType = unit.fanout;
    }
    [self requestWaterfallWithAction:action];
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
    self.instanceLoadState = [NSMutableDictionary dictionary];
    self.optimalFillInstance = @"";
    if (![insPriority isKindOfClass:[NSArray class]] || insPriority.count == 0) {
        OMLogD(@"%@ load priority empty",self.pid);
        [self notifyNoFill];
        [self notifyLoadEnd];
        return;
    }
    self.priorityList = insPriority;
    [self groupByBatchSize:_batchSize];
    [self loadGroupInstane];

}


- (void)checkOptimalInstance {
    BOOL checkOptimalInstance = NO;
    for (int i=0; i< [self.priorityList count]; i++) {
        NSString *instanceID = self.priorityList[i];
        OMInstanceLoadState loadState = [self.instanceLoadState[instanceID]integerValue];
        if (loadState >= (_fanoutType?OMInstanceLoadStateLoading:OMInstanceLoadStateFail) && loadState < OMInstanceLoadStateSuccess) {
            continue;
        } else if (loadState == OMInstanceLoadStateSuccess) {
            checkOptimalInstance = YES;
            self.optimalFillInstance = instanceID;
            break;
        } else {
            //need wait high priority;
            break;
        }
    }
    if (checkOptimalInstance) {
        [self notifyOptimalFill];
        [self notifyFill:self.optimalFillInstance];
        [self notifyLoadEnd];
    } else {
        BOOL noFill = YES;
        for (int i=0; i< [self.priorityList count]; i++) {
            NSString *instanceID = self.priorityList[i];
            OMInstanceLoadState loadState = [self.instanceLoadState[instanceID]integerValue];
            if (loadState <= OMInstanceLoadStateLoading) {
                noFill = NO;
                break;
            }
        }
        if (noFill) {
            [self notifyNoFill];
            [self notifyLoadEnd];
        }
    }
}

- (void)addLoadingInstance {
    if (!self.notifyLoadResult) {
        BOOL groupLoadFinish = YES;
        NSInteger loadingGroupIndex = self.loadIndex -1 ;
        if (loadingGroupIndex < self.loadGroups.count) {
            NSArray *group = self.loadGroups[loadingGroupIndex];
            for (NSString *instanceID in group) {
                OMInstanceLoadState loadState = [self.instanceLoadState[instanceID]integerValue];
                if (loadState <= OMInstanceLoadStateLoading) {
                    groupLoadFinish = NO;
                }
            }
        }
        if (groupLoadFinish) {
           [self loadGroupInstane];
        }
    }
}

@end
