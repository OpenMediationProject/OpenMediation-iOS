// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleBanner.h"

@implementation OMPangleBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        NSString *pid = [adParameter objectForKey:@"pid"];
        Class BUDBannerAdViewClass = NSClassFromString(@"BUNativeExpressBannerView");
        if (BUDBannerAdViewClass) {
            _bannerAdView = [[BUDBannerAdViewClass alloc] initWithSlotID:pid rootViewController:rootViewController adSize:CGSizeMake(frame.size.width, frame.size.height) IsSupportDeepLink:YES];
            _bannerAdView.delegate = self;
            _bannerAdView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            [self addSubview:_bannerAdView];
        }
    }
    return self;
}

- (void)loadAd{
    [_bannerAdView loadAdData];
}


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
