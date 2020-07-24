// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobAdapter.h"
#import "OMAdMobRewardedVideo.h"

@implementation OMAdMobRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];

    }
    return self;
}

- (void)loadAd {
    Class adMobClass = NSClassFromString(@"GADRewardedAd");
    if (adMobClass && [adMobClass respondsToSelector:@selector(shimmedClass)]) {
        adMobClass = [adMobClass shimmedClass];
    }
    if (adMobClass && [adMobClass instancesRespondToSelector:@selector(initWithAdUnitID:)]) {
        _videoAd = [[adMobClass alloc]initWithAdUnitID:_pid];
    }
    
    Class requestClass = NSClassFromString(@"GADRequest");
    if (requestClass && [requestClass respondsToSelector:@selector(shimmedClass)]) {
        requestClass = [requestClass shimmedClass];
    }
    if (_videoAd && [_videoAd respondsToSelector:@selector(loadRequest:completionHandler:)] && requestClass && [requestClass respondsToSelector:@selector(request)]) {
        __weak __typeof(self) weakSelf = self;
        GADRequest *request = [requestClass request];
        
        if (![OMAdMobAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        
        [_videoAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
            if (weakSelf) {
                if (error) {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                        [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
                    }
                } else {
                    if ([weakSelf isReady] && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                        [weakSelf.delegate customEvent:weakSelf didLoadAd:nil];
                    }
                }
            }
        }];
    }
}

- (BOOL)isReady {
    if (_videoAd && [_videoAd respondsToSelector:@selector(isReady)]) {
        return _videoAd.isReady;
    } else {
        return NO;
    }
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        if (_videoAd && [_videoAd respondsToSelector:@selector(presentFromRootViewController:delegate:)]) {
            [_videoAd presentFromRootViewController:vc delegate:self];
        }
    }
}




/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(nonnull GADRewardedAd *)rewardedAd{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
didFailToPresentWithError:(nonnull NSError *)error{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}


/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
 userDidEarnReward:(nonnull GADAdReward *)reward{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(nonnull GADRewardedAd *)rewardedAd{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

@end
