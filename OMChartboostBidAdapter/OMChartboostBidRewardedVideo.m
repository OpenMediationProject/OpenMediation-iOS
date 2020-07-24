// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostBidRewardedVideo.h"

@implementation OMChartboostBidRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        [[OMChartboostBidRouter sharedInstance]registerPidDelegate:_pid delegate:self];
    }
    return self;
}

- (void)loadAd {
    if ([self isReady]) {
        [self omChartboostBiDdidLoadWithError:nil];
        if (_biInfo) {
            [self omChartboostBidDidLoadWinningBidWithInfo:_biInfo];
        }
    } else {
        [[OMChartboostBidRouter sharedInstance]loadRewardedVideoWithPlacmentID:_pid];
    }
}

- (BOOL)isReady {
    return [[OMChartboostBidRouter sharedInstance]isReady:_pid];
}

- (void)show:(UIViewController *)vc {
    [[OMChartboostBidRouter sharedInstance]showAd:_pid withVC:vc];
}


#pragma mark -- OMChartboostBidAdapterDelegate

- (void)omChartboostBiDdidLoadWithError:(nullable HeliumError *)error {
    if (!error && [self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    } else if(error) {
        NSError *cerror = [[NSError alloc] initWithDomain:@"com.helium.bid" code:error.errorCode userInfo:@{@"msg":error.errorDescription}];
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [_delegate customEvent:self didFailToLoadWithError:cerror];
        }
        
        if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
            [_bidDelegate bidReseponse:self bid:nil error:cerror];
        }
    }
    
}

- (void)omChartboostBidDidShowWithError:(HeliumError *)error {
    if (error) {
        if(error && _delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]){
            NSError *cerror = [[NSError alloc] initWithDomain:@"com.helium.bid" code:error.errorCode userInfo:@{@"msg":@"The ad failed to show"}];
            [_delegate rewardedVideoCustomEventDidFailToShow:self withError:cerror];
        }
    } else {
        if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]){
            [_delegate rewardedVideoCustomEventDidOpen:self];
        }
        if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]){
            [_delegate rewardedVideoCustomEventVideoStart:self];
        }
    }
}

- (void)omChartboostBidDidClickWithError:(HeliumError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]){
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
    
}

- (void)omChartboostBidDidCloseWithError:(HeliumError *)error {
    
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]){
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]){
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)omChartboostBidDidGetReward:(NSInteger)reward {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]){
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}



- (void)omChartboostBidDidLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    _biInfo = bidInfo;
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:bidInfo error:nil];
    }
}

@end
