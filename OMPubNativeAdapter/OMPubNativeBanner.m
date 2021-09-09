// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPubNativeBanner.h"
#import "OMPubNativeAdapter.h"

@implementation OMPubNativeBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class HyBidViewClass = NSClassFromString(@"HyBidAdView");
        Class adSize = NSClassFromString(@"HyBidAdSize");
        _pid = [adParameter objectForKey:@"pid"];
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]] && HyBidViewClass && [HyBidViewClass instancesRespondToSelector:@selector(initWithSize:)] && adSize) {
            _bannerAdView = [(HyBidAdView*)[HyBidViewClass alloc] initWithSize:[self convertWithSize:frame.size]];
        }
        _bannerAdView.delegate = self;
        [self addSubview:_bannerAdView];
    }
    return self;
}

- (HyBidAdSize *)convertWithSize:(CGSize)size {
    Class adSize = NSClassFromString(@"HyBidAdSize");
    if (size.width == 300 && size.height == 250) {
        return [adSize SIZE_300x250];
    } else if (size.width == 728 && size.height == 90) {
        return [adSize SIZE_728x90];
    } else  {
        return [adSize SIZE_320x50];
    }
}

- (void)loadAd {
    if (_bannerAdView && [_bannerAdView respondsToSelector:@selector(loadWithZoneID:andWithDelegate:)]) {
        [_bannerAdView loadWithZoneID:_pid andWithDelegate:self];
    }
}

#pragma mark - HyBidAdViewDelegate

- (void)adViewDidLoad:(HyBidAdView *)adView {
    Class utilsClass = NSClassFromString(@"HyBidHeaderBiddingUtils");
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)] && utilsClass && [utilsClass respondsToSelector:@selector(eCPMFromAd:withDecimalPlaces:)]) {
        NSString *price = [utilsClass eCPMFromAd:self.bannerAdView.ad withDecimalPlaces:THREE_DECIMAL_PLACES];
        [_bidDelegate bidReseponse:self bid:@{@"price":price} error:nil];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adView:(HyBidAdView *)adView didFailWithError:(NSError *)error {
    NSError *hybidError = [[NSError alloc] initWithDomain:@"com.mediation.pubnativeadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:hybidError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:hybidError];
    }
}

- (void)adViewDidTrackClick:(HyBidAdView *)adView {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
    
}

- (void)adViewDidTrackImpression:(HyBidAdView *)adView {
    
}

@end
