// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubNative.h"
#import "OMMopubNativeAd.h"

@implementation OMMopubNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        _rootVC = rootViewController;
        Class downloadClass = NSClassFromString(@"MPImageDownloadQueue");
        if (downloadClass) {
            _imageDownloadQueue = [[downloadClass alloc] init];
        }
        
        NSString *pid = [adParameter objectForKey:@"pid"];
        
        Class staitcSettingClass = NSClassFromString(@"MPStaticNativeAdRendererSettings");
        Class renderClass = NSClassFromString(@"MPStaticNativeAdRenderer");
        Class requestClass = NSClassFromString(@"MPNativeAdRequest");
        
        if (staitcSettingClass && renderClass && [renderClass respondsToSelector:@selector(rendererConfigurationWithRendererSettings:)] && requestClass) {
            MPStaticNativeAdRendererSettings *settings = [[staitcSettingClass alloc] init];
            settings.renderingViewClass = NSClassFromString(@"OMMopubNativeView");
            MPNativeAdRendererConfiguration *config =
                [renderClass rendererConfigurationWithRendererSettings:settings];
            _adLoader = [requestClass requestWithAdUnitIdentifier:pid
                                                                   rendererConfigurations:@[ config ]];
        }
    }
    return self;
}

- (void)loadAd{

    Class targetClass = NSClassFromString(@"MPNativeAdRequestTargeting");
    if (targetClass && [targetClass respondsToSelector:@selector(targeting)]) {
        MPNativeAdRequestTargeting *targeting = [targetClass targeting];

        NSSet<NSString *> *desiredAssets = [NSSet
            setWithObjects:@"title", @"text", @"iconimage", @"mainimage",  @"ctatext", nil];
        targeting.desiredAssets = desiredAssets;
        _adLoader.targeting = targeting;
        __weak __typeof(self) weakSelf = self;
        if (_adLoader && [_adLoader respondsToSelector:@selector(startWithCompletionHandler:)]) {
            [_adLoader startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
                if (error) {
                    if (weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                        [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
                    }

                } else {
                    if (response) {
                        weakSelf.nativeAd = response;
                        weakSelf.nativeAd.delegate = weakSelf;
                        [weakSelf preCacheNativeImagesWithCompletionHandler:^(NSError *error) {
                            if (!error) {
                                OMMopubNativeAd *nativeAd = [[OMMopubNativeAd alloc]initWithMopubResponse:response];
                                
                                if (weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                                    [weakSelf.delegate customEvent:weakSelf didLoadAd:nativeAd];
                                }
                            } else {
                                NSError *error = [NSError errorWithDomain:@"com.om.mediation" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"cache main image failed"}];
                                if (weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                                    [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
                                }
                            }
                        }];
                    }
                }
            }];
        }
    }
}


- (void)preCacheNativeImagesWithCompletionHandler:(void (^)(NSError* error))completionHandler {
    
    NSString *mainImageUrl = _nativeAd.properties[@"mainimage"];
    NSURL *imageURL = [NSURL URLWithString:mainImageUrl];
    NSData *imageData = [[NSClassFromString(@"MPNativeCache") sharedCache]
        retrieveDataForKey:imageURL.absoluteString];
    
    if (imageData) {
        completionHandler(nil);
    } else {
        if (_imageDownloadQueue) {
            [_imageDownloadQueue
            addDownloadImageURLs:@[imageURL]
                 completionBlock:^(NSDictionary<NSURL *, UIImage *> *result, NSArray *errors) {
                if (errors.count>0) {
                    completionHandler(errors[0]);
                } else {
                    completionHandler(nil);
                }
            }];
        }
    }
}

- (UIViewController *)viewControllerForPresentingModalView {
    return _rootVC;
}

- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:ad];
    }
}

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
        if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
            [_delegate nativeCustomEventDidClick:nativeAd];
        }
}

@end
