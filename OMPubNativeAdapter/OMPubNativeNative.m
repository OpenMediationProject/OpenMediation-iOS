// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPubNativeNative.h"
#import "OMPubNativeNativeAd.h"

@implementation OMPubNativeNative

- (instancetype)initWithParameter:(NSDictionary *)adParameter rootVC:(UIViewController *)rootViewController {
    if (self = [super init]) {
        Class nativeClass = NSClassFromString(@"HyBidNativeAdLoader");
        if (nativeClass && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            self.nativeAdLoader = [[nativeClass alloc] init];
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

-(void)loadAd {
    if (self.nativeAdLoader && [self.nativeAdLoader respondsToSelector:@selector(loadNativeAdWithDelegate:withZoneID:)]) {
        [self.nativeAdLoader loadNativeAdWithDelegate:self withZoneID:_pid];
    }
}

- (void)nativeAdDidFinishFetching:(HyBidNativeAd *)nativeAd {
    
}

- (void)nativeAd:(HyBidNativeAd *)nativeAd didFailFetchingWithError:(NSError *)error {
    
}

- (void)nativeAd:(HyBidNativeAd *)nativeAd impressionConfirmedWithView:(UIView *)view {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:nativeAd];
    }
}

- (void)nativeAdDidClick:(HyBidNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:nativeAd];
    }
}

- (void)nativeLoaderDidFailWithError:(NSError *)error {
    NSError *hybidError = [[NSError alloc] initWithDomain:@"com.mediation.pubnativeadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:hybidError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:hybidError];
    }
}

- (void)nativeLoaderDidLoadWithNativeAd:(HyBidNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    nativeAd.delegate = self;
    OMPubNativeNativeAd *hyBidNativeAd = [[OMPubNativeNativeAd alloc] initWithHybidNativeAd:nativeAd];
    Class utilsClass = NSClassFromString(@"HyBidHeaderBiddingUtils");
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)] && utilsClass && [utilsClass respondsToSelector:@selector(eCPMFromAd:withDecimalPlaces:)]) {
        NSString *price = [utilsClass eCPMFromAd:nativeAd.ad withDecimalPlaces:THREE_DECIMAL_PLACES];
        [_bidDelegate bidReseponse:self bid:@{@"price":price,@"adObject":hyBidNativeAd} error:nil];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:hyBidNativeAd];
    }
}

@end
