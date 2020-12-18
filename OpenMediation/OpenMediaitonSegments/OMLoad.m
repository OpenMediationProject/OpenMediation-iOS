// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMLoad.h"
#import "OMWaterfallRequest.h"
#import "OMConfig.h"
#import "OMWaterfallRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"

@implementation OMLoad

- (instancetype)initWithPid:(NSString*)pid adFormat:(OpenMediationAdFormat)format {
    if (self = [super init]) {
        _actionName = @[@"init",@"timer",@"close",@"manual"];
        _stateName = @[@"wait",@"loading",@"fail",@"timeout",@"success",@"callShow"];
        _priorityList = @[];
        _instanceLoadState = [NSMutableDictionary dictionary];
        _pid = OM_SAFE_STRING(pid);
        _adFormat = format;
        
        OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:self.pid];
        if (!unit || unit.batchTimeout <= 0) {
            _timeoutSecond = 15;
            OMLogD(@"%@ timeout use default %zd",self.pid,_timeoutSecond);
        } else {
            _timeoutSecond = unit.batchTimeout;
        }
    }
    return self;
}

- (void)loadWithAction:(OMLoadAction)action {
    if (action >= OMLoadActionInit && action <= OMLoadActionManualLoad ) {
        OMLogD(@"%@ load with action %@",_pid,_actionName[(action-1)]);
    }
}

- (void)requestWaterfallWithAction:(OMLoadAction)action {
    if (action >= OMLoadActionInit && action <= OMLoadActionManualLoad ) {
        OMLogD(@"%@ request waterfall with action %@",_pid,_actionName[(action-1)]);
    }

    if (_delegate && [_delegate respondsToSelector:@selector(omLoadReqeustWithAction:)]) {
        [_delegate omLoadReqeustWithAction:action];
    }
}

- (BOOL)isReady {
    return NO;
}

- (void)loadWithPriority:(NSArray *)insPriority {
    _notifyLoadResult = NO;
    _loading = YES;
    _loadIndex = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    OMLogD(@"%@ load start",self.pid);
}

- (void)resetContext {
    _instanceLoadState = [NSMutableDictionary dictionary];
}

- (void)groupByBatchSize:(NSInteger)batchSize {
    _loadGroups = [NSMutableArray array];
    if (batchSize > [_priorityList count]) {
        batchSize = [_priorityList count];
    }
    
    for (int i=0; i<[_priorityList count]; i+=batchSize) {
        NSMutableArray *group = [NSMutableArray array];
        NSMutableArray *adns = [NSMutableArray array];
        for (int k=i; k<(i+batchSize)&&k<[_priorityList count] ; k++) {
            [group addObject:_priorityList[k]];
            OMAdNetwork adn =  [[OMConfig sharedInstance] getInstanceAdNetwork:_priorityList[k]];
            [adns addObject:[NSNumber numberWithInteger:adn]];
        }
        
        [_loadGroups addObject:group];
        OMLogD(@"%@ group = %@, adn = %@",self.pid,[group componentsJoinedByString:@","],[adns componentsJoinedByString:@","]);
    }
}

- (void)loadGroupInstane {
    if (_loadIndex < _loadGroups.count) {
        [self performSelector:@selector(loadGroupTimeout:) withObject:@(_loadIndex) afterDelay:_timeoutSecond];
        NSArray *group = _loadGroups[_loadIndex];
        _loadIndex++;
        for (NSString *instanceID in group) {
            [self saveInstanceLoadState:instanceID state:OMInstanceLoadStateLoading];
            if (_delegate && [_delegate respondsToSelector:@selector(omLoadInstance:)]) {
                [_delegate omLoadInstance:instanceID];
            }
        }

    }
}

- (void)loadGroupTimeout:(NSNumber*)groupIndex {
    OMLogD(@"%@ group %@ timeout",self.pid,groupIndex);
    NSInteger index = [groupIndex integerValue];
    if (index < _loadGroups.count) {
        NSArray *group = _loadGroups[index];
        for (NSString *instanceID in group) {
            OMInstanceLoadState state = [_instanceLoadState[instanceID]integerValue];
            if (state == OMInstanceLoadStateLoading) {
                [self saveInstanceLoadState:instanceID state:OMInstanceLoadStateTimeout];
                if (_delegate && [_delegate respondsToSelector:@selector(omLoadInstanceTimeout:)]) {
                    [_delegate omLoadInstanceTimeout:instanceID];
                }
            }
        }
    }
}

- (void)saveInstanceLoadState:(NSString*)instanceID state:(OMInstanceLoadState)loadState {
    OMInstanceLoadState currentLoadState = [_instanceLoadState[instanceID]integerValue];
    if (OM_STR_EMPTY(instanceID) || (loadState<0) || (loadState > OMInstanceLoadStateCallShow) ||  ((currentLoadState == OMInstanceLoadStateWait) && loadState >OMInstanceLoadStateLoading)) {
        OMLogD(@"%@ instance %@ load state %zd",_pid,OM_SAFE_STRING(instanceID),(long)loadState);
    } else {
        OMLogD(@"%@ instance %@ load state %@",_pid,instanceID,self.stateName[loadState]);;
        _instanceLoadState[instanceID] = [NSNumber numberWithInteger:loadState];
    
        [self checkOptimalInstance];
        [self addLoadingInstance];
        
    }
}

- (void)checkOptimalInstance {
    
}

- (void)addLoadingInstance {
    
}

- (void)notifyFill:(NSString*)instanceID {
    if (!_notifyLoadResult) {
        _notifyLoadResult = YES;
        OMLogD(@"%@ fill:%@",self.pid,instanceID);
        if (_delegate && [_delegate respondsToSelector:@selector(omLoadFill:)]) {
            [_delegate omLoadFill:instanceID];
        }
    }
}

- (void)notifyOptimalFill {
    OMLogD(@"%@ optimal fill:%@",self.pid,self.optimalFillInstance);
    if (_delegate && [_delegate respondsToSelector:@selector(omLoadOptimalFill:)]) {
        [_delegate omLoadOptimalFill:self.optimalFillInstance];
    }
}

- (void)notifyNoFill {
    if (!_notifyLoadResult) {
        _notifyLoadResult = YES;
        OMLogD(@"%@ nofill",self.pid);
        if (_delegate && [_delegate respondsToSelector:@selector(omLoadNoFill)]) {
            [_delegate omLoadNoFill];
        }
    }
}

- (void)notifyLoadEnd {
    if (_loading) {
        _loading = NO;
        OMLogD(@"%@ load end",self.pid);
        if (_delegate && [_delegate respondsToSelector:@selector(omLoadNoFill)]) {
            [_delegate omLoadEnd];
        }
    }
}

- (void)addEvent:(NSInteger)eventID extraData:data {
    if (_delegate && [_delegate respondsToSelector:@selector(omLoadAddEvent:extraData:)]) {
        [_delegate omLoadAddEvent:eventID extraData:data];
    }
}

@end
