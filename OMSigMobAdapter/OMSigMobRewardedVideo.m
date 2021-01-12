// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSigMobRewardedVideo.h"

@implementation OMSigMobRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMSigMobRouter sharedInstance] registerPidDelegate:_pid delegate:self];
    }
    return self;
}

-(void)loadAd {
    [[OMSigMobRouter sharedInstance] loadRewardedVideoWithPlacmentID:_pid];
}

-(BOOL)isReady {
    return [[OMSigMobRouter sharedInstance] isRewardedVideoReady:_pid];;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [[OMSigMobRouter sharedInstance] showRewardedVideoAd:_pid withVC:vc];
    }
}


- (void)OMSigMobDidload {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)OMSigMobDidFailToLoad:(nonnull NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)OMSigMobDidStart {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)OMSigMobDidClick{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)OMSigMobVideoEnd {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)OMSigMobDidReceiveReward {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)OMSigMobDidClose {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)OMSigMobDidFailToShow:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}

@end
