// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTapjoyRewardedVideo.h"


@implementation OMTapjoyRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        Class tapjoyClass = NSClassFromString(@"TJPlacement");
        if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(limitedPlacementWithName:mediationAgent:delegate:)]) {
            _tapjoyPlacement = [tapjoyClass limitedPlacementWithName:_pid mediationAgent:@"OpenMediation" delegate:self];
            _tapjoyPlacement.delegate = self;
            _tapjoyPlacement.videoDelegate = self;
        } else if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(placementWithName:delegate:)]) {
            _tapjoyPlacement = [tapjoyClass placementWithName:_pid delegate:self];
            _tapjoyPlacement.delegate = self;
            _tapjoyPlacement.videoDelegate = self;
        }
    }
    return self;
}

- (void)loadAd {

    if (!self.tapjoyPlacement && self.pid) {
        Class tapjoyClass = NSClassFromString(@"TJPlacement");
        if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(limitedPlacementWithName:mediationAgent:delegate:)]) {
            self.tapjoyPlacement = [tapjoyClass limitedPlacementWithName:self.pid mediationAgent:@"OpenMediation" delegate:self];
            self.tapjoyPlacement.delegate = self;
            self.tapjoyPlacement.videoDelegate = self;
        } else if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(placementWithName:delegate:)]) {
            self.tapjoyPlacement = [tapjoyClass placementWithName:self.pid delegate:self];
            self.tapjoyPlacement.delegate = self;
            self.tapjoyPlacement.videoDelegate = self;
        }
    }
    if (self.tapjoyPlacement && [self.tapjoyPlacement respondsToSelector:@selector(requestContent)]) {
        [self.tapjoyPlacement requestContent];
    } else {
        NSError *error = [NSError errorWithDomain:@"com.om.tapjoyadapter" code:-1 userInfo: @{NSLocalizedDescriptionKey:@"",NSLocalizedFailureReasonErrorKey:@""}];
        if (self.delegate && [self.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [_delegate customEvent:self didFailToLoadWithError:error];
        }
    }

}

- (BOOL)isReady {
    if (_tapjoyPlacement && [_tapjoyPlacement respondsToSelector:@selector(isContentReady)]) {
        return _tapjoyPlacement.contentReady;
    } else {
        return NO;
    }
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        if (_tapjoyPlacement && [_tapjoyPlacement respondsToSelector:@selector(showContentWithViewController:)]) {
            [_tapjoyPlacement showContentWithViewController:vc];
        }
    }
}

- (void)requestDidSucceed:(TJPlacement *)placement {
    
}

- (void)requestDidFail:(TJPlacement *)placement error:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)contentIsReady:(TJPlacement *)placement {
    if ([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}



- (void)videoDidFail:(TJPlacement*)placement error:(NSString*)errorMsg {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:[NSError errorWithDomain:@"com.tapjoy.video" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}]];
    }
}
- (void)contentDidAppear:(TJPlacement *)placement {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }

}

#pragma mark -- TJPlacementVideoDelegate
- (void)videoDidStart:(TJPlacement*)placement {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}


- (void)videoDidComplete:(TJPlacement*)placement {
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}


- (void)didClick:(TJPlacement*)placement {
    
}

- (void)placement:(TJPlacement *)placement didRequestPurchase:(TJActionRequest *)request productId:(NSString *)productId {
    
}

- (void)placement:(TJPlacement *)placement didRequestReward:(TJActionRequest *)request itemId:(NSString *)itemId quantity:(int)quantity {
    
}

- (void)contentDidDisappear:(TJPlacement *)placement {
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

@end
