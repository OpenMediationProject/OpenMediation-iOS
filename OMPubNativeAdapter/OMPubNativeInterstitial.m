// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPubNativeInterstitial.h"

@implementation OMPubNativeInterstitial

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
        Class HyBidFullscreenVideoAdClass = NSClassFromString(@"_TtC5HyBid19HyBidInterstitialAd");
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
    Class utilsClass = NSClassFromString(@"HyBidHeaderBiddingUtils");
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)] && utilsClass && [utilsClass respondsToSelector:@selector(eCPMFromAd:withDecimalPlaces:)]) {
        NSString *price = [utilsClass eCPMFromAd:self.fullscreenVideoAd.ad withDecimalPlaces:THREE_DECIMAL_PLACES];
        [_bidDelegate bidReseponse:self bid:@{@"price":price} error:nil];
        NSLog(@"PubNative price %@",price);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)interstitialDidFailWithError:(NSError *)error {
    NSError *hybidError = [[NSError alloc] initWithDomain:@"com.mediation.pubnativeadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:hybidError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:hybidError];
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
