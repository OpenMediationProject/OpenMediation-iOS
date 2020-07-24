// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingBanner.h"

@implementation OMAdTimingBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        Class AdTimingBannerClass = NSClassFromString(@"AdTimingAdsBanner");
        if (AdTimingBannerClass && [AdTimingBannerClass instancesRespondToSelector:@selector(initWithBannerType:placementID:)]) {
            _banner = [[AdTimingBannerClass alloc] initWithBannerType:[self convertWithSize:frame.size] placementID:[adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@""];
            [_banner addLayoutAttribute:AdTimingAdsBannerLayoutAttributeTop constant:0];
            [_banner addLayoutAttribute:AdTimingAdsBannerLayoutAttributeLeft constant:0];
            _banner.delegate = self;
            [self addSubview:_banner];
        }
    }
    return self;
}

- (AdTimingAdsBannerType)convertWithSize:(CGSize)size {
    if (size.width == 300 && size.height == 250) {
        return AdTimingAdsBannerTypeLarge;
    } else if (size.width == 728 && size.height == 90) {
        return AdTimingAdsBannerTypeLeaderboard;
    } else  {
        return AdTimingAdsBannerTypeDefault;
    }
}

- (void)loadAd{
    [_banner loadAndShow];
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    [_banner loadAndShowWithPayLoad:bidPayload];
}

#pragma mark -- AdTimingBannerDelegate

- (void)adtimingBannerDidLoad:(AdTimingAdsBanner *)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adtimingBannerDidFailToLoad:(AdTimingAdsBanner *)banner withError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adtimingBannerWillExposure:(AdTimingAdsBanner *)banner {
    
}

- (void)adtimingBannerDidClick:(AdTimingAdsBanner *)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)adtimingBannerWillPresentScreen:(AdTimingAdsBanner *)banner {
    
}

- (void)adtimingBannerDidDismissScreen:(AdTimingAdsBanner *)banner {
    
}

- (void)adtimingBannerWillLeaveApplication:(AdTimingAdsBanner *)banner {
}

@end
