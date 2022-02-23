// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralInterstitial.h"

@implementation OMMintegralInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

-(void)loadAd {
    Class MTGNewInterstitialAdManagerClass = NSClassFromString(@"MTGNewInterstitialAdManager");
    if (MTGNewInterstitialAdManagerClass && [[MTGNewInterstitialAdManagerClass alloc] respondsToSelector:@selector(initWithPlacementId:unitId:delegate:)]) {
        _ivAdManager = [[MTGNewInterstitialAdManagerClass alloc] initWithPlacementId:@"" unitId:_pid delegate:self];
    }
    if (_ivAdManager) {
        [_ivAdManager loadAd];
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    Class MTGNewInterstitialBidAdManagerClass = NSClassFromString(@"MTGNewInterstitialBidAdManager");
    if (MTGNewInterstitialBidAdManagerClass && [MTGNewInterstitialBidAdManagerClass instancesRespondToSelector:@selector(initWithPlacementId:unitId:delegate:)]) {
        _ivBidAdManager = [[MTGNewInterstitialBidAdManagerClass alloc] initWithPlacementId:@"" unitId:_pid delegate:self];
    }
    if (_ivBidAdManager) {
        [_ivBidAdManager loadAdWithBidToken:bidPayload];
    }
}

-(BOOL)isReady {
    if (_ivAdManager) {
        return [_ivAdManager isAdReady];
    }else if (_ivBidAdManager) {
        return [_ivBidAdManager isAdReady];
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if (_ivAdManager && [self isReady]) {
        [_ivAdManager showFromViewController:vc];
    }else if (_ivBidAdManager && [self isReady]) {
        [_ivBidAdManager showFromViewController:vc];
    }
}

- (void)newInterstitialAdResourceLoadSuccess:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)newInterstitialAdLoadFail:(nonnull NSError *)error adManager:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)newInterstitialAdShowSuccess:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)newInterstitialAdShowFail:(nonnull NSError *)error adManager:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    
}

- (void)newInterstitialAdClicked:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)newInterstitialAdPlayCompleted:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    
}

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */

// Play End
- (void)newInterstitialAdEndCardShowSuccess:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    
}


- (void)newInterstitialAdDismissedWithConverted:(BOOL)converted adManager:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    
}

- (void)newInterstitialAdDidClosed:(MTGNewInterstitialAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

#pragma mark MTGNewInterstitialBidAdDelegate

- (void)newInterstitialBidAdResourceLoadSuccess:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)newInterstitialBidAdLoadFail:(nonnull NSError *)error adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


/**
 *  Called when the ad display success
 */
- (void)newInterstitialBidAdShowSuccess:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

/**
 *  Only called when displaying bidding ad.
 */
- (void)newInterstitialBidAdShowSuccessWithBidToken:(nonnull NSString * )bidToken adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    
}

/**
 *  Called when the ad failed to display
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)newInterstitialBidAdShowFail:(nonnull NSError *)error adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)newInterstitialBidAdPlayCompleted:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    
}

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */
- (void)newInterstitialBidAdEndCardShowSuccess:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    
}


/**
 *  Called when the ad is clicked
 */
- (void)newInterstitialBidAdClicked:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *  @param converted   - BOOL describing whether the ad has converted
 */
- (void)newInterstitialBidAdDismissedWithConverted:(BOOL)converted adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    
}

/**
 *  Called when the ad  did closed;
 */
- (void)newInterstitialBidAdDidClosed:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

/**
 *  If New Interstitial  reward is set, you will receive this callback
 *  @param rewardedOrNot  Whether the video played to required rate
 * @param alertWindowStatus  {@link MTGNIAlertWindowStatus} for list of supported types
 NOTE:You can decide whether or not to give the reward based on this callback
 */
- (void)newInterstitialBidAdRewarded:(BOOL)rewardedOrNot alertWindowStatus:(MTGNIAlertWindowStatus)alertWindowStatus adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager {
    
}

@end
