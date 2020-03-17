// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralRewardedVideo.h"
#import "OMMintegralAdapter.h"

@implementation OMMintegralRewardedVideo
- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMMintegralRouter sharedInstance] registerPidDelegate:_pid delegate:self];
    }
    return self;
    
}

-(void)loadAd {
    [[OMMintegralRouter sharedInstance] loadPlacmentID:_pid];
}

-(BOOL)isReady {
    return [[OMMintegralRouter sharedInstance] isReady:_pid];
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [[OMMintegralRouter sharedInstance] showVideo:_pid withVC:vc];
    }
}

#pragma mark - MTGRewardAdLoadDelegate

- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

#pragma mark -- OMMintegralAdapterDelegate

- (void)omMintegralDidReceiveReward {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)omMintegralDidload {
        if ([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)omMintegralDidFailToLoad:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        NSError *cerror = [[NSError alloc] initWithDomain:@"" code:error.code userInfo:@{@"msg":@"There are no ads to show now"}];
        [_delegate customEvent:self didFailToLoadWithError:cerror];
    }
}

- (void)omMintegralDidStart {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)omMintegralDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)omMintegralRewardedVideoEnd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)omMintegralDidFinish:(BOOL)skipped {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

@end
