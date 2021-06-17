// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPubNativeRewardedVideo.h"

@implementation OMPubNativeRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
    
}

-(void)loadAd {
    if ([self isReady]) {
        [self rewardedDidLoad];
    } else {
        
        Class HyBidRewardedVideoAdClass = NSClassFromString(@"HyBidRewardedAd");
        if (HyBidRewardedVideoAdClass && [HyBidRewardedVideoAdClass instancesRespondToSelector:@selector(initWithZoneID:andWithDelegate:)]) {
            _rewardedVideoAd = [[HyBidRewardedVideoAdClass alloc] initWithZoneID:_pid andWithDelegate:self];
        }
        if (_rewardedVideoAd) {
            [_rewardedVideoAd load];
        }
    }
}

-(BOOL)isReady {
    if (_rewardedVideoAd) {
        return (_rewardedVideoAd.isReady);
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [_rewardedVideoAd showFromViewController:vc];
    }
}

- (void)rewardedDidLoad {
    Class utilsClass = NSClassFromString(@"HyBidHeaderBiddingUtils");
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)] && utilsClass && [utilsClass respondsToSelector:@selector(eCPMFromAd:withDecimalPlaces:)]) {
        NSString *price = [utilsClass eCPMFromAd:self.rewardedVideoAd.ad withDecimalPlaces:THREE_DECIMAL_PLACES];
        [_bidDelegate bidReseponse:self bid:@{@"price":price} error:nil];
    }
}

- (void)rewardedDidFailWithError:(NSError *)error {
    NSError *hybidError = [[NSError alloc] initWithDomain:@"com.hybid.bid" code:error.code userInfo:@{@"msg":error.description}];
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:hybidError];
    }
}

- (void)rewardedDidTrackClick {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)rewardedDidTrackImpression {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)rewardedDidDismiss {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)onReward {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

@end
