#import "OMAdMobAdapter.h"
#import "OMAdMobBanner.h"


@implementation OMAdMobBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class GADBannerViewClass = NSClassFromString(@"GADBannerView");
        if (GADBannerViewClass && adParameter && [adParameter isKindOfClass:[NSDictionary class]] && [GADBannerViewClass instancesRespondToSelector:@selector(initWithAdSize:)]) {
            _admobBannerView = [[GADBannerViewClass alloc] initWithAdSize:GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.size.width)];
            _admobBannerView.adUnitID = [adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@"";
            _admobBannerView.delegate = self;
            _admobBannerView.rootViewController = rootViewController;
            [self addSubview:_admobBannerView];
        }
    }
    return self;
}
- (void)loadAd {
    Class requestClass = NSClassFromString(@"GADRequest");
    if (requestClass && [requestClass respondsToSelector:@selector(request)]) {
        GADRequest *request  = [requestClass request];
        if ([OMAdMobAdapter npaAd] && NSClassFromString(@"GADExtras")) {
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
