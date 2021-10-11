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

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    [self loadAd];
}

- (BOOL)isReady {
    return [[OMVungleRouter sharedInstance]isAdAvailableForPlacementID:_pid];
}

- (void)show:(UIViewController*)vc {
    [[OMVungleRouter sharedInstance]showAdFromViewController:vc forPlacementId:_pid];
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
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)omVungleShowFailed:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
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
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)omVungleDidReceiveReward {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

@end
