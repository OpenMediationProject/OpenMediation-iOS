// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostInterstitial.h"

@implementation OMChartboostInterstitial
- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMChartboostRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}

- (void)loadAd {
    [[OMChartboostRouter sharedInstance]loadChartboostInterstitial:_pid];
}

- (BOOL)isReady {
    BOOL isReady = NO;
    Class chartboostClass = NSClassFromString(@"Chartboost");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(hasInterstitial:)]) {
        isReady = [chartboostClass hasInterstitial:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        Class chartboostClass = NSClassFromString(@"Chartboost");
        if (chartboostClass && [chartboostClass respondsToSelector:@selector(showInterstitial:)]) {
            [chartboostClass showInterstitial:_pid];
        }
    }
}

- (void)omChartboostDidload {
    if ([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)omChartboostDidFailToLoad:(nonnull NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)omChartboostDidStart {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
}

- (void)omChartboostDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)omChartboostDidFinish {
    if (_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

- (void)omChartboostDidReceiveReward {
    
}


- (void)omChartboostRewardedVideoEnd {
    
}

@end
