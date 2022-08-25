// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHeliumRouter.h"

static OMHeliumRouter * _instance = nil;

@implementation OMHeliumRouter
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _placementDelegateMap = [NSMapTable weakToWeakObjectsMapTable];
        _placementAdMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerPidDelegate:(NSString*)pid delegate:(id)delegate {
    [_placementDelegateMap setObject:delegate forKey:pid];
}


- (void)loadInterstitialWithPlacmentID:(NSString *)pid {
    
    id <HeliumInterstitialAd> heliumInterstitial = [_placementAdMap objectForKey:pid];
    if (!heliumInterstitial) {
        Class heliumClass = NSClassFromString(@"Helium");
        if (heliumClass && [heliumClass instancesRespondToSelector:@selector(interstitialAdProviderWithDelegate:andPlacementName:)]) {
            heliumInterstitial = [[heliumClass sharedHelium] interstitialAdProviderWithDelegate:self andPlacementName:pid];
            [_placementAdMap setObject:heliumInterstitial forKey:pid];
        }
    }
    
    [heliumInterstitial loadAd];
    
}
- (void)loadRewardedVideoWithPlacmentID:(NSString *)pid {
    
    id <HeliumRewardedAd> heliumRewarded = [_placementAdMap objectForKey:pid];

    if (!heliumRewarded) {
        Class heliumClass = NSClassFromString(@"Helium");
        if (heliumClass && [heliumClass instancesRespondToSelector:@selector(interstitialAdProviderWithDelegate:andPlacementName:)]) {
            heliumRewarded = [[heliumClass sharedHelium] rewardedAdProviderWithDelegate:self andPlacementName:pid];
            [_placementAdMap setObject:heliumRewarded forKey:pid];
        }
    }
    
    [heliumRewarded loadAd];
}


- (BOOL)isReady:(NSString *)pid {
    BOOL isReady = NO;
    id <HeliumInterstitialAd> heliumInterstitial = [_placementAdMap objectForKey:pid];
    if (heliumInterstitial && [heliumInterstitial respondsToSelector:@selector(readyToShow)]) {
        isReady = [heliumInterstitial readyToShow];
    }
    return isReady;
}

- (void)showAd:(NSString *)pid withVC:(UIViewController*)vc {
    if ([self isReady:pid]) {
        id <HeliumInterstitialAd> heliumInterstitial = [_placementAdMap objectForKey:pid];
        if(heliumInterstitial && [heliumInterstitial respondsToSelector:@selector(showAdWithViewController:)]) {
            [heliumInterstitial showAdWithViewController:vc];
        }
    }
}

#pragma -- CHBHeliumInterstitialAdDelegate


- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                             didLoadWithError:(HeliumError *)error {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidLoadWithError:error];
    }
}

- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                             didShowWithError:(HeliumError *)error {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidShowWithError:error];
    }
}

- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didClickWithError:(HeliumError *)error {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidClickWithError:error];
    }
}

- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                            didCloseWithError:(HeliumError *)error {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidCloseWithError:error];
    }
}


- (void)heliumInterstitialAdWithPlacementName:(NSString*)placementName
                    didLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidLoadWinningBidWithInfo:bidInfo];
    }
}

#pragma -- CHBHeliumRewardedAdDelegate

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                         didLoadWithError:(HeliumError *)error {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidLoadWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                         didShowWithError:(HeliumError *)error {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidShowWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                        didClickWithError:(HeliumError *)error {
    
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidClickWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                        didCloseWithError:(HeliumError *)error {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidCloseWithError:error];
    }
}

- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                             didGetReward:(NSInteger)reward {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidGetReward:reward];
    }
}


- (void)heliumRewardedAdWithPlacementName:(NSString*)placementName
                didLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    id <OMHeliumAdapterDelegate> delegate = [_placementDelegateMap objectForKey:placementName];
    if (delegate) {
        [delegate omHeliumDidLoadWinningBidWithInfo:bidInfo];
    }
}



@end
