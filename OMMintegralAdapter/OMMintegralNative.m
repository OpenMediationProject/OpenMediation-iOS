// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralNative.h"
#import "OMMintegralNativeAd.h"
#import "OMMintegralAdapter.h"

@implementation OMMintegralNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            
        }
        _rootVC = rootViewController;
    }
    return self;
}

- (void)loadAd {
    Class mtgClass = NSClassFromString(@"MTGNativeAdManager");
    Class mtgTemplateClass = NSClassFromString(@"MTGTemplate");
    if (mtgClass && [mtgClass instancesRespondToSelector:@selector(initWithPlacementId:unitID:supportedTemplates:autoCacheImage:adCategory:presentingViewController:)] && [mtgTemplateClass respondsToSelector:@selector(templateWithType:adsNum:)]) {
        _mtgManager = [[mtgClass alloc] initWithPlacementId:@"" unitID:_pid supportedTemplates:@[[mtgTemplateClass templateWithType:MTGAD_TEMPLATE_BIG_IMAGE adsNum:1]] autoCacheImage:NO adCategory:0 presentingViewController:_rootVC];
        _mtgManager.delegate = self;
    }
    if (_mtgManager && [_mtgManager respondsToSelector:@selector(loadAds)]) {
        [_mtgManager loadAds];
    }
}

#pragma mark AdManger delegate

- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds nativeManager:(nonnull MTGNativeAdManager *)nativeManager {
    if (nativeAds.count > 0) {
        MTGCampaign *campaign = nativeAds[0];
        OMMintegralNativeAd *mtgNativeAd = [[OMMintegralNativeAd alloc] initWithMtgNativeAd:campaign withManager:_mtgManager];
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
            [_delegate customEvent:self didLoadAd:mtgNativeAd];
        }
    }
}

- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error nativeManager:(nonnull MTGNativeAdManager *)nativeManager {
    if (error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd nativeManager:(nonnull MTGNativeAdManager *)nativeManager {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:nativeAd];
    }
}

#pragma mark MTGMediaViewDelegate

- (void)nativeAdImpressionWithType:(MTGAdSourceType)type mediaView:(MTGMediaView *)mediaView {
        if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
            [_delegate nativeCustomEventWillShow:mediaView.campaign];
        }
}

- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd mediaView:(MTGMediaView *)mediaView {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:nativeAd];
    }
}

@end
