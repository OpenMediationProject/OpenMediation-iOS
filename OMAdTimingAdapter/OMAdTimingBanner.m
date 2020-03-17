// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingBanner.h"

@implementation OMAdTimingBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        Class AdTimingBannerClass = NSClassFromString(@"AdTimingBanner");
        if (AdTimingBannerClass && [AdTimingBannerClass instancesRespondToSelector:@selector(initWithBannerType:placementID:)]) {
            _banner = [[AdTimingBannerClass alloc] initWithBannerType:AdTimingBannerTypeDefault placementID:[adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@""];
            [_banner addLayoutAttribute:AdTimingBannerLayoutAttributeTop constant:0];
            [_banner addLayoutAttribute:AdTimingBannerLayoutAttributeLeft constant:0];
            _banner.delegate = self;
            [self addSubview:_banner];
        }
    }
    return self;
}

- (void)loadAd{
    [_banner loadAndShow];
}

#pragma mark -- AdTimingBannerDelegate

- (void)adtimingBannerDidLoad:(AdTimingBanner *)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adtimingBanner:(AdTimingBanner *)banner didFailWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adtimingBannerWillExposure:(AdTimingBanner *)banner {
    
}

- (void)adtimingBannerDidClick:(AdTimingBanner *)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)adtimingBannerWillPresentScreen:(AdTimingBanner *)banner {
    
}

- (void)adtimingBannerDidDismissScreen:(AdTimingBanner *)banner {
    
}

- (void)adtimingBannerWillLeaveApplication:(AdTimingBanner *)banner {
}

@end
