// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostBidInterstitial.h"

@implementation OMChartboostBidInterstitial

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
        [[OMChartboostBidRouter sharedInstance]loadInterstitialWithPlacmentID:_pid];
    }
}

- (BOOL)isReady {
    return [[OMChartboostBidRouter sharedInstance]isReady:_pid];
}

- (void)show:(UIViewController *)vc {
    [[OMChartboostBidRouter sharedInstance]showAd:_pid withVC:vc];
}

#pragma -- OMChartboostBidAdapterDelegate


- (void)omChartboostBiDdidLoadWithError:(nullable HeliumError *)error {
    if(!error && [self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]){
        [_delegate customEvent:self didLoadAd:nil];
    } else if (error) {
        NSError *cerror = [[NSError alloc] initWithDomain:@"com.helium.ads" code:error.errorCode userInfo:@{@"msg":error.errorDescription}];
        if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]){
            [_delegate customEvent:self didFailToLoadWithError:cerror];
        }
        if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
            [_bidDelegate bidReseponse:self bid:nil error:cerror];
        }
    }
}

- (void)omChartboostBidDidShowWithError:(HeliumError *)error {
    if (error) {
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]){
            NSError *cerror = [[NSError alloc] initWithDomain:@"com.charboost.bid" code:error.errorCode userInfo:@{@"msg":error.errorDescription}];
            [_delegate interstitialCustomEventDidFailToShow:self error:cerror];
        }
    } else {
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]){
            [_delegate interstitialCustomEventDidOpen:self];
        }
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]){
            [_delegate interstitialCustomEventDidShow:self];
        }
    }
}

- (void)omChartboostBidDidClickWithError:(HeliumError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]){
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)omChartboostBidDidCloseWithError:(HeliumError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]){
        [_delegate interstitialCustomEventDidClose:self];
    }
}


- (void)omChartboostBidDidLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    _biInfo = bidInfo;
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:bidInfo error:nil];
    }
}

@end
