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
        
        AdColonyAdOptions *options = [NSClassFromString(@"AdColonyAdOptions") new];

        if ([OMAdColonyAdapter getUserAge]) {
            if (!options.userMetadata) {
                Class userClass = NSClassFromString(@"AdColonyUserMetadata");
                if (userClass) {
                    options.userMetadata = [[userClass alloc]init];
                }
            }
            options.userMetadata.userAge = [OMAdColonyAdapter getUserAge];
        }
        if ([OMAdColonyAdapter getUserGender]) {
            if (!options.userMetadata) {
                Class userClass = NSClassFromString(@"AdColonyUserMetadata");
                if (userClass) {
                    options.userMetadata = [[userClass alloc]init];
                }
            }
            options.userMetadata.userGender = (([OMAdColonyAdapter getUserGender]==1)?@"male":@"female");
        }
        
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
    if(self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [self.delegate customEvent:self didLoadAd:nil];
    }
    self.adColonyAd = interstitial;
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [self.delegate rewardedVideoCustomEventDidReceiveReward:self];
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

@end
