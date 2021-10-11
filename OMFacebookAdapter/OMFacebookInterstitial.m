// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookInterstitial.h"

@implementation OMFacebookInterstitial


- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}
- (void)loadAd {
    Class FBInterstitialAdClass = NSClassFromString(@"FBInterstitialAd");
    if (FBInterstitialAdClass) {
        _facebookInterstitial = [[FBInterstitialAdClass alloc] initWithPlacementID:_pid];
        _facebookInterstitial.delegate = self;
        [_facebookInterstitial loadAd];
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    Class FBInterstitialAdClass = NSClassFromString(@"FBInterstitialAd");
    if (FBInterstitialAdClass) {
        _facebookInterstitial = [[FBInterstitialAdClass alloc] initWithPlacementID:_pid];
        _facebookInterstitial.delegate = self;
        [_facebookInterstitial loadAdWithBidPayload:bidPayload];
    }
}

- (BOOL)isReady{
    if (_facebookInterstitial && [_facebookInterstitial respondsToSelector:@selector(isAdValid)]) {
        return _facebookInterstitial.isAdValid && _ready;
    }
    return _ready;
}

- (void)show:(UIViewController*)vc{
    [_facebookInterstitial showAdFromRootViewController:vc];
    _ready = NO;
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd {
    _ready = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }

}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }

}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd {
    _facebookInterstitial = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
    
}

@end
