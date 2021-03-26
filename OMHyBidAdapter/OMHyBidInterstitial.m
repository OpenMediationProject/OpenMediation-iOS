// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHyBidInterstitial.h"

@implementation OMHyBidInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

-(void)loadAd {
    
    if ([self isReady]) {
        [self interstitialDidLoad];
    } else {
        Class HyBidFullscreenVideoAdClass = NSClassFromString(@"HyBidInterstitialAd");
        if (HyBidFullscreenVideoAdClass && [[HyBidFullscreenVideoAdClass alloc] respondsToSelector:@selector(initWithZoneID:andWithDelegate:)]) {
            _fullscreenVideoAd = [[HyBidFullscreenVideoAdClass alloc] initWithZoneID:_pid andWithDelegate:self];
        }
        if (_fullscreenVideoAd) {
            [_fullscreenVideoAd load];
        }
    }
}

-(BOOL)isReady {
    if (_fullscreenVideoAd) {
        return (_fullscreenVideoAd.isReady);
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [_fullscreenVideoAd showFromViewController:vc];
    }
}

- (void)interstitialDidLoad {
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":_fullscreenVideoAd.ad.eCPM} error:nil];
    }
}

- (void)interstitialDidFailWithError:(NSError *)error {
    NSError *hybidError = [[NSError alloc] initWithDomain:@"com.hybid.bid" code:error.code userInfo:@{@"msg":error.description}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:hybidError];
    }
}

- (void)interstitialDidTrackClick {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)interstitialDidTrackImpression {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)interstitialDidDismiss {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

@end
