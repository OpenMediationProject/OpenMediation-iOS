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
    Class interstitialClass = NSClassFromString(@"AdTimingInterstitialAd");
    if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(loadWithPlacementID:)] && [_pid length]>0) {
        [[interstitialClass sharedInstance]loadWithPlacementID:_pid];
        if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(addMediationDelegate:)]) {
            [[interstitialClass sharedInstance]addMediationDelegate:self];
        }
    }

}

- (BOOL)isReady {
    BOOL isReady = NO;
    Class interstitialClass = NSClassFromString(@"AdTimingInterstitialAd");
    if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(isReady:)] && [_pid length]>0) {
        isReady = [[interstitialClass sharedInstance]isReady:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController *)vc {
    Class interstitialClass = NSClassFromString(@"AdTimingInterstitialAd");
    if ([self isReady]) {
        if (interstitialClass && [interstitialClass respondsToSelector:@selector(sharedInstance)] && [interstitialClass instancesRespondToSelector:@selector(showWithViewController:placementID:)]) {
            [[interstitialClass sharedInstance]showWithViewController:vc placementID:_pid];
        }
    }
}

#pragma mark - AdTimingMediatedInterstitialDelegate

- (void)adtimingInterstitialChangedAvailability:(NSString*)placementID newValue:(BOOL)available {
    if (available && [placementID isEqualToString:_pid]) {
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
            [_delegate customEvent:self didLoadAd:nil];
        }
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
