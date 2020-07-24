// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMConfig.h"
#import "OpenMediationConstant.h"
#import "OMScene.h"
#import "OMUnit.h"
#import "OMInstance.h"
#import "OMToolUmbrella.h"
#import "OMEventManager.h"

NSString *kOpenMediatonInitSuccessNotification = @"kOpenMediatonInitSuccessNotification";

static OMConfig *_instance = nil;

@implementation OMConfig

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _adFormats = @{@(OpenMediationAdFormatBanner):@"Banner",\
                           @(OpenMediationAdFormatNative):@"Native",\
                           @(OpenMediationAdFormatInterstitial):@"Interstitial",\
                           @(OpenMediationAdFormatRewardedVideo):@"RewardedVideo"};
        _appKey = @"";
        _hbUrl = @"";
        _clUrl = @"";
        _lrUrl = @"";
        _icUrl = @"";
        _iapUrl = @"";
        _erUrl = @"";
        _openDebug = YES;
        _adnNameMap = [NSMutableDictionary dictionary];
        _adnAppkeyMap = [NSMutableDictionary dictionary];
        _adUnitList = [NSMutableArray array];
        _adUnitMap = [NSMutableDictionary dictionary];
        _consent = YES;
        _adnNameMap = [NSMutableDictionary dictionary];
        _adnAppkeyMap = [NSMutableDictionary dictionary];
        _adUnitList = [NSMutableArray array];
        _adUnitMap = [NSMutableDictionary dictionary];
        _instanceMap = [NSMutableDictionary dictionary];
        _adnPlacementMap = [NSMutableDictionary dictionary];
        
        _consent = -1;
        _userAge = 0;
        _userGender = 0;
    }
    return self;
}

- (NSString *)adFormatName:(OpenMediationAdFormat)adFormat {
    return OM_SAFE_STRING([_adFormats objectForKey:@(adFormat)]);
}

- (BOOL)initSuccess {
    return (_initState == OMInitStateInitialized);
}


- (void)setInitState:(OMInitState)initState {
    _initState = initState;
    if (_initState == OMInitStateInitializing) {
        [[OMEventManager sharedInstance]addEvent:INIT_START extraData:nil];
    } else if (_initState == OMInitStateInitialized) {
        [[OMEventManager sharedInstance]initSuccess];
        [[NSNotificationCenter defaultCenter]postNotificationName:kOpenMediatonInitSuccessNotification object:nil];
    }
}


- (void)loadCongifData:(NSDictionary *)configData {
    _openDebug = [[configData objectForKey:@"d"]boolValue];
    NSDictionary *apiDic = [configData objectForKey:@"api"];
    if (apiDic && [apiDic isKindOfClass:[NSDictionary class]]) {
        [self loadApi:apiDic];
    }
    NSArray *mediation = [configData objectForKey:@"ms"];
    if (mediation && [mediation isKindOfClass:[NSArray class]]) {
        [self loadMediation:mediation];
    }
    NSArray *adUnits = [configData objectForKey:@"pls"];
    if (adUnits && [adUnits isKindOfClass:[NSArray class]]) {
        [self loadAdUnits:adUnits];
    }
    [[OMEventManager sharedInstance]loadEventConfig:[configData objectForKey:@"events"]];
    self.initState = OMInitStateInitialized;
}

- (void)loadApi:(NSDictionary*)apiData {
    _hbUrl = OM_SAFE_STRING([apiData objectForKey:@"hb"]);
    _clUrl = OM_SAFE_STRING([apiData objectForKey:@"wf"]);
    _lrUrl = OM_SAFE_STRING([apiData objectForKey:@"lr"]);
    _icUrl = OM_SAFE_STRING([apiData objectForKey:@"ic"]);
    _iapUrl = OM_SAFE_STRING([apiData objectForKey:@"iap"]);
    _erUrl = OM_SAFE_STRING([apiData objectForKey:@"er"]);
}

- (void)loadMediation:(NSArray *)mediationData {
    for (NSDictionary *dic in mediationData) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *adnID = [dic objectForKey:@"id"];
            NSString *adnName = [dic objectForKey:@"n"];
            NSString *adnAppKey = [dic objectForKey:@"k"];
            if (OM_IS_NOT_NULL(adnID) && OM_IS_NOT_NULL(adnName) && OM_IS_NOT_NULL(adnAppKey)) {
                [_adnNameMap setObject:adnName forKey:adnID];
                [_adnAppkeyMap setObject:adnAppKey forKey:adnID];
                OMLogV(@"mName=%@,mKey=%@",adnName,adnAppKey);
            }
        }
    }
}

- (void)loadAdUnits:(NSArray *)adUnits {
    for (NSDictionary *adUnit in adUnits) {
        if ([adUnit isKindOfClass:[NSDictionary class]]) {
            OMUnit *unit = [[OMUnit alloc] initWithUnitData:adUnit];
            [_adUnitList addObject:unit];
            [_adUnitMap setObject:unit forKey:unit.unitID];
            [_instanceMap addEntriesFromDictionary:unit.instanceMap];
            for (OMInstance *instance in unit.instanceList) {
                NSString *mKey = [NSString stringWithFormat:@"%@_%@",[NSString stringWithFormat:@"%zd",instance.adnID],instance.adnPlacementID];
                [_adnPlacementMap setObject:instance forKey:mKey];
            }
            OMLogD(@"load pid = %@,format = %@",unit.unitID,[self adFormatName:unit.adFormat]);
        }
    }
}

#pragma mark AdNetwork

- (NSString *)adnName:(OMAdNetwork)adnID {
    NSString *appKey = @"";
    if ([_adnNameMap objectForKey:@(adnID)]) {
        appKey = [_adnNameMap objectForKey:@(adnID)];
    }
    return appKey;
}


- (NSString *)adnAppKey:(OMAdNetwork)adnID {
    NSString *appKey = @"";
    if ([_adnAppkeyMap objectForKey:@(adnID)]) {
        appKey = [_adnAppkeyMap objectForKey:@(adnID)];
    }
    return appKey;
}

- (NSArray *)adnPlacements:(OMAdNetwork)adnID {
    NSMutableArray *pids = [NSMutableArray array];
    NSArray *instances = [_instanceMap allValues];
    for (OMInstance* instance in instances) {
        if (instance.adnID == adnID) {
            [pids addObject:instance.adnPlacementID];
        }
    }
    return [pids copy];
}

#pragma mark Scene
- (OMScene *)getSceneWithSceneID:(NSString*)sceneID inAdUnit:(NSString*)unitID {
    OMScene *scene = nil;
    OMUnit *adUnit = [[OMConfig sharedInstance].adUnitMap objectForKey:unitID];
    if (adUnit && [adUnit getSceneById:sceneID]) {
        scene = [adUnit getSceneById:sceneID];
    }
    return scene;
}

- (OMScene *)getSceneWithSceneName:(NSString*)sceneName inAdUnit:(NSString*)unitID {
    OMScene *scene = nil;
    OMUnit *adUnit = [[OMConfig sharedInstance].adUnitMap objectForKey:unitID];
    if (adUnit && [adUnit getSceneByName:sceneName]) {
        scene = [adUnit getSceneByName:sceneName];
    }
    return scene;
}


- (NSString *)getSceneIDWithSceneName:(NSString*)sceneName inAdUnit:(NSString*)unitID {
    NSString *sceneID = @"";
    OMScene *scene = [self getSceneWithSceneName:sceneName inAdUnit:unitID];
    if (scene) {
        sceneID = scene.sceneID;
    }
    return sceneID;
}


#pragma mark AdUnit

- (BOOL)configContainAdUnit:(NSString*)unitID {
    OMUnit *unit = [self.adUnitMap objectForKey:unitID];
    return (unit?YES:NO);
}

- (OpenMediationAdFormat)adUnitFormat:(NSString*)unitID {
    OpenMediationAdFormat adFormat = -1;
    OMUnit *adUnit = [_adUnitMap objectForKey:unitID];
    if (adUnit) {
        adFormat = adUnit.adFormat;
    }
    return adFormat;
}

- (NSString*)defaultUnitIDForAdFormat:(OpenMediationAdFormat)adFormat {
    NSString *unitID = @"";
    for (OMUnit *unit in _adUnitList) {
        if (unit.adFormat == adFormat) {
            if (OM_STR_EMPTY(unitID)) {
                unitID = unit.unitID;
            }
            if (unit.main) {
                unitID = unit.unitID;
            }
        }
    }
    return unitID;
}

- (BOOL)isValidAdUnitId:(NSString*)unitID forAdFormat:(OpenMediationAdFormat)adFormat {
    BOOL isValid = NO;
    if (OM_STR_EMPTY(unitID)) {
        return NO;
    }
    OMUnit *unit = [self.adUnitMap objectForKey:unitID];
    if (unit.adFormat == adFormat) {
        isValid = YES;
    }
    return isValid;
}

- (NSArray*)adFormatUnits:(OpenMediationAdFormat)adFormat {
    NSMutableArray *adUnits = [NSMutableArray array];
    for (OMUnit *unit in _adUnitList) {
        if (unit.adFormat == adFormat) {
            [adUnits addObject:unit];
        }
    }
    return [adUnits copy];
}

#pragma mark Instance

- (NSArray *)allInstanceInAdUnit:(NSString*)unitID {
    NSArray *instances = @[];
    OMUnit *adUnit = [_adUnitMap objectForKey:unitID];
    if (adUnit) {
        instances = adUnit.instanceList;
    }
    return instances;
    
}

- (OMInstance *)getInstanceByinstanceID:(NSString*)instanceID {
    return [_instanceMap objectForKey:instanceID];
}

- (BOOL)isHBInstance:(NSString*)instanceID {
    BOOL hb = NO;
    OMInstance *instance = [self getInstanceByinstanceID:instanceID];
    if (instance) {
        hb = instance.hb;
    }
    return hb;
}

- (NSString *)getInstanceAdnPlacementID:(NSString*)instanceID {
    NSString *mediationPlacementID = @"";
    OMInstance *instance = [self getInstanceByinstanceID:instanceID];
    if (instance) {
        mediationPlacementID = instance.adnPlacementID;
    }
    return mediationPlacementID;
}

- (OMAdNetwork)getInstanceAdNetwork:(NSString*)instanceID {
    OMAdNetwork adnID = 0;
    OMInstance *instance = [self getInstanceByinstanceID:instanceID];
    if (instance) {
        adnID = instance.adnID;
    }
    return adnID;
}

- (NSString *)checkinstanceIDWithAdNetwork:(OMAdNetwork)adnID adnPlacementID:(NSString *)placementID {
    NSString *instanceID = @"";
    NSString *mKey = [NSString stringWithFormat:@"%@_%@",[NSString stringWithFormat:@"%zd",adnID],placementID];
    OMInstance *instance = [_adnPlacementMap objectForKey:mKey];
    if (instance) {
        instanceID = instance.instanceID;
    }
    return instanceID;
}

@end
