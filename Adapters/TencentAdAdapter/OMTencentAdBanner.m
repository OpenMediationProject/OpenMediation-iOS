// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdBanner.h"

@implementation OMTencentAdBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if(self = [super initWithFrame:frame]){
        Class gdtClass = NSClassFromString(@"GDTUnifiedBannerView");
        if (gdtClass && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _gdtBannerView = [[gdtClass alloc] initWithFrame:[self convertWithFrame:frame] placementId:([adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@"") viewController:rootViewController];
            _gdtBannerView.delegate = self;
            _gdtBannerView.center = CGPointMake(CGRectGetWidth(frame)/2.0, CGRectGetHeight(frame)/2.0);
            [self addSubview:_gdtBannerView];
        }
    }
    return self;
}

- (CGRect)convertWithFrame:(CGRect)frame {
    CGSize adSize = CGSizeMake((frame.size.height*6.4), frame.size.height);
    CGRect adFrame = CGRectMake((frame.size.width - adSize.width)/2.0, (frame.size.height - adSize.height)/2.0, adSize.width, adSize.height);
    return adFrame;
}

- (void)loadAd{
    [_gdtBannerView loadAdAndShow];
}

- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
           [_delegate customEvent:self didFailToLoadWithError:error];
       }
}

- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]){
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]){
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
    
}

- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
    
}

- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
    
}

- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{
}

- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView{
    
}

- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView{
    
}

@end
