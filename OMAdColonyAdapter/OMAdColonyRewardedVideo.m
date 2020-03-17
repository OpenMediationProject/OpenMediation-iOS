// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdColonyRewardedVideo.h"


@implementation OMAdColonyRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter{
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

- (void)loadAd {
    
    Class adColonyClass = NSClassFromString(@"AdColony");
    if (adColonyClass && [adColonyClass respondsToSelector:@selector(requestInterstitialInZone:options:success:failure:)]) {
        __weak __typeof(self) weakSelf = self;
        [adColonyClass requestInterstitialInZone:_pid options:nil success:^(AdColonyInterstitial *ad) {
            if (weakSelf) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                    [weakSelf.delegate customEvent:weakSelf didLoadAd:nil];
                }
                weakSelf.adColonyAd = ad;
                
                [weakSelf.adColonyAd setExpire:^{
                    
                }];
                [weakSelf.adColonyAd setClick:^{
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
                        [weakSelf.delegate rewardedVideoCustomEventDidClick:weakSelf];
                    }
                }];
                [weakSelf.adColonyAd setOpen:^{
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
                        [weakSelf.delegate rewardedVideoCustomEventDidOpen:weakSelf];
                    }
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
                        [weakSelf.delegate rewardedVideoCustomEventVideoStart:weakSelf];
                    }
                }];
                [weakSelf.adColonyAd setClose:^{
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
                        [weakSelf.delegate rewardedVideoCustomEventVideoEnd:weakSelf];
                    }
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
                        [weakSelf.delegate rewardedVideoCustomEventDidReceiveReward:weakSelf];
                    }
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
                        [weakSelf.delegate rewardedVideoCustomEventDidClose:self];
                    }
                }];
            }
            
        } failure:^(AdColonyAdRequestError *error) {
            if (weakSelf) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                    [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
                }
            }
        }];
    }
}

- (BOOL)isReady {
    if (self.adColonyAd) {
        return !self.adColonyAd.expired;
    }
    return NO;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        [self.adColonyAd showWithPresentingViewController:vc];
    }
}


@end
