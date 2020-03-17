// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleRewardedVideo.h"


@implementation OMVungleRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter  {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMVungleRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}
- (void)loadAd  {
    [[OMVungleRouter sharedInstance]loadPlacmentID:_pid];
}

- (BOOL)isReady {
    BOOL isReady = NO;
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        isReady = [vungle isAdCachedForPlacementID:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController*)vc {
    NSDictionary *options = @{};
    NSError *error;
    Class vungleClass = NSClassFromString(@"VungleSDK");
    if (vungleClass && [vungleClass respondsToSelector:@selector(sharedSDK)] && [[vungleClass sharedSDK] respondsToSelector:@selector(playAd: options:placementID: error:)]) {
        VungleSDK *vungle = [vungleClass sharedSDK];
        [vungle playAd:vc options:options placementID:_pid error:&error];
        if (error) {
        }
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
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)omVungleDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)omVungleRewardedVideoEnd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)omVungleDidFinish:(BOOL)skipped {
    if (!skipped) {
        if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
            [_delegate rewardedVideoCustomEventDidReceiveReward:self];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

@end
