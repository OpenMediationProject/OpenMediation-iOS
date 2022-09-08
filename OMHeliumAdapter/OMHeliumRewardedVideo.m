// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHeliumRewardedVideo.h"

@implementation OMHeliumRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMHeliumRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}

- (void)loadAd {
    if ([self isReady]) {
        [self omHeliumDidLoadWithError:nil];
        if (_biInfo) {
            [self omHeliumDidLoadWinningBidWithInfo:_biInfo];
        }
    } else {
        [[OMHeliumRouter sharedInstance]loadRewardedVideoWithPlacmentID:_pid];
    }
}

- (BOOL)isReady {
    return [[OMHeliumRouter sharedInstance]isReady:_pid];
}

- (void)show:(UIViewController *)vc {
    [[OMHeliumRouter sharedInstance]showAd:_pid withVC:vc];
}


#pragma mark -- OMHeliumAdapterDelegate

- (void)omHeliumDidLoadWithError:(nullable HeliumError *)error {
    if (!error && [self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    } else if(error) {
        SEL descriptionSel = NSSelectorFromString(@"localizedDescription");
        NSString *errorDescription = @"The ad no fill";
        if ([error respondsToSelector:descriptionSel]) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            errorDescription = [error performSelector:descriptionSel];
            #pragma clang diagnostic pop
        }
        NSError *cerror = [[NSError alloc] initWithDomain:@"com.helium.bid" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [_delegate customEvent:self didFailToLoadWithError:cerror];
        }
        
        if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
            [_bidDelegate bidReseponse:self bid:nil error:cerror];
        }
    }
    
}

- (void)omHeliumDidShowWithError:(HeliumError *)error {
    if (error) {
        if(error && _delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]) {
            NSError *cerror = [[NSError alloc] initWithDomain:@"com.helium.bid" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:@"The ad failed to show"}];
            [_delegate rewardedVideoCustomEventDidFailToShow:self withError:cerror];
        }
    } else {
        if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
            [_delegate rewardedVideoCustomEventDidOpen:self];
        }
        if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
            [_delegate rewardedVideoCustomEventVideoStart:self];
        }
    }
}

- (void)omHeliumDidClickWithError:(HeliumError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
    
}

- (void)omHeliumDidCloseWithError:(HeliumError *)error {
    
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]) {
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)omHeliumDidGetReward:(NSInteger)reward {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]) {
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}



- (void)omHeliumDidLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    _biInfo = bidInfo;
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:bidInfo error:nil];
    }
}

@end
