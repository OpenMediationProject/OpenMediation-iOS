// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdInterstitial.h"
#import "OMTencentAdClass.h"

@implementation OMTencentAdInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter
{
    if (self = [super init]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]){
            _pid = [adParameter objectForKey:@"pid"];
            _appID = [adParameter objectForKey:@"appKey"];
        }
    }
    return self;
}


- (void)loadAd{
    Class GDTInterstitialClass = NSClassFromString(@"GDTUnifiedInterstitialAd");
    if (GDTInterstitialClass && [[GDTInterstitialClass alloc] respondsToSelector:@selector(initWithAppId:placementId:)]) {
        _interstitial = [[GDTInterstitialClass alloc] initWithPlacementId:_pid];
        _interstitial.delegate = self;
    }
    if (_interstitial) {
        [_interstitial loadFullScreenAd];
    }
}

-(BOOL)isReady{
    if (_interstitial) {
        return [_interstitial isAdValid];
    }
    return NO;
}

- (void)show:(UIViewController *)vc{
    
    Class sdkClass = NSClassFromString(@"GDTSDKConfig");
    if (sdkClass && [sdkClass respondsToSelector:@selector(enableDefaultAudioSessionSetting:)]) {
        [sdkClass enableDefaultAudioSessionSetting:NO];
    }
    
    if ([self isReady]) {
        [_interstitial presentFullScreenAdFromRootViewController:vc];
    }
}


- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]){
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]){
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]){
        [_delegate interstitialCustomEventDidFailToShow:self error:error];
    }
}

- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    // 广告结束
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]){
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    // 全屏广告页关闭
}

- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status{
    
}

- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    // 视频广告详情页展示
}

- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    
}

- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    // 视频广告详情页关闭
}



@end
