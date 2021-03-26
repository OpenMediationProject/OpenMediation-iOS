// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobAdapter.h"
#import "OMAdMobNative.h"
#import "OMAdMobNativeAd.h"

@implementation OMAdMobNative


- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        NSArray *adTypes = @[@"6"];
        id adLoaderClass = NSClassFromString(@"GADAdLoader");
        if (adLoaderClass && [adLoaderClass instancesRespondToSelector:@selector(initWithAdUnitID:rootViewController:adTypes:options:)] && adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *options = [NSMutableArray array];
            Class mediaOptionsClass = NSClassFromString(@"GADNativeAdMediaAdLoaderOptions");
            if (mediaOptionsClass) {
                GADNativeAdMediaAdLoaderOptions *mediaOption = [[mediaOptionsClass alloc] init];
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
    if (requestClass && [requestClass respondsToSelector:@selector(request)]) {
        GADRequest *request  = [requestClass request];
        if ([OMAdMobAdapter npaAd] && NSClassFromString(@"GADExtras")) {
            GADExtras *extras = [[NSClassFromString(@"GADExtras") alloc] init];
            extras.additionalParameters = @{@"npa": @"1"};
            [request registerAdNetworkExtras:extras];
        }
        [_adLoader loadRequest:request];
        _canLoadRequest = NO;
    }
}

#pragma mark -- GADAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    if (error && _delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
        [_delegate customEvent:self didFailToLoadWithError:error];
    }
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader {
    _canLoadRequest = YES;
}


- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    nativeAd.delegate = self;
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadWithAdnName:)]) {
        NSString *adnName = @"";
        GADResponseInfo *info = [nativeAd responseInfo];
        if (info && [info respondsToSelector:@selector(adNetworkClassName)]) {
            adnName = [info adNetworkClassName];
        }
        [_delegate customEvent:self didLoadWithAdnName:adnName];
    }
    OMAdMobNativeAd *admobAd = [[OMAdMobNativeAd alloc]initWithGadNativeAd:nativeAd];
    if (_delegate && [_delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
        [_delegate customEvent:self didLoadAd:admobAd];
    }
}

- (void)nativeAdDidRecordImpression:(GADNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:self];
    }
}

- (void)nativeAdDidRecordClick:(GADNativeAd *)nativeAd {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
        [_delegate nativeCustomEventDidClick:self];
    }
}

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {
    
}

- (void)nativeAdWillDismissScreen:(GADNativeAd *)nativeAd {
    
}

- (void)nativeAdDidDismissScreen:(GADNativeAd *)nativeAd {
    
}

- (void)nativeAdWillLeaveApplication:(GADNativeAd *)nativeAd {
    
}

- (void)nativeAdIsMuted:(GADNativeAd *)nativeAd {
    
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
