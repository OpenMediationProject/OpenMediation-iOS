// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleBanner.h"

@implementation OMVungleBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        _pid = [adParameter objectForKey:@"pid"];
        Class bannerViewClass = NSClassFromString(@"_TtC12VungleAdsSDK12VungleBanner");
        if (bannerViewClass) {
            _bannerView = [[bannerViewClass alloc] initWithPlacementId:_pid size:[self convertWithSize:frame.size]];
            _bannerView.delegate = self;
        }
    }
    return self;
}

- (BannerSize)convertWithSize:(CGSize)size {
    if (size.width == 320 && size.height == 50) {
        return BannerSizeRegular;
    } else if (size.width == 728 && size.height == 90) {
        return BannerSizeLeaderboard;
    } else if (size.width == 300 && size.height == 250) {
        return BannerSizeMrec;
    }else{
        return BannerSizeShort;
    }
}


- (void)loadAd {
    [_bannerView load:nil];
}

- (void)bannerAdDidLoad:(VungleBanner * _Nonnull)bavnner {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
        [_bannerView presentOn:self];
    }
}
- (void)bannerAdDidFailToLoad:(VungleBanner * _Nonnull)banner withError:(NSError * _Nonnull)withError {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:withError];
    }
}

- (void)bannerAdDidClick:(VungleBanner * _Nonnull)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}
- (void)bannerAdWillLeaveApplication:(VungleBanner * _Nonnull)banner {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}

- (void)bannerAdWillPresent:(VungleBanner * _Nonnull)banner {
    
}

- (void)bannerAdDidPresent:(VungleBanner * _Nonnull)banner {
    
}

- (void)bannerAdDidFailToPresent:(VungleBanner * _Nonnull)banner withError:(NSError * _Nonnull)withError {
    
}

- (void)bannerAdWillClose:(VungleBanner * _Nonnull)banner {
    
}

- (void)bannerAdDidClose:(VungleBanner * _Nonnull)banner {
    
}

- (void)bannerAdDidTrackImpression:(VungleBanner * _Nonnull)banner{
    
}

@end
