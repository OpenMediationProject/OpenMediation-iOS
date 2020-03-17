// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostRewardedVideo.h"
#import "OMChartboostAdapter.h"


@implementation OMChartboostRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMChartboostRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}

- (void)loadAd {
    [[OMChartboostRouter sharedInstance]loadChartboostPlacmentID:_pid];
}

- (BOOL)isReady {
    BOOL isReady = NO;
    Class chartboostClass = NSClassFromString(@"Chartboost");
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(hasRewardedVideo:)]) {
        isReady = [chartboostClass hasRewardedVideo:_pid];
    }
    return isReady;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        Class chartboostClass = NSClassFromString(@"Chartboost");
        if (chartboostClass && [chartboostClass respondsToSelector:@selector(showRewardedVideo:)]) {
            [chartboostClass showRewardedVideo:_pid];
        }
    }
}

- (void)omChartboostDidload {
    if ([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)omChartboostDidFailToLoad:(nonnull NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        NSError *cerror = [[NSError alloc] initWithDomain:@"" code:error.code userInfo:@{@"msg":@"There are no ads to show now"}];
        [_delegate customEvent:self didFailToLoadWithError:cerror];
    }
}

- (void)omChartboostDidStart {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)omChartboostDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)omChartboostRewardedVideoEnd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)omChartboostDidReceiveReward {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)omChartboostDidFinish {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

@end
