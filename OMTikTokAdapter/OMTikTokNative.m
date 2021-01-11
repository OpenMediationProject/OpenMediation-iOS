// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTikTokNative.h"
#import "OMTikTokNativeAd.h"

@implementation OMTikTokNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            NSString *pid = [adParameter objectForKey:@"pid"];
            Class slotClass = NSClassFromString(@"BUAdSlot");
            Class buSize = NSClassFromString(@"BUSize");
            if (slotClass) {
                BUAdSlot *slot = [[slotClass alloc] init];
                slot.ID = pid;
                slot.AdType = BUAdSlotAdTypeFeed;
                slot.position = BUAdSlotPositionTop;
                slot.imgSize = [buSize sizeBy:BUProposalSize_Feed690_388];
                slot.isSupportDeepLink = YES;
                
                Class adLoaderClass = NSClassFromString(@"BUNativeAd");
                if (adLoaderClass) {
                    _adLoader = [[adLoaderClass alloc] initWithSlot:slot];
                    _adLoader.delegate = self;
                    _adLoader.rootViewController = rootViewController;
                }
            }
        
        }
        _rootVC = rootViewController;
    }
    return self;
}

- (void)loadAd {
    if (_adLoader && [_adLoader respondsToSelector:@selector(loadAdData)]) {
        [_adLoader loadAdData];
    }
}

- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd {
    OMTikTokNativeAd *tiktokAd = [[OMTikTokNativeAd alloc]initWithNativeAd:nativeAd];
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:tiktokAd];
    }
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    if (error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:self];
    }
}


- (void)nativeAdDidCloseOtherController:(BUNativeAd *)nativeAd interactionType:(BUInteractionType)interactionType {
    
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}

- (void)nativeAd:(BUNativeAd *_Nullable)nativeAd dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterWords {
    
}

- (void)videoAdView:(BUVideoAdView *)videoAdView didLoadFailWithError:(NSError *_Nullable)error {
    
}


- (void)videoAdView:(BUVideoAdView *)videoAdView stateDidChanged:(BUPlayerPlayState)playerState {
    
}

- (void)playerDidPlayFinish:(BUVideoAdView *)videoAdView {
    
}

- (void)videoAdViewDidClick:(BUVideoAdView *)videoAdView {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}


- (void)videoAdViewFinishViewDidClick:(BUVideoAdView *)videoAdView {
    
}

- (void)videoAdViewDidCloseOtherController:(BUVideoAdView *)videoAdView interactionType:(BUInteractionType)interactionType {
    
}


@end
