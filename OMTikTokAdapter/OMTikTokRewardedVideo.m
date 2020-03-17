// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTikTokRewardedVideo.h"
@interface OMTikTokRewardedVideo()

@end

@implementation OMTikTokRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        _appID = @"";
    }
    return self;
    
}

-(void)loadAd {
    Class BURewardedVideoAdClass = NSClassFromString(@"BURewardedVideoAd");
    Class BURewardedVideoModelClass = NSClassFromString(@"BURewardedVideoModel");
    if (BURewardedVideoAdClass && BURewardedVideoModelClass && [BURewardedVideoAdClass instancesRespondToSelector:@selector(initWithSlotID:rewardedVideoModel:)]) {
        BURewardedVideoModel *rewardedModel = [[BURewardedVideoModelClass alloc] init];
        _rewardedVideoAd = [[BURewardedVideoAdClass alloc] initWithSlotID:_pid rewardedVideoModel:rewardedModel];
        _rewardedVideoAd.delegate = self;
    }
    if (_rewardedVideoAd) {
        [_rewardedVideoAd loadAdData];
    }
}

-(BOOL)isReady {
    if (_rewardedVideoAd) {
        return _rewardedVideoAd.adValid;
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [_rewardedVideoAd showAdFromRootViewController:vc];
    }
    
}


-(void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}


- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}


- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}


- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error && _delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

// 奖励
- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

@end
