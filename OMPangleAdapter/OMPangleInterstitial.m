// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleAdapter.h"
#import "OMPangleInterstitial.h"


@implementation OMPangleInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

-(void)loadAd {
    Class BUFullscreenVideoAdClass = NSClassFromString([OMPangleAdapter internalAPI]?@"BUNativeExpressFullscreenVideoAd":@"BUFullscreenVideoAd");
    if (BUFullscreenVideoAdClass && [[BUFullscreenVideoAdClass alloc] respondsToSelector:@selector(initWithSlotID:)]) {
        
        _fullscreenVideoAd = [[BUFullscreenVideoAdClass alloc] initWithSlotID:_pid];
        _fullscreenVideoAd.delegate = self;
    }
    if (_fullscreenVideoAd) {
        [_fullscreenVideoAd loadAdData];
    }
}

-(BOOL)isReady {
    if (_fullscreenVideoAd) {
        return self.adReadyFlag;
    }
    return NO;
}

- (void)show:(UIViewController *)vc
{
    if ([self isReady]) {
        self.adReadyFlag = NO;
        [_fullscreenVideoAd showAdFromRootViewController:vc];
    }
}


/**
 视频广告视频素材缓存成功
 */
- (void)fullscreenVideoAdVideoDataDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    self.adReadyFlag = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

/**
 广告位已经展示
 */
- (void)fullscreenVideoAdDidVisible:(BUFullscreenVideoAd *)fullscreenVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}



/**
 视频广告点击
 */
- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

/**
 视频广告关闭
 */
- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}


/**
 视频广告素材加载失败
 
 @param fullscreenVideoAd 当前视频对象
 @param error 错误对象
 */
- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


#pragma mark BUNativeExpressFullscreenVideoAdDelegate
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    self.adReadyFlag = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
    
}

- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
}


- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
    
}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    
}
@end
