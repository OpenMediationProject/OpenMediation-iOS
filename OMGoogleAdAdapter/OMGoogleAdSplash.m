// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMGoogleAdSplash.h"
#import "OMGoogleAdAdapter.h"

@implementation OMGoogleAdSplash

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size{
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            _appOpenAd = nil;
        }
    }
    return self;
}

- (void)loadAd{
    Class adMobClass = NSClassFromString(@"GADAppOpenAd");
    Class requestClass = NSClassFromString(@"GADRequest");
    if (requestClass && [requestClass respondsToSelector:@selector(request)] && adMobClass && [adMobClass respondsToSelector:@selector(loadWithAdUnitID:request:completionHandler:)]) {
        GADRequest *request = [requestClass request];
        if ([OMGoogleAdAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        
        [adMobClass loadWithAdUnitID:_pid request:request completionHandler:^(GADAppOpenAd *appOpenAd, NSError *error) {
            self.appOpenAd = appOpenAd;
            self.appOpenAd.fullScreenContentDelegate = self;
            self.loadTime = [NSDate date];
            if (error) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                    [self.delegate customEvent:self didFailToLoadWithError:error];
                }
            }else{
                self.ready = YES;
                if (self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didLoadWithAdnName:)]) {
                    NSString *adnName = @"";
                    GADResponseInfo *info = [appOpenAd responseInfo];
                    if (info && [info respondsToSelector:@selector(adNetworkClassName)]) {
                        adnName = [info adNetworkClassName];
                    }
                    [self.delegate customEvent:self didLoadWithAdnName:adnName];
                }
                if ([self isReady] && self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                    [self.delegate customEvent:self didLoadAd:nil];
                }
            }
        }];
    }
}

- (BOOL)isReady {
    if (self.ready && self.appOpenAd && [self wasLoadTimeLessThanNHoursAgo:4]) {
        return YES;
    }
    return NO;
}

- (BOOL)wasLoadTimeLessThanNHoursAgo:(int)n {
    NSDate *now = [NSDate date];
    NSTimeInterval timeIntervalBetweenNowAndLoadTime = [now timeIntervalSinceDate:self.loadTime];
    double secondsPerHour = 3600.0;
    double intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour;
    return intervalInHours < n;
}

- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView {
    if ([self isReady] && window && [_appOpenAd respondsToSelector:@selector(presentFromRootViewController:)]) {
        [_appOpenAd presentFromRootViewController:window.rootViewController];
    }
    _ready = NO;
}

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventFailToShow:error:)]) {
        [_delegate splashCustomEventFailToShow:self error:error];
    }
}

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidShow:)]) {
        [_delegate splashCustomEventDidShow:self];
    }
}

/// Tells the delegate that a click has been recorded for the ad.
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClick:)]) {
        [_delegate splashCustomEventDidClick:self];
    }
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClose:)]) {
        [_delegate splashCustomEventDidClose:self];
    }
}

@end
