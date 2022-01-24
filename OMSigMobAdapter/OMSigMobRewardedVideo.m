// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSigMobRewardedVideo.h"

@implementation OMSigMobRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

-(void)loadAd {
    Class WindRewardVideoAdClass = NSClassFromString(@"WindRewardVideoAd");
    Class WindRequestClass = NSClassFromString(@"WindAdRequest");
    if (WindRewardVideoAdClass && WindRequestClass && [WindRewardVideoAdClass instancesRespondToSelector:@selector(initWithPlacementId:request:)] && [WindRequestClass respondsToSelector:@selector(request)]) {
        WindAdRequest *request  = [WindRequestClass request];
        _rewardedVideoAd = [[WindRewardVideoAdClass alloc] initWithPlacementId:_pid request:request];
        _rewardedVideoAd.delegate = self;
    }
    if (_rewardedVideoAd) {
        [_rewardedVideoAd loadAdData];
    }
}

-(BOOL)isReady {
    if (_rewardedVideoAd) {
        return _rewardedVideoAd.ready;
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [_rewardedVideoAd showAdFromRootViewController:vc options:nil];
    }
}

- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)rewardVideoAdDidLoad:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    if(error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)rewardVideoAdDidVisible:(WindRewardVideoAd *)rewardVideoAd {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)rewardVideoAdDidClick:(WindRewardVideoAd *)rewardVideoAd {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)rewardVideoAdDidClickSkip:(WindRewardVideoAd *)rewardVideoAd {
    
}

- (void)rewardVideoAdDidClose:(WindRewardVideoAd *)rewardVideoAd reward:(WindRewardInfo *)reward {
    if (reward) {
        if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
            [_delegate rewardedVideoCustomEventDidReceiveReward:self];
        }
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)rewardVideoAdDidPlayFinish:(WindRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    if (!error) {
        if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
            [_delegate rewardedVideoCustomEventVideoEnd:self];
        }
    }else{
        if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
            [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
        }
    }
}

- (void)rewardVideoAdServerResponse:(WindRewardVideoAd *)rewardVideoAd isFillAd:(BOOL)isFillAd {
    
}

- (void)rewardVideoAdWillVisible:(WindRewardVideoAd *)rewardVideoAd {
    
}


@end
