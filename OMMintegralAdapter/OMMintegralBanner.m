// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralBanner.h"


@implementation OMMintegralBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class MTGBannerAdViewClass = NSClassFromString(@"MTGBannerAdView");
        if (MTGBannerAdViewClass && [MTGBannerAdViewClass instancesRespondToSelector:@selector(initBannerAdViewWithAdSize:placementId:unitId:rootViewController:)]) {
            _bannerAdView = [[MTGBannerAdViewClass alloc]initBannerAdViewWithAdSize:frame.size placementId:@"" unitId:[adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@""  rootViewController:rootViewController];
            _bannerAdView.frame = CGRectMake(frame.size.width/2.0-_bannerAdView.frame.size.width/2.0, frame.size.height-_bannerAdView.frame.size.height, _bannerAdView.frame.size.width, _bannerAdView.frame.size.height);
            _bannerAdView.delegate = self;
            [self addSubview:_bannerAdView];
        }
    }
    return self;
}

- (void)loadAd {
    [_bannerAdView loadBannerAd];
}

#pragma mark MTGBannerAdViewDelegate
- (void)adViewLoadSuccess:(MTGBannerAdView *)adView {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
    _impr = NO;
}

- (void)adViewLoadFailedWithError:(NSError *)error adView:(MTGBannerAdView *)adView {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


- (void)adViewWillLogImpression:(MTGBannerAdView *)adView {

}


- (void)adViewDidClicked:(MTGBannerAdView *)adView {
   if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
       [_delegate bannerCustomEventDidClick:self];
   }
}

- (void)adViewWillLeaveApplication:(MTGBannerAdView *)adView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}

- (void)adViewWillOpenFullScreen:(MTGBannerAdView *)adView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)adViewCloseFullScreen:(MTGBannerAdView *)adView {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]) {
        [_delegate bannerCustomEventDismissScreen:self];
    }
}

- (void)adViewClosed:(nonnull MTGBannerAdView *)adView {
    
}

@end
