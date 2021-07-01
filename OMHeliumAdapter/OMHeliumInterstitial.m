// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMHeliumInterstitial.h"

@implementation OMHeliumInterstitial

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
        [[OMHeliumRouter sharedInstance]loadInterstitialWithPlacmentID:_pid];
    }
}

- (BOOL)isReady {
    return [[OMHeliumRouter sharedInstance]isReady:_pid];
}

- (void)show:(UIViewController *)vc {
    [[OMHeliumRouter sharedInstance]showAd:_pid withVC:vc];
}

#pragma -- OMHeliumAdapterDelegate


- (void)omHeliumDidLoadWithError:(nullable HeliumError *)error {
    if(!error && [self isReady] && _delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:nil];
    } else if (error) {
        NSError *cerror = [[NSError alloc] initWithDomain:@"com.helium.ads" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
        if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            [_delegate customEvent:self didFailToLoadWithError:cerror];
        }
        if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
            [_bidDelegate bidReseponse:self bid:nil error:cerror];
        }
    }
}

- (void)omHeliumDidShowWithError:(HeliumError *)error {
    if (error) {
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidFailToShow:error:)]) {
            NSError *cerror = [[NSError alloc] initWithDomain:@"com.charboost.bid" code:error.errorCode userInfo:@{NSLocalizedDescriptionKey:error.errorDescription}];
            [_delegate interstitialCustomEventDidFailToShow:self error:cerror];
        }
    } else {
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidOpen:)]) {
            [_delegate interstitialCustomEventDidOpen:self];
        }
        if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidShow:)]) {
            [_delegate interstitialCustomEventDidShow:self];
        }
    }
}

- (void)omHeliumDidClickWithError:(HeliumError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClick:)]) {
        [_delegate interstitialCustomEventDidClick:self];
    }
}

- (void)omHeliumDidCloseWithError:(HeliumError *)error {
    if(_delegate && [_delegate respondsToSelector:@selector(interstitialCustomEventDidClose:)]) {
        [_delegate interstitialCustomEventDidClose:self];
    }
}


- (void)omHeliumDidLoadWinningBidWithInfo:(NSDictionary*)bidInfo {
    _biInfo = bidInfo;
    if (_bidDelegate && [_bidDelegate respondsToSelector:@selector(bidReseponse:bid:error:)]) {
        [_bidDelegate bidReseponse:self bid:bidInfo error:nil];
    }
}

@end
