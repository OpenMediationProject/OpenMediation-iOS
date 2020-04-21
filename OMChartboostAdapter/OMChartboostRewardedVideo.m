// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostRewardedVideo.h"
#import "OMChartboostAdapter.h"


@implementation OMChartboostRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

- (void)loadAd {
    Class CHBRewardedClass = NSClassFromString(@"CHBRewarded");
    if (CHBRewardedClass && [[CHBRewardedClass alloc] respondsToSelector:@selector(initWithLocation:delegate:)]) {
        _chbRewarded = [[CHBRewardedClass alloc] initWithLocation:_pid delegate:self];
    }
    if (_chbRewarded) {
        [_chbRewarded cache];
    }
}

- (BOOL)isReady {
    BOOL isReady = NO;
    if(_chbRewarded && [_chbRewarded respondsToSelector:@selector(isCached)]){
        isReady = _chbRewarded.isCached;
    }
    return isReady;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        if(_chbRewarded && [_chbRewarded respondsToSelector:@selector(showFromViewController:)]){
            [_chbRewarded showFromViewController:vc];
        }
    }
}

- (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error{
    if([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [_delegate customEvent:self didLoadAd:nil];
    }
    
    if(error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
        NSError *cerror = [[NSError alloc] initWithDomain:@"com.charboost.ads" code:error.code userInfo:@{@"msg":@"There are no ads fill"}];
        [_delegate customEvent:self didFailToLoadWithError:cerror];
    }
}


- (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]){
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]){
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
    
    if(error && _delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]){
        NSError *cerror = [[NSError alloc] initWithDomain:@"com.charboost.ads" code:error.code userInfo:@{@"msg":@"The ad failed to show"}];
        [_delegate rewardedVideoCustomEventDidFailToShow:self withError:cerror];
    }
    
    
}

- (void)didClickAd:(CHBClickEvent *)event error:(nullable CHBClickError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]){
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)chartboostVideoEnd {
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]){
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

- (void)didDismissAd:(CHBDismissEvent *)event{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]){
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)didEarnReward:(CHBRewardEvent *)event{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]){
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

@end
