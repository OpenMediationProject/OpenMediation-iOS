// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMyTargetBanner.h"
#import "OMMyTargetAdapter.h"
#import "OMMyTargetBannerClass.h"

@implementation OMMyTargetBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        Class MTRGBannerAdViewClass = NSClassFromString(@"MTRGAdView");
        if (MTRGBannerAdViewClass && [MTRGBannerAdViewClass respondsToSelector:@selector(adViewWithSlotId:withRefreshAd:adSize:)]) {
            NSString *pid = [adParameter objectForKey:@"pid"];
            _bannerAdView = [MTRGBannerAdViewClass adViewWithSlotId:[pid integerValue] withRefreshAd:YES adSize:[self convertWithSize:frame.size]];
            _bannerAdView.delegate = self;
            if ([OMMyTargetAdapter mtgAge]) {
                [_bannerAdView.customParams setAge:[OMMyTargetAdapter mtgAge]];
            }
            if ([[OMMyTargetAdapter mtgGender] isEqualToString:@"0"]) {
                [_bannerAdView.customParams setGender:MTRGGenderUnknown];
            }else if ([[OMMyTargetAdapter mtgGender] isEqualToString:@"1"]){
                [_bannerAdView.customParams setGender:MTRGGenderMale];
            }else if ([[OMMyTargetAdapter mtgGender] isEqualToString:@"2"]){
                [_bannerAdView.customParams setGender:MTRGGenderFemale];
            }
            _bannerAdView.viewController = rootViewController;
            _bannerAdView.frame = CGRectMake(frame.size.width/2.0-_bannerAdView.frame.size.width/2.0, frame.size.height-_bannerAdView.frame.size.height, _bannerAdView.frame.size.width, _bannerAdView.frame.size.height);
            [self addSubview:_bannerAdView];
        }
    }
    return self;
}

- (MTRGAdSize)convertWithSize:(CGSize)size {
    if (size.width == 300 && size.height == 250) {
        return MTRGAdSize_300x250;
    } else if (size.width == 728 && size.height == 90) {
        return MTRGAdSize_728x90;
    } else  {
        return MTRGAdSize_320x50;
    }
}


- (void)loadAd{
    [_bannerAdView load];
}

- (void)onLoadWithAdView:(MTRGAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [_delegate customEvent:self didLoadAd:nil];
    }
}
 
- (void)onNoAdWithReason:(NSString *)reason adView:(MTRGAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
        [_delegate customEvent:self didFailToLoadWithError:[NSError errorWithDomain:@"com.mytarget.ads" code:0 userInfo: @{NSLocalizedDescriptionKey:reason}]];
    }
}

- (void)onAdShowWithAdView:(MTRGAdView *)adView
{
}

- (void)onAdClickWithAdView:(MTRGAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]){
        [_delegate bannerCustomEventDidClick:self];
    }
}
 
- (void)onShowModalWithAdView:(MTRGAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]){
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}
 
- (void)onDismissModalWithAdView:(MTRGAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]){
        [_delegate bannerCustomEventDismissScreen:self];
    }
}
 
- (void)onLeaveApplicationWithAdView:(MTRGAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]){
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}


@end
