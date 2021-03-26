// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHyBidNative.h"
#import "OMHyBidNativeAd.h"

@implementation OMHyBidNative

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
        [_delegate nativeCustomEventWillShow:self];
    }
}

- (void)nativeAdDidClick:(HyBidNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}

- (void)nativeLoaderDidFailWithError:(NSError *)error {
    NSError *hybidError = [[NSError alloc] initWithDomain:@"com.hybid.bid" code:error.code userInfo:@{@"msg":error.description}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:hybidError];
    }
}

- (void)nativeLoaderDidLoadWithNativeAd:(HyBidNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    nativeAd.delegate = self;
    OMHyBidNativeAd *hyBidNativeAd = [[OMHyBidNativeAd alloc] initWithHybidNativeAd:nativeAd];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":nativeAd.ad.eCPM, @"adObject":hyBidNativeAd} error:nil];
    }
}

@end
