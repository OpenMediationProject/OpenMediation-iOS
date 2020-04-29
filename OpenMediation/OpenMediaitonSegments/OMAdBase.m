// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdBase.h"
#import "OMAdBasePrivate.h"
#import "OMConfig.h"
#import "OMToolUmbrella.h"
#import "OMWaterfallRequest.h"
#import "OMInstanceContainer.h"
#import "OMUnit.h"
#import "OMNetworkUmbrella.h"
#import "OMEventManager.h"
#import "OMMediations.h"
#import "OMLrRequest.h"
#import "OMEventManager.h"
#import "OpenMediation.h"
#import "OMBid.h"

@protocol OMBidCustomEvent<NSObject>
- (void)loadAdWithBidPayload:(NSString *)bidPayload;
@end

#define OMDefaultMaxTimeoutMS     5000

#define OMBidTest   YES //for bid

@implementation OMAdBase

- (instancetype)initWithPlacementID:(NSString*)placementID size:(CGSize)size {
    return [self initWithPlacementID:placementID size:size rootViewController:nil];
}

- (instancetype)initWithPlacementID:(NSString*)placementID size:(CGSize)size rootViewController:(UIViewController*)rootViewController {
    if (self = [super init]) {
        _pid = OM_SAFE_STRING(placementID);
        _showSceneID = @"";
        _size = size;
        _rootViewController = rootViewController;
        self.instanceAdapters = [NSMutableDictionary dictionary];
        self.didLoadAdObjects = [NSMutableDictionary dictionary];
        self.loadBidResponse = [NSMutableDictionary dictionary];
        self.bid = [[OMBid alloc]init];
    }
    return self;
}

- (void)loadAd {
    
}

- (void)preload {
    
}


- (void)loadAd:(OpenMediationAdFormat)adFormat actionType:(OMLoadAction)action {
    OMLogD(@"%@ loadAd action:%zd",self.pid,action);
    if (_loadAction != OMLoadActionManualLoad) {
        [self addEvent:((adFormat == OpenMediationAdFormatBanner)?REFRESH_INTERVAL:ATTEMPT_TO_BRING_NEW_FEED) instance:@"" extraData:nil];
    }

    if (![[OMConfig sharedInstance] consent]) {
        OMLogD(@"%@ load block: gdpr",_pid);
        [self addEvent:LOAD_BLOCKED instance:nil extraData:@{@"msg":@"gdpr"}];
        [self sendDidFailWithErrorType:OMErrorLoadGDPRRefuse];
        return;
    }
    if (_adLoader.loading) {
        OMLogD(@"%@ load block: loading",_pid);
        [self addEvent:LOAD_BLOCKED instance:nil extraData:@{@"msg":@"loading"}];
        return;
    }
    if (![[OMLoadFrequencryControl sharedInstance]allowLoadOnPlacement:_pid]) {
        OMLogD(@"%@ load block: frequency capped",_pid);
        [self addEvent:LOAD_BLOCKED instance:nil extraData:@{@"msg":@"frequency capped"}];
        [self sendDidFailWithErrorType:OMErrorLoadFrequencry];
        return;
    }
    
    [[OMDependTask sharedInstance]addTaskDependOjbect:[OMConfig sharedInstance] keyPath:@"initState" observeValues:@[@"2",@"0"] observeTask:^{
        if (![OMConfig sharedInstance].initSuccess) {
            OMLogD(@"%@ load block: sdk not initialized",self.pid);
            [self addEvent:LOAD_BLOCKED instance:nil extraData:@{@"msg":@"SDK not initialized"}];
            [self sendDidFailWithErrorType:OMErrorLoadInitFailed];
        } else if (![[OMConfig sharedInstance]configContainAdUnit:self.pid]) {
            OMLogD(@"%@ load block: placement not found",self.pid);
            [self addEvent:LOAD_BLOCKED instance:nil extraData:@{@"msg":[NSString stringWithFormat:@"placement not found"]}];
            [self sendDidFailWithErrorType:OMErrorLoadPlacementNotFound];
        } else if (![[OMConfig sharedInstance] isValidAdUnitId:self.pid forAdFormat:adFormat]) {
            OMLogD(@"%@ load block: Invalid placment for adformat = %zd",self.pid,adFormat);
            [self addEvent:LOAD_BLOCKED instance:nil extraData:@{@"msg":[NSString stringWithFormat:@"Invalid placment %@ for adformat = %zd",self.pid,adFormat]}];
            [self sendDidFailWithErrorType:OMErrorLoadPlacementAdTypeIncorrect];
        } else {
            if (!self.loadConfig) {
                self.loadConfig = YES;
                [self loadPlacementConfig];
            }
            [self loadAdWithAction:action];
        }
    } realTaskCheckValues:@[@"0"] realTask:^{
        [OpenMediation initWithAppKey:[OMConfig sharedInstance].appKey];
    }];
}


- (void)loadPlacementConfig {
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:_pid];
    Class loadClass = NSClassFromString((unit.adFormat<OpenMediationAdFormatRewardedVideo?@"OMHybridLoad":@"OMSmartLoad"));
    if (loadClass && [loadClass instancesRespondToSelector:@selector(initWithPid:adFormat:)]) {
        self.adLoader = [[loadClass alloc]initWithPid:_pid adFormat:unit.adFormat];
        self.adLoader.delegate = self;
    }
    _adFormat = unit.adFormat;
}

- (void)loadAdWithAction:(OMLoadAction)action {
    
    self.callLoad = (action == OMLoadActionManualLoad);
    self.replenishLoad = !self.callLoad;
    if ([self isReady]) {
        [self notifyAvailable:YES];
    }
    [self.adLoader loadWithAction:action];
    
}

#pragma mark -- bid

- (NSArray*)bidNetworkItmes:(NSArray*)intances {
    NSMutableArray *bidItems = [NSMutableArray array];
    OMConfig *config = [OMConfig sharedInstance];
    for (NSString *instanceID in intances) {
        OMInstance *bidInstance = [config getInstanceByinstanceID:[NSString stringWithFormat:@"%@",instanceID]];
        if (bidInstance) {
            id adapter = [_instanceAdapters objectForKey:bidInstance.instanceID];
            if (!(adapter && [adapter respondsToSelector:@selector(isReady)] && [adapter isReady] )) {
                NSString *adnName = [config.adnNameMap objectForKey:@(bidInstance.adnID)];
                NSString *appKey = [config.adnAppkeyMap objectForKey:@(bidInstance.adnID)];
                OMBidNetworkItem *bidNetworkItem = [OMBidNetworkItem networkItemWithName:adnName appKey:appKey placementID:bidInstance.adnPlacementID timeOut:((bidInstance.hbt<1000)?OMDefaultMaxTimeoutMS:bidInstance.hbt) test:OMBidTest extra:@{@"instanceID":bidInstance.instanceID}];
                [bidItems addObject:bidNetworkItem];
                [self addEvent:INSTANCE_BID_REQUEST instance:bidInstance.instanceID extraData:nil];
            }
        }
    }
    return [bidItems copy];
}

- (void)getHbInstance:(OMLoadAction)action completionHandler:(hbRequestCompletionHandler)completionHandler {
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:_pid];
    __block NSArray *bidInstances = [NSArray array];
    if (!unit || !unit.hb) {
        OMLogD(@"%@ hb close",self.pid);
        completionHandler(bidInstances);
        return;
    }
    [OMHbRequest requestDataWithPid:_pid actionType:action completionHandler:^(NSDictionary * _Nullable ins, NSError * _Nullable error) {
        if (!error) {
            self.abTest = [[ins objectForKey:@"abt"]boolValue];
            if ([ins objectForKey:@"ins"] && [[ins objectForKey:@"ins"]isKindOfClass:[NSArray class]]) {
                bidInstances = [ins objectForKey:@"ins"];
                OMLogD(@"%@ hb ins %@",self.pid,bidInstances);
 
            }
        }
        completionHandler(bidInstances);
        
    }];
}

- (void)getBidResponses:(OMLoadAction)action completionHandler:(bidCompletionHandler)completionHandler {
    __block NSMutableDictionary *bidSuccessResponses = [NSMutableDictionary dictionary];
    
    [self getHbInstance:action completionHandler:^(NSArray *bidInstances) {
        if (bidInstances && bidInstances.count>0) {
            [self.bid bidWithNetworkItems:[self bidNetworkItmes:bidInstances] adFormat:self.adFormat completionHandler:^(NSDictionary * _Nonnull bidResponses) {
                bidSuccessResponses = [NSMutableDictionary dictionaryWithDictionary:bidResponses];

                NSArray *allBidIns = [bidResponses allKeys];
                for (NSString *instanceID in allBidIns) {
                    OMBidResponse *bidResponse = [bidResponses objectForKey:instanceID];
                    if (bidResponse.isSuccess) {
                        [self addEvent:INSTANCE_BID_RESPONSE instance:instanceID extraData:@{@"bid":@1,@"price":@(bidResponse.price),@"cur":bidResponse.currency}];
                        OMLogD(@"instance %@ bid response price %lf cur %@",instanceID,bidResponse.price,bidResponse.currency);
                    } else {
                        OMLogD(@"instance %@ bid failed",instanceID);
                        [self addEvent:INSTANCE_BID_FAILED instance:instanceID extraData:@{@"msg":bidResponse.errorMsg}];
                        [bidSuccessResponses removeObjectForKey:instanceID];
                    }
                }
                completionHandler(bidSuccessResponses);
            }];
        }else {
            completionHandler(bidSuccessResponses);
        }
    }];
}

- (void)notifyLossBid {
    NSMutableArray *bidInstances = [NSMutableArray arrayWithArray:[_clBidResponse allKeys]];
    NSArray *loadInstances = [_loadBidResponse allKeys];
    [bidInstances removeObjectsInArray:loadInstances];
    
    for (NSString *instanceID in bidInstances) {
        OMBidResponse *bidResponse = [_clBidResponse objectForKey:instanceID];
        [bidResponse loss];
        OMLogD(@"%@ bid loss",instanceID);
        [self addEvent:INSTANCE_BID_LOSE instance:instanceID extraData:nil];
    }
}



#pragma mark -- OMLoadDelegate

- (void)omLoadReqeustWithAction:(OMLoadAction)action {
    if (action == OMLoadActionTimer) {
        self.replenishLoad = YES;
    }
    [self getBidResponses:action completionHandler:^(NSDictionary * _Nonnull bidResponses) {
        
        self.clBidResponse = [bidResponses copy];
        if (self.testInstance && self.testInstance.count>0) {
            [self.adLoader resetContext];
        }
        NSMutableArray *bids = [NSMutableArray array];
        
        for (NSString *instanceID in self.clBidResponse) {
            OMBidResponse *bidResponse = [self.clBidResponse objectForKey:instanceID];
            NSDictionary *bidData = @{@"iid":instanceID,@"price":[NSNumber numberWithDouble:bidResponse.price],@"cur":bidResponse.currency};
            [bids addObject:bidData];
        }

        OMLogD(@"%@ load request with action: %zd",self.pid,action);
        
        [OMLrRequest postWithType:OMLRTypeWaterfallLoad pid:self.pid adnID:0 instanceID:@"" action:self.loadAction scene:@"" abt:self.abTest];//lr load
        
        [self addEvent:LOAD instance:nil extraData:nil];//load event
        
        [OMWaterfallRequest requestDataWithPid:self.pid actionType:action bidResponses:bids completionHandler:^(NSDictionary * _Nullable ins, NSError * _Nullable error) {
            if (!error) {
                self.abTest = [[ins objectForKey:@"abt"]boolValue];
                if ([ins objectForKey:@"ins"] && [[ins objectForKey:@"ins"]isKindOfClass:[NSArray class]]) {

                    NSArray *instancePriority = [ins objectForKey:@"ins"];
                    NSString *instancePriorityStr = [instancePriority componentsJoinedByString:@","];
                    OMLogD(@"%@ waterfall priority %@",self.pid,instancePriorityStr);
                    instancePriority = [[instancePriority componentsJoinedByString:@","]componentsSeparatedByString:@","];
                    
                    if (self.testInstance && self.testInstance.count>0) {
                        [self.adLoader loadWithPriority:self.testInstance];
                    } else {
                        [self.adLoader loadWithPriority:instancePriority];
                    }
                } else {
                    OMLogD(@"%@ waterfall request ins empty",self.pid);
                    [self.adLoader loadWithPriority:@[]];
                }
                
            } else {
                OMLogD(@"%@ waterfall request error:%@",self.pid,error);
                [self.adLoader loadWithPriority:@[]];
            }
        }];
    }];
}


- (void)omLoadInstance:(NSString*)instanceID {
    OMLogD(@"%@ loader load instance:%@",self.pid,instanceID);
    if (![[OMLoadFrequencryControl sharedInstance]allowLoadOnInstance:instanceID]) {
        [self instanceLoadBlockWithError:OMErrorLoadFrequencry instanceID:instanceID];
        return;
    }
    
    OMConfig *config = [OMConfig sharedInstance];
    OMAdNetwork adnID = [config getInstanceAdNetwork:instanceID];
    if (![[OMConfig sharedInstance]getInstanceByinstanceID:instanceID]) {
        OMLogD(@"%@ load instance %@ not found",self.pid,instanceID);
        [self addEvent:INSTANCE_NOT_FOUND instance:instanceID extraData:nil];
        [self instanceLoadBlockWithError:OMErrorLoadInstanceNotFound instanceID:instanceID];
    } else {
        if ([[config adnAppKey:adnID]length]>0) {
            if (![[OMMediations sharedInstance]adnSDKInitialized:adnID]) {
                //mediation init
                [self addEvent:INSTANCE_INIT_START instance:instanceID extraData:nil];
                __weak __typeof(self) weakSelf = self;
                [[OMMediations sharedInstance]initAdNetworkSDKWithId:adnID
                                                   completionHandler:^(NSError * _Nullable error) {
                    if (!error) {
                        OMLogD(@"%@ %@ init success",self.pid,instanceID);
                        [self addEvent:INSTANCE_INIT_SUCCESS instance:instanceID extraData:nil];
                        [weakSelf loadInstance:instanceID];
                    } else {
                        //init failed
                        OMLogD(@"%@ %@ init failed: %@",self.pid,instanceID,error);
                        [self addEvent:INSTANCE_INIT_FAILED instance:instanceID extraData:@{@"msg":[error description]}];
                        [weakSelf instanceLoadBlockWithError:OMErrorLoadInitFailed instanceID:instanceID];
                    }
                }];
            } else {
                [self loadInstance:instanceID];
            }
        } else {
            //key empty;
            OMLogD(@"%@ %@ init failed: key empty",self.pid,instanceID);
            [self addEvent:INSTANCE_INIT_FAILED instance:instanceID extraData:@{@"msg":@"key empty"}];
            [self instanceLoadBlockWithError:OMErrorLoadInitFailed instanceID:instanceID];
        }
    }
}

- (void)loadInstance:(NSString*)instanceID {
    OMBidResponse *instanceBidResponse = [self.clBidResponse objectForKey:instanceID];
    id adapter = [_instanceAdapters objectForKey:instanceID];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    
    if (adapter && [adapter respondsToSelector:@selector(isReady)] && [adapter isReady]) {
        OMLogD(@"%@ load instance %@ ready true",self.pid,instanceID);
        [self addEvent:INSTANCE_LOAD instance:instanceID extraData:nil];
        [self addEvent:INSTANCE_LOAD_SUCCESS instance:instanceID extraData:nil];
        [OMLrRequest postWithType:OMLRTypeInstanceReady pid:self.pid adnID:adnID instanceID:instanceID action:_loadAction scene:@"" abt:self.abTest];//lr ready;
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateSuccess];
    } else if (instanceBidResponse && adapter && [adapter respondsToSelector:@selector(loadAdWithBidPayload:)]) {
           @synchronized (self) {
               [_loadBidResponse setObject:instanceBidResponse forKey:instanceID];
           }
        [instanceBidResponse win];
        [self addEvent:INSTANCE_BID_WIN instance:instanceID extraData:nil];
        OMLogD(@"%@ %@ bid win notice",self.pid,instanceID);
        
        [OMLrRequest postWithType:OMLRTypeInstanceLoad pid:self.pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:_loadAction scene:@"" abt:self.abTest];//lr instance load;
        [self addEvent:INSTANCE_LOAD instance:instanceID extraData:nil];
        [adapter loadAdWithBidPayload:(NSString*)instanceBidResponse.payLoad];
    } else if (adapter && [adapter respondsToSelector:@selector(loadAd)]) {

        OMLogD(@"%@ load instance %@ adapter call load",self.pid,instanceID);
        [OMLrRequest postWithType:OMLRTypeInstanceLoad pid:self.pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:_loadAction scene:@"" abt:self.abTest];//lr instance load;
        [self addEvent:INSTANCE_LOAD instance:instanceID extraData:nil];
        [adapter loadAd];
    }
}

- (void)omLoadInstanceTimeout:(NSString *)instanceID {
    OMLogD(@"%@ load instance %@ timeout",self.pid,instanceID);
    [self addEvent:INSTANCE_LOAD_TIMEOUT instance:instanceID extraData:nil];
}

- (void)instanceLoadBlockWithError:(OMErrorCode)errorType instanceID:(NSString*)instanceID {
    OMLogD(@"%@ load instance block:%zd",self.pid,errorType);
    [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateFail];
}


- (void)omLoadFill:(NSString*)instanceID {
    OMLogD(@"%@ loader fill %@",self.pid,instanceID)
    if (![[OMConfig sharedInstance] consent]) {
        [self sendDidFailWithErrorType:OMErrorLoadGDPRRefuse];
        return;
    }
    
    [OMLrRequest postWithType:OMLRTypeWaterfallReady pid:self.pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:_loadAction scene:@"" abt:self.abTest];//lr ready
    
    
    if (_adFormat <= OpenMediationAdFormatRewardedVideo) {
        [self omDidLoad];
    } else {
        [self addEvent:AVAILABLE_FROM_CACHE instance:instanceID extraData:nil];
        [self notifyAvailable:YES];
    }
}

- (void)omLoadOptimalFill:(NSString*)instanceID {
    OMLogD(@"%@ Optimal fill instance %@",self.pid,instanceID);
    [self notifyAvailable:YES];
}

- (void)omLoadNoFill {
    [self addEvent:NO_MORE_OFFERS instance:nil extraData:nil];
    [self sendDidFailWithErrorType:OMErrorLoadWaterfallFail];
    [self notifyAvailable:NO];
}

- (void)omLoadEnd {
    [self notifyLossBid];
}


- (void)omLoadAddEvent:(NSInteger)eventID extraData:data {
    [self addEvent:eventID instance:nil extraData:data];
}

- (void)sendDidFailWithErrorType:(OMErrorCode)errorCode{
    NSError *error = [OMError omErrorWithCode:errorCode];
    NSError *developerError = [OMSDKError errorWithAdtError:error];
    [OMSDKError throwDeveloperError:developerError];
    _callLoad = NO;
    [self performSelector:@selector(omDidFail:) withObject:developerError afterDelay:0.5];
}

- (void)omDidLoad {
    
}

- (void)omDidFail:(NSError*)error {
    
}

- (void)notifyAvailable:(BOOL)avalible {
    if (self.replenishLoad) {
        [self addEvent:AVAILABLE_FROM_CACHE instance:_adLoader.optimalFillInstance extraData:nil];
        self.replenishLoad = NO;
    }
    if ((_callLoad || (_adAvailable != avalible)) && (!_adLoader.adShow ||!avalible)) {
        [self omDidChangedAvailable:avalible];
        OMLogD(@"notify %@ available change %zd",self.pid,(NSInteger)avalible);
        _callLoad = NO;
        _adAvailable =  avalible;
    }
}

- (void)omDidChangedAvailable:(BOOL)available {
    OMLogD(@"%@ change available:%zd",self.pid,(NSInteger)available);
}

#pragma mark -- isReady

- (BOOL)isReady {
    BOOL isReady = NO;
    if ([[OMConfig sharedInstance] consent] && _adLoader && [_adLoader isReady] && !_adLoader.adShow) {
        isReady = YES;
    }
    return isReady;
}



#pragma mark -- OMCustomEventDelegate


- (void)customEvent:(id)instanceAdapter didLoadAd:(id)didLoadAd {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    if (instanceID) {
        OMLogD(@"%@ instance %@ load success",self.pid,instanceID);
        [OMLrRequest postWithType:OMLRTypeInstanceReady pid:self.pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:_loadAction scene:@"" abt:self.abTest];//lr ready
        
        [self addEvent:INSTANCE_LOAD_SUCCESS instance:instanceID extraData:nil];
        if (didLoadAd) {
            [_didLoadAdObjects setObject:didLoadAd forKey:instanceID];
        }
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateSuccess];
    }
}

- (void)customEvent:(id)adapter didFailToLoadWithError:(NSError*)error {
    NSString *instanceID = [self checkInstanceIDWithAdapter:adapter];
    if (instanceID) {
        NSString *errorMsg = [error isKindOfClass:[NSError class]]?[error description]:@"";
        OMLogD(@"%@ instance %@ load fail error %@",self.pid,instanceID,errorMsg);
        [self addEvent:INSTANCE_LOAD_ERROR instance:instanceID extraData:@{@"msg":errorMsg}];
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateFail];
    }
}



#pragma mark -- show

- (void)showInstance:(id)instanceID {
    if (!OM_STR_EMPTY(instanceID)) {
        [[OMInstanceContainer sharedInstance]removeImpressionInstance:instanceID];
        [self addEvent:INSTANCE_SHOW instance:instanceID extraData:nil];
    }
}

- (void)adshow:(id)instanceAdapter {
    self.adLoader.adShow = YES;
    [self notifyAvailable:NO];
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMLogD(@"%@ instance %@ show",self.pid,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_SHOW_SUCCESS instance:instanceID extraData:nil];
    [OMLrRequest postWithType:OMLRTypeInstanceImpression pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:self.abTest];
    
    
    [[OMLoadFrequencryControl sharedInstance]recordImprOnPlacement:_pid sceneID:self.showSceneID];
    [[OMLoadFrequencryControl sharedInstance]recordImprOnInstance:OM_SAFE_STRING(instanceID)];
}

- (void)adShowFail:(id)instanceAdapter {
    self.adLoader.adShow = NO;
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMLogD(@"%@ instance %@ show fail",self.pid,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_SHOW_FAILED instance:instanceID extraData:nil];
    [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateWait];
    [self loadAd:_adFormat actionType:OMLoadActionCloseEvent];
}

- (void)adClick:(id)instanceAdapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMLogD(@"%@ instance %@ click",self.pid,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_CLICKED instance:instanceID extraData:nil];
    [OMLrRequest postWithType:OMLRTypeInstanceClick pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:self.abTest];
    
    
    
}

- (void)adVideoStart:(id)instanceAdapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMLogD(@"%@ instance %@ video start",self.pid,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_VIDEO_START instance:instanceID extraData:nil];
    [OMLrRequest postWithType:OMLRTypeVideoStart pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:self.abTest];
}

- (void)adVideoComplete:(id)instanceAdapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    
    OMLogD(@"%@ instance %@ video start",self.pid,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_VIDEO_COMPLETED instance:instanceID extraData:nil];
    [OMLrRequest postWithType:OMLRTypeVideoComplete pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:self.abTest];
}

- (void)adClose:(id)instanceAdapter {
    self.adLoader.adShow = NO;
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMLogD(@"%@ instance %@ close",self.pid,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_CLOSED instance:instanceID extraData:nil];
    [self.adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateWait];
    [self loadAd:_adFormat actionType:OMLoadActionCloseEvent];
}

- (void)adReceiveReward:(id)instanceAdapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    
    OMLogD(@"%@ instance %@ receive reward",self.pid,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_VIDEO_REWARDED instance:instanceID extraData:nil];
}


- (NSString*)checkInstanceIDWithAdapter:(id)adapter {
    NSString *adapterInstanceID = @"";
    NSArray *instanceIDs = [_instanceAdapters allKeys];
    for (NSString *instanceID in instanceIDs) {
        id instanceAdapter = [_instanceAdapters objectForKey:instanceID];
        if (adapter == instanceAdapter) {
            adapterInstanceID = instanceID;
            break;
        }
    }
    return adapterInstanceID;
}


- (void)dealloc{
    [self addEvent:DESTROY instance:nil extraData:nil];
}



#pragma mark -- addEvent

- (void)addEvent:(NSInteger)eventID instance:(NSString*)instanceID extraData:data {
    
    NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
    if (data) {
        [wrapperData addEntriesFromDictionary:data];
    }
    OMConfig *config = [OMConfig sharedInstance];
    [wrapperData setObject:[NSNumber omStr2Number:_pid] forKey:@"pid"];
    if (self.abTest) {
        [wrapperData setObject:[NSNumber numberWithInteger:self.abTest] forKey:@"abt"];
    }
    if (!OM_STR_EMPTY(instanceID)) {
        OMAdNetwork adnID = [config getInstanceAdNetwork:instanceID];
        [wrapperData setObject:[NSNumber omStr2Number:instanceID] forKey:@"iid"];
        [wrapperData setObject:[NSNumber numberWithInteger:adnID] forKey:@"mid"];
        
        if ([_adLoader.priorityList containsObject:instanceID]) {
            [wrapperData setObject:[NSNumber numberWithInteger:[_adLoader.priorityList indexOfObject:instanceID]] forKey:@"priority"];
        }else {
            OMLogD(@"instance %@ not in priorityList %@",instanceID,[_adLoader.priorityList componentsJoinedByString:@","])
        }
        
        [wrapperData setObject:[NSNumber numberWithInteger:_adLoader.cacheCount] forKey:@"cs"];
        NSDictionary *adNetworkInfo = [[[OMMediations sharedInstance]adNetworkInfo]objectForKey:@(adnID)];
        if (adNetworkInfo) {
            [wrapperData addEntriesFromDictionary:adNetworkInfo];
        }
    }
    
    [[OMEventManager sharedInstance] addEvent:eventID extraData:wrapperData];
}

#pragma mark -- test

-(void)testI:(NSArray *)instanceIDArray {
    if (!instanceIDArray) {
        return;
    } else {
        self.testInstance = instanceIDArray;
    }
}



@end
