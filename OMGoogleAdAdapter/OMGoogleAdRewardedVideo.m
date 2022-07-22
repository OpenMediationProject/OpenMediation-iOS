// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMGoogleAdAdapter.h"
#import "OMGoogleAdRewardedVideo.h"

@implementation OMGoogleAdRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        
    }
    return self;
}

- (void)loadAd {
    Class adMobClass = NSClassFromString(@"GADRewardedAd");
    Class requestClass = NSClassFromString(@"GAMRequest");
    if (adMobClass && [adMobClass respondsToSelector:@selector(loadWithAdUnitID:request:completionHandler:)] && requestClass && [requestClass respondsToSelector:@selector(request)]) {
        __weak typeof(self) weakSelf = self;
        GAMRequest *request  = [requestClass request];
        if ([OMGoogleAdAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        [adMobClass loadWithAdUnitID:_pid
                             request:request
                   completionHandler:^(GADRewardedAd *ad, NSError *error) {
            if (!error) {
                weakSelf.ready = YES;
                weakSelf.videoAd = ad;
                weakSelf.videoAd.fullScreenContentDelegate = weakSelf;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadWithAdnName:)]) {
                    NSString *adnName = @"";
                    GADResponseInfo *info = [ad responseInfo];
                    if (info && [info respondsToSelector:@selector(adNetworkClassName)]) {
                        adnName = [info adNetworkClassName];
                    }
                    [weakSelf.delegate customEvent:weakSelf didLoadWithAdnName:adnName];
                }
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                    [weakSelf.delegate customEvent:weakSelf didLoadAd:nil];
                }
            } else {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                    [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
                }
            }
        }];
    }
}

- (BOOL)isReady {
    return self.ready;
}

- (void)show:(UIViewController *)vc {
    __weak typeof(self) weakSelf = self;
    if ([self isReady]) {
        if (_videoAd && [_videoAd respondsToSelector:@selector(presentFromRootViewController:userDidEarnRewardHandler:)]) {
            [_videoAd presentFromRootViewController:vc userDidEarnRewardHandler:^{
                weakSelf.reward = weakSelf.videoAd.adReward;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
                    [weakSelf.delegate rewardedVideoCustomEventDidReceiveReward:weakSelf];
                }
            }];
        }
    }
}


/// Tells the delegate that an impression has been recorded for the ad.
- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

/// Tells the delegate that a click has been recorded for the ad.
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}


/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}


@end
