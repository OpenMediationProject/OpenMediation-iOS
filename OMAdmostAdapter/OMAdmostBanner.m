// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdmostBanner.h"

@implementation OMAdmostBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        Class bannerClass = NSClassFromString(@"AMRBanner");
        if (bannerClass && [adParameter isKindOfClass:[NSDictionary class]] && bannerClass && [bannerClass respondsToSelector:@selector(bannerForZoneId:)]) {
            _pid = [adParameter objectForKey:@"pid"];
            _banner = [bannerClass bannerForZoneId:_pid];
            _banner.viewController = rootViewController;
            _banner.bannerWidth = frame.size.width;
        }
        _banner.delegate = self;
    }
    return self;
}

- (void)loadAd {
    if (_banner && [_banner respondsToSelector:@selector(loadBanner)]) {
        [_banner loadBanner];
    }
}

#pragma mark - AMRBannerDelegate

- (void)didReceiveBanner:(AMRBanner *)banner {
    [self addSubview:_banner.bannerView];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:([banner.ecpm doubleValue]/100.0)]} error:nil];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)didFailToReceiveBanner:(AMRBanner *)banner error:(AMRError *)error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.admostadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
}

- (void)didClickBanner:(AMRBanner *)banner {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

@end
