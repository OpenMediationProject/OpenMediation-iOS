// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMediations.h"
#import "OMConfig.h"
#import "OMMediationAdapter.h"




@interface AdTimingBid : NSObject
+ (NSString *)SDKVersion;
@end

@interface GADMobileAds : NSObject
+ (nonnull GADMobileAds *)sharedInstance;
@property(nonatomic, nonnull, readonly) NSString *sdkVersion;
@end

@interface VungleSDK : NSObject
+ (VungleSDK *)sharedSDK;
- (NSDictionary *)debugInfo;
@end

@interface UnityAds : NSObject
+ (NSString *)getVersion;
@end

@interface ALSdk : NSObject
@property (class, nonatomic, copy, readonly) NSString *version;
@end

@interface Chartboost : NSObject
+ (NSString*)getSDKVersion;
@end

@interface BUAdSDKManager : NSObject
@property (nonatomic, copy, readonly, class) NSString *SDKVersion;
@end;

@interface MoPub : NSObject
- (NSString *)version;
@end

@interface GDTSDKConfig : NSObject
+ (NSString *)sdkVersion;
@end

@interface IASDKCore : NSObject
+ (instancetype _Null_unspecified)sharedInstance;
- (NSString * _Null_unspecified)version;
@end

@interface IronSource : NSObject
+ (NSString *)sdkVersion;
@end

@interface WindAds : NSObject
+ (NSString * _Nonnull)sdkVersion;
@end

static OMMediations *_instance = nil;

@implementation OMMediations

+ (BOOL)importAdnSDK:(OMAdNetwork)adnID {
    NSString *sdkClassName = [[OMMediations sharedInstance].adnSdkClassMap objectForKey:@(adnID)];
    return (sdkClassName && NSClassFromString(sdkClassName));
}


+ (void)validateIntegration {
    NSArray *mediationAdNetworks = [[OMMediations sharedInstance].adnNameMap allKeys];
    for (NSString *AdNetwork in mediationAdNetworks) {
        OMAdNetwork adnID = [AdNetwork integerValue];
        [self checkAdnSDKVersion:adnID];
    }
}

+ (void)checkAdnSDKVersion:(OMAdNetwork)adnID {
    NSString *adnName = [[OMMediations sharedInstance].adnNameMap valueForKey:[NSString stringWithFormat:@"%zd",adnID]];
    Class adnAdapterClass = [[OMMediations sharedInstance] adnAdapterClass:adnID];
    if ([OMMediations importAdnSDK:adnID]) {
        OMLogI(@"---------------%@---------------",adnName);
        OMLogI(@"SDK - version %@ - VERIFIED",[[OMMediations sharedInstance] adnSDKVersion:adnID]);
    } else {
        OMLogI(@"---------------%@---------------",adnName);
        OMLogI(@"SDK - *** MISSING ***");
    }
    
    if ([adnAdapterClass respondsToSelector:@selector(sdkVersion)] && [adnAdapterClass respondsToSelector:@selector(adapterVerison)]) {
        NSString *adapterVersion = [adnAdapterClass adapterVerison];
        OMLogI(@"Adapter - version %@ - VERIFIED",adapterVersion);
    } else {
        OMLogI(@"Adapter - *** MISSING ***");
    }
}

+ (NSString*)adnName:(OMAdNetwork)adnID {
    return OM_SAFE_STRING([[OMMediations sharedInstance].adnNameMap objectForKey:@(adnID)]);
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _adnNameMap = @{
            @(OMAdNetworkAdTiming):@"AdTiming",
            @(OMAdNetworkAdMob):@"AdMob",
            @(OMAdNetworkFacebook):@"Facebook",
            @(OMAdNetworkUnityAds):@"Unity",
            @(OMAdNetworkVungle):@"Vungle",
            @(OMAdNetworkTencentAd):@"TencentAd",
            @(OMAdNetworkAdColony):@"AdColony",
            @(OMAdNetworkAppLovin):@"AppLovin",
            @(OMAdNetworkMopub):@"Mopub",
            @(OMAdNetworkTapjoy):@"Tapjoy",
            @(OMAdNetworkChartboost):@"Chartboost",
            @(OMAdNetworkTikTok):@"TikTok",
            @(OMAdNetworkMintegral):@"Mintegral",
            @(OMAdNetworkIronSource):@"IronSource",
            @(OMAdNetworkChartboostBid):@"ChartboostBid",
            @(OMAdNetworkFyber):@"Fyber",
            @(OMAdNetworkSigMob):@"SigMob",
        };
        
        _adnSdkClassMap = @{
            @(OMAdNetworkAdTiming):@"AdTimingBid",
            @(OMAdNetworkAdMob):@"GADMobileAds",
            @(OMAdNetworkFacebook):@"FBAdSettings",
            @(OMAdNetworkUnityAds):@"UnityAds",
            @(OMAdNetworkVungle):@"VungleSDK",
            @(OMAdNetworkTencentAd):@"GDTSDKConfig",
            @(OMAdNetworkAdColony):@"AdColony",
            @(OMAdNetworkAppLovin):@"ALSdk",
            @(OMAdNetworkMopub):@"MoPub",
            @(OMAdNetworkTapjoy):@"Tapjoy",
            @(OMAdNetworkChartboost):@"Chartboost",
            @(OMAdNetworkTikTok):@"BUAdSDKManager",
            @(OMAdNetworkMintegral):@"MTGSDK",
            @(OMAdNetworkIronSource):@"IronSource",
            @(OMAdNetworkChartboostBid):@"HeliumSdk",
            @(OMAdNetworkFyber):@"IASDKCore",
            @(OMAdNetworkSigMob):@"WindAds",
        };
        
        _adnSDKInitState = [NSMutableDictionary dictionary];
        
        
    }
    return self;
}


- (Class)adnAdapterClass:(OMAdNetwork)adnID {
    NSString *adnName = [[OMMediations sharedInstance].adnNameMap objectForKey:@(adnID)];
    return NSClassFromString([NSString stringWithFormat:@"OM%@Adapter",adnName]);
}

- (NSString*)adnSDKVersion:(OMAdNetwork)adnID {
    NSString *sdkVersion = @"";
    Class sdkClass = nil;
    if ([self.adnSdkClassMap objectForKey:@(adnID)]) {
        sdkClass = NSClassFromString([self.adnSdkClassMap objectForKey:@(adnID)]);
    }

    switch (adnID) {
        case OMAdNetworkAdTiming:
            {
                if (sdkClass && [sdkClass respondsToSelector:@selector(SDKVersion)]) {
                    sdkVersion = [sdkClass SDKVersion];
                }
            }
            break;
        case OMAdNetworkAdMob:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(sharedInstance)]) {
                GADMobileAds *admob = [sdkClass sharedInstance];
                if(admob && [admob respondsToSelector:@selector(sdkVersion)]) {
                    sdkVersion = [admob sdkVersion];
                }
            }
        }
            break;
        case OMAdNetworkFacebook:
        {
            //fb
        }
            break;
        case OMAdNetworkUnityAds:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(getVersion)]) {
                sdkVersion = [sdkClass getVersion];
            }
        }
            break;
        case OMAdNetworkVungle:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(sharedSDK)]) {
                VungleSDK *vungle = [sdkClass sharedSDK];
                if (vungle && [vungle respondsToSelector:@selector(debugInfo)]) {
                    NSDictionary *dic = [vungle debugInfo];
                    if (dic[@"version"]) {
                        sdkVersion = dic[@"version"];
                    }
                }
            }
        }
            break;
        case OMAdNetworkAdColony:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(getSDKVersion)]) {
                sdkVersion = [sdkClass getSDKVersion];
            }
        }
            break;
        case OMAdNetworkAppLovin:
        {
            if(sdkClass && [sdkClass respondsToSelector:@selector(version)]) {
                sdkVersion = [sdkClass performSelector:@selector(version)];
            }
        }
            break;
        case OMAdNetworkMopub:
        {
//            if (sdkClass && [sdkClass respondsToSelector:@selector(sharedInstance)]) {
//                MoPub *mopub = [sdkClass sharedInstance];
//                if ([mopub respondsToSelector:@selector(version)]) {
//                    sdkVersion = [mopub version];
//                }
//            }
        }
            break;
        case OMAdNetworkTapjoy:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(getVersion)]) {
                sdkVersion = [sdkClass getVersion];
            }
        }
            break;
        case OMAdNetworkChartboost:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(getSDKVersion)]) {
                sdkVersion = [sdkClass getSDKVersion];
            }
        }
            break;
        case OMAdNetworkTikTok:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(SDKVersion)]) {
                sdkVersion = [sdkClass SDKVersion];
            }
        }
            break;
        case OMAdNetworkMintegral:
        {
            // mintegral
        }
            break;
        case OMAdNetworkTencentAd:
        {
            if(sdkClass && [sdkClass respondsToSelector:@selector(sdkVersion)]) {
                sdkVersion = [sdkClass sdkVersion];
                
            }
        }
            break;
        case OMAdNetworkIronSource:
        {
            if(sdkClass && [sdkClass respondsToSelector:@selector(sdkVersion)]) {
                sdkVersion = [sdkClass sdkVersion];
            }
        }
            break;
        case OMAdNetworkFyber:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(sharedInstance)]) {
                IASDKCore *fyberCore = [sdkClass sharedInstance];
                if ([fyberCore respondsToSelector:@selector(version)]) {
                    sdkVersion = [fyberCore version];
                }
            }
        }
            break;
        case OMAdNetworkSigMob:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(sdkVersion)]) {
                sdkVersion = [sdkClass sdkVersion];
            }
        }
            break;
        default:
            break;
    }
    return sdkVersion;
}


- (void)initAdNetworkSDKWithId:(OMAdNetwork)adnID completionHandler:(OMMediationInitCompletionBlock)completionHandler {
    OMConfig *config = [OMConfig sharedInstance];
    Class adapterClass = [self adnAdapterClass:adnID];
    NSString *key = [config adnAppKey:adnID];
    NSArray *pids = [config adnPlacements:adnID];
    if (adapterClass && [adapterClass respondsToSelector:@selector(initSDKWithConfiguration:completionHandler:)]) {
        __weak __typeof(self) weakSelf = self;
        
        if (![self adnSDKInitializing:adnID]) {
            if (adnID == OMAdNetworkMopub && [pids count]>0) {
                
                ///MoPub need init first
                [_adnSDKInitState setObject:[NSNumber numberWithInteger:OMAdnSDKInitStateInitializing] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                
                [adapterClass initSDKWithConfiguration:@{@"appKey":key,@"pids":pids} completionHandler:^(NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            OMAdnSDKInitState state = error?OMAdnSDKInitStateDefault:OMAdnSDKInitStateInitialized;
                            [weakSelf.adnSDKInitState setObject:[NSNumber numberWithInteger:state] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                            if (completionHandler) {
                                completionHandler(error);
                            }
                        });
                }];
                if (config.consent >=0 && [adapterClass respondsToSelector:@selector(setConsent:)]) {
                    [adapterClass setConsent:(BOOL)config.consent];
                }
                if (config.USPrivacy && [adapterClass respondsToSelector:@selector(setUSPrivacyLimit:)]) {
                    [adapterClass setUSPrivacyLimit:config.USPrivacy];
                }
                
                if (config.userAge && [adapterClass respondsToSelector:@selector(setUserAge:)]) {
                    [adapterClass setUserAge:config.userAge];
                }
                if (config.userGender && [adapterClass respondsToSelector:@selector(setUserGender:)]) {
                    [adapterClass setUserGender:config.userGender];
                }
            } else {
                if (config.consent >=0 && [adapterClass respondsToSelector:@selector(setConsent:)]) {
                    [adapterClass setConsent:(BOOL)config.consent];
                }
                if (config.USPrivacy && [adapterClass respondsToSelector:@selector(setUSPrivacyLimit:)]) {
                    [adapterClass setUSPrivacyLimit:config.USPrivacy];
                }
                
                if (config.userAge && [adapterClass respondsToSelector:@selector(setUserAge:)]) {
                    [adapterClass setUserAge:config.userAge];
                }
                if (config.userGender && [adapterClass respondsToSelector:@selector(setUserGender:)]) {
                    [adapterClass setUserGender:config.userGender];
                }
                
                [_adnSDKInitState setObject:[NSNumber numberWithInteger:OMAdnSDKInitStateInitializing] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                
                [adapterClass initSDKWithConfiguration:@{@"appKey":key,@"pids":pids} completionHandler:^(NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            OMAdnSDKInitState state = error?OMAdnSDKInitStateDefault:OMAdnSDKInitStateInitialized;
                            [weakSelf.adnSDKInitState setObject:[NSNumber numberWithInteger:state] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                            if (completionHandler) {
                                completionHandler(error);
                            }
                        });
                }];
            }
        }
        
    }else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediations"
            code:400
        userInfo:@{NSLocalizedDescriptionKey:@"Failed,adapter not found"}];
        completionHandler(error);
    }
}

- (BOOL)adnSDKInitialized:(OMAdNetwork)adnID {
    if(adnID == OMAdNetworkCrossPromotion) {
        return YES;
    }else{
        OMAdnSDKInitState initState = [[self.adnSDKInitState objectForKey:[NSString stringWithFormat:@"%zd",adnID]]integerValue];
        return (initState == OMAdnSDKInitStateInitialized);
    }
}

- (BOOL)adnSDKInitializing:(OMAdNetwork)adnID {
    OMAdnSDKInitState initState = [[self.adnSDKInitState objectForKey:[NSString stringWithFormat:@"%zd",adnID]]integerValue];
    return (initState == OMAdnSDKInitStateInitializing);
}


- (NSDictionary*)adNetworkInfo {
    if (!_adNetworkInfo) {
        NSMutableDictionary *adNetworks  = [NSMutableDictionary dictionary];
        NSArray *mediationAdNetworks = [self.adnNameMap allKeys];
        for (NSString *adNetwork in mediationAdNetworks) {
            OMAdNetwork adnID = [adNetwork integerValue];
            if ([OMMediations importAdnSDK:adnID]) {
                OMLogI(@"%@ SDK version %@",[self.adnNameMap objectForKey:@(adnID)],[self adnSDKVersion:adnID]);
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:adnID],@"mid",[self adnSDKVersion:adnID],@"msdkv",@"",@"adapterv", nil];
                Class adnAdapterClass = [self adnAdapterClass:adnID];
                if (adnAdapterClass && [adnAdapterClass respondsToSelector:@selector(adapterVerison)]) {
                    OMLogI(@"%@ adapter version %@",[self.adnNameMap objectForKey:@(adnID)],[adnAdapterClass adapterVerison]);
                    [dic setValue:[adnAdapterClass adapterVerison] forKey:@"adapterv"];
                }
                [adNetworks setObject:dic forKey:adNetwork];
            } else {
                OMLogI(@"%@ SDK not in project",[self.adnNameMap objectForKey:@(adnID)]);
            }
        }
        _adNetworkInfo = [adNetworks copy];
    }
    return _adNetworkInfo;
}

@end
