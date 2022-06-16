// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSigMobInterstitial.h"

@implementation OMSigMobInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        
    }
    return self;
}

-(void)loadAd {
    Class WindIntersititialAdClass = NSClassFromString(@"WindIntersititialAd");
    Class WindRequestClass = NSClassFromString(@"WindAdRequest");
    if (WindIntersititialAdClass && WindRequestClass && [WindIntersititialAdClass instancesRespondToSelector:@selector(initWithRequest:)] && [WindRequestClass respondsToSelector:@selector(request)]) {
        WindAdRequest *request  = [WindRequestClass request];
        request.placementId = _pid;
        _interstitialAd = [[WindIntersititialAdClass alloc] initWithRequest:request];
        _interstitialAd.delegate = self;
    }
    if (_interstitialAd) {
        [_interstitialAd loadAdData];
    }
}

-(BOOL)isReady {
    if (_interstitialAd) {
        return _interstitialAd.ready;
    }
    return NO;
    
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [_interstitialAd showAdFromRootViewController:vc options:nil];
    }
}

- (void)intersititialAdDidLoad:(WindIntersititialAd *)intersititialAd {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)intersititialAdDidLoad:(WindIntersititialAd *)intersititialAd didFailWithError:(NSError *)error {
    if(error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)intersititialAdWillVisible:(WindIntersititialAd *)intersititialAd {
    
}

- (void)intersititialAdDidVisible:(WindIntersititialAd *)intersititialAd {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)intersititialAdDidClick:(WindIntersititialAd *)intersititialAd {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)intersititialAdDidClickSkip:(WindIntersititialAd *)intersititialAd {
    
}

- (void)intersititialAdDidClose:(WindIntersititialAd *)intersititialAd {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)intersititialAdDidPlayFinish:(WindIntersititialAd *)intersititialAd didFailWithError:(NSError *)error {
    if (error) {
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
            [_delegate interstitialCustomEventDidFailToShow:self error:error];
        }
    }
}

- (void)intersititialAdServerResponse:(WindIntersititialAd *)intersititialAd isFillAd:(BOOL)isFillAd {
    
}

@end
