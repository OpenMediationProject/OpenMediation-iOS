// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnityRewardedVideo.h"


@implementation OMUnityRewardedVideo
- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMUnityRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}

- (void)loadAd {
    if ([self isReady]) {
      //ready
        [self omUnityDidload];
    }
}

- (BOOL)isReady {
    Class unityClass = NSClassFromString(@"UnityAds");
    BOOL isReady = NO;
    if (unityClass && [unityClass respondsToSelector:@selector(isReady:)]) {
        isReady = [unityClass isReady:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController*)vc {
    Class unityClass = NSClassFromString(@"UnityAds");
    if (unityClass && [unityClass respondsToSelector:@selector(show: placementId:)]) {
        [unityClass show:vc placementId:_pid];
    }
}

#pragma mark -- OMUnityDelegate

- (void)omUnityDidload {
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

@end
