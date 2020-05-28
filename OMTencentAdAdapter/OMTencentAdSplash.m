// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdSplash.h"

@implementation OMTencentAdSplash

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size fetchTime:(CGFloat)fetchTime {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            _fetchTime = fetchTime;
        }
    }
    return self;
}

- (void)loadAd{
    Class GDTSplashClass = NSClassFromString(@"GDTSplashAd");
    if (GDTSplashClass && [[GDTSplashClass alloc] respondsToSelector:@selector(initWithPlacementId:)]) {
        _splashAd = [[GDTSplashClass alloc] initWithPlacementId:_pid];
        _splashAd.delegate = self;
        _splashAd.fetchDelay = self.fetchTime;
    }
    if (_splashAd) {
        [_splashAd loadAd];
        self.isLoadSuccess = NO;
    }
}

- (BOOL)isReady {
    if (_splashAd) {
        return [_splashAd isAdValid];
    }
    return NO;
}

- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView {
    if ([self isReady] && window) {
        [self.splashAd showAdInWindow:window withBottomView:customView skipView:nil];
    }
}


/**
 *  开屏广告素材加载成功
 */
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
    self.isLoadSuccess = YES;
}


/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    
}

/**
 *  开屏广告展示失败 加载失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    if (self.isLoadSuccess) {
        if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventFailToShow:error:)]) {
             [_delegate splashCustomEventFailToShow:self error:error];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [_delegate customEvent:self didFailToLoadWithError:error];
        }
    }
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd {
    
}

/**
 *  开屏广告曝光回调
 */
- (void)splashAdExposured:(GDTSplashAd *)splashAd {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidShow:)]) {
        [_delegate splashCustomEventDidShow:self];
    }
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClick:)]) {
        [_delegate splashCustomEventDidClick:self];
    }
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd {
    
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClose:)]) {
        [_delegate splashCustomEventDidClose:self];
    }
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd {
    
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd {
    
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd {
    
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd {
    
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time {
    
}

@end
