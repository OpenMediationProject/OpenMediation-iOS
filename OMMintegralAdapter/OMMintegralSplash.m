// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralSplash.h"

@implementation OMMintegralSplash

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size {
    if (self = [self init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            _adSize = size;
        }
    }
    return self;
}

- (void)loadAd{
    Class MTGSplashClass = NSClassFromString(@"MTGSplashAD");
    if (MTGSplashClass && [[MTGSplashClass alloc] respondsToSelector:@selector(initWithPlacementID:unitID:countdown:allowSkip:)]) {
        _splashAD = [[MTGSplashClass alloc] initWithPlacementID:@"" unitID:_pid countdown:5 allowSkip:YES];
        _splashAD.delegate = self;
    }
    if (_splashAD) {
        [_splashAD preload];
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    _isBidAd = YES;
    Class MTGSplashClass = NSClassFromString(@"MTGSplashAD");
    if (MTGSplashClass && [[MTGSplashClass alloc] respondsToSelector:@selector(initWithPlacementID:unitID:countdown:allowSkip:)]) {
        _splashAD = [[MTGSplashClass alloc] initWithPlacementID:@"" unitID:_pid countdown:5 allowSkip:YES];
        _splashAD.delegate = self;
    }
    if (_splashAD) {
        [_splashAD preloadWithBidToken:bidPayload];
    }
}

- (BOOL)isReady{
    if (_splashAD) {
        if (_isBidAd) {
            return [_splashAD isBiddingADReadyToShow];
        }else{
            return [_splashAD isADReadyToShow]  ;
        }
    }
    return NO;
}

- (void)showWithWindow:(UIWindow *)window customView:(nonnull UIView *)customView {
    if ([self isReady] && window) {
        if (_isBidAd) {
            [_splashAD showBiddingADInKeyWindow:window customView:customView];
        }else{
            [_splashAD showInKeyWindow:window customView:customView];
        }
    }
}

/* Called when preloading ad successfully. */
- (void)splashADPreloadSuccess:(MTGSplashAD *)splashAD{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

/* Called when preloading ad failed. */
- (void)splashADPreloadFail:(MTGSplashAD *)splashAD error:(NSError *)error{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

/* Called when loading ad successfully. */
- (void)splashADLoadSuccess:(MTGSplashAD *)splashAD{
    
}

/* Called when loading ad failed. */
- (void)splashADLoadFail:(MTGSplashAD *)splashAD error:(NSError *)error{
    
}

/* Called when showing ad successfully. */
- (void)splashADShowSuccess:(MTGSplashAD *)splashAD{
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidShow:)]) {
        [_delegate splashCustomEventDidShow:self];
    }
}

/* Called when showing ad failed. */
- (void)splashADShowFail:(MTGSplashAD *)splashAD error:(NSError *)error{
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventFailToShow:error:)]) {
        [_delegate splashCustomEventFailToShow:self error:error];
    }
}

/* Called when the application is about to leave as a result of tap event.
   Your application will be moved to the background shortly after this method is called. */
- (void)splashADDidLeaveApplication:(MTGSplashAD *)splashAD{
    
}

/* Called when click event occured. */
- (void)splashADDidClick:(MTGSplashAD *)splashAD{
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClick:)]) {
        [_delegate splashCustomEventDidClick:self];
    }
}

/* Called when ad is about to close. */
- (void)splashADWillClose:(MTGSplashAD *)splashAD{
    
}

/* Called when ad did close. */
- (void)splashADDidClose:(MTGSplashAD *)splashAD{
   if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClose:)]) {
       [_delegate splashCustomEventDidClose:self];
   }
}

/* Called when remaining countdown update. */
- (void)splashAD:(MTGSplashAD *)splashAD timeLeft:(NSUInteger)time{
    
}

@end
