// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookRewardedVideo.h"

@implementation OMFacebookRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

- (void)loadAd {
    Class fbClass = NSClassFromString(@"FBRewardedVideoAd");
   if (fbClass && [fbClass instancesRespondToSelector:@selector(initWithPlacementID:)]) {
       self.faceBookPlacement = [[fbClass alloc] initWithPlacementID:_pid];;
       self.faceBookPlacement.delegate = self;
   }
    if (self.faceBookPlacement) {
        [self.faceBookPlacement loadAd];
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
     Class fbClass = NSClassFromString(@"FBRewardedVideoAd");
    if (fbClass && [fbClass instancesRespondToSelector:@selector(initWithPlacementID:)]) {
        self.faceBookPlacement = [[fbClass alloc] initWithPlacementID:_pid];;
        self.faceBookPlacement.delegate = self;
    }
    if (self.faceBookPlacement) {
        [self.faceBookPlacement loadAdWithBidPayload:bidPayload];
    }
}

- (BOOL)isReady {
    if (self.faceBookPlacement) {
        return (self.faceBookPlacement.adValid && _ready);
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        _ready = NO;
        [self.faceBookPlacement showAdFromRootViewController:vc];
    }
}

- (void)rewardedVideoAdDidLoad:(FBRewardedVideoAd *)rewardedVideoAd {
    _ready =YES;
    if ([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)rewardedVideoAd:(FBRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)rewardedVideoAdDidClick:(FBRewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)rewardedVideoAdWillLogImpression:(FBRewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)rewardedVideoAdVideoComplete:(FBRewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)rewardedVideoAdDidClose:(FBRewardedVideoAd *)rewardedVideoAd {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

@end
