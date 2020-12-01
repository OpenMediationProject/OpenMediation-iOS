// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostInterstitial.h"

@implementation OMChartboostInterstitial
- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super init]) {
        _pid = [adParameter objectForKey:@"pid"];
    }
    return self;
}

- (void)loadAd {
    Class CHBInterstitialClass = NSClassFromString(@"CHBInterstitial");
    if (CHBInterstitialClass && [[CHBInterstitialClass alloc] respondsToSelector:@selector(initWithLocation:delegate:)]) {
        _chbInterstitial = [[CHBInterstitialClass alloc] initWithLocation:_pid delegate:self];
    }
    if (_chbInterstitial) {
        [_chbInterstitial cache];
    }
}

- (BOOL)isReady {
    BOOL isReady = NO;
    if(_chbInterstitial && [_chbInterstitial respondsToSelector:@selector(isCached)]) {
        isReady = _chbInterstitial.isCached;
    }
    return isReady;
}

- (void)show:(UIViewController *)vc {
    if ([self isReady]) {
        if(_chbInterstitial && [_chbInterstitial respondsToSelector:@selector(showFromViewController:)]) {
            [_chbInterstitial showFromViewController:vc];
        }
    }
}

- (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error{
    if([self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    }
    
    if (error) {
        if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            NSError *cerror = [[NSError alloc] initWithDomain:@"com.charboost.ads" code:error.code userInfo:@{@"msg":@"There are no ads fill"}];
            [_delegate customEvent:self didFailToLoadWithError:cerror];
        }
    }
}

- (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
        [_delegate interstitialCustomEventDidOpen:self];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
        [_delegate interstitialCustomEventDidShow:self];
    }
    
    if (error) {
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
            NSError *cerror = [[NSError alloc] initWithDomain:@"com.charboost.ads" code:error.code userInfo:@{@"msg":@"The ad failed to show"}];
            [_delegate interstitialCustomEventDidFailToShow:self error:cerror];
        }
    }
}

- (void)didClickAd:(CHBClickEvent *)event error:(nullable CHBClickError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)didDismissAd:(CHBDismissEvent *)event{
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}

@end
