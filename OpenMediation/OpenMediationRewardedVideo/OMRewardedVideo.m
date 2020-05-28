// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMRewardedVideo.h"
#import "OMRewardedVideoAd.h"
#import "OMModelUmbrella.h"
#import "OMToolUmbrella.h"
#import "OMModelUmbrella.h"
#import "OMAdBasePrivate.h"
#import "OMAdSingletonInterfacePrivate.h"
#import "OMEventManager.h"

@protocol OMRewardedVideoPrivateDelegate <OMRewardedVideoDelegate>

@optional

- (void)omRewardedVideoChangedAvailability:(NSString*)placementID newValue:(BOOL)available;

@end

static OMRewardedVideo * _instance = nil;


@implementation OMRewardedVideo

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithAdClassName:@"OMRewardedVideoAd" adFormat:OpenMediationAdFormatRewardedVideo];
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
    [self showWithViewController:viewController scene:sceneName extraParams:@""];
}

- (void)showWithViewController:(UIViewController *)viewController scene:(NSString *)sceneName extraParams:(NSString*)extraParams {
    NSString *unitID = [[OMConfig sharedInstance]defaultUnitIDForAdFormat:OpenMediationAdFormatRewardedVideo];
    OMScene *scene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:unitID];
    [self addAdEvent:CALLED_SHOW placementID:unitID scene:scene extraMsg:OM_SAFE_STRING(sceneName)];
    [self show:viewController placementID:unitID scene:sceneName extraParams:extraParams];
    
}

- (void)showWithViewController:(UIViewController *)viewController placementID:(NSString *)placementID {//for placement
    [self addAdEvent:CALLED_SHOW placementID:placementID scene:nil extraMsg:nil];
    [self show:viewController placementID:placementID scene:@"" extraParams:@""];
}

- (void)show:(UIViewController *)viewController placementID:(NSString *)placementID scene:(NSString*)sceneName extraParams:(NSString*)extraParams {
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
    
    if (![[OMConfig sharedInstance] isValidAdUnitId:placementID forAdFormat:OpenMediationAdFormatRewardedVideo]) {
        NSError *error = [OMError omErrorWithCode:OMErrorLoadPlacementAdTypeIncorrect];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:error]];
        return;
    }
    
    if (![self placementIsReady:placementID]) {
        NSError *error = [OMError omErrorWithCode:OMErrorShowFailNotReady];
        NSError *noReadyError = [OMSDKError errorWithAdtError:error];
        [OMSDKError throwDeveloperError:noReadyError];
        [self rewardedVideoDidFailToShow:placementID scene:sceneName withError:noReadyError];
        return;
    }
    if ([[OMLoadFrequencryControl sharedInstance]overCapOnPlacement:placementID scene:sceneName]) {
        NSError *error = [OMError omErrorWithCode:OMErrorShowFailSceneCapped];
        NSError *cappedError = [OMSDKError errorWithAdtError:error];
        [OMSDKError throwDeveloperError:cappedError];
        [self rewardedVideoDidFailToShow:placementID scene:sceneName withError:cappedError];
        return;
    }
    
    OMRewardedVideoAd *video = [self.loadAdInstanceDic objectForKey:placementID];
    if (video) {
        [video show:viewController extraParams:extraParams scene:sceneName];
    }
}


- (void)rewardedVideoChangedAvailability:(OMRewardedVideoAd *)video newValue:(BOOL)available {
    for (id<OMRewardedVideoPrivateDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoChangedAvailability:)]) {
            if (available) {
                [self addAdEvent:CALLBACK_LOAD_SUCCESS placementID:video.placementID scene:nil extraMsg:nil];
            }
            [delegate omRewardedVideoChangedAvailability:available];
        }
        if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoChangedAvailability:newValue:)]) {
            if (available) {
                [self addAdEvent:CALLBACK_LOAD_SUCCESS placementID:video.placementID scene:nil extraMsg:nil];
            }
            [delegate omRewardedVideoChangedAvailability:video.placementID newValue:available];
        }
    }
}

- (void)rewardedVideoDidOpen:(OMRewardedVideoAd *)video {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)video).showSceneID inAdUnit:video.placementID];
    if (showScene) {
        for (id<OMRewardedVideoDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoDidOpen:)]) {
                [delegate omRewardedVideoDidOpen:showScene];
            }
        }
        
    }
}

- (void)rewardedVideoDidStart:(OMRewardedVideoAd *)video {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)video).showSceneID inAdUnit:video.placementID];
    if (showScene) {
        for (id<OMRewardedVideoDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoPlayStart:)]) {
                [self addAdEvent:CALLBACK_PRESENT_SCREEN placementID:video.placementID scene:showScene extraMsg:nil];
                [delegate omRewardedVideoPlayStart:showScene];
            }
        }
    }
    
}

- (void)rewardedVideoDidEnd:(OMRewardedVideoAd *)video {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)video).showSceneID inAdUnit:video.placementID];
    if (showScene) {
        for (id<OMRewardedVideoDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoPlayEnd:)]) {
                [delegate omRewardedVideoPlayEnd:showScene];
            }
        }
    }
}

- (void)rewardedVideoDidClick:(OMRewardedVideoAd *)video {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)video).showSceneID inAdUnit:video.placementID];
    if (showScene) {
        for (id<OMRewardedVideoDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoDidClick:)]) {
                [self addAdEvent:CALLBACK_CLICK placementID:video.placementID scene:showScene extraMsg:nil];
                [delegate omRewardedVideoDidClick:showScene];
            }
        }
    }
}
- (void)rewardedVideoDidReceiveReward:(OMRewardedVideoAd *)video {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)video).showSceneID inAdUnit:video.placementID];
    for (id<OMRewardedVideoDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoDidReceiveReward:)]) {
            [self addAdEvent:CALLBACK_REWARDED placementID:video.placementID scene:showScene extraMsg:nil];
            [delegate omRewardedVideoDidReceiveReward:showScene];
        }
    }
}

- (void)rewardedVideoDidClose:(OMRewardedVideoAd *)video {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)video).showSceneID inAdUnit:video.placementID];
    if (showScene) {
        for (id<OMRewardedVideoDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoDidClose:)]) {
                [self addAdEvent:CALLBACK_DISMISS_SCREEN placementID:video.placementID scene:showScene extraMsg:nil];
                [delegate omRewardedVideoDidClose:showScene];
            }
        }
    }
}
- (void)rewardedVideoDidFailToShow:(OMRewardedVideoAd *)video error:(NSError*)error {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)video).showSceneID inAdUnit:video.placementID];
    [self rewardedVideoDidFailToShow:video.placementID scene:showScene.sceneName withError:error];
}
- (void)rewardedVideoDidFailToShow:(NSString*)placementID scene:(NSString*)sceneName withError:(NSError*)error {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:placementID];
    if (showScene) {
        for (id<OMRewardedVideoDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(omRewardedVideoDidFailToShow:withError:)]) {
                [self addAdEvent:CALLBACK_SHOW_FAILED placementID:placementID scene:showScene extraMsg:(error?[error description]:@"")];
                [delegate omRewardedVideoDidFailToShow:showScene withError:error];
            }
        }
    }
}



@end
