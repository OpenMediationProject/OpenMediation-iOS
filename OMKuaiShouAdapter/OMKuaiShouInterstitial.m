// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMKuaiShouInterstitial.h"

@implementation OMKuaiShouInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

-(void)loadAd {
    Class KSFullscreenVideoAdClass = NSClassFromString(@"KSFullscreenVideoAd");
    if (KSFullscreenVideoAdClass && [[KSFullscreenVideoAdClass alloc] respondsToSelector:@selector(initWithPosId:)]) {
        
        _fullscreenVideoAd = [[KSFullscreenVideoAdClass alloc] initWithPosId:_pid];
        _fullscreenVideoAd.delegate = self;
    }
    if (_fullscreenVideoAd) {
        [_fullscreenVideoAd loadAdData];
    }
}

-(BOOL)isReady {
    if (_fullscreenVideoAd) {
        return (_fullscreenVideoAd.isValid);
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

- (void)fullscreenVideoAdVideoDidLoad:(KSFullscreenVideoAd *)fullscreenVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
            [weakSelf.delegate customEvent:self didLoadAd:nil];
        }
    });
}


- (void)fullscreenVideoAd:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [weakSelf.delegate customEvent:self didFailToLoadWithError:error];
        }
    });
}

- (void)fullscreenVideoAdDidVisible:(KSFullscreenVideoAd *)fullscreenVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
            [weakSelf.delegate interstitialCustomEventDidOpen:self];
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
            [weakSelf.delegate interstitialCustomEventDidShow:self];
        }
    });
}


- (void)fullscreenVideoAdDidClose:(KSFullscreenVideoAd *)fullscreenVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
            [weakSelf.delegate interstitialCustomEventDidClose:self];
        }
    });
}


- (void)fullscreenVideoAdDidClick:(KSFullscreenVideoAd *)fullscreenVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
            [weakSelf.delegate interstitialCustomEventDidClick:self];
        }
    });
}

- (void)fullscreenVideoAdDidPlayFinish:(KSFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
                [weakSelf.delegate interstitialCustomEventDidFailToShow:self error:error];
            }
        }
    });
}

@end
