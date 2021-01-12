// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleSplash.h"

@implementation OMVungleSplash

- (instancetype)initWithParameter:(NSDictionary *)adParameter adSize:(CGSize)size{
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            [[OMVungleRouter sharedInstance] registerPidDelegate:_pid delegate:self];
        }
    }
    return self;
}

- (void)loadAd{
    [[OMVungleRouter sharedInstance] loadPlacmentID:_pid];
}

- (BOOL)isReady {
    return [[OMVungleRouter sharedInstance] isAdAvailableForPlacementID:_pid];
}

- (void)showWithWindow:(UIWindow *)window customView:(UIView *)customView {
    if ([self isReady] && window) {
        [[OMVungleRouter sharedInstance]showAdFromViewController:window.rootViewController forPlacementId:_pid];
    }
}

#pragma mark --
- (void)omVungleDidload {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)omVungleDidFailToLoad:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)omVungleDidStart {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidShow:)]) {
        [_delegate splashCustomEventDidShow:self];
    }
}

- (void)omVungleDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClick:)]) {
        [_delegate splashCustomEventDidClick:self];
    }
}

- (void)omVungleRewardedVideoEnd {
   
}

- (void)omVungleDidFinish:(BOOL)skipped {
    if (_delegate && [_delegate respondsToSelector:@selector(splashCustomEventDidClose:)]) {
        [_delegate splashCustomEventDidClose:self];
    }
}

@end
