// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubRewardedVideo.h"

@implementation OMMopubRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        Class mopubClass = NSClassFromString(@"MPRewardedAds");
        if (mopubClass && [mopubClass respondsToSelector:@selector(setDelegate:forAdUnitId:)] && [_pid length]>0) {
            [mopubClass setDelegate:self forAdUnitId:_pid];
        }
    }
    return self;
}


- (void)loadAd {
    Class mopubClass = NSClassFromString(@"MPRewardedAds");
    if (mopubClass && [mopubClass respondsToSelector:@selector(loadRewardedAdWithAdUnitID:withMediationSettings:)] && [_pid length]>0) {
        [mopubClass loadRewardedAdWithAdUnitID:_pid withMediationSettings:nil];
    }
}

- (BOOL)isReady {
    Class mopubClass = NSClassFromString(@"MPRewardedAds");
    if (mopubClass && [mopubClass respondsToSelector:@selector(hasAdAvailableForAdUnitID:)]) {
        return [mopubClass hasAdAvailableForAdUnitID:_pid];
    }else
        return NO;
}

- (void)show:(UIViewController*)vc {
    Class mopubClass = NSClassFromString(@"MPRewardedAds");
    if (mopubClass && [mopubClass respondsToSelector:@selector(presentRewardedAdForAdUnitID:fromViewController:withReward:)] && [mopubClass respondsToSelector:@selector(availableRewardsForAdUnitID:)]) {
        [mopubClass presentRewardedAdForAdUnitID:_pid fromViewController:vc withReward:[mopubClass availableRewardsForAdUnitID:_pid][0]];
    }
}


- (void)rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


- (void)rewardedAdDidFailToShowForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}


- (void)rewardedAdWillPresentForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
}

- (void)rewardedAdDidPresentForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}


- (void)rewardedAdWillDismissForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)rewardedAdDidDismissForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)rewardedAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}


- (void)rewardedAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {

}


- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)rewardedAdDidExpireForAdUnitID:(NSString *)adUnitID {
    if (_delegate && [_delegate respondsToSelector:@selector(customEventAdDidExpired:)]) {
        [_delegate customEventAdDidExpired:self];
    }
}

@end
