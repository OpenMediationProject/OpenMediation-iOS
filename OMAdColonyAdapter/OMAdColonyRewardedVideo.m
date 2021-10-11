// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdColonyRewardedVideo.h"
#import "OMAdColonyAdapter.h"

@implementation OMAdColonyRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter{
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

- (void)loadAd {
    
    Class adColonyClass = NSClassFromString(@"AdColony");
    if(adColonyClass && [adColonyClass respondsToSelector:@selector(requestInterstitialInZone:options:andDelegate:)]) {
        [adColonyClass requestInterstitialInZone:_pid options:nil andDelegate:self];
    }
    
}

- (BOOL)isReady {
    if (self.adColonyAd) {
        return !self.adColonyAd.expired;
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [self.adColonyAd showWithPresentingViewController:vc];
    }
}

// Store a reference to the returned interstitial object
- (void)adColonyInterstitialDidLoad:(AdColonyInterstitial *)interstitial {
    Class adColonyClass = NSClassFromString(@"AdColony");
    if(adColonyClass && [adColonyClass respondsToSelector:@selector(zoneForID:)]) {
        self.zone = [adColonyClass zoneForID:_pid];
    }
    self.adColonyAd = interstitial;
    
    __weak typeof(self) weakSelf = self;
    [self.zone setReward:^(BOOL success, NSString * _Nonnull name, int amount) {
        if (success) {
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
                [weakSelf.delegate rewardedVideoCustomEventDidReceiveReward:weakSelf];
            }
        }
    }];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [self.delegate customEvent:self didLoadAd:nil];
    }
    
}

// Handle loading error
- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError *)error {
    if(self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [self.delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adColonyInterstitialWillOpen:(AdColonyInterstitial *)interstitial {
    if(self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [self.delegate rewardedVideoCustomEventDidOpen:self];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [self.delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)adColonyInterstitialDidClose:(AdColonyInterstitial *)interstitial {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [self.delegate rewardedVideoCustomEventVideoEnd:self];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [self.delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)adColonyInterstitialWillLeaveApplication:(AdColonyInterstitial *)interstitial {
    NSLog(@"Interstitial will send user out of application");
}

- (void)adColonyInterstitialDidReceiveClick:(AdColonyInterstitial *)interstitial {
    if(self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [self.delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)adColonyInterstitialExpired:(AdColonyInterstitial * _Nonnull)interstitial {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customEventAdDidExpired:)]) {
        [self.delegate customEventAdDidExpired:self];
    }
}

@end
