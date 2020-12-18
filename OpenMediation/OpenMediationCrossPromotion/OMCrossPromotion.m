// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotion.h"
#import "OMCrossPromotionAd.h"
#import "OpenMediationAdFormats.h"
#import "OMToolUmbrella.h"
#import "OMModelUmbrella.h"
#import "OMAdBasePrivate.h"
#import "OMAdSingletonInterfacePrivate.h"
#import "OMEventManager.h"

#define DEFAULT_AD_SIZE  CGSizeMake(132, 153)


@protocol OMCrossPromotionPrivateDelegate <OMCrossPromotionDelegate>

@optional

- (void)omCrossPromotionChangedAvailability:(NSString*)placementID newValue:(BOOL)available;

@end

static OMCrossPromotion * _instance = nil;

@implementation OMCrossPromotion

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithAdClassName:@"OMCrossPromotionAd" adFormat:OpenMediationAdFormatCrossPromotion];
    });
    return _instance;
    
}

- (void)addDelegate:(id)delegate{
    [super addDelegate:delegate];
}

- (void)removeDelegate:(id)delegate{
    [super removeDelegate:delegate];
}

- (BOOL)isReady {
    return [super isReady];
}


- (BOOL)isCappedForScene:(NSString *)sceneName {
    return [super isCappedForScene:sceneName];
}

- (void)showAdWithScreenPoint:(CGPoint)scaleXY angle:(CGFloat) angle scene:(NSString *)sceneName {
    [self showAdWithScreenPoint:scaleXY adSize:DEFAULT_AD_SIZE angle:angle scene:sceneName];
}

- (CGSize)adScaleAspectFitSize:(CGSize)adSize {
    CGFloat scale = MIN((adSize.width/DEFAULT_AD_SIZE.width), (adSize.height/DEFAULT_AD_SIZE.height));
    return CGSizeMake(scale*DEFAULT_AD_SIZE.width, scale*DEFAULT_AD_SIZE.height);
}

- (void)showAdWithScreenPoint:(CGPoint)scaleXY adSize:(CGSize)size angle:(CGFloat) angle scene:(NSString *)sceneName {
    NSString *unitID = [[OMConfig sharedInstance]defaultUnitIDForAdFormat:OpenMediationAdFormatCrossPromotion];
    OMScene *scene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:unitID];
    [self addAdEvent:CALLED_SHOW placementID:unitID scene:scene extraMsg:OM_SAFE_STRING(sceneName)];
    [self showAdWithScreenPoint:scaleXY adSize:[self adScaleAspectFitSize:size] angle:angle placementID:unitID scene:sceneName];
}

- (void)showAdWithScreenPoint:(CGPoint)scaleXY adSize:(CGSize)size angle:(CGFloat) angle placementID:(NSString *)placementID {
    [self addAdEvent:CALLED_SHOW placementID:placementID scene:nil extraMsg:nil];
    [self showAdWithScreenPoint:scaleXY adSize:size angle:angle placementID:placementID scene:@""];
}

- (void)showAdWithScreenPoint:(CGPoint)scaleXY adSize:(CGSize)size angle:(CGFloat) angle placementID:(NSString *)placementID scene:(NSString*)sceneName {
    if(![OMConfig sharedInstance].initSuccess) {
        NSError *adtError = [OMError omErrorWithCode:OMErrorShowNotInitialized];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:adtError]];
        return;
    }
    
    if(OM_STR_EMPTY(placementID)) {
        NSError *adtError = [OMError omErrorWithCode:OMErrorShowPlacementEmpty];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:adtError]];
        return;
    }
    
    if(![[OMConfig sharedInstance]configContainAdUnit:placementID]) {
        NSError *adtError = [OMError omErrorWithCode:OMErrorLoadPlacementNotFound];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:adtError]];
        return;
    }
    
    if(![[OMConfig sharedInstance] isValidAdUnitId:placementID forAdFormat:OpenMediationAdFormatCrossPromotion]) {
        NSError *adtError = [OMError omErrorWithCode:OMErrorLoadPlacementAdTypeIncorrect];
        [OMSDKError throwDeveloperError:[OMSDKError errorWithAdtError:adtError]];
        return;
    }
    
    if(![self placementIsReady:placementID]) {
        NSError *adtError = [OMError omErrorWithCode:OMErrorShowFailNotReady];
        NSError *noReadyError = [OMSDKError errorWithAdtError:adtError];
        [OMSDKError throwDeveloperError:noReadyError];
        [self promotionDidFailToShow:placementID scene:sceneName withError:noReadyError];
        return;
    }
    if([[OMLoadFrequencryControl sharedInstance]overCapOnPlacement:placementID scene:sceneName]) {
        NSError *adtError = [OMError omErrorWithCode:OMErrorShowFailSceneCapped];
        NSError *cappedError = [OMSDKError errorWithAdtError:adtError];
        [OMSDKError throwDeveloperError:cappedError];
        [self promotionDidFailToShow:placementID scene:sceneName withError:cappedError];
        return;
    }
    OMCrossPromotionAd *promotionAd = [self.loadAdInstanceDic objectForKey:placementID];
    if(promotionAd) {
        [promotionAd showAdWithScreenPoint:scaleXY adSize:size angle:angle scene:sceneName];
    }
}

- (void)hideAd {
    NSString *unitID = [[OMConfig sharedInstance]defaultUnitIDForAdFormat:OpenMediationAdFormatCrossPromotion];
    [self hideAd:unitID];
}

- (void)hideAd:(NSString*)placementID {
    OMCrossPromotionAd *promotionAd = [self.loadAdInstanceDic objectForKey:placementID];
    if(promotionAd) {
        [promotionAd hideAd];
    }
}

#pragma mark - OMCrossPromotionAdDelegate


- (void)promotionChangedAvailability:(OMCrossPromotionAd *)promotion newValue:(BOOL)available {
    for (id<OMCrossPromotionPrivateDelegate> delegate in self.delegates) {
        if(delegate && [delegate respondsToSelector:@selector(omCrossPromotionChangedAvailability:)]) {
            if (available) {
                [self addAdEvent:CALLBACK_LOAD_SUCCESS placementID:promotion.placementID scene:nil extraMsg:nil];
            }
            [delegate omCrossPromotionChangedAvailability:available];
        }
    }
}

- (void)promotionWillAppear:(OMCrossPromotionAd *)promotion {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)promotion).showSceneID inAdUnit:promotion.placementID];
    if(showScene) {
        for (id<OMCrossPromotionDelegate> delegate in self.delegates) {
            if (delegate && [delegate conformsToProtocol:@protocol(OMCrossPromotionDelegate)] && [delegate respondsToSelector:@selector(omCrossPromotionWillAppear:)]) {
                [self addAdEvent:CALLBACK_PRESENT_SCREEN placementID:promotion.placementID scene:showScene extraMsg:nil];
                [delegate omCrossPromotionWillAppear:showScene];
            }
        }
    }
}


- (void)promotionDidClick:(OMCrossPromotionAd *)promotion {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)promotion).showSceneID inAdUnit:promotion.placementID];
    if(showScene) {
        for (id<OMCrossPromotionDelegate> delegate in self.delegates) {
            if (delegate && [delegate conformsToProtocol:@protocol(OMCrossPromotionDelegate)] && [delegate respondsToSelector:@selector(omCrossPromotionDidClick:)]) {
                [self addAdEvent:CALLBACK_CLICK placementID:promotion.placementID scene:showScene extraMsg:nil];
                [delegate omCrossPromotionDidClick:showScene];
            }
        }
    }
}

- (void)promotionDidDisappear:(OMCrossPromotionAd *)promotion {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneID:((OMAdBase*)promotion).showSceneID inAdUnit:promotion.placementID];
    if(showScene) {
        for (id<OMCrossPromotionDelegate> delegate in self.delegates) {
            if (delegate && [delegate conformsToProtocol:@protocol(OMCrossPromotionDelegate)] && [delegate respondsToSelector:@selector(omCrossPromotionDidDisappear:)]) {
                [self addAdEvent:CALLBACK_DISMISS_SCREEN placementID:promotion.placementID scene:showScene extraMsg:nil];
                [delegate omCrossPromotionDidDisappear:showScene];
            }
        }
    }
}



- (void)promotionDidFailToShow:(NSString*)placementID scene:(NSString*)sceneName withError:(NSError*)error {
    OMScene *showScene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:placementID];
    if(showScene) {
        for (id<OMCrossPromotionDelegate> delegate in self.delegates) {
            if (delegate && [delegate conformsToProtocol:@protocol(OMCrossPromotionDelegate)] && [delegate respondsToSelector:@selector(omCrossPromotionDidFailToShow:withError:)]) {
                [self addAdEvent:CALLBACK_SHOW_FAILED placementID:placementID scene:showScene extraMsg:OM_SAFE_STRING([error description])];
                [delegate omCrossPromotionDidFailToShow:showScene withError:error];
            }
        }
    }
}
@end
