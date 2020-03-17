// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInterstitialAd.h"
#import "OpenMediationConstant.h"
#import "OMModelUmbrella.h"
#import "OMNetworkUmbrella.h"
#import "OMInterstitialCustomEvent.h"
#import "OMRewardedVideoCustomEvent.h"
#import "OMInstanceContainer.h"
#import "OMAdBasePrivate.h"
#import "OMMediations.h"

@interface OMTapjoyRewardedVideo : NSObject
@property (nonatomic, strong) id tapjoyPlacement;
@end

@interface OMAppLovinInterstitial : NSObject
@property (nonatomic, strong) id ad;
@end

@interface OMFacebookInterstitial : NSObject
@property (nonatomic, strong) id facebookInterstitial;
@end;

@interface OMInterstitialAd() <interstitialCustomEventDelegate> {


}
@end

#define OM_INTERSTITIAL_SIZE  CGSizeMake(768, 1024)

@implementation OMInterstitialAd

#pragma mark PublicMethod
- (instancetype)initWithPlacementID:(NSString *)placementID {
    if (self = [super initWithPlacementID:placementID size:OM_INTERSTITIAL_SIZE]) {
    }
    return self;
}

- (void)loadInstance:(NSString*)instanceID {
    OMInstance *instance = [[OMConfig sharedInstance]getInstanceByinstanceID:instanceID];
    if (instance) {
        NSString *mediationPid = instance.adnPlacementID;
        OMAdNetwork adnID = instance.adnID;
        NSString *instanceID = instance.instanceID;
        NSString *mediationName = [[OMConfig sharedInstance]adnName:adnID];
        if ([mediationName length]>0) {
            NSString *interstitialClassName = [NSString stringWithFormat:@"OM%@Interstitial",mediationName];
            Class adapterClass = NSClassFromString(interstitialClassName);
            if (!adapterClass) {
                NSString *videoClassName = [NSString stringWithFormat:@"OM%@RewardedVideo",mediationName];
               adapterClass = NSClassFromString(videoClassName);
            }
            if (adapterClass && [adapterClass instancesRespondToSelector:@selector(initWithParameter:)]) {
                id <OMInterstitialCustomEvent> interstitialAdapter = [[OMInstanceContainer sharedInstance]getInstance:instanceID block:^id{
                    id adapter = [[adapterClass alloc] initWithParameter:@{@"pid":mediationPid,@"appKey":[[OMConfig sharedInstance]adnAppKey:adnID] }];
                    return adapter;
                }];
                interstitialAdapter.delegate = self;
                [self.instanceAdapters setObject:interstitialAdapter forKey:instanceID];
            }
        }
    }
    [super loadInstance:instanceID];
}

- (void)loadAd {
    [super loadAd:OpenMediationAdFormatInterstitial actionType:OMLoadActionManualLoad];
}

- (void)preload {
    [self loadAd:OpenMediationAdFormatInterstitial actionType:OMLoadActionInit];
}

- (BOOL)isReady {
    return [super isReady];
}

- (void)show {
    [self showWithRootViewController:[UIViewController omRootViewController]scene:@""];
}

- (NSString*)placementID {
    return self.pid;
}

- (void)showWithRootViewController:(UIViewController *)rootViewController scene:(NSString*)sceneName {
    if (![rootViewController isKindOfClass:[UIViewController class]]) {
        rootViewController = [UIViewController omRootViewController];
        OMLogW(@"rootViewController error, use default viewController")
    }
    
    self.showSceneID = [[OMConfig sharedInstance] getSceneIDWithSceneName:sceneName inAdUnit:self.placementID];
    OMLogD(@"interstitial show pid = %@ scene name %@ scene id %@",self.placementID,(OM_STR_EMPTY(sceneName)?@"empty":sceneName),self.showSceneID);
    
    if (self.adLoader && !OM_STR_EMPTY(self.adLoader.optimalFillInstance)) {
        id <OMInterstitialCustomEvent> interstitialAdapter = [self.instanceAdapters objectForKey:self.adLoader.optimalFillInstance];
        if (interstitialAdapter && [interstitialAdapter respondsToSelector:@selector(show:)]) {
            [interstitialAdapter show:rootViewController];
        }
        [self showInstance:self.adLoader.optimalFillInstance];

    }
}

- (void)omDidChangedAvailable:(BOOL)available{
    [super omDidChangedAvailable:available];
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialChangedAvailability:newValue:)]) {
        [self.delegate interstitialChangedAvailability:self newValue:available];
    }
}

#pragma mark -- interstitialCustomEventDelegate
- (void)interstitialCustomEventDidOpen:(id<OMInterstitialCustomEvent>)adapter {
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialDidOpen:)]) {
        [self.delegate interstitialDidOpen:self];
    }

}

- (void)interstitialCustomEventDidShow:(id<OMInterstitialCustomEvent>)adapter {

    [self adshow:adapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialDidShow:)]) {
        [self.delegate interstitialDidShow:self];
    }

}

- (void)interstitialCustomEventDidClick:(id<OMInterstitialCustomEvent>)adapter {
    [self adClick:adapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialDidClick:)]) {
        [self.delegate interstitialDidClick:self];
    }
}

- (void)interstitialCustomEventDidClose:(id<OMInterstitialCustomEvent>)adapter {
    [self adClose:adapter];
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialDidClose:)]) {
        [self.delegate interstitialDidClose:self];
    }
}

- (void)interstitialCustomEventDidFailToShow:(id<OMInterstitialCustomEvent>)adapter error:(NSError*)error {
    [self adShowFail:adapter];
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialDidFailToShow:error:)]) {
        [_delegate interstitialDidFailToShow:self error:error];
    }
}

#pragma mark -- rewardedVideoCustomEventDelegate

- (void)rewardedVideoCustomEventDidOpen:(id<OMRewardedVideoCustomEvent>)adapter {
    [self interstitialCustomEventDidOpen:(id<OMInterstitialCustomEvent>)adapter];
}

- (void)rewardedVideoCustomEventVideoStart:(id<OMRewardedVideoCustomEvent>)adapter {
    [self interstitialCustomEventDidShow:(id<OMInterstitialCustomEvent>)adapter];

}

- (void)rewardedVideoCustomEventVideoEnd:(id<OMRewardedVideoCustomEvent>)adapter {

}

- (void)rewardedVideoCustomEventDidClick:(id<OMRewardedVideoCustomEvent>)adapter {
    [self interstitialCustomEventDidClick:(id<OMInterstitialCustomEvent>)adapter];
}

- (void)rewardedVideoCustomEventDidClose:(id<OMRewardedVideoCustomEvent>)adapter {
    [self interstitialCustomEventDidClose:(id<OMInterstitialCustomEvent>)adapter];
}

- (void)rewardedVideoCustomEventDidFailToShow:(id<OMRewardedVideoCustomEvent>)adapter withError:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialDidFailToShow:error:)]) {
        [_delegate interstitialDidFailToShow:self error:error];
    }
}

@end
