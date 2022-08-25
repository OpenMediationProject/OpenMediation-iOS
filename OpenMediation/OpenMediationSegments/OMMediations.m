// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMediations.h"
#import "OMConfig.h"
#import "OMMediationAdapter.h"
#import "OMUserData.h"

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

@interface BUInterfaceBaseObject : NSObject
@end

@interface BUAdSDKManager : NSObject
@property (nonatomic, copy, readonly, class) NSString *SDKVersion;
@end

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

@interface KSAdSDKManager : NSObject
@property (nonatomic, readonly, class) NSString *SDKVersion;
@end

@interface HyBid : NSObject
+ (NSString *)sdkVersion;
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
            @(OMAdNetworkGoogleAd):@"GoogleAd",
            @(OMAdNetworkTapjoy):@"Tapjoy",
            @(OMAdNetworkChartboost):@"Chartboost",
            @(OMAdNetworkPangle):@"Pangle",
            @(OMAdNetworkMintegral):@"Mintegral",
            @(OMAdNetworkIronSource):@"IronSource",
            @(OMAdNetworkHelium):@"Helium",
            @(OMAdNetworkFyber):@"Fyber",
            @(OMAdNetworkSigMob):@"SigMob",
            @(OMAdNetworkKsAd):@"KuaiShou",
            @(OMAdNetworkPubNative):@"PubNative",
            @(OMAdNetworkAdmost):@"Admost",
            @(OMAdNetworkInMobi):@"InMobi",
            @(OMAdNetworkReklamUp):@"GoogleAd",
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
            @(OMAdNetworkGoogleAd):@"GADMobileAds",
            @(OMAdNetworkTapjoy):@"Tapjoy",
            @(OMAdNetworkChartboost):@"Chartboost",
            @(OMAdNetworkPangle):@"BUAdSDKManager",
            @(OMAdNetworkMintegral):@"MTGSDK",
            @(OMAdNetworkIronSource):@"IronSource",
            @(OMAdNetworkHelium):@"Helium",
            @(OMAdNetworkFyber):@"IASDKCore",
            @(OMAdNetworkSigMob):@"WindAds",
            @(OMAdNetworkKsAd):@"KSAdSDKManager",
            @(OMAdNetworkPubNative):@"HyBid",
            @(OMAdNetworkAdmost):@"AMRSDK",
            @(OMAdNetworkInMobi):@"IMSdk",
            @(OMAdNetworkReklamUp):@"GADMobileAds",
        };
        
        _adnSDKInitState = [NSMutableDictionary dictionary];
        _adnInitCompletionBlocks = [NSMutableDictionary dictionary];
        
        
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
        case OMAdNetworkGoogleAd:
        case OMAdNetworkReklamUp:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(sharedInstance)]) {
                GADMobileAds *admob = [sdkClass sharedInstance];
                if(admob && [admob respondsToSelector:@selector(sdkVersion)]) {
                    sdkVersion = [admob sdkVersion];
                }
            }
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
        case OMAdNetworkPangle:
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
        case OMAdNetworkKsAd:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(SDKVersion)]) {
                sdkVersion = [sdkClass SDKVersion];
            }
        }
            break;
        case OMAdNetworkPubNative:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(sdkVersion)]) {
                sdkVersion = [sdkClass sdkVersion];
            }
        }
            break;
        case OMAdNetworkAdmost:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(SDKVersion)]) {
                sdkVersion = [sdkClass SDKVersion];
            }
        }
            break;
        case OMAdNetworkInMobi:
        {
            if (sdkClass && [sdkClass respondsToSelector:@selector(getVersion)]) {
                sdkVersion = [sdkClass getVersion];
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
    OMUserData *userData = [OMUserData sharedInstance];
    NSString *adnName = [config adnName:adnID];
    Class adapterClass = NSClassFromString([NSString stringWithFormat:@"OM%@Adapter",adnName]);
    Class sdkClass = NSClassFromString(OM_SAFE_STRING([self.adnSdkClassMap objectForKey:@(adnID)]));
    
    NSString *key = [config adnAppKey:adnID];
    NSArray *pids = [config adnPlacements:adnID];
    
    NSMutableArray *completionBlocks = [NSMutableArray array];
    if ([_adnInitCompletionBlocks objectForKey:@(adnID)]) {
        completionBlocks  = [NSMutableArray arrayWithArray:[_adnInitCompletionBlocks objectForKey:@(adnID)]];
    }
    [completionBlocks addObject:completionHandler];
    [_adnInitCompletionBlocks setObject:completionBlocks forKey:@(adnID)];
    
    
    if (sdkClass && adapterClass && [adapterClass respondsToSelector:@selector(initSDKWithConfiguration:completionHandler:)]) {
        __weak __typeof(self) weakSelf = self;
        
        if (![self adnSDKInitializing:adnID]) {
            if ([adapterClass respondsToSelector:@selector(setLogEnable:)]) {
                [adapterClass setLogEnable:config.openDebug];
            }
            if (adnID == OMAdNetworkMopub && [pids count]>0) {
                
                ///MoPub need init first
                [_adnSDKInitState setObject:[NSNumber numberWithInteger:OMAdnSDKInitStateInitializing] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                
                [adapterClass initSDKWithConfiguration:@{@"appKey":key,@"pids":pids} completionHandler:^(NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            OMAdnSDKInitState state = error?OMAdnSDKInitStateDefault:OMAdnSDKInitStateInitialized;
                            [weakSelf.adnSDKInitState setObject:[NSNumber numberWithInteger:state] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                            NSArray *completionBlocks = [weakSelf.adnInitCompletionBlocks objectForKey:@(adnID)];
                            for (OMMediationInitCompletionBlock completionHandler in completionBlocks) {
                                completionHandler(error);
                            }
                        });
                }];
                if (userData.consent >=0 && [adapterClass respondsToSelector:@selector(setConsent:)]) {
                    [adapterClass setConsent:(BOOL)userData.consent];
                }
                if (userData.USPrivacy && [adapterClass respondsToSelector:@selector(setUSPrivacyLimit:)]) {
                    [adapterClass setUSPrivacyLimit:userData.USPrivacy];
                }
                if (userData.userAgeRestricted && [adapterClass respondsToSelector:@selector(setUserAgeRestricted:)]) {
                    [adapterClass setUserAgeRestricted:userData.userAgeRestricted];
                }
                
                if (userData.userAge && [adapterClass respondsToSelector:@selector(setUserAge:)]) {
                    [adapterClass setUserAge:userData.userAge];
                }
                if (userData.userGender && [adapterClass respondsToSelector:@selector(setUserGender:)]) {
                    [adapterClass setUserGender:userData.userGender];
                }
            } else {
                if (userData.consent >=0 && [adapterClass respondsToSelector:@selector(setConsent:)]) {
                    [adapterClass setConsent:(BOOL)userData.consent];
                }
                if (userData.USPrivacy && [adapterClass respondsToSelector:@selector(setUSPrivacyLimit:)]) {
                    [adapterClass setUSPrivacyLimit:userData.USPrivacy];
                }
                if (userData.userAgeRestricted && [adapterClass respondsToSelector:@selector(setUserAgeRestricted:)]) {
                    [adapterClass setUserAgeRestricted:userData.userAgeRestricted];
                }
                if (userData.userAge && [adapterClass respondsToSelector:@selector(setUserAge:)]) {
                    [adapterClass setUserAge:userData.userAge];
                }
                if (userData.userGender && [adapterClass respondsToSelector:@selector(setUserGender:)]) {
                    [adapterClass setUserGender:userData.userGender];
                }
                
                [_adnSDKInitState setObject:[NSNumber numberWithInteger:OMAdnSDKInitStateInitializing] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                
                [adapterClass initSDKWithConfiguration:@{@"appKey":key,@"pids":pids} completionHandler:^(NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            OMAdnSDKInitState state = error?OMAdnSDKInitStateDefault:OMAdnSDKInitStateInitialized;
                            [weakSelf.adnSDKInitState setObject:[NSNumber numberWithInteger:state] forKey:[NSString stringWithFormat:@"%zd",adnID]];
                            NSArray *completionBlocks = [weakSelf.adnInitCompletionBlocks objectForKey:@(adnID)];
                            for (OMMediationInitCompletionBlock completionHandler in completionBlocks) {
                                completionHandler(error);
                            }
                            [weakSelf.adnInitCompletionBlocks setObject:@[] forKey:@(adnID)];
                        });
                }];
            }
        }
        
    }else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediations"
            code:400
        userInfo:@{NSLocalizedDescriptionKey:@"Init adn failed,sdk or adapter not found"}];
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
