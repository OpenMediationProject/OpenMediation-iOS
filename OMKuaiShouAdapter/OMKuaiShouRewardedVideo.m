// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMKuaiShouRewardedVideo.h"

@implementation OMKuaiShouRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
    
}

-(void)loadAd {
    Class KSRewardedVideoAdClass = NSClassFromString(@"KSRewardedVideoAd");
    Class KSRewardedVideoModelClass = NSClassFromString(@"KSRewardedVideoModel");
    if (KSRewardedVideoAdClass && KSRewardedVideoModelClass && [KSRewardedVideoAdClass instancesRespondToSelector:@selector(initWithPosId:rewardedVideoModel:)]) {
        KSRewardedVideoModel *rewardedModel = [[KSRewardedVideoModelClass alloc] init];
        _rewardedVideoAd = [[KSRewardedVideoAdClass alloc] initWithPosId:_pid rewardedVideoModel:rewardedModel];
        _rewardedVideoAd.delegate = self;
    }
    if (_rewardedVideoAd) {
        [_rewardedVideoAd loadAdData];
    }
}

-(BOOL)isReady {
    if (_rewardedVideoAd) {
        return (_rewardedVideoAd.isValid);
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [_rewardedVideoAd showAdFromRootViewController:vc];
    }
}


- (void)rewardedVideoAdVideoDidLoad:(KSRewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
            [weakSelf.delegate customEvent:self didLoadAd:nil];
        }
    });
}


- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [weakSelf.delegate customEvent:self didFailToLoadWithError:error];
        }
    });
}


- (void)rewardedVideoAdDidVisible:(KSRewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
            [weakSelf.delegate rewardedVideoCustomEventDidOpen:self];
        }
    });
}


- (void)rewardedVideoAdDidClose:(KSRewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
            [weakSelf.delegate rewardedVideoCustomEventDidClose:self];
        }
    });
}


- (void)rewardedVideoAdDidClick:(KSRewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
            [weakSelf.delegate rewardedVideoCustomEventDidClick:self];
        }
    });
}


- (void)rewardedVideoAdDidPlayFinish:(KSRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
            [weakSelf.delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
            [weakSelf.delegate rewardedVideoCustomEventVideoEnd:self];
        }
    });
}

- (void)rewardedVideoAdStartPlay:(KSRewardedVideoAd *)rewardedVideoAd {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
            [weakSelf.delegate rewardedVideoCustomEventVideoStart:self];
        }
    });
}

- (void)rewardedVideoAd:(KSRewardedVideoAd *)rewardedVideoAd hasReward:(BOOL)hasReward {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
            [weakSelf.delegate rewardedVideoCustomEventDidReceiveReward:self];
        }
    });
}

@end
