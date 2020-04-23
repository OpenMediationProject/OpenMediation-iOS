// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMopubNative.h"
#import "OMMopubNativeAd.h"

NSString *const kAdTitleKey               = @"title";
NSString *const kAdTextKey                = @"text";
NSString *const kAdIconImageKey           = @"iconimage";
NSString *const kAdIconImageViewKey       = @"iconimageview";
NSString *const kAdMainImageKey           = @"mainimage";
NSString *const kAdSponsoredByCompanyKey  = @"sponsored";
NSString *const kAdMainMediaViewKey       = @"mainmediaview";
NSString *const kAdCTATextKey             = @"ctatext";
NSString *const kAdStarRatingKey          = @"starrating";
NSString *const kVideoConfigKey           = @"videoconfig";
NSString *const kVASTVideoKey             = @"video";
NSString *const kNativeAdConfigKey        = @"nativeadconfig";
NSString *const kAdPrivacyIconImageUrlKey = @"privacyicon";
NSString *const kAdPrivacyIconUIImageKey  = @"privacyiconuiimage";
NSString *const kAdPrivacyIconClickUrlKey = @"privacyclkurl";

@implementation OMMopubNative

- (instancetype)initWithParameter:(NSDictionary*)adParameter rootVC:(UIViewController*)rootViewController {
    if (self = [super init]) {
        _rootController = rootViewController;
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
            setWithObjects:kAdTitleKey, kAdTextKey, kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, nil];
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
    
    NSString *mainImageUrl = _nativeAd.properties[kAdMainImageKey];
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
    return _rootController;
}

- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData {
    if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventWillShow:)]) {
        [_delegate nativeCustomEventWillShow:self];
    }
}

- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd {
        if (_delegate && [_delegate respondsToSelector:@selector(nativeCustomEventDidClick:)]) {
            [_delegate nativeCustomEventDidClick:self];
        }
}

@end
