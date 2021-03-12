// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobSplash.h"
#import "OMAdMobAdapter.h"

@implementation OMAdMobSplash

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
    if (requestClass && [requestClass respondsToSelector:@selector(request)] && adMobClass && [adMobClass respondsToSelector:@selector(loadWithAdUnitID:request:orientation:completionHandler:)]) {
        GADRequest *request = [requestClass request];
        if ([OMAdMobAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        
        [adMobClass loadWithAdUnitID:_pid request:request orientation:UIInterfaceOrientationPortrait completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
            self.appOpenAd = appOpenAd;
            self.appOpenAd.fullScreenContentDelegate = self;
            self.loadTime = [NSDate date];
            if (error) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                    [self.delegate customEvent:self didFailToLoadWithError:error];
                }
            }else{
                self.ready = YES;
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

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidShow:)]) {
        [_delegate splashCustomEventDidShow:self];
    }
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClose:)]) {
        [_delegate splashCustomEventDidClose:self];
    }
}

@end
