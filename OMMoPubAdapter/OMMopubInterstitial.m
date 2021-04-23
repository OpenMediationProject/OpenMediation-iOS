// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubInterstitial.h"

@implementation OMMopubInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }

    }
    return self;
}
- (void)loadAd {

    Class interstitialClass = NSClassFromString(@"MPInterstitialAdController");

    if (interstitialClass && [interstitialClass respondsToSelector:@selector(interstitialAdControllerForAdUnitId:)]) {
        _interstitial = [interstitialClass  interstitialAdControllerForAdUnitId:_pid];
        _interstitial.delegate = self;
        [_interstitial loadAd];
        
    }
}

- (BOOL)isReady{
    return _interstitial.ready;
}

- (void)show:(UIViewController*)vc{
    [self.interstitial showFromViewController:vc];
}

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial
                          withError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    if (!_hasShown && _delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    if (!_hasShown && _delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)interstitialWillDismiss:(MPInterstitialAdController *)interstitial {
    
}

- (void)interstitialDidDismiss:(MPInterstitialAdController *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    
}


- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
    _hasShown = YES;
}

@end
