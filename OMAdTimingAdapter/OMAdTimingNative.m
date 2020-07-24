// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdTimingNative.h"
#import "OMAdTimingNativeAd.h"

@implementation OMAdTimingNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
        _rootVC = rootViewController;
    }
    return self;
}

- (void)loadAd {
    
    id adtNativeClass = NSClassFromString(@"AdTimingAdsNative");
    if (adtNativeClass && [adtNativeClass instancesRespondToSelector:@selector(initWithPlacementID:)] && _pid) {
        _native = [[adtNativeClass alloc] initWithPlacementID:_pid];
        _native.delegate = self;
        [_native loadAd];
    }
    
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    id adtNativeClass = NSClassFromString(@"AdTimingAdsNative");
    if (adtNativeClass && [adtNativeClass instancesRespondToSelector:@selector(initWithPlacementID:)] && _pid) {
        _native = [[adtNativeClass alloc] initWithPlacementID:_pid];
        _native.delegate = self;
        [_native loadAdWithPayLoad:bidPayload];
    }
}

#pragma mark -- AdTimingNativeDelegate

- (void)adtimingNative:(AdTimingAdsNative*)native didLoad:(AdTimingAdsNativeAd*)nativeAd {
    
    OMAdTimingNativeAd *adtNativeAd = [[OMAdTimingNativeAd alloc]initWithAdTimingNativeAd:nativeAd];
    
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:adtNativeAd];
    }
}

- (void)adtimingNativeDidFailToLoad:(AdTimingAdsNative*)native withError:(NSError*)error {
    if (error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adtimingNativeWillExposure:(AdTimingAdsNative*)native {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:self];
    }
}

- (void)adtimingNativeDidClick:(AdTimingAdsNative*)native {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}


@end
