// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInterstitial.h"
#import "OMInterstitialAd.h"
#import "OMModelUmbrella.h"
#import "OMToolUmbrella.h"
#import "OMModelUmbrella.h"
#import "OMAdBasePrivate.h"
#import "OMAdSingletonInterfacePrivate.h"
#import "OMEventManager.h"

@protocol OMInterstitialPrivateDelegate <OMInterstitialDelegate>

@optional

- (void)omInterstitialChangedAvailability:(NSString*)placementID newValue:(BOOL)available;

@end



static OMInterstitial * _instance = nil;


@implementation OMInterstitial

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithAdClassName:@"OMInterstitialAd" adFormat:OpenMediationAdFormatInterstitial];
    });
    return _instance;
    
}

- (void)addDelegate:(id)delegate {
    [super addDelegate:delegate];
}

- (void)removeDelegate:(id)delegate {
    [super removeDelegate:delegate];
}

- (BOOL)isReady {
    return [super isReady];
}


- (BOOL)isCappedForScene:(NSString *)sceneName {
    return [super isCappedForScene:sceneName];
}

- (void)showWithViewController:(UIViewController *)viewController scene:(NSString *)sceneName { //for scene
    
    NSString *unitID = [[OMConfig sharedInstance]defaultUnitIDForAdFormat:OpenMediationAdFormatInterstitial];
    OMScene *scene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:unitID];
    [self addAdEvent:CALLED_SHOW placementID:unitID scene:scene extraMsg:OM_SAFE_STRING(sceneName)];
    [self show:viewController placementID:unitID scene:sceneName];
    
}

- (void)showWithViewController:(UIViewController *)viewController placementID:(NSString *)placementID{//for placement
    [self addAdEvent:CALLED_SHOW placementID:placementID scene:nil extraMsg:nil];
    [self show:viewController placementID:placementID scene:@""];
}

- (void)show:(UIViewController *)viewController placementID:(NSString *)placementID scene:(NSString*)sceneName {
    if (![OMConfig sharedInstance].initSuccess) {
        NSError *error = [OMError omErrorWithCode:OMErrorShowNotInitialized];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:error]];
        return;
    }
    
    if (OM_STR_EMPTY(placementID)) {
        NSError *error = [OMError omErrorWithCode:OMErrorShowPlacementEmpty];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:error]];
        return;
    }
    
    if (![[OMConfig sharedInstance]configContainAdUnit:placementID]) {
        NSError *error = [OMError omErrorWithCode:OMErrorLoadPlacementNotFound];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:error]];
        return;
    }
    
    if (![[OMConfig sharedInstance] isValidAdUnitId:placementID forAdFormat:OpenMediationAdFormatInterstitial]) {
        NSError *error = [OMError omErrorWithCode:OMErrorLoadPlacementAdTypeIncorrect];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:error]];
        return;
    }
    
    if (![self placementIsReady:placementID]) {
        NSError *error = [OMError omErrorWithCode:OMErrorShowFailNotReady];
        NSError *noReadyError = [OMSDKError errorWithAdtError:error];
        [OMSDKError throwDeveloperError:noReadyError];
        [self interstitialDidFailToShow:placementID scene:sceneName withError:noReadyError];
        return;
    }
    if ([[OMLoadFrequencryControl sharedInstance]overCapOnPlacement:placementID scene:sceneName]) {
        NSError *error = [OMError omErrorWithCode:OMErrorShowFailSceneCapped];
        NSError *cappedError = [OMSDKError errorWithAdtError:error];
        [OMSDKError throwDeveloperError:cappedError];
        [self interstitialDidFailToShow:placementID scene:sceneName withError:cappedError];
        return;
    }
    OMInterstitialAd*interstitial = [self.loadAdInstanceDic objectForKey:placementID];
    if (interstitial) {
        [interstitial showWithRootViewController:viewController scene:sceneName];
    }
}

- (void)interstitialChangedAvailability:(OMInterstitialAd*)interstitial newValue:(BOOL)available{
    for (id<OMInterstitialPrivateDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omInterstitialChangedAvailability:)]) {
            if (available) {
                [self addAdEvent:CALLBACK_LOAD_SUCCESS placementID:interstitial.placementID scene:nil extraMsg:nil];
            }
            [delegate omInterstitialChangedAvailability:available];
        }
    }
}

- (void)interstitialDidOpen:(OMInterstitialAd*)interstitial {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)interstitial).showSceneID inAdUnit:interstitial.placementID];
    if (showScene) {
        for (id<OMInterstitialDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omInterstitialDidOpen:)]) {
                [delegate omInterstitialDidOpen:showScene];
            }
        }
    }
    
}

- (void)interstitialDidShow:(OMInterstitialAd*)interstitial {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)interstitial).showSceneID inAdUnit:interstitial.placementID];
    if (showScene) {
        for (id<OMInterstitialDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omInterstitialDidShow:)]) {
                [self addAdEvent:CALLBACK_PRESENT_SCREEN placementID:interstitial.placementID scene:showScene extraMsg:nil];
                [delegate omInterstitialDidShow:showScene];
            }
        }
    }
    
}


- (void)interstitialDidClick:(OMInterstitialAd*)interstitial {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)interstitial).showSceneID inAdUnit:interstitial.placementID];
    if (showScene) {
        for (id<OMInterstitialDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omInterstitialDidClick:)]) {
                [self addAdEvent:CALLBACK_CLICK placementID:interstitial.placementID scene:showScene extraMsg:nil];
                [delegate omInterstitialDidClick:showScene];
            }
        }
    }
    
    
}

- (void)interstitialDidClose:(OMInterstitialAd*)interstitial {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)interstitial).showSceneID inAdUnit:interstitial.placementID];
    if (showScene) {
        for (id<OMInterstitialDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omInterstitialDidClose:)]) {
                [self addAdEvent:CALLBACK_DISMISS_SCREEN placementID:interstitial.placementID scene:showScene extraMsg:nil];
                [delegate omInterstitialDidClose:showScene];
            }
        }
    }
    
}

- (void)interstitialDidFailToShow:(OMInterstitialAd*)interstitial error:(NSError*)error {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)interstitial).showSceneID inAdUnit:interstitial.placementID];
    [self interstitialDidFailToShow:interstitial.placementID scene:showScene.sceneName withError:error];
}

- (void)interstitialDidFailToShow:(NSString*)placementID scene:(NSString*)sceneName withError:(NSError*)error {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:placementID];
    if (showScene) {
        for (id<OMInterstitialDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omInterstitialDidFailToShow:withError:)]) {
                [self addAdEvent:CALLBACK_SHOW_FAILED placementID:placementID scene:showScene extraMsg:OM_SAFE_STRING([error description])];
                [delegate omInterstitialDidFailToShow:showScene withError:error];
            }
        }
    }
}

@end

