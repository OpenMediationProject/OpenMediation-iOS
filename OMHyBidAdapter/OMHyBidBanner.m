// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHyBidBanner.h"
#import "OMHyBidAdapter.h"

@implementation OMHyBidBanner

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
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":self.bannerAdView.ad.eCPM} error:nil];
    }
}

- (void)adView:(HyBidAdView *)adView didFailWithError:(NSError *)error {
    NSError *hybidError = [[NSError alloc] initWithDomain:@"com.hybid.bid" code:error.code userInfo:@{@"msg":error.description}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:hybidError];
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
