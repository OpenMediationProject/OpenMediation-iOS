// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobAdapter.h"
#import "OMAdMobNative.h"
#import "OMAdMobNativeAd.h"

@implementation OMAdMobNative


- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        NSArray *adTypes = @[@"6"];//GADUnifiedNativeAd
        id adLoaderClass = NSClassFromString(@"GADAdLoader");
        if (adLoaderClass && [adLoaderClass respondsToSelector:@selector(shimmedClass)]) {
            adLoaderClass = [adLoaderClass shimmedClass];
        }
        
        if (adLoaderClass && [adLoaderClass instancesRespondToSelector:@selector(initWithAdUnitID:rootViewController:adTypes:options:)] && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *options = [NSMutableArray array];
            Class imageOptionsClass = NSClassFromString(@"GADNativeAdImageAdLoaderOptions");
            if (imageOptionsClass) {
                GADNativeAdImageAdLoaderOptions *imageOption = [[imageOptionsClass alloc] init];
                imageOption.preferredImageOrientation = GADNativeAdImageAdLoaderOptionsOrientationLandscape;
                [options addObject:imageOption];
            }
            Class mediaOptionsClass = NSClassFromString(@"GADNativeAdMediaAdLoaderOptions");
            if (mediaOptionsClass) {
                GADNativeAdMediaAdLoaderOptions *mediaOption = [[mediaOptionsClass alloc] init];
                mediaOption.mediaAspectRatio = 2;//GADMediaAspectRatioLandscape
                [options addObject:mediaOption];
            }
            
            _adLoader = [[adLoaderClass alloc] initWithAdUnitID:[adParameter objectForKey:@"pid"]
                                                 rootViewController:rootViewController
                                                            adTypes:adTypes
                                                            options:[options copy]];
            _adLoader.delegate = self;
            _canLoadRequest = YES;
        }
    }
    return self;
}

- (void)loadAd{
    Class requestClass = NSClassFromString(@"GADRequest");
    if ([requestClass respondsToSelector:@selector(shimmedClass)]) {
         requestClass = [requestClass shimmedClass];
    }
    if (_adLoader && requestClass && [requestClass respondsToSelector:@selector(request)] && _canLoadRequest) {
        GADRequest *request  = [requestClass request];
        if ([OMAdMobAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        [self.adLoader loadRequest:request];
        _canLoadRequest = NO;
    }
}

#pragma mark -- GADAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    if (error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader {
    _canLoadRequest = YES;
}

#pragma mark -- GADUnifiedNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
    nativeAd.delegate = self;
    nativeAd.videoController.delegate = self;
    
    OMAdMobNativeAd *admobAd = [[OMAdMobNativeAd alloc]initWithGadNativeAd:nativeAd];
    
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:admobAd];
    }
}

#pragma mark -- GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:self];
    }
}

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    
}

- (void)nativeAdIsMuted:(GADUnifiedNativeAd *)nativeAd {
    
}


#pragma mark -- GADVideoControllerDelegate

- (void)videoControllerDidPlayVideo:(GADVideoController *)videoController {
    
}

- (void)videoControllerDidPauseVideo:(GADVideoController *)videoController {
    
}

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    
}

- (void)videoControllerDidMuteVideo:(GADVideoController *)videoController {
    
}

- (void)videoControllerDidUnmuteVideo:(GADVideoController *)videoController {
    
}



@end
