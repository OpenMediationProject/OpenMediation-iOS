#import "OMAdMobAdapter.h"
#import "OMAdMobBanner.h"


@implementation OMAdMobBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class GADBannerViewClass = NSClassFromString(@"GADBannerView");
        if (GADBannerViewClass && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _admobBannerView = [[GADBannerViewClass alloc] initWithFrame:frame];
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
    if ([requestClass respondsToSelector:@selector(shimmedClass)]) {
        requestClass = [requestClass shimmedClass];
    }
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


- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]) {
        [_delegate bannerCustomEventDismissScreen:self];
    }
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}

@end
