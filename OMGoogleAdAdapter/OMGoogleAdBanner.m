// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMGoogleAdAdapter.h"
#import "OMGoogleAdBanner.h"


@implementation OMGoogleAdBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class bannerViewClass = NSClassFromString(@"GAMBannerView");
        if (bannerViewClass && adParameter && [adParameter isKindOfClass:[NSDictionary class]] && [bannerViewClass instancesRespondToSelector:@selector(initWithAdSize:)]) {
            _admobBannerView = [[bannerViewClass alloc] initWithAdSize:GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.size.width)];
            _admobBannerView.adUnitID = [adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@"";
            _admobBannerView.delegate = self;
            _admobBannerView.rootViewController = rootViewController;
            [self addSubview:_admobBannerView];
        }
    }
    return self;
}
- (void)loadAd {
    Class requestClass = NSClassFromString(@"GAMRequest");
    if (requestClass && [requestClass respondsToSelector:@selector(request)]) {
        GAMRequest *request  = [requestClass request];
        if ([OMGoogleAdAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        [_admobBannerView loadRequest:request];
    }
}

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadWithAdnName:)]) {
        NSString *adnName = @"";
        GADResponseInfo *info = [bannerView responseInfo];
        if (info && [info respondsToSelector:@selector(adNetworkClassName)]) {
            adnName = [info adNetworkClassName];
        }
        [_delegate customEvent:self didLoadWithAdnName:adnName];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
    
}

- (void)bannerViewDidRecordClick:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}
   
- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}


- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]) {
        [_delegate bannerCustomEventDismissScreen:self];
    }
    
}


@end
