// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAppLovinBanner.h"
#import "OMAppLovinAdapter.h"

@implementation OMAppLovinBanner

- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithFrame:frame]) {
        ALSdk *sdk = [OMAppLovinAdapter alShareSdk];
        Class ALAdViewClass = NSClassFromString(@"ALAdView");
        Class adSize = NSClassFromString(@"ALAdSize");
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]] && ALAdViewClass && [[ALAdViewClass alloc] respondsToSelector:@selector(initWithSdk:size:zoneIdentifier:)] && adSize && [adSize banner]) {
            _bannerAdView = [[ALAdViewClass alloc] initWithSdk:sdk size:[adSize banner] zoneIdentifier:[adParameter objectForKey:@"pid"]];
            _bannerAdView.adLoadDelegate = self;
            _bannerAdView.adDisplayDelegate = self;
            _bannerAdView.adEventDelegate = self;
            _bannerAdView.translatesAutoresizingMaskIntoConstraints = NO;
            _bannerAdView.frame = CGRectMake(frame.size.width/2.0-_bannerAdView.frame.size.width/2.0, frame.size.height-_bannerAdView.frame.size.height, _bannerAdView.frame.size.width, _bannerAdView.frame.size.height);
            [self addSubview:_bannerAdView];
        }
    }
    return self;
}

- (void)loadAd{
    [_bannerAdView loadNextAd];
}

#pragma mark - Ad Load Delegate

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [_delegate customEvent:self didLoadAd:nil];
    }
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
        [_delegate customEvent:self didFailToLoadWithError:[NSError errorWithDomain:@"com.applovin.ads" code:code userInfo:nil]];
    }
}

#pragma mark - Ad Display Delegate

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]){
        [_delegate bannerCustomEventDidClick:self];
    }
}

#pragma mark - Ad View Event Delegate

- (void)ad:(ALAd *)ad didPresentFullscreenForAdView:(ALAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]){
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)ad:(ALAd *)ad willDismissFullscreenForAdView:(ALAdView *)adView
{
}

- (void)ad:(ALAd *)ad didDismissFullscreenForAdView:(ALAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]){
        [_delegate bannerCustomEventDismissScreen:self];
    }
}

- (void)ad:(ALAd *)ad willLeaveApplicationForAdView:(ALAdView *)adView
{
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]){
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}

- (void)ad:(ALAd *)ad didFailToDisplayInAdView:(ALAdView *)adView withError:(ALAdViewDisplayErrorCode)code
{
}


@end
