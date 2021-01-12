// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookNative.h"
#import "OMFacebookNativeAd.h"

@interface OMFacebookNative()

@property (nonatomic, strong) NSString *pid;

@end

@implementation OMFacebookNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        if (adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _pid = [adParameter objectForKey:@"pid"];
        }
        _rootVC = rootViewController;
    }
    return self;
}

- (void)loadAd{
    
    Class FBNativeAdClass = NSClassFromString(@"FBNativeAd");
    if (FBNativeAdClass && _pid) {
        FBNativeAd *nativeAd = [[FBNativeAdClass alloc] initWithPlacementID:_pid];
        nativeAd.delegate = self;
        [nativeAd loadAd];
    }
}

- (void)loadAdWithBidPayload:(NSString *)bidPayload {
    Class FBNativeAdClass = NSClassFromString(@"FBNativeAd");
     if (FBNativeAdClass && _pid) {
         FBNativeAd *nativeAd = [[FBNativeAdClass alloc] initWithPlacementID:_pid];
         nativeAd.delegate = self;
         [nativeAd loadAdWithBidPayload:bidPayload];
     }
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd{
    self.fbNativeAd = nativeAd;
    if (self.fbNativeAd && self.fbNativeAd.isAdValid) {
        [self.fbNativeAd unregisterView];
    }
    OMFacebookNativeAd *facebookAd = [[OMFacebookNativeAd alloc]initWithFBNativeAd:nativeAd];    
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:facebookAd];
    }
}


- (void)nativeAdDidDownloadMedia:(FBNativeAd *)nativeAd {
    
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:self];
    }
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    if (error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd {
    
}

@end
