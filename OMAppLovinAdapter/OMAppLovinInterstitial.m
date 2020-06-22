// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAppLovinAdapter.h"
#import "OMAppLovinInterstitial.h"




@implementation OMAppLovinInterstitial
- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

- (void)loadAd {
    ALSdk *sdk = [OMAppLovinAdapter alShareSdk];
    Class appLovinClass = NSClassFromString(@"ALInterstitialAd");
    if (sdk && appLovinClass && !_appLovinInterstitial) {
        _appLovinInterstitial = [[appLovinClass alloc] initWithSdk:sdk];
        _appLovinInterstitial.adDisplayDelegate = self;
        _appLovinInterstitial.adVideoPlaybackDelegate = self;
    }
    Class appLovinServiceClass = NSClassFromString(@"ALAdService");
    if (sdk && appLovinServiceClass && [_pid length]>0) {
        [sdk.adService loadNextAdForZoneIdentifier:_pid andNotify:self];
    }
}

- (BOOL)isReady {
    return _ready;
}

- (void)show:(UIViewController*)vc {
    if(self.alAd && _appLovinInterstitial && [_appLovinInterstitial respondsToSelector:@selector(showAd:)]){
        [_appLovinInterstitial showAd:self.alAd];
    }
    _ready = NO;
}

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad {
    _ready = YES;
    self.alAd = ad;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:[NSError errorWithDomain:@"com.applovin.ads" code:code userInfo: @{NSLocalizedDescriptionKey:@"",NSLocalizedFailureReasonErrorKey:@""}]];
    }
}

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}


- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}


- (void)videoPlaybackBeganInAd:(ALAd *)ad {
    
}

// end
- (void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched {
    
}


@end
