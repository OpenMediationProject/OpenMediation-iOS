// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubRewardedVideo.h"

@implementation OMMopubRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        Class mopubClass = NSClassFromString(@"MPRewardedVideo");
        if (mopubClass && [mopubClass respondsToSelector:@selector(setDelegate:forAdUnitId:)] && [_pid length]>0) {
            [mopubClass setDelegate:self forAdUnitId:_pid];
        }
    }
    return self;
}


- (void)loadAd {
    Class mopubClass = NSClassFromString(@"MPRewardedVideo");
    if (mopubClass && [mopubClass respondsToSelector:@selector(loadRewardedVideoAdWithAdUnitID:withMediationSettings:)] && [_pid length]>0) {
        [mopubClass loadRewardedVideoAdWithAdUnitID:_pid withMediationSettings:nil];
    }
}

- (BOOL)isReady {
    Class mopubClass = NSClassFromString(@"MPRewardedVideo");
    if (mopubClass && [mopubClass respondsToSelector:@selector(hasAdAvailableForAdUnitID:)]) {
        return [mopubClass hasAdAvailableForAdUnitID:_pid];
    }else
        return NO;
}

- (void)show:(UIViewController*)vc {
    Class mopubClass = NSClassFromString(@"MPRewardedVideo");
    if (mopubClass && [mopubClass respondsToSelector:@selector(presentRewardedVideoAdForAdUnitID:fromViewController:withReward:)]) {
        [mopubClass presentRewardedVideoAdForAdUnitID:_pid fromViewController:vc withReward:nil];
    }
}


- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}


- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}


- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}


- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {

}


- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

@end
