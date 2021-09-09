// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdmostInterstitial.h"

@implementation OMAdmostInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

- (void)loadAd {
    Class interstitialClass = NSClassFromString(@"AMRInterstitial");
    if (interstitialClass && [interstitialClass respondsToSelector:@selector(interstitialForZoneId:)] && !_interstitial) {
        _interstitial = [interstitialClass interstitialForZoneId:_pid];
        _interstitial.delegate = self;
    }
    [_interstitial loadInterstitial];
}

- (BOOL)isReady {
    BOOL ready = NO;
    if (_interstitial && [_interstitial respondsToSelector:@selector(isLoaded)]) {
        ready = [_interstitial isLoaded];
    }
    return ready;
}

- (void)show:(UIViewController*)vc {
    if(self.interstitial && [self isReady] && [_interstitial respondsToSelector:@selector(showFromViewController:)]) {
        [_interstitial showFromViewController:vc];
    }
}

#pragma mark - AMRInterstitialDelegate

- (void)didReceiveInterstitial:(AMRInterstitial *)interstitial {
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:([interstitial.ecpm doubleValue]/100.0)]} error:nil];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)didFailToReceiveInterstitial:(AMRInterstitial *)interstitial error:(AMRError * )error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.admostadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }
}

- (void)didShowInterstitial:(AMRInterstitial *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)didFailToShowInterstitial:(AMRInterstitial *)interstitial error:(AMRError *)error {
    NSError *failError = [[NSError alloc] initWithDomain:@"com.openmediation.admostadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
    
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:failError];
    }
}

- (void)didClickInterstitial:(AMRInterstitial *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)didDismissInterstitial:(AMRInterstitial *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)didInterstitialStateChanged:(AMRInterstitial *)interstitial state:(AMRAdState)state {
    
}

@end
