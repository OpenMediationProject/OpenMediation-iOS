// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleBanner.h"

@implementation OMVungleBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMVungleRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}

- (void)loadAd {
    _adShow = NO;
    [[OMVungleRouter sharedInstance]loadBannerWithPlacementID:_pid];
}

- (void)renderBanner {
    
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)] && [vungleClass instancesRespondToSelector:@selector(addAdViewToView:withOptions:placementID:error:)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        _renderView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_renderView];
        [vungle addAdViewToView:_renderView withOptions:@{} placementID:self.pid error:nil];
        
    }
    
}

- (void)omVungleDidload {
    if (!_adShow) {
        _adShow = YES;
        [self renderBanner];
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
            [_delegate customEvent:self didLoadAd:nil];
        }
    }
}

- (void)omVungleDidFailToLoad:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)omVungleDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)omVungleDidFinish:(BOOL)skipped {
    _adShow = NO;
}

- (void)omVungleWillLeaveApplication {
    if (_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}
@end
