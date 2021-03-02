// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleSplash.h"

@implementation OMPangleSplash

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            _AdFrame = CGRectMake(0, 0, size.width, size.height);
        }
    }
    return self;
}

- (void)loadAd {
    Class PangleSplashClass = NSClassFromString(@"BUSplashAdView");
    if (PangleSplashClass && [[PangleSplashClass alloc] respondsToSelector:@selector(initWithSlotID:frame:)]) {
        _splashView = [[PangleSplashClass alloc] initWithSlotID:_pid frame:_AdFrame];
        _splashView.delegate = self;
    }
    if (_splashView) {
        [_splashView loadAdData];
    }
}

- (BOOL)isReady{
    if (_splashView) {
        return [_splashView isAdValid];
    }
    return NO;
}

- (void)showWithWindow:(UIWindow *)window customView:(nonnull UIView *)customView {
    if (window) {
        _splashView.rootViewController = window.rootViewController;
        customView.frame = CGRectMake(0, _splashView.frame.size.height, customView.frame.size.width, customView.frame.size.height);
        [_splashView addSubview:customView];
        [window.rootViewController.view addSubview:_splashView];
    }
}

/**
 This method is called when splash ad material loaded successfully.
 */
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

/**
 This method is called when splash ad material failed to load.
 @param error : the reason of error
 */
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError * _Nullable)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

/**
 This method is called when splash ad slot will be showing.
 */
- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidShow:)]) {
        [_delegate splashCustomEventDidShow:self];
    }
}

/**
 This method is called when splash ad is clicked.
 */
- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClick:)]) {
        [_delegate splashCustomEventDidClick:self];
    }
}

/**
 This method is called when splash ad is closed.
 */
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [splashAd removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClose:)]) {
        [_delegate splashCustomEventDidClose:self];
    }
}

/**
 This method is called when splash ad is about to close.
 */
- (void)splashAdWillClose:(BUSplashAdView *)splashAd {

}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType {
    
}

/**
 This method is called when spalashAd skip button  is clicked.
 */
- (void)splashAdDidClickSkip:(BUSplashAdView *)splashAd {
    
}

/**
 This method is called when spalashAd countdown equals to zero
 */
- (void)splashAdCountdownToZero:(BUSplashAdView *)splashAd {
    
}

@end
