// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdSingletonInterface.h"
#import "OMConfig.h"
#import "OMUnit.h"
#import "OMToolUmbrella.h"
#import "OMAdBasePrivate.h"
#import "OpenMediation.h"
#import "OMEventManager.h"

@interface OMAdBase()
- (instancetype)initWithPlacementID:(NSString*)placementID;
- (void)setDelegate:(id)delegate;
@end

@interface OMAdSingletonInterface ()
@property (nonatomic, strong) NSMutableDictionary *loadAdInstanceDic;
@property (nonatomic, strong) NSHashTable *delegates;
@property (nonatomic, strong) NSHashTable *mediationDelegates;
@property (nonatomic, strong) NSMapTable *placementDelegateMap;
@property (nonatomic, strong) NSString *adClassName;
@property (nonatomic, assign) OpenMediationAdFormat adFormat;
@end

@implementation OMAdSingletonInterface

- (instancetype)initWithAdClassName:(NSString*)adClassName adFormat:(OpenMediationAdFormat)adFormat {
    if (self = [super init]) {
        _loadAdInstanceDic = [NSMutableDictionary dictionary];
        _delegates = [NSHashTable weakObjectsHashTable];
        _mediationDelegates = [NSHashTable weakObjectsHashTable];
        _placementDelegateMap = [NSMapTable weakToWeakObjectsMapTable];
        _adClassName = adClassName;
        _adFormat = adFormat;

    }
    return self;
}

- (void)addDelegate:(id)delegate {
    if (![_delegates containsObject:delegate]) {
        [_delegates addObject:delegate];
        OMLogD(@"%@ add delegate %@",NSStringFromClass([self class]),delegate);
    }
}

- (void)removeDelegate:(id)delegate {
    [_delegates removeObject:delegate];
    OMLogD(@"%@ remove delegate %@",NSStringFromClass([self class]),delegate);
}

- (void)addMediationDelegate:(id)delegate {
    if (![_mediationDelegates containsObject:delegate]) {
        [_mediationDelegates addObject:delegate];
        OMLogD(@"%@ add mediation delegate %@",NSStringFromClass([self class]),delegate);
    }
}

- (void)removeMediationDelegate:(id)delegate {
    [_mediationDelegates removeObject:delegate];
    OMLogD(@"%@ remove mediation delegate %@",NSStringFromClass([self class]),delegate);
}


- (void)registerDelegate:(NSString*)placementID delegate:(id)delegate {//for admob multiple instance
    if (!OM_STR_EMPTY(placementID) && ![_placementDelegateMap objectForKey:placementID]) {
        [_placementDelegateMap setObject:delegate forKey:placementID];
    }
}


- (void)preload {
    NSString *unitID = [[OMConfig sharedInstance]defaultUnitIDForAdFormat:_adFormat];
    [self preloadPlacementID:unitID];
    
}

- (void)preloadPlacementID:(NSString*)pid {
    OMLogD(@"pload %@",pid);
    OMAdBase *adInstance = [_loadAdInstanceDic objectForKey:pid];
    if (!adInstance && NSClassFromString(_adClassName)) {
        adInstance = [[NSClassFromString(_adClassName) alloc] initWithPlacementID:pid];
        adInstance.delegate = self;
        [adInstance preload];
        [_loadAdInstanceDic setObject:adInstance forKey:pid];
    }
}

- (void)loadAd {

}

- (void)loadWithPlacementID:(NSString*)placementID {
    [self addAdEvent:CALLED_LOAD placementID:OM_SAFE_STRING(placementID) scene:nil extraMsg:nil];
    
    if (OM_STR_EMPTY(placementID)) {
        NSError *error = [OMError omErrorWithCode:OMErrorLoadPlacementEmpty];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:error]];
        return;
    }
    OMAdBase *adInstance = [_loadAdInstanceDic objectForKey:placementID];
    if (!adInstance) {
        adInstance = [[NSClassFromString(_adClassName) alloc] initWithPlacementID:placementID];
        adInstance.delegate = self;
        [_loadAdInstanceDic setObject:adInstance forKey:placementID];
    }
    [adInstance loadAd];
}

- (BOOL)isReady {
    NSString *unitID = [[OMConfig sharedInstance] defaultUnitIDForAdFormat:_adFormat];
    BOOL isReady = [self isReady:unitID];
    NSInteger event = isReady?CALLED_IS_READY_TRUE:CALLED_IS_READY_FALSE;
    [self addAdEvent:event placementID:unitID scene:nil extraMsg:nil];
    return isReady;
}

- (BOOL)isReady:(NSString*)placementID {
    BOOL isReady = NO;
    if (!OM_STR_EMPTY(placementID)) {
        OMAdBase *adInstance = [_loadAdInstanceDic objectForKey:placementID];
        isReady = [adInstance isReady];
    }
    return isReady;
}

- (BOOL)placementIsReady:(NSString*)placementID {
    return [self isReady:placementID];
}



- (BOOL)isCappedForScene:(NSString *)sceneName {
    NSString *unitID = [[OMConfig sharedInstance]defaultUnitIDForAdFormat:_adFormat];
    BOOL isCapped = [[OMLoadFrequencryControl sharedInstance]overCapOnPlacement:unitID scene:sceneName];
    NSInteger event =  isCapped?CALLED_IS_CAPPED_TRUE:CALLED_IS_CAPPED_FALSE;
    OMScene *scene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:unitID];
    [self addAdEvent:event placementID:unitID scene:scene extraMsg:OM_SAFE_STRING(sceneName)];
    return isCapped;
}

- (void)addAdEvent:(NSInteger)eventID placementID:(NSString*)placementID scene:(OMScene*)scene extraMsg:(NSString*)message {
    NSMutableDictionary *extraData = [NSMutableDictionary dictionary];
    [extraData setObject:[NSNumber omStr2Number:placementID] forKey:@"pid"];
    if (scene) {
        [extraData setObject:[NSNumber omStr2Number:scene.sceneID] forKey:@"scene"];
    }
    if (message) {
        [extraData setObject:message forKey:@"msg"];
    }
    [[OMEventManager sharedInstance]addEvent:eventID extraData:extraData];
}

@end
