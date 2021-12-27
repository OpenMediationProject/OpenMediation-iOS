// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnityRewardedVideo.h"


@implementation OMUnityRewardedVideo
- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMUnityRouter sharedInstance] registerPidDelegate:_pid delegate:self];
    }
    return self;
}

- (void)loadAd {
    [[OMUnityRouter sharedInstance] loadPlacmentID:_pid];
}

- (BOOL)isReady {
    return _isUnityAdReady;
}

- (void)show:(UIViewController*)vc {
    if ([self isReady]) {
        [[OMUnityRouter sharedInstance] showVideo:_pid withVC:vc];
    }
    _isUnityAdReady = NO;
}

#pragma mark -- OMUnityDelegate

- (void)omUnityDidload {
    _isUnityAdReady = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
    
}

- (void)omUnityDidFailToLoad:(NSError*)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)omUnityDidStart {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)omUnityDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)omUnityRewardedVideoEnd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)omUnityDidFinish:(BOOL)skipped {
    if (!skipped) {
        if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
            [_delegate rewardedVideoCustomEventDidReceiveReward:self];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
    
}

- (void)omUnityFailToShow:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}

@end
