// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceRewardedVideo.h"

@implementation OMIronSourceRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter
{
    if (self = [super init]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
            if ([OMIronSourceAdapter mediationAPI]) {
                Class IronSourceClass = NSClassFromString(@"IronSource");
                if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(setRewardedVideoDelegate:)]) {
                    [IronSourceClass setRewardedVideoDelegate:self];
                }
            } else {
                [[OMIronSourceRouter sharedInstance] registerPidDelegate:_pid delegate:self];
            }
        }
    }
    return self;
}

-(void)loadAd
{
    if ([OMIronSourceAdapter mediationAPI]) {
        if ([self isReady]) {
            [self rewardedVideoHasChangedAvailability:YES];
        }
    } else {
        Class IronSourceClass = NSClassFromString(@"IronSource");
        if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(loadISDemandOnlyRewardedVideo:)]) {
            [IronSourceClass loadISDemandOnlyRewardedVideo:_pid];
        }
    }

}

-(BOOL)isReady
{
    BOOL isReady = NO;
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if ([OMIronSourceAdapter mediationAPI]) {
        if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(hasRewardedVideo)]) {
            isReady = [IronSourceClass hasRewardedVideo];
        }
    } else {
        if(IronSourceClass && [IronSourceClass respondsToSelector:@selector(hasISDemandOnlyRewardedVideo:)]) {
            isReady = [IronSourceClass hasISDemandOnlyRewardedVideo:_pid];
        }
    }

    return isReady;
}

- (void)show:(UIViewController *)vc
{
    Class IronSourceClass = NSClassFromString(@"IronSource");
    if ([self isReady]) {
        if ([OMIronSourceAdapter mediationAPI]) {
            if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(showRewardedVideoWithViewController:placement:)]) {
                [IronSourceClass showRewardedVideoWithViewController:vc placement:_pid];
            }
        } else if (![OMIronSourceAdapter mediationAPI]) {
            if (IronSourceClass && [IronSourceClass respondsToSelector:@selector(showISDemandOnlyRewardedVideo:instanceId:)]) {
                [IronSourceClass showISDemandOnlyRewardedVideo:vc instanceId:_pid];
            }
        }
    }
}

#pragma mark - DemandOnlyEvent

- (void)OMIronSourceDidload {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)OMIronSourceDidFailToLoad:(nonnull NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)OMIronSourceDidStart {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)OMIronSourceDidClick{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)OMIronSourceVideoEnd {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)OMIronSourceDidReceiveReward {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)OMIronSourceDidFinish {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)OMIronSourceDidFailToShow:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}

#pragma mark - ISRewardedVideoDelegate

- (void)rewardedVideoHasChangedAvailability:(BOOL)available {
    if (available) {
        if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
            [_delegate customEvent:self didLoadAd:nil];
        }
    }
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
    }
}

- (void)rewardedVideoDidOpen {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }

}

- (void)rewardedVideoDidClose {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)rewardedVideoDidStart {

}

- (void)rewardedVideoDidEnd {

}


@end
