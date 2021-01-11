// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnityBanner.h"

@implementation OMUnityBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        Class UADSBannerViewClass = NSClassFromString(@"UADSBannerView");
        if (UADSBannerViewClass) {
            _bannerView = [[UADSBannerViewClass alloc] initWithPlacementId:[adParameter objectForKey:@"pid"] size:frame.size];
            _bannerView.delegate = self;
            [self addSubview:_bannerView];
        }
    }
    return self;
}

- (void)loadAd{
    if (_bannerView && [_bannerView respondsToSelector:@selector(load)]) {
        [_bannerView load];
    }
}


-(void)bannerViewDidLoad:(UADSBannerView *)bannerView{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)bannerViewDidError:(UADSBannerView *)bannerView error:(UADSBannerError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

-(void)bannerViewDidClick:(UADSBannerView *)bannerView{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)bannerViewDidLeaveApplication:(UADSBannerView *)bannerView{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}

@end
