//
//  OMVungleInterstitial.m
//  OMVungleAdapter
//
//  Created by M on 2023/4/12.
//  Copyright © 2023 AdTiming. All rights reserved.
//

#import "OMVungleInterstitial.h"

@implementation OMVungleInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

- (void)loadAd {
    Class vungleClass = NSClassFromString(@"_TtC12VungleAdsSDK18VungleInterstitial");
    if (vungleClass && [vungleClass instancesRespondToSelector:@selector(initWithPlacementId:)]) {
        _interstitialAd = [[vungleClass alloc] initWithPlacementId:_pid];
        _interstitialAd.delegate = self;
        [_interstitialAd load:nil];
    }
}

- (BOOL)isReady{
    BOOL isReady = NO;
    if (_interstitialAd && [_interstitialAd respondsToSelector:@selector(canPlayAd)]) {
        isReady = [_interstitialAd canPlayAd];
    }
    return isReady;
}

- (void)show:(UIViewController*)vc{
    if ([self isReady] && [_interstitialAd respondsToSelector:@selector(presentWith:)]) {
        [_interstitialAd presentWith:vc];
    }
}

- (void)interstitialAdDidLoad:(VungleInterstitial *)interstitial {
    if ([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}
- (void)interstitialAdDidFailToLoad:(VungleInterstitial *)interstitial withError:(NSError *)withError {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:withError];
    }
}
- (void)interstitialAdDidPresent:(VungleInterstitial *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}
- (void)interstitialAdDidFailToPresent:(VungleInterstitial *)interstitial withError:(NSError *)withError {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:withError];
    }
}
- (void)interstitialAdDidClick:(VungleInterstitial *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}
- (void)interstitialAdDidClose:(VungleInterstitial *)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}
- (void)interstitialAdWillPresent:(VungleInterstitial *)interstitial {
    
}
- (void)interstitialAdWillClose:(VungleInterstitial *)interstitial {
    
}
- (void)interstitialAdDidTrackImpression:(VungleInterstitial *)interstitial {
    
}
- (void)interstitialAdWillLeaveApplication:(VungleInterstitial *)interstitial {
    
}

@end
