// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingBanner.h"

@implementation OMAdTimingBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        Class AdTimingBannerClass = NSClassFromString(@"AdTimingBidBanner");
        if (AdTimingBannerClass && [AdTimingBannerClass instancesRespondToSelector:@selector(initWithBannerType:placementID:)]) {
            _banner = [[AdTimingBannerClass alloc] initWithBannerType:[self convertWithSize:frame.size] placementID:[adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@""];
            [_banner addLayoutAttribute:AdTimingBidBannerLayoutAttributeTop constant:0];
            [_banner addLayoutAttribute:AdTimingBidBannerLayoutAttributeLeft constant:0];
            _banner.delegate = self;
            [self addSubview:_banner];
        }
    }
    return self;
}

- (AdTimingBidBannerType)convertWithSize:(CGSize)size {
    if (size.width == 300 && size.height == 250) {
        return AdTimingBidBannerTypeLarge;
    } else if (size.width == 728 && size.height == 90) {
        return AdTimingBidBannerTypeLeaderboard;
    } else  {
        return AdTimingBidBannerTypeDefault;
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    [_banner loadAndShowWithPayLoad:bidPayload];
}

#pragma mark -- AdTimingBannerDelegate

- (void)AdTimingBidBannerDidLoad:(AdTimingBidBanner *)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)AdTimingBidBannerDidFailToLoad:(AdTimingBidBanner *)banner withError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)AdTimingBidBannerWillExposure:(AdTimingBidBanner *)banner {
    
}

- (void)AdTimingBidBannerDidClick:(AdTimingBidBanner *)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)AdTimingBidBannerWillPresentScreen:(AdTimingBidBanner *)banner {
    
}

- (void)AdTimingBidBannerDidDismissScreen:(AdTimingBidBanner *)banner {
    
}

- (void)AdTimingBidBannerWillLeaveApplication:(AdTimingBidBanner *)banner {
}

@end
