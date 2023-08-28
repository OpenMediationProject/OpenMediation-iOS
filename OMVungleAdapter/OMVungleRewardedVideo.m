// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMVungleRewardedVideo.h"
#import "OMVungleAdapter.h"

@implementation OMVungleRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

- (void)loadAd {
    Class vungleClass = NSClassFromString(@"_TtC12VungleAdsSDK14VungleRewarded");
    if (vungleClass && [vungleClass instancesRespondToSelector:@selector(initWithPlacementId:)]) {
        _videoAd = [[vungleClass alloc] initWithPlacementId:_pid];
        _videoAd.delegate = self;
        [_videoAd load:nil];
    }
}

- (BOOL)isReady {
    BOOL isReady = NO;
    if (_videoAd && [_videoAd respondsToSelector:@selector(canPlayAd)]) {
        isReady = [_videoAd canPlayAd];
    }
    return isReady;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady] && [_videoAd respondsToSelector:@selector(presentWith:)]) {
        [_videoAd presentWith:vc];
    }
}


- (void)rewardedAdDidLoad:(VungleRewarded *)rewarded {
    if ([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}
- (void)rewardedAdDidFailToLoad:(VungleRewarded *)rewarded withError:(NSError *)withError {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:withError];
    }
}
- (void)rewardedAdDidPresent:(VungleRewarded *)rewarded {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
}
- (void)rewardedAdDidFailToPresent:(VungleRewarded *)rewarded withError:(NSError *)withError {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:withError];
    }
}
- (void)rewardedAdDidClick:(VungleRewarded * _Nonnull)rewarded {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}
- (void)rewardedAdDidClose:(VungleRewarded *)rewarded {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)rewardedAdDidRewardUser:(VungleRewarded *)rewarded {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

@end
