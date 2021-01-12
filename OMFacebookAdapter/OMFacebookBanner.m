#import "OMFacebookBanner.h"


@implementation OMFacebookBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class fbAdView = NSClassFromString(@"FBAdView");
        struct FBAdSize adsize = {CGSizeMake(-1, frame.size.height)};
        if (fbAdView && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _facebookBannerView = [[fbAdView alloc] initWithPlacementID:([adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@"")
                                                                 adSize:adsize
                                                     rootViewController:rootViewController];
        }
        _facebookBannerView.frame = CGRectMake(frame.size.width/2.0-_facebookBannerView.frame.size.width/2.0, frame.size.height-_facebookBannerView.frame.size.height, _facebookBannerView.frame.size.width, _facebookBannerView.frame.size.height);;
        _facebookBannerView.delegate = self;
        [self addSubview:_facebookBannerView];
    }
    return self;
}

- (void)loadAd {
    [_facebookBannerView loadAd];
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    [_facebookBannerView loadAdWithBidPayload:bidPayload];
}
- (void)adViewDidLoad:(FBAdView *)adView {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView {
    
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]) {
        [_delegate bannerCustomEventDismissScreen:self];
    }
}

- (void)adViewDidClick:(FBAdView *)adView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)adViewWillLogImpression:(FBAdView *)adView {

}

@end
