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
#import "OMInterstitialCustomEvent.h"
#import "OMBidNetworkItem.h"
#import "OMBidResponse.h"
#import "OMImpressionDataRouter.h"
#import "OMUserData.h"


#define OMDefaultMaxTimeoutMS     5000

#define OMBidTest   YES //for bid

@interface OpenMediation()
+ (void)initWithAppKey:(NSString*)appKey baseHost:(nonnull NSString *)host;
@end

@interface OMImpressionData()
- (instancetype)initWithUnit:(OMUnit*)unit  instance:(OMInstance*)instance scene:(OMScene*)scene;
@end

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
        self.didLoadAdnName = [NSMutableDictionary dictionary];
        self.loadedInstanceBidResponses = [NSMutableDictionary dictionary];
        self.bid = [[OMBid alloc]init];
        self.bid.delegate = self;
    }
    return self;
}

- (void)loadAd {
    
}

- (void)preload {
    
}


- (void)loadAd:(OpenMediationAdFormat)adFormat actionType:(OMLoadAction)action {
    OMLogD(@"%@ loadAd action:%zd",self.pid,action);
    if (action == OMLoadActionManualLoad) {
        self.callLoad = YES;
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
            [self loadAdWithAction:action];
        }
    } realTaskCheckValues:@[@"0"] realTask:^{
        [OpenMediation initWithAppKey:[OMConfig sharedInstance].appKey baseHost:[OMConfig sharedInstance].baseHost];
    }];
}

- (void)loadAdWithAction:(OMLoadAction)action {
    
    if (!self.adLoader) {
        OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:_pid];
        _adFormat = unit.adFormat;
        Class loadClass = NSClassFromString(((unit.adFormat<OpenMediationAdFormatNative || unit.adFormat == OpenMediationAdFormatSplash)?@"OMHybridLoad":@"OMSmartLoad"));
        if (loadClass && [loadClass instancesRespondToSelector:@selector(initWithPid:adFormat:)]) {
            self.adLoader = [[loadClass alloc]initWithPid:_pid adFormat:unit.adFormat];
            self.adLoader.delegate = self;
        }
    }
    
    if (action != OMLoadActionManualLoad) {
        [self addEvent:((_adFormat == OpenMediationAdFormatBanner)?REFRESH_INTERVAL:ATTEMPT_TO_BRING_NEW_FEED) instance:@"" extraData:nil];
        if (![OMConfig sharedInstance].autoCache) {
            OMLogD(@"%@ load block: auto cache off",_pid);
            [self addEvent:LOAD_BLOCKED instance:nil extraData:@{@"msg":@"auto cache off"}];
            return;
        }
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
    
    if ((_adFormat == OpenMediationAdFormatInterstitial || _adFormat == OpenMediationAdFormatRewardedVideo) && [self isReady] && [self isAdAvailable]) {
        [self notifyAvailable:YES];
    } else if(_adFormat == OpenMediationAdFormatNative && self.callLoad && [self isReady] && [self isAdAvailable]) {
        self.callLoad = NO;
        [self omDidLoad];
    }
    [self.adLoader loadWithAction:action];
    
}

#pragma mark - bid

- (NSArray*)bidNetworkItmes:(NSArray*)intances {
    NSMutableArray *bidItems = [NSMutableArray array];
    OMConfig *config = [OMConfig sharedInstance];
    for (NSString *instanceID in intances) {
        OMInstance *bidInstance = [config getInstanceByinstanceID:[NSString stringWithFormat:@"%@",instanceID]];
        bidInstance.wfReqId = self.wfReqId;
        if (self.wfRule) {
            bidInstance.ruleId = [[self.wfRule objectForKey:@"id"] integerValue];
        }
        if (bidInstance) {
            NSString *adnName = [config.adnNameMap objectForKey:@(bidInstance.adnID)];
            NSString *appKey = [config.adnAppkeyMap objectForKey:@(bidInstance.adnID)];
            OMBidNetworkItem *bidNetworkItem = [OMBidNetworkItem networkItemWithName:adnName appKey:appKey placementID:bidInstance.adnPlacementID timeOut:((bidInstance.hbt<1000)?OMDefaultMaxTimeoutMS:bidInstance.hbt) test:OMBidTest extra:@{@"unitID":self.pid,@"instanceID":bidInstance.instanceID,@"adnID":[NSNumber numberWithInteger:bidInstance.adnID],@"prefix":@"OM"}];
            [bidItems addObject:bidNetworkItem];
        }
    }
    return [bidItems copy];
}

- (NSDictionary*)checkReadyloadedInstanceBidResponses {
    NSMutableDictionary *bidResponses = [NSMutableDictionary dictionary];
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:_pid];
    if (unit) {
        OMLogD(@"%@ instance bid responses %@",self.pid,[[self.loadedInstanceBidResponses allKeys] componentsJoinedByString:@","]);
        for (NSString *instanceID in unit.hbInstances) {
            OMBidResponse *bidResponse = [self.loadedInstanceBidResponses objectForKey:instanceID];
            if ( (unit.adFormat == OpenMediationAdFormatNative || unit.adFormat == OpenMediationAdFormatRewardedVideo || unit.adFormat == OpenMediationAdFormatInterstitial) && (bidResponse && (bidResponse.expire <= 0 || (bidResponse.expire > (NSInteger)([NSDate date].timeIntervalSince1970*1000))))) {
                [bidResponses setObject:[self.loadedInstanceBidResponses objectForKey:instanceID] forKey:instanceID];
                
            } else {
                if (bidResponse) {
                    [bidResponse notifyLossWithReasonCode:OMBidLossedReasonCodeNotHiggestBidder];
                }
            }
        }
    }
    return  [bidResponses copy];
}

- (NSArray*)getS2STokens:(NSArray*)readyInstances {
    NSMutableArray * tokens = [NSMutableArray array];
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:_pid];
    OMConfig *config = [OMConfig sharedInstance];
    if (unit) {
        NSMutableArray *allBidIns = [NSMutableArray arrayWithArray:unit.hbInstances];
        [allBidIns removeObjectsInArray:readyInstances];
        for (NSString *instanceID in allBidIns) {
            OMInstance *instance = [config getInstanceByinstanceID:instanceID];
            if (instance) {
                NSString *adnName = [config.adnNameMap objectForKey:@(instance.adnID)];
                Class adnBidClass = NSClassFromString([NSString stringWithFormat:@"OM%@Bid",adnName]);
                if (adnBidClass && [adnBidClass respondsToSelector:@selector(bidderToken)]) {
                    @synchronized (self) {
                        [tokens addObject:@{@"iid":instanceID,@"token":OM_SAFE_STRING([adnBidClass bidderToken])}];
                    }
                }
            }
        }
    }
    return  [tokens copy];
}

- (void)notifyLossBid {
    NSMutableArray *wfAllBidResonses = [NSMutableArray arrayWithArray:[_wfAllBidResonses allKeys]];
    NSArray *loadInstances = [_loadedInstanceBidResponses allKeys];
    [wfAllBidResonses removeObjectsInArray:loadInstances];
    
    for (NSString *instanceID in wfAllBidResonses) {
        OMBidResponse *bidResponse = [_wfAllBidResonses objectForKey:instanceID];
        [bidResponse notifyLossWithReasonCode:OMBidLossedReasonCodeNotHiggestBidder];
        [self.loadedInstanceBidResponses removeObjectForKey:instanceID];
        OMLogD(@"%@ bid loss %zd",instanceID,OMBidLossedReasonCodeNotHiggestBidder);
        [self addEvent:INSTANCE_BID_LOSE instance:instanceID extraData:nil];
    }
}



#pragma mark - OMLoadDelegate

- (void)omLoadRequestWithAction:(OMLoadAction)action {
    self.loadAction = action;
    if (self.loadAction == OMLoadActionTimer) {
        self.replenishLoad = YES;
    }
    self.wfReqId = [NSUUID UUID].UUIDString;
    if (_adFormat == OpenMediationAdFormatCrossPromotion) {
        NSMutableArray *instancePriority = [NSMutableArray array];
        NSString *instanceID = [[OMConfig sharedInstance]checkinstanceIDWithAdNetwork:OMAdNetworkCrossPromotion adnPlacementID:self.pid];
        if ([instanceID length]>0) {
            [instancePriority addObject:instanceID];
        }
        
        [self.adLoader loadWithPriority:[instancePriority copy]]; //交叉推广不请求wf接口
        return;
    }
    
    NSDictionary *bidResponses = [self checkReadyloadedInstanceBidResponses];
    
    NSArray *tokens = [self getS2STokens:[bidResponses allKeys]];
    
    [OMLrRequest postWithType:OMLRTypeWaterfallLoad pid:self.pid adnID:0 instanceID:@"" action:self.loadAction scene:@"" abt:0 abtId:0 bid:NO reqId:self.wfReqId ruleId:0 revenue:0 rp:0 ii:0 adn:@""];//lr load
    
    [self addEvent:LOAD instance:nil extraData:@{@"reqId":OM_SAFE_STRING(self.wfReqId)}];//load event
    
    self.wfAllBidResonses = [NSMutableDictionary dictionaryWithDictionary:bidResponses];
    NSMutableArray *bids = [NSMutableArray array];
    for (NSString *instanceID in bidResponses) {
        OMBidResponse *bidResponse = [bidResponses objectForKey:instanceID];
        NSDictionary *bidData = @{@"iid":instanceID,@"price":[NSNumber numberWithFloat:bidResponse.price],@"cur":bidResponse.currency};
        [bids addObject:bidData];
    }
    
    OMLogD(@"%@ waterfall request reqid %@ bids %@, tokens %@",self.pid, self.wfReqId ,bids,tokens);
    
    
    [OMWaterfallRequest requestDataWithPid:self.pid size:self.size actionType:action reqId:self.wfReqId bidResponses:bids tokens:tokens instanceState:[self allInstanceState] completionHandler:^(NSDictionary * _Nullable responseData, NSError * _Nullable error) {
        if (!error) {
            [self parseAbGroupValueWIthResponse:responseData];
            [self parseRuleWithResponse:responseData];
            [self parseS2SBidResponseWithResponse:responseData];
            [self parseInstanceListWithResponse:responseData];

        } else {
            OMLogD(@"%@ waterfall request error:%@",self.pid,error);
            [self.adLoader loadWithPriority:@[]];
        }
    }];
}

- (void)parseAbGroupValueWIthResponse:(NSDictionary*)response {
    if ([response objectForKey:@"abt"]) {
        self.abGroup = [[response objectForKey:@"abt"]integerValue];
        self.abTestId = [[response objectForKey:@"abtId"]integerValue];
    } else {
        self.abGroup = -1; //no ab test
    }
}

- (void)parseRuleWithResponse:(NSDictionary*)response {
    if ([response objectForKey:@"rule"] && [[response objectForKey:@"rule"]isKindOfClass:[NSDictionary class]]) {
        self.wfRule = [response objectForKey:@"rule"];
    } else {
        OMLogD(@"Waterfall response does not include rule data");
    }
}

- (void)parseS2SBidResponseWithResponse:(NSDictionary*)response {
    NSMutableDictionary *s2sBidReponses = [NSMutableDictionary dictionary];
    if ([response objectForKey:@"bidresp"] && [[response objectForKey:@"bidresp"]isKindOfClass:[NSArray class]] ) {
        NSArray *responses = [response objectForKey:@"bidresp"];
       
        for (NSDictionary *bidResponseData in responses) {
            NSString *instanceID = [NSString stringWithFormat:@"%@",bidResponseData[@"iid"]];
            if ([bidResponseData objectForKey:@"adm"]) {
                OMBidResponse *response = [OMBidResponse buildResponseWithData:bidResponseData];
                [s2sBidReponses setObject:response forKey:instanceID];
                
                OMLogD(@"instance %@ bid response price %lf currency %@",instanceID,response.price,response.currency);
            } else {
                NSString *error = [NSString stringWithFormat:@"error:%@,nbr:%@",OM_SAFE_STRING(bidResponseData[@"err"]),OM_SAFE_STRING(bidResponseData[@"nbr"])];
                
                OMLogD(@"instance %@ bid failed %@",instanceID,error);

            }
        }
        if (s2sBidReponses.count > 0) {
            [self.wfAllBidResonses addEntriesFromDictionary:s2sBidReponses];
        }
    } else {
        OMLogD(@"Waterfall response does not include s2s bid response data");
    }
}

- (void)parseInstanceListWithResponse:(NSDictionary*)response {
    self.wfInsPriority = [NSArray array];
    if ([response objectForKey:@"ins"] && [[response objectForKey:@"ins"]isKindOfClass:[NSArray class]]) {
        self.wfInsPriority = [response objectForKey:@"ins"];
    }
    if ([response objectForKey:@"c2s"] && [[response objectForKey:@"c2s"]isKindOfClass:[NSArray class]]) {
        NSArray *c2sIns = [response objectForKey:@"c2s"];
        [self.bid bidWithNetworkItems:[self bidNetworkItmes:c2sIns] adFormat:[[OMConfig sharedInstance]adFormatName:self.adFormat] adSize:_size];

    } else {
        [self sortInstancePriorityWithIns:self.wfInsPriority c2sBidResponses:@{}];
    }
}

#pragma mark - OMBidDelegate

- (void)omBidRequest:(NSString *)instance {
    [self addEvent:INSTANCE_BID_REQUEST instance:[NSString stringWithFormat:@"%@",instance] extraData:nil];
}

- (void)omBidComplete:(NSDictionary*)bidResponses {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *successBidResponses = [NSMutableDictionary dictionary];
    NSArray *allBidIns = [bidResponses allKeys];
    for (NSString *instanceID in allBidIns) {
        OMBidResponse *bidResponse = [bidResponses objectForKey:instanceID];
        if (bidResponse.isSuccess) {
            [self addEvent:INSTANCE_BID_RESPONSE instance:instanceID extraData:@{@"bid":[NSNumber numberWithInt:1],@"price":[NSNumber numberWithDouble:bidResponse.price],@"cur":bidResponse.currency}];
            OMLogD(@"%@ instance %@ bid response price %lf currency %@",self.pid,instanceID,bidResponse.price,bidResponse.currency);
            [successBidResponses setObject:bidResponse forKey:instanceID];
            if (weakSelf.adFormat == OpenMediationAdFormatNative) {
                [weakSelf.didLoadAdObjects setObject:bidResponse.adObject forKey:instanceID];
            }
        } else {
            [self addEvent:INSTANCE_BID_FAILED instance:instanceID extraData:@{@"msg":OM_SAFE_STRING(bidResponse.errorMsg)}];
            OMLogD(@"%@ instance %@ bid failed",self.pid,instanceID);
        }
    }
    [self sortInstancePriorityWithIns:self.wfInsPriority c2sBidResponses:successBidResponses];
}

- (void)sortInstancePriorityWithIns:(NSArray*)ins c2sBidResponses:(NSDictionary*)bidResponses {
    [self.wfAllBidResonses addEntriesFromDictionary:bidResponses];
    NSMutableArray *c2sInstances = [NSMutableArray array];
    
    for (NSString *instanceID in bidResponses) {
        OMBidResponse *response = [bidResponses objectForKey:instanceID];
        [c2sInstances addObject:@{@"id":@([instanceID integerValue]),@"i":@(0),@"r":@(response.price),@"rp":@(1)}];
    }
    
    self.wfInsList = [NSMutableArray arrayWithArray:ins];
    for (NSDictionary *c2sIns in c2sInstances) {
        NSInteger inserIndex = -1;
        for (int i=0; i<self.wfInsList.count; i++) {
            NSDictionary *ins = self.wfInsList[i];
            if([c2sIns[@"r"] compare:ins[@"r"]] == NSOrderedDescending) {
                inserIndex = i;
                break;
            }
        }
        if (inserIndex >=0 && inserIndex< self.wfInsList.count) {
            [self.wfInsList insertObject:c2sIns atIndex:inserIndex];
        }else {
            [self.wfInsList addObject:c2sIns];
        }
    }
    NSMutableArray *insPriority = [NSMutableArray array];
    NSMutableDictionary *wfInsRevenueData = [NSMutableDictionary dictionary];

    for (NSInteger i=0; i<[self.wfInsList count]; i++) {
        NSDictionary *insData  = self.wfInsList[i];
        NSString *insId = [NSString stringWithFormat:@"%@",[insData objectForKey:@"id"]];
        if ([insId length]>0) {
            [insPriority addObject:insId];
        }
        [wfInsRevenueData setObject:insData forKey:insId];
    }
    
    OMLogD(@"%@ waterfall response ins %@",self.pid,[insPriority componentsJoinedByString:@","]);
    
    self.wfInsRevenueData = [wfInsRevenueData copy];
    self.wfInsPriority = [insPriority copy];
    [self.adLoader loadWithPriority: self.wfInsPriority];
}


- (void)omLoadInstance:(NSString*)instanceID {
    OMLogD(@"%@ loader load instance:%@",self.pid,instanceID);
    
    OMConfig *config = [OMConfig sharedInstance];
    OMAdNetwork adnID = [config getInstanceAdNetwork:instanceID];
    if (![[OMConfig sharedInstance]getInstanceByinstanceID:instanceID]) {
        OMLogD(@"%@ load instance %@ not found",self.pid,instanceID);
        [self addEvent:INSTANCE_NOT_FOUND instance:instanceID extraData:@{@"reqId":OM_SAFE_STRING(self.wfReqId),@"ruleId":[NSString stringWithFormat:@"%ld",(long)[[self.wfRule objectForKey:@"id"] integerValue]]}];
        [self instanceLoadBlockWithError:OMErrorLoadInstanceNotFound instanceID:instanceID];
    } else {
        OMInstance *instance = [[OMConfig sharedInstance] getInstanceByinstanceID:instanceID];
        instance.wfReqId = self.wfReqId;
        instance.abGroup = self.abGroup;
        instance.abTestId = self.abTestId;
        instance.realInstancePriority = [_adLoader.priorityList indexOfObject:instanceID];
        if (self.wfRule) {
            instance.ruleId = [[self.wfRule objectForKey:@"id"] integerValue];
            instance.ruleName = OM_SAFE_STRING([self.wfRule objectForKey:@"n"]);
            instance.ruleType = [[self.wfRule objectForKey:@"t"] integerValue];
            instance.rulePriority = [[self.wfRule objectForKey:@"i"] integerValue];
        }
        
        NSDictionary *instanceData = [self.wfInsRevenueData objectForKey:instanceID];
        if (instanceData) {
            instance.revenue =  [instanceData[@"r"] floatValue]/1000.0;
            instance.revenuePrecision = [instanceData[@"rp"] integerValue];
            instance.instancePriority = [instanceData[@"i"] integerValue];
        }
            
        if ([[config adnAppKey:adnID]length]>0 || adnID == OMAdNetworkMopub || adnID == OMAdNetworkCrossPromotion) {
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
                        [self addEvent:INSTANCE_INIT_FAILED instance:instanceID extraData:@{@"msg":OM_SAFE_STRING([error description])}];
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
    OMBidResponse *instanceBidResponse = [self.wfAllBidResonses objectForKey:instanceID];
    id adapter = [_instanceAdapters objectForKey:instanceID];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMInstance *instance = [[OMConfig sharedInstance] getInstanceByinstanceID:instanceID];
    
    if (![[OMLoadFrequencryControl sharedInstance]allowLoadOnInstance:instanceID]) {
        OMLogD(@"%@ load adnName %@ instance %@ block with frequencry",self.pid,adnName,instanceID);
        [self addEvent:INSTANCE_INIT_FAILED instance:instanceID extraData:@{@"msg":@"block with frequencry"}];
        [self instanceLoadBlockWithError:OMErrorLoadFrequencry instanceID:instanceID];
        return;
    }
    
    if (adapter && [adapter respondsToSelector:@selector(isReady)] && [adapter isReady]) {
        
        NSInteger adnExpiredTime = [[OMConfig sharedInstance] adnExpiredTime:adnID];
        if (adnExpiredTime>0) {
            instance.expiredTime = (NSInteger)([[NSDate date]timeIntervalSince1970]) + adnExpiredTime;
        } else {
            instance.expiredTime = 0;
        }
        
        OMLogD(@"%@ load adnName %@ instance %@ ready true",self.pid,adnName,instanceID);
        if (instanceBidResponse) {
            @synchronized (self) {
                [_loadedInstanceBidResponses setObject:instanceBidResponse forKey:instanceID];
            }
        }
        if (!instance.hb) {
            [self addEvent:INSTANCE_LOAD instance:instanceID extraData:nil];
            [OMLrRequest postWithType:OMLRTypeInstanceLoad pid:self.pid adnID:adnID instanceID:instanceID action:_loadAction scene:@"" abt:instance.abGroup abtId:instance.abTestId bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:@""];//lr load;
            [self addEvent:INSTANCE_LOAD_SUCCESS instance:instanceID extraData:nil];
            [OMLrRequest postWithType:OMLRTypeInstanceReady pid:self.pid adnID:adnID instanceID:instanceID action:_loadAction scene:@"" abt:instance.abGroup abtId:instance.abTestId  bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];//lr ready;
        }
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateSuccess];
    } else if (instanceBidResponse && adapter && [adapter respondsToSelector:@selector(loadAdWithBidPayload:)]) {
        NSString *payload = OM_SAFE_STRING((NSString*)instanceBidResponse.payLoad);
        OMLogD(@"%@ load adnName %@ instance %@ with bid payload %@",self.pid,adnName,instanceID,payload);
           @synchronized (self) {
               [_loadedInstanceBidResponses setObject:instanceBidResponse forKey:instanceID];
           }
        NSDictionary *extraData = nil;
        if (!payload.length) {
            extraData = @{@"msg":@"payload empty"};
        }
        [self addEvent:INSTANCE_PAYLOAD_REQUEST instance:instanceID extraData:extraData];
        [adapter loadAdWithBidPayload:payload];
    } else if (instance.hb && adapter && [adapter respondsToSelector:@selector(loadAd)]) {
        [self addEvent:INSTANCE_BID_REQUEST instance:instanceID extraData:nil];
        [adapter loadAd];
    } else if (!instance.hb && adapter && [adapter respondsToSelector:@selector(loadAd)]) {
        OMLogD(@"%@ load adnName %@ instance %@ adapter call load",self.pid,adnName,instanceID);
        [OMLrRequest postWithType:OMLRTypeInstanceLoad pid:self.pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:_loadAction scene:@"" abt:instance.abGroup abtId:instance.abTestId bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:@""];//lr instance load;
        [self addEvent:INSTANCE_LOAD instance:instanceID extraData:nil];
        [adapter loadAd];
    }
    [self saveInstanceLoadTime:instanceID];
}

- (void)omLoadInstanceTimeout:(NSString *)instanceID {
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMLogD(@"%@ load adnName %@ instance %@ timeout",self.pid,adnName,instanceID);
    [self addEvent:INSTANCE_LOAD_TIMEOUT instance:instanceID extraData:nil];
}

- (void)instanceLoadBlockWithError:(OMErrorCode)errorType instanceID:(NSString*)instanceID {
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMLogD(@"%@ load adnName %@ instance %@ block:%zd",self.pid,adnName,instanceID,errorType);
    [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateFail];
}


- (void)omLoadFill:(NSString*)instanceID {
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMLogD(@"%@ loader fill adnName %@ instance %@",self.pid,adnName,instanceID)
    OMInstance *instance = [[OMConfig sharedInstance] getInstanceByinstanceID:instanceID];
    
    [OMLrRequest postWithType:OMLRTypeWaterfallReady pid:self.pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:_loadAction scene:@"" abt:instance.abGroup abtId:instance.abTestId bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:instance.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];//lr ready
    
    
    if ((_adFormat < OpenMediationAdFormatRewardedVideo) || (_adFormat == OpenMediationAdFormatSplash)) {
        if (_adFormat == OpenMediationAdFormatBanner) {
            [self omDidLoad];
        }else if(self.callLoad){
            self.callLoad = NO;
            [self omDidLoad];
        }
    } else {
        [self notifyAvailable:YES];
    }
}

- (void)omLoadOptimalFill:(NSString*)instanceID {
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMLogD(@"%@ optimal fill adnName %@ instance %@",self.pid,adnName,instanceID);
    if (_adFormat == OpenMediationAdFormatInterstitial || _adFormat == OpenMediationAdFormatRewardedVideo || _adFormat == OpenMediationAdFormatCrossPromotion) {
        [self notifyAvailable:YES];
    } else if (_adFormat == OpenMediationAdFormatNative) {
        if (self.callLoad) {
            self.callLoad = NO;
            [self omDidLoad];
        }
    }
}

- (void)omLoadNoFill {
    [self addEvent:NO_MORE_OFFERS instance:nil extraData:nil];
    [self sendDidFailWithErrorType:OMErrorLoadWaterfallFail];
    [self notifyAvailable:NO];
}

- (void)omLoadEnd {
    BOOL supplementCache = NO;
    
    NSDictionary *instanceState = [self.adLoader.instanceLoadState copy];
    for (NSString *instanceID in instanceState) {
        OMInstanceLoadState loadState = [instanceState[instanceID]integerValue];
        if (loadState == OMInstanceLoadStateCallShow) {
            [self.adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateWait];
            supplementCache = YES;
        }
    }
    if ([_adLoader isKindOfClass:NSClassFromString(@"OMSmartLoad")] && supplementCache) {
        [self loadAd:_adFormat actionType:OMLoadActionCloseEvent];
    }
    [self notifyLossBid];
}


- (void)omLoadAddEvent:(NSInteger)eventID extraData:data {
    [self addEvent:eventID instance:nil extraData:data];
}

- (BOOL)omCheckInstanceReady:(NSString*)instanceID {
    BOOL instanceReady = YES;
    id adapter = [_instanceAdapters objectForKey:instanceID];
    if (adapter && [adapter respondsToSelector:@selector(isReady)]) {
        instanceReady = [adapter isReady];
    }
    if (!instanceReady) {
        if (_adLoader.wfLoading) {
            [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateCallShow];//instance available state changed
        } else {
            [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateWait];//instance available state changed
        }
        OMBidResponse *bidResponse = [self.loadedInstanceBidResponses objectForKey:instanceID];
        if (bidResponse) {
            [bidResponse notifyLossWithReasonCode:OMBidLossedReasonCodeNotShow];
            [self addEvent:INSTANCE_BID_LOSE instance:instanceID extraData:nil];
            OMLogD(@"%@ bid loss %zd",instanceID,OMBidLossedReasonCodeNotShow);
        }
        [self.loadedInstanceBidResponses removeObjectForKey:instanceID];
    }
    return instanceReady;
}

- (void)sendDidFailWithErrorType:(OMErrorCode)errorCode {
    if (self.callLoad) {
        self.callLoad = NO;
        NSError *error = [OMError omErrorWithCode:errorCode];
        NSError *developerError = [OMSDKError errorWithAdtError:error];
        [OMSDKError throwDeveloperError:developerError];
        [self performSelector:@selector(omDidFail:) withObject:developerError afterDelay:0.5];
    }
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

#pragma mark - Instance State

- (void)saveInstanceLoadTime:(NSString*)instanceID {

    NSMutableDictionary *allInstanceState = [NSMutableDictionary dictionary];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]) {
        allInstanceState = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]];
    }
        
    NSMutableDictionary *instanceState = [NSMutableDictionary dictionary];
    
    if ([allInstanceState objectForKey:instanceID]) {
        instanceState = [NSMutableDictionary dictionaryWithDictionary:[allInstanceState objectForKey:instanceID]];
        
    }
    
    [instanceState setObject:[NSNumber numberWithInteger:[instanceID integerValue]] forKey:@"iid"];
    NSInteger timeStamp = (NSInteger)[NSDate date].timeIntervalSince1970;
    
    
    [instanceState setObject:[NSNumber numberWithInteger:timeStamp] forKey:@"lts"];//last time stamp

    
    [allInstanceState setObject:instanceState forKey:instanceID];
    [[NSUserDefaults standardUserDefaults]setObject:allInstanceState forKey:@"OMInstanceLoadState"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    OMLogD(@"instance state save %@ load time %@",instanceID,[NSDate date]);
    
}

- (void)removeSuccessInstance:(NSString*)instanceID {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]) {
        NSMutableDictionary *allInstanceState = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]];
        [allInstanceState removeObjectForKey:instanceID];
        [[NSUserDefaults standardUserDefaults]setObject:allInstanceState forKey:@"OMInstanceLoadState"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        OMLogD(@"instance state remove success instance %@ ",instanceID);
    }
}

- (void)saveInstanceLoadError:(NSString*)instanceID errorCode:(NSString*)code codeMsg:(NSString*)msg {
    NSMutableDictionary *allInstanceState = [NSMutableDictionary dictionary];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]) {
        allInstanceState = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]];
    }
        
    NSMutableDictionary *instanceState = [NSMutableDictionary dictionary];
    
    if ([allInstanceState objectForKey:instanceID]) {
        instanceState = [NSMutableDictionary dictionaryWithDictionary:[allInstanceState objectForKey:instanceID]];
        
    }
    
    [instanceState setObject:[NSNumber numberWithInteger:[instanceID integerValue]] forKey:@"iid"];
    
    NSInteger timeStamp = (NSInteger)[NSDate date].timeIntervalSince1970;
    
    NSInteger startTime = [[instanceState objectForKey:@"lts"]integerValue];//last time stamp
    
    [instanceState setObject:[NSNumber numberWithInteger:(timeStamp - startTime)] forKey:@"dur"]; //duration

    [instanceState setObject:code forKey:@"code"];
    
    if (!OM_STR_EMPTY(msg)) {
        [instanceState setObject:msg forKey:@"msg"];
    }
        
    [allInstanceState setObject:instanceState forKey:instanceID];
    [[NSUserDefaults standardUserDefaults]setObject:allInstanceState forKey:@"OMInstanceLoadState"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    OMLogD(@"instance state save instance %@ error %@ ",instanceID,instanceState);
}

- (NSArray *)allInstanceState {
    NSMutableDictionary *allInstanceState = [NSMutableDictionary dictionary];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]) {
        allInstanceState = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"OMInstanceLoadState"]];
    }
    
    NSMutableArray *allInstanceStateInUnit = [NSMutableArray array];
    
    NSArray *instancesInUnit = [[OMConfig sharedInstance]allInstanceInAdUnit:_pid];
    
    for (OMInstance *instance in instancesInUnit) {
        if ([allInstanceState objectForKey:instance.instanceID]) {
            [allInstanceStateInUnit  addObject:[allInstanceState objectForKey:instance.instanceID]];
        }
    }
    return [allInstanceStateInUnit copy];
      
}

#pragma mark - isReady

- (BOOL)isReady {
    return (_adLoader && [_adLoader isReady] && (!_adLoader.adShow  || _adFormat == OpenMediationAdFormatNative));
}

#pragma mark - isAdAvailable

- (BOOL)isAdAvailable {
    return (_adLoader && [_adLoader isAdAvailable]);
}


#pragma mark - OMCustomEventDelegate


- (void)customEvent:(id)instanceAdapter didLoadAd:(id)adObject {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    if (instanceID) {
        OMLogD(@"%@ adnName %@ instance %@ load success",self.pid,adnName,instanceID);
        OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
        if (instance) {
            NSInteger adnExpiredTime = [[OMConfig sharedInstance] adnExpiredTime:adnID];
            if (adnExpiredTime>0) {
                instance.expiredTime = (NSInteger)([[NSDate date]timeIntervalSince1970]) + adnExpiredTime;
            } else {
                instance.expiredTime = 0;
            }
            if (instance.hb) {
                [self addEvent:INSTANCE_PAYLOAD_SUCCESS instance:instanceID extraData:nil];
            } else {
                [OMLrRequest postWithType:OMLRTypeInstanceReady pid:self.pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:_loadAction scene:@"" abt:self.abGroup abtId:self.abTestId bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];//lr ready
                
                [self addEvent:INSTANCE_LOAD_SUCCESS instance:instanceID extraData:nil];
            }
        }
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:self.pid] isEqualToString:self.wfReqId]) {
            [OMLrRequest postWithType:OMLRTypeWaterfallFill pid:self.pid adnID:0 instanceID:@"" action:_loadAction scene:@"" abt:self.abGroup abtId:self.abTestId bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];
            [[NSUserDefaults standardUserDefaults] setObject:self.wfReqId forKey:self.pid];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        if (adObject) {
            if (_adFormat == OpenMediationAdFormatNative) {
                [_didLoadAdObjects setObject:adObject forKey:instanceID];
            } else if(_adFormat == OpenMediationAdFormatCrossPromotion) {//revenue data
                NSDictionary *revenueData = (NSDictionary*)adObject;
                instance.revenue = [[revenueData objectForKey:@"r"]floatValue]/1000.0;
                instance.revenuePrecision = [[revenueData objectForKey:@"rp"]integerValue];
            }
        }
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateSuccess];
        
        [self removeSuccessInstance:instanceID];
    }
}

- (void)customEvent:(id)adapter didLoadWithAdnName:(NSString*)adnName {
    NSString *instanceID = [self checkInstanceIDWithAdapter:adapter];
    if (instanceID && adnName) {
        [self.didLoadAdnName setObject:adnName forKey:instanceID];
    }
}

- (void)customEvent:(id)adapter didFailToLoadWithError:(NSError*)error {
    NSString *instanceID = [self checkInstanceIDWithAdapter:adapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    if (instanceID) {
        OMBidResponse *bidResponse = [self.loadedInstanceBidResponses objectForKey:instanceID];
        if (bidResponse) {
            [bidResponse notifyLossWithReasonCode:OMBidLossedReasonCodeInternalError];
            [self addEvent:INSTANCE_BID_LOSE instance:instanceID extraData:nil];
            OMLogD(@"%@ bid loss %zd",instanceID,OMBidLossedReasonCodeInternalError);
        }
        [self.loadedInstanceBidResponses removeObjectForKey:instanceID];
        
        NSString *code = [NSString stringWithFormat:@"%zd",error.code];
        NSString *msg = [error isKindOfClass:[NSError class]]?OM_SAFE_STRING(error.localizedDescription):@"";

        OMLogD(@"%@ adnName %@ instance %@ load fail error %@",self.pid,adnName,instanceID,msg);
        
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateFail];
        
        [self saveInstanceLoadError:instanceID errorCode:code codeMsg:msg];
        
        OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
        [self addEvent:(instance.hb?INSTANCE_PAYLOAD_FAIL:INSTANCE_LOAD_ERROR) instance:instanceID extraData:@{@"msg":msg,@"code":code}];
    }
}

- (void)customEventAdDidExpired:(id)adapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:adapter];
    if (_adLoader.wfLoading) {
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateCallShow];
    } else {
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateWait];
        [self loadAd:_adFormat actionType:OMLoadActionCloseEvent];
    }
}

- (void)bidReseponse:(NSObject *)bidAdapter bid:(NSDictionary*)bidInfo error:( NSError*)error {
    if (!error) {
        NSString *instanceID = [self checkInstanceIDWithAdapter:bidAdapter];
        OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
        NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
        
        
        OMBidResponse *bidResponse = [OMBidResponse buildResponseWithData:bidInfo];
        [self.wfAllBidResonses setObject:bidResponse forKey:instanceID];
        [self.loadedInstanceBidResponses setObject:bidResponse forKey:instanceID];
        [self addEvent:INSTANCE_BID_RESPONSE instance:instanceID extraData:@{@"bid":[NSNumber numberWithInt:1],@"price":[NSNumber numberWithDouble:bidResponse.price],@"cur":bidResponse.currency}];
        
        OMLogD(@"%@ adnName %@ instance %@ bid price %@",self.pid,adnName,instanceID,[NSNumber numberWithDouble:bidResponse.price]);
        
        NSDictionary *c2sIns = @{@"id":@([instanceID integerValue]),@"i":@(0),@"r":@(bidResponse.price),@"rp":@(1)};
        
        NSMutableDictionary *wfInsRevenueData =   [NSMutableDictionary dictionaryWithDictionary:self.wfInsRevenueData];
        [wfInsRevenueData setObject:c2sIns forKey:instanceID];
        self.wfInsRevenueData = [wfInsRevenueData copy];
        
        if ([_adLoader isKindOfClass:[OMSmartLoad class] ]) {
            NSInteger c2sIndex = [_adLoader.priorityList indexOfObject:instanceID];
            if (c2sIndex != NSNotFound && c2sIndex>=0 && c2sIndex< self.wfInsList.count) {
                [self.wfInsList removeObjectAtIndex:c2sIndex];
            }
            
            NSInteger inserIndex = -1;
            for (int i=0; i<self.wfInsList.count; i++) {
                NSDictionary *ins = self.wfInsList[i];
                if([c2sIns[@"r"] compare:ins[@"r"]] == NSOrderedDescending) {
                    inserIndex = i;
                    break;
                }
            }
            if (inserIndex >=0 && inserIndex< self.wfInsList.count) {
                [self.wfInsList insertObject:c2sIns atIndex:inserIndex];
            }else {
                [self.wfInsList addObject:c2sIns];
                inserIndex = self.wfInsList.count-1;
            }
            
            NSMutableArray *insPriority = [NSMutableArray array];
            
            for (NSInteger i=0; i<[self.wfInsList count]; i++) {
                NSDictionary *insData  = self.wfInsList[i];
                NSString *insId = [NSString stringWithFormat:@"%@",[insData objectForKey:@"id"]];
                if ([insId length]>0) {
                    [insPriority addObject:insId];
                }
            }
            
            OMLogD(@"%@ waterfall resort ins priority %@",self.pid,[insPriority componentsJoinedByString:@","]);
            _adLoader.priorityList = [insPriority copy];
            [_adLoader groupByBatchSize:1];
            [_adLoader checkOptimalInstance];
        }
    }
}


#pragma mark - show

- (void)showInstance:(id)instanceID {
    if (!OM_STR_EMPTY(instanceID)) {
        OMBidResponse *bidResponse = [self.loadedInstanceBidResponses objectForKey:instanceID];
        if (bidResponse) {
            [bidResponse win];
            [self addEvent:INSTANCE_BID_WIN instance:instanceID extraData:nil];
            OMLogD(@"%@ %@ bid win notice",self.pid,instanceID);
        }
        [[OMInstanceContainer sharedInstance]removeImpressionInstance:instanceID];
        [self addEvent:INSTANCE_SHOW instance:instanceID extraData:nil];
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateCallShow];
    }
    [[NSUserDefaults standardUserDefaults]setObject:OM_SAFE_STRING(self.showSceneID) forKey:[NSString stringWithFormat:@"%@_scene",self.pid]];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)adshow:(id)instanceAdapter eventData:(NSDictionary*)eventData {
    self.adLoader.adShow = YES;
    [self notifyAvailable:NO];
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    
    OMLogD(@"%@ adnName %@ instance %@ show",self.pid,adnName,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_SHOW_SUCCESS instance:instanceID extraData:nil];
    
    OMInstance *instance = [[OMConfig sharedInstance] getInstanceByinstanceID:instanceID];
    [OMLrRequest postWithType:OMLRTypeInstanceImpression pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:(instance?instance.abGroup:-1) abtId:(instance?instance.abTestId:-1) bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.realInstancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];
    
    [[OMLoadFrequencryControl sharedInstance]recordImprOnPlacement:_pid sceneID:self.showSceneID];
    [[OMLoadFrequencryControl sharedInstance]recordImprOnInstance:OM_SAFE_STRING(instanceID)];
    OMUnit *unit = [[OMConfig sharedInstance].adUnitMap objectForKey:self.pid];
    OMScene *scene = [unit getSceneById:self.showSceneID];
    
    if (instance) {
        [[OMUserData sharedInstance]addRevelue:instance.revenue];
        OMImpressionData *impressionData = [[OMImpressionData alloc] initWithUnit:unit instance:instance scene:scene];
        [[OMImpressionDataRouter sharedInstance]postImpressionData:impressionData];
    }
}

- (void)adShowFail:(id)instanceAdapter {
    self.adLoader.adShow = NO;
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMLogD(@"%@ adnName %@ instance %@ show fail",self.pid,adnName,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_SHOW_FAILED instance:instanceID extraData:nil];
    if (!_adLoader.wfLoading) {
        [_adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateWait];
    }
    [self loadAd:_adFormat actionType:OMLoadActionCloseEvent];
}

- (void)adClick:(id)instanceAdapter eventData:(NSDictionary*)eventData {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
    OMLogD(@"%@ adnName %@ instance %@ click",self.pid,adnName,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_CLICKED instance:instanceID extraData:eventData];
    [OMLrRequest postWithType:OMLRTypeInstanceClick pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:(instance?instance.abGroup:-1) abtId:(instance?instance.abTestId:-1) bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];
    
    
    
}

- (void)adVideoStart:(id)instanceAdapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
    OMLogD(@"%@ adnName %@ instance %@ video start",self.pid,adnName,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_VIDEO_START instance:instanceID extraData:nil];
    [OMLrRequest postWithType:OMLRTypeVideoStart pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:(instance?instance.abGroup:-1) abtId:(instance?instance.abTestId:-1) bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];
}

- (void)adVideoComplete:(id)instanceAdapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
    OMLogD(@"%@ adnName %@ instance %@ video end",self.pid,adnName,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_VIDEO_COMPLETED instance:instanceID extraData:nil];
    [OMLrRequest postWithType:OMLRTypeVideoComplete pid:_pid adnID:[[OMConfig sharedInstance]getInstanceAdNetwork:instanceID] instanceID:instanceID action:0 scene:self.showSceneID abt:(instance?instance.abGroup:-1) abtId:(instance?instance.abTestId:-1) bid:[[OMConfig sharedInstance]isHBInstance:instanceID] reqId:self.wfReqId ruleId:instance.ruleId revenue:instance.revenue rp:instance.revenuePrecision ii:instance.instancePriority adn:OM_SAFE_STRING([_didLoadAdnName objectForKey:instanceID])];
}

- (void)adClose:(id)instanceAdapter {
    self.adLoader.adShow = NO;
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMLogD(@"%@ adnName %@ instance %@ close",self.pid,adnName,OM_SAFE_STRING(instanceID));
    [self addEvent:INSTANCE_CLOSED instance:instanceID extraData:nil];
    [self.loadedInstanceBidResponses removeObjectForKey:instanceID];
    if (!self.adLoader.wfLoading) {
        [self.adLoader saveInstanceLoadState:instanceID state:OMInstanceLoadStateWait];
    }
    if(!self.adLoader.loading && [_adLoader isKindOfClass:NSClassFromString(@"OMSmartLoad")]) {
        [self loadAd:_adFormat actionType:OMLoadActionCloseEvent];
    }
}

- (void)adReceiveReward:(id)instanceAdapter {
    NSString *instanceID = [self checkInstanceIDWithAdapter:instanceAdapter];
    OMAdNetwork adnID = [[OMConfig sharedInstance]getInstanceAdNetwork:instanceID];
    NSString *adnName = [[OMConfig sharedInstance] adnName:adnID];
    OMLogD(@"%@ adnName %@ instance %@ receive reward",self.pid,adnName,OM_SAFE_STRING(instanceID));
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



#pragma mark - addEvent

- (void)customEventAddEvent:(NSObject*)adapter event:(NSDictionary*)body {
    if([body isKindOfClass:[NSDictionary class]]&& [body objectForKey:@"eid"]) {
        NSInteger eid = [[body objectForKey:@"eid"]integerValue];
        NSString *adapterInstanceID = [self checkInstanceIDWithAdapter:adapter];
        [self addEvent:eid instance:adapterInstanceID extraData:[body copy]];
    }
}


- (void)addEvent:(NSInteger)eventID instance:(NSString*)instanceID extraData:(NSDictionary*)data {
    
    NSMutableDictionary *wrapperData = [NSMutableDictionary dictionary];
    if (data) {
        [wrapperData addEntriesFromDictionary:data];
    }
    OMConfig *config = [OMConfig sharedInstance];
    [wrapperData setObject:[NSNumber omStr2Number:_pid] forKey:@"pid"];

    if (!OM_STR_EMPTY(instanceID)) {
        OMAdNetwork adnID = [config getInstanceAdNetwork:instanceID];
        [wrapperData setObject:[NSNumber omStr2Number:instanceID] forKey:@"iid"];
        [wrapperData setObject:[NSNumber numberWithInteger:adnID] forKey:@"mid"];
        
        if ([_didLoadAdnName objectForKey:instanceID]) {
            [wrapperData setObject:[_didLoadAdnName objectForKey:instanceID] forKey:@"cadn"];
        }
        
        OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
        if (instance) {
            [wrapperData setObject:OM_SAFE_STRING(instance.wfReqId) forKey:@"reqId"];
            [wrapperData setObject:instance.ruleId?@(instance.ruleId):@([[self.wfRule objectForKey:@"id"] integerValue]) forKey:@"ruleId"];
            [wrapperData setObject:@(instance.abGroup) forKey:@"abt"];
            [wrapperData setObject:@(instance.abTestId) forKey:@"abtId"];
            [wrapperData setObject:instance.hb?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0] forKey:@"bid"];
        }

        
        if([self.loadedInstanceBidResponses objectForKey:instanceID]) {
            OMBidResponse *bidResponse = [self.loadedInstanceBidResponses objectForKey:instanceID];
            if(bidResponse) {
                [wrapperData setObject:[NSNumber numberWithDouble:bidResponse.price] forKey:@"price"];
                [wrapperData setObject:bidResponse.currency forKey:@"cur"];
            }
        }
        [wrapperData setObject:[NSNumber numberWithInteger:instance.realInstancePriority] forKey:@"priority"];
        if ([_adLoader isKindOfClass:[OMSmartLoad class]]) {
            [wrapperData setObject:[NSNumber numberWithInteger:((OMSmartLoad*)_adLoader).cacheCount] forKey:@"cs"];
        }
        NSDictionary *adNetworkInfo = [[[OMMediations sharedInstance]adNetworkInfo]objectForKey:@(adnID)];
        if (adNetworkInfo) {
            [wrapperData addEntriesFromDictionary:adNetworkInfo];
        }
    }
    
    [[OMEventManager sharedInstance] addEvent:eventID extraData:wrapperData];
}

@end
