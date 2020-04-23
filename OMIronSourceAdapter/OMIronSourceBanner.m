// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceBanner.h"

@implementation OMIronSourceBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        Class IronSourceClass = NSClassFromString(@"IronSource");
        if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(initWithAppKey:)] && [IronSourceClass respondsToSelector:@selector(setBannerDelegate:)]) {
            [IronSourceClass initWithAppKey:[adParameter objectForKey:@"appKey"]];
            [IronSourceClass setBannerDelegate:self];
            self.showVC = rootViewController;
        }
    }
    return self;
}

- (void)loadAd{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        Class IronSourceClass = NSClassFromString(@"IronSource");
        if (self.bannerView) {
            [IronSourceClass destroyBanner:self.bannerView];
            self.bannerView = nil;
        }
        if (self.showVC && IronSourceClass && [IronSourceClass respondsToSelector:@selector(loadBannerWithViewController:size:)]) {
            [IronSourceClass loadBannerWithViewController:self.showVC size:ISBannerSize_BANNER];
        }
    });

}

#pragma mark - Banner Delegate Functions
- (void)bannerDidLoad:(ISBannerView *)bannerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bannerView = bannerView;
        if (@available(iOS 11.0, *)) {
            [self.bannerView setCenter:CGPointMake(self.center.x,self.frame.size.height - (self.bannerView.frame.size.height/2.0) - self.safeAreaInsets.bottom)];
        } else {
            [self.bannerView setCenter:CGPointMake(self.center.x,self.frame.size.height - (self.bannerView.frame.size.height/2.0))];
        }
        
        [self addSubview:self.bannerView];
    });
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [self.delegate customEvent:self didLoadAd:nil];
    }
    
}

- (void)bannerDidFailToLoadWithError:(NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)didClickBanner {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]){
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)bannerWillPresentScreen {
}

- (void)bannerDidDismissScreen {
}

- (void)bannerWillLeaveApplication {
}


@end
