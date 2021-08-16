// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3


#import "OMInMobiRewardedVideo.h"

@implementation OMInMobiRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
    
}

-(void)loadAd {
    Class rewardedClass = NSClassFromString(@"IMInterstitial");
    if (rewardedClass && [rewardedClass instancesRespondToSelector:@selector(initWithPlacementId:)] && !_rewardedVideo) {
        _rewardedVideo = [[rewardedClass alloc] initWithPlacementId:[_pid longLongValue]];
        _rewardedVideo.delegate = self;
    }
    [_rewardedVideo load];

}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    Class rewardedClass = NSClassFromString(@"IMInterstitial");
    if (rewardedClass && [rewardedClass instancesRespondToSelector:@selector(initWithPlacementId:)] && !_rewardedVideo) {
        _rewardedVideo = [[rewardedClass alloc] initWithPlacementId:[_pid longLongValue]];
        _rewardedVideo.delegate = self;
    }
    [_rewardedVideo load:[bidPayload dataUsingEncoding:NSUTF8StringEncoding]];
}

-(BOOL)isReady {
    BOOL ready = NO;
    if (_rewardedVideo && [_rewardedVideo respondsToSelector:@selector(isReady)]) {
        ready = [_rewardedVideo isReady];
    }
    return ready;
}

- (void)show:(UIViewController *)vc {
    if(self.rewardedVideo && [self isReady] && [_rewardedVideo respondsToSelector:@selector(showFromViewController:)]) {
        [_rewardedVideo showFromViewController:vc];
    }
}

#pragma mark - IMInterstitialDelegate


-(void)interstitial:(IMInterstitial*)interstitial didReceiveWithMetaInfo:(IMAdMetaInfo*)metaInfo {
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:[metaInfo getBid]]} error:nil];
    }
}

-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus *)error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.inmobiadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }
}

-(void)interstitialWillPresent:(IMInterstitial*)interstitial {
    
}

-(void)interstitialDidPresent:(IMInterstitial*)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error {
    NSError *failError = [[NSError alloc] initWithDomain:@"com.openmediation.inmobiadapter" code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
    
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:failError];
    }
}

-(void)interstitialDidDismiss:(IMInterstitial*)interstitial {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

@end
