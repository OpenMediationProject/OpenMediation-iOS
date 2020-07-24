// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdRewardedVideo.h"
#import "OMTencentAdClass.h"

@implementation OMTencentAdRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter{
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
        _appID = [adParameter objectForKey:@"appKey"];
    }
    return self;
    
}

-(void)loadAd{
    Class GDTRewardedVideoAdClass = NSClassFromString(@"GDTRewardVideoAd");
    if (GDTRewardedVideoAdClass && GDTRewardedVideoAdClass && [GDTRewardedVideoAdClass instancesRespondToSelector:@selector(initWithAppId:placementId:)]) {
        _rewardedVideoAd = [[GDTRewardedVideoAdClass alloc] initWithPlacementId:_pid];
        _rewardedVideoAd.delegate = self;
    }
    if (_rewardedVideoAd) {
        [_rewardedVideoAd loadAd];
    }
}

-(BOOL)isReady{
    if (_rewardedVideoAd) {
        return _rewardedVideoAd.adValid;
    }
    return NO;
}

- (void)show:(UIViewController *)vc{
    
    Class sdkClass = NSClassFromString(@"GDTSDKConfig");
    if (sdkClass && [sdkClass respondsToSelector:@selector(enableDefaultAudioSessionSetting:)]) {
        [sdkClass enableDefaultAudioSessionSetting:NO];
    }
    
    if ([self isReady]) {
        [_rewardedVideoAd showAdFromRootViewController:vc];
    }
    
}

- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
    
}

- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd{
    
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error{
    
    // 5002 视频下载失败
    // 5003 视频播放失败
    // 5004 没有合适的广告
    
    if (error.code == 5003) {
        if(error && _delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidFailToShow:withError:)]){
            [_delegate rewardedVideoCustomEventDidFailToShow:self withError:error];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [_delegate customEvent:self didFailToLoadWithError:error];
        }
    }
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]){
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]){
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
}

@end
