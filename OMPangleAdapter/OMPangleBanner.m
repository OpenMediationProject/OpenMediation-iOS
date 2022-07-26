// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleBanner.h"
#import "OMPangleAdapter.h"

@implementation OMPangleBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        _pid = [adParameter objectForKey:@"pid"];
        _rootVC = rootViewController;
        Class BUDBannerAdViewClass = NSClassFromString(@"BUNativeExpressBannerView");
        if (BUDBannerAdViewClass) {
            _bannerAdView = [[BUDBannerAdViewClass alloc] initWithSlotID:_pid rootViewController:rootViewController adSize:CGSizeMake(frame.size.width, frame.size.height)];
            _bannerAdView.delegate = self;
            _bannerAdView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [self addSubview:_bannerAdView];
        }
    }
    return self;
}

- (void)loadAd{
    if ([OMPangleAdapter internalAPI]) {
        [_bannerAdView loadAdData];
    }else{
        // 海外
        Class PAGBannerClass = NSClassFromString(@"PAGBannerAd");
        Class requestClass = NSClassFromString(@"PAGBannerRequest");
        if (PAGBannerClass && [PAGBannerClass respondsToSelector:@selector(loadAdWithSlotID:request:completionHandler:)] && requestClass && [requestClass respondsToSelector:@selector(requestWithBannerSize:)]) {
            __weak typeof(self) weakSelf = self;
            PAGBannerAdSize adSize = {self.frame.size};
            PAGBannerRequest *request  = [requestClass requestWithBannerSize:adSize];
            [PAGBannerClass loadAdWithSlotID:_pid
                                     request:request
                           completionHandler:^(PAGBannerAd *ad, NSError *error) {
                if (!error) {
                    weakSelf.pagBannerAd = ad;
                    weakSelf.pagBannerAd.delegate = self;
                    weakSelf.pagBannerAd.rootViewController = weakSelf.rootVC;
                    weakSelf.pagBannerView = self.pagBannerAd.bannerView;
                    weakSelf.pagBannerView.frame = self.frame;
                    [self addSubview:weakSelf.pagBannerView];
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                        [weakSelf.delegate customEvent:weakSelf didLoadAd:nil];
                    }
                } else {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                        [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
                    }
                }
            }];
        }
    }
}

// 海外
- (void)adDidShow:(PAGBannerAd *)ad {

}

- (void)adDidClick:(PAGBannerAd *)ad {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

- (void)adDidDismiss:(PAGBannerAd *)ad {
    
}

// 国内
#pragma mark BUNativeExpressBannerViewDelegate
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

/**
 This method is called when bannerAdView ad slot failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

/**
 This method is called when rendering a nativeExpressAdView successed.
 */
- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError * __nullable)error{
    
}

/**
 This method is called when bannerAdView ad slot showed new ad.
 */
- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView{
    
}

/**
 This method is called when bannerAdView is clicked.
 */
- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
        [_delegate bannerCustomEventDidClick:self];
    }
}

/**
 This method is called when the user clicked dislike button and chose dislike reasons.
 @param filterwords : the array of reasons for dislike.
 */
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords{
    
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType{
    
}

@end
