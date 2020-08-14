// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralInterstitial.h"

@implementation OMMintegralInterstitial

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            _appID = @"";
        }
    }
    return self;
}

-(void)loadAd {
    Class MTGInterstitialVideoAdManagerClass = NSClassFromString(@"MTGInterstitialVideoAdManager");
    if (MTGInterstitialVideoAdManagerClass && [[MTGInterstitialVideoAdManagerClass alloc] respondsToSelector:@selector(initWithPlacementId:unitId:delegate:)]) {
        _ivAdManager = [[MTGInterstitialVideoAdManagerClass alloc] initWithPlacementId:@"" unitId:_pid delegate:self];
        _ivAdManager.delegate = self;
    }
    if (_ivAdManager) {
        [_ivAdManager loadAd];
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    Class MTGBidInterstitialVideoAdManagerClass = NSClassFromString(@"MTGBidInterstitialVideoAdManager");
    if (MTGBidInterstitialVideoAdManagerClass && [MTGBidInterstitialVideoAdManagerClass instancesRespondToSelector:@selector(initWithPlacementId:unitId:delegate:)]) {
        _ivBidAdManager = [[MTGBidInterstitialVideoAdManagerClass alloc] initWithPlacementId:@"" unitId:_pid delegate:self];
        _ivBidAdManager.delegate = self;
    }
    if (_ivBidAdManager) {
        [_ivBidAdManager loadAdWithBidToken:bidPayload];
    }
}

-(BOOL)isReady {
    if (_ivAdManager) {
        return [_ivAdManager isVideoReadyToPlayWithPlacementId:@"" unitId:_pid];
    }else if (_ivBidAdManager){
        return [_ivBidAdManager isVideoReadyToPlayWithPlacementId:@"" unitId:_pid];
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if (_ivAdManager && [self isReady]) {
        [_ivAdManager showFromViewController:vc];
    }else if (_ivBidAdManager && [self isReady]){
        [_ivBidAdManager showFromViewController:vc];
    }
}

- (void) onInterstitialVideoLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void) onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void) onInterstitialVideoShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void) onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    
}

- (void) onInterstitialVideoAdClick:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
   if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
       [_delegate interstitialCustomEventDidClick:self];
   }
}

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)onInterstitialVideoPlayCompleted:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
       
}

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */

// Play End
- (void)onInterstitialVideoEndCardShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
        
}


- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{

}

- (void) onInterstitialVideoAdDidClosed:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

@end
