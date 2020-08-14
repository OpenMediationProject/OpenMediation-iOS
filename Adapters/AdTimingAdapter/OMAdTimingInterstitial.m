// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingInterstitial.h"

@implementation OMAdTimingInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

- (void)loadAd {
    Class interstitialClass = NSClassFromString(@"AdTimingAdsInterstitial");
    if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(loadWithPlacementID:)] && [_pid length]>0) {
        [[interstitialClass sharedInstance]loadWithPlacementID:_pid];
        if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(addDelegate:)]) {
            [[interstitialClass sharedInstance]addDelegate:self];
        }
    }

}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    Class interstitialClass = NSClassFromString(@"AdTimingAdsInterstitial");
    if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(loadWithPlacementID:)] && [_pid length]>0) {
        [[interstitialClass sharedInstance]loadWithPlacementID:_pid payLoad:bidPayload];
        if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(addDelegate:)]) {
            [[interstitialClass sharedInstance]addDelegate:self];
        }
    }
}

- (BOOL)isReady {
    BOOL isReady = NO;
    Class interstitialClass = NSClassFromString(@"AdTimingAdsInterstitial");
    if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(isReady:)] && [_pid length]>0) {
        isReady = [[interstitialClass sharedInstance]isReady:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController *)vc {
    Class interstitialClass = NSClassFromString(@"AdTimingAdsInterstitial");
    if ([self isReady]) {
        if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(showAdFromRootViewController:placementID:)]) {
            [[interstitialClass sharedInstance]showAdFromRootViewController:vc placementID:_pid];
        }
    }
}

#pragma mark - AdTimingMediatedInterstitialDelegate


- (void)adtimingInterstitialDidLoad:(NSString *)placementID {
    if ([placementID isEqualToString:_pid]) {
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
            [_delegate customEvent:self didLoadAd:nil];
        }
    }
}

- (void)adtimingInterstitialDidFailToLoad:(NSString *)placementID withError:(NSError *)error {
    if ([placementID isEqualToString:_pid] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adtimingInterstitialDidOpen:(NSString*)placementID {
    if ([placementID isEqualToString:_pid] && _delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
}

- (void)adtimingInterstitialDidShow:(NSString*)placementID {
    if ([placementID isEqualToString:_pid] && _delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)adtimingInterstitialDidClick:(NSString*)placementID {
    if ([placementID isEqualToString:_pid] && _delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)adtimingInterstitialDidClose:(NSString*)placementID {
    if ([placementID isEqualToString:_pid] && _delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)adtimingInterstitialDidFailToShow:(NSString*)placementID withError:(NSError *)error {
    if ([placementID isEqualToString:_pid] && _delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}

@end
