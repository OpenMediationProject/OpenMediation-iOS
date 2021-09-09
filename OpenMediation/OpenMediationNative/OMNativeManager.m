// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMNativeManager.h"
#import "OpenMediationAdFormats.h"
#import "OMAdSingletonInterfacePrivate.h"


static OMNativeManager * _instance = nil;

@implementation OMNativeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithAdClassName:@"OMNative" adFormat:OpenMediationAdFormatNative];
    });
    return _instance;
    
}

- (void)addDelegate:(id)delegate {
    [super addDelegate:delegate];
}

- (void)removeDelegate:(id)delegate {
    [super removeDelegate:delegate];
}

- (void)loadWithPlacementID:(NSString*)placementID {
    [super loadWithPlacementID:placementID];
}

- (void)omNative:(OMNative*)native didLoad:(OMNativeAd*)nativeAd {
    for (id<OMNativeDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omNative:didLoad:)]) {
            [delegate omNative:native didLoad:nativeAd];
        }
    }
}

- (void)omNative:(OMNative*)native didLoadAdView:(OMNativeAdView*)nativeAdView {
    for (id<OMNativeDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omNative:didLoadAdView:)]) {
            [delegate omNative:native didLoadAdView:nativeAdView];
        }
    }
}

- (void)omNative:(OMNative*)native didFailWithError:(NSError*)error {
    for (id<OMNativeDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omNative:didFailWithError:)]) {
            [delegate omNative:native didFailWithError:error];
        }
    }
}

- (void)omNative:(OMNative*)native nativeAdDidShow:(OMNativeAd*)nativeAd {
    for (id<OMNativeDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omNative:nativeAdDidShow:)]) {
            [delegate omNative:native nativeAdDidShow:nativeAd];
        }
    }
}

- (void)omNative:(OMNative*)native nativeAdDidClick:(OMNativeAd*)nativeAd {
    for (id<OMNativeDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(omNative:nativeAdDidClick:)]) {
            [delegate omNative:native nativeAdDidClick:nativeAd];
        }
    }
}
@end
