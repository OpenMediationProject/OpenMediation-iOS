// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdmostRewardedVideo.h"

@implementation OMAdmostRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
    
}

-(void)loadAd {
    Class rewardedClass = NSClassFromString(@"AMRRewardedVideo");
    if (rewardedClass && [rewardedClass respondsToSelector:@selector(rewardedVideoForZoneId:)] && !_rewardedVideo) {
        _rewardedVideo = [rewardedClass rewardedVideoForZoneId:_pid];
        _rewardedVideo.delegate = self;
    }
    [_rewardedVideo loadRewardedVideo];

}

-(BOOL)isReady {
    BOOL ready = NO;
    if (_rewardedVideo && [_rewardedVideo respondsToSelector:@selector(isLoaded)]) {
        ready = [_rewardedVideo isLoaded];
    }
    return ready;
}

- (void)show:(UIViewController *)vc {
    if(self.rewardedVideo && [self isReady] && [_rewardedVideo respondsToSelector:@selector(showFromViewController:)]) {
        [_rewardedVideo showFromViewController:vc];
    }
}

#pragma mark - AMRRewardedVideoDelegate

- (void)didReceiveRewardedVideo:(AMRRewardedVideo *)rewardedVideo {
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:@{@"price":[NSNumber numberWithDouble:([rewardedVideo.ecpm doubleValue]/100.0)]} error:nil];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)didFailToReceiveRewardedVideo:(AMRRewardedVideo *)rewardedVideo error:(AMRError *)error {
    NSError *loadError = [[NSError alloc] initWithDomain:@"com.openmediation.admostadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:loadError];
    }
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:nil error:loadError];
    }

}

- (void)didShowRewardedVideo:(AMRRewardedVideo *)rewardedVideo {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)didFailToShowRewardedVideo:(AMRRewardedVideo *)rewardedVideo error:(AMRError *)error {
    NSError *failError = [[NSError alloc] initWithDomain:@"com.openmediation.admostadapter" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
    
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:failError];
    }
}

- (void)didClickRewardedVideo:(AMRRewardedVideo *)rewardedVideo {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)didCompleteRewardedVideo:(AMRRewardedVideo *)rewardedVideo {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)didDismissRewardedVideo:(AMRRewardedVideo *)rewardedVideo {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)didRewardedVideoStateChanged:(AMRRewardedVideo *)rewardedVideo state:(AMRAdState)state {
    
}





- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId {

}

- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

@end
