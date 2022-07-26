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
    if ([OMPangleAdapter internalAPI]) {
        Class BUFullscreenVideoAdClass = NSClassFromString(@"BUNativeExpressFullscreenVideoAd");
        if (BUFullscreenVideoAdClass && [[BUFullscreenVideoAdClass alloc] respondsToSelector:@selector(initWithSlotID:)]) {
            _fullscreenVideoAd = [[BUFullscreenVideoAdClass alloc] initWithSlotID:_pid];
            _fullscreenVideoAd.delegate = self;
        }
        if (_fullscreenVideoAd) {
            [_fullscreenVideoAd loadAdData];
        }
    }else{
        // 海外
        Class PAGIvClass = NSClassFromString(@"PAGLInterstitialAd");
        Class requestClass = NSClassFromString(@"PAGInterstitialRequest");
        if (PAGIvClass && [PAGIvClass respondsToSelector:@selector(loadAdWithSlotID:request:completionHandler:)] && requestClass && [requestClass respondsToSelector:@selector(request)]) {
            __weak typeof(self) weakSelf = self;
            PAGInterstitialRequest *request  = [requestClass request];
            [PAGIvClass loadAdWithSlotID:_pid
                                 request:request
                       completionHandler:^(PAGLInterstitialAd *ad, NSError *error) {
                if (!error) {
                    weakSelf.adReadyFlag = YES;
                    weakSelf.pagInterstitialAd = ad;
                    weakSelf.pagInterstitialAd.delegate = self;
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

-(BOOL)isReady {
    if (_fullscreenVideoAd || _pagInterstitialAd) {
        return self.adReadyFlag;
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        self.adReadyFlag = NO;
        if ([OMPangleAdapter internalAPI]) {
            [_fullscreenVideoAd showAdFromRootViewController:vc];
        }else{
            [_pagInterstitialAd presentFromRootViewController:vc];
        }
    }
}

- (void)adDidShow:(PAGLInterstitialAd *)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)adDidClick:(PAGLInterstitialAd *)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)adDidDismiss:(PAGLInterstitialAd *)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

// 国内

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
