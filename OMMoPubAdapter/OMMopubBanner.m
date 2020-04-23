// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubBanner.h"

@implementation OMMopubBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        _rootVC = rootViewController;
        Class bannerViewClass = NSClassFromString(@"MPAdView");
        if (bannerViewClass && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _bannerView = [[bannerViewClass alloc] initWithAdUnitId:[adParameter objectForKey:@"pid"]?[adParameter objectForKey:@"pid"]:@""];
            _bannerView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            _bannerView.delegate = self;
            [self addSubview:_bannerView];
        }
    }
    return self;
}

- (void)loadAd {
    
    if (_bannerView && [_bannerView respondsToSelector:@selector(loadAdWithMaxAdSize:)]) {
        [_bannerView loadAdWithMaxAdSize:self.frame.size];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [self.bannerView rotateToOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGSize size = [self.bannerView adContentViewSize];
    CGFloat centeredX = (self.bounds.size.width - size.width) / 2;
    CGFloat bottomAlignedY = self.bounds.size.height - size.height;
    self.bannerView.frame = CGRectMake(centeredX, bottomAlignedY, size.width, size.height);
}



#pragma mark Mopub Ads View delegate methods

- (UIViewController *)viewControllerForPresentingModalView {
    return _rootVC;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
  if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
      [_delegate customEvent:self didFailToLoadWithError:error];
  }
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [self.delegate bannerCustomEventDidClick:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]){
      [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
  if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]){
      [_delegate bannerCustomEventWillPresentScreen:self];
  };
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
  if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]){
      [_delegate bannerCustomEventDismissScreen:self];
  }
}


@end
