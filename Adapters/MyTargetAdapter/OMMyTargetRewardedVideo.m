// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMyTargetRewardedVideo.h"
#import "OMMyTargetAdapter.h"
#import <OMMyTargetBannerClass.h>

@implementation OMMyTargetRewardedVideo

- (instancetype)initWithParameter:(NSDictionary*)adParameter
{
    if (self = [super init]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]){
            _pid = [adParameter objectForKey:@"pid"];
        }
    }
    return self;
}

-(void)loadAd
{
    Class MTRGInterstitialClass = NSClassFromString(@"MTRGInterstitialAd");
    if (MTRGInterstitialClass && [MTRGInterstitialClass respondsToSelector:@selector(interstitialAdWithSlotId:)]) {
        _ivAd = [MTRGInterstitialClass interstitialAdWithSlotId:[self.pid integerValue]];
        _ivAd.delegate = self;
        if ([OMMyTargetAdapter mtgAge]) {
            [_ivAd.customParams setAge:[OMMyTargetAdapter mtgAge]];
        }
        if ([[OMMyTargetAdapter mtgGender] isEqualToString:@"0"]) {
            [_ivAd.customParams setGender:MTRGGenderUnknown];
        }else if ([[OMMyTargetAdapter mtgGender] isEqualToString:@"1"]){
            [_ivAd.customParams setGender:MTRGGenderMale];
        }else if ([[OMMyTargetAdapter mtgGender] isEqualToString:@"2"]){
            [_ivAd.customParams setGender:MTRGGenderFemale];
        }
    }
    if (_ivAd) {
        [_ivAd load];
    }
}

-(BOOL)isReady
{
    return _ready;;
}

- (void)show:(UIViewController *)vc
{
    if ([self isReady]) {
        [_ivAd showWithController:vc];
    }
    _ready = NO;
}

- (void)onLoadWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    _ready = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
}
  
- (void)onNoAdWithReason:(NSString *)reason interstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:[NSError errorWithDomain:@"com.mytarget.ads" code:0 userInfo: @{NSLocalizedDescriptionKey:reason}]];
    }
}

- (void)onDisplayWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidOpen:)]) {
        [_delegate rewardedVideoCustomEventDidOpen:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoStart:)]) {
        [_delegate rewardedVideoCustomEventVideoStart:self];
    }
}
 
- (void)onClickWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClick:)]) {
        [_delegate rewardedVideoCustomEventDidClick:self];
    }
}
 
- (void)onCloseWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidClose:)]) {
        [_delegate rewardedVideoCustomEventDidClose:self];
    }
}

- (void)onVideoCompleteWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventVideoEnd:)]){
        [_delegate rewardedVideoCustomEventVideoEnd:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(rewardedVideoCustomEventDidReceiveReward:)]){
        [_delegate rewardedVideoCustomEventDidReceiveReward:self];
    }
}

- (void)onLeaveApplicationWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    
}


@end
