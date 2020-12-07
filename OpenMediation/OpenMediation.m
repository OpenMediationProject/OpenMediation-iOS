// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OpenMediation.h"
#import "OMConfig.h"
#import "OMNetworkUmbrella.h"
#import "OMToolUmbrella.h"
#import "OMMediations.h"
#import "OMAudience.h"
#import "OMEventManager.h"
#import "OMInterstitial.h"
#import "OMRewardedVideo.h"
#import "OMCrossPromotion.h"

@interface OMRewardedVideo()
- (void)preload;
@end

@interface OMInterstitial()
- (void)preload;
@end

@interface OMCrossPromotion()
- (void)preload;
@end

static OpenMediationAdFormat initAdFormats = 0;

#define SDKInitCheckInterval 3.0


static NSTimer *SDKInitCheckTimer = nil;

@implementation OpenMediation

+ (void)initWithAppKey:(NSString*)appKey {
    [self initWithAppKey:appKey baseHost:@"https://s.openmediation.com"];
}
    
+ (void)initWithAppKey:(NSString*)appKey baseHost:(nonnull NSString *)host {
    if (!initAdFormats) {
        [self initWithAppKey:appKey baseHost:host adFormat:(OpenMediationAdFormatRewardedVideo|OpenMediationAdFormatInterstitial|OpenMediationAdFormatCrossPromotion)];
    } else {
        [self initWithAppKey:appKey baseHost:host adFormat:initAdFormats];
    }
}

+ (void)initWithAppKey:(NSString *)appKey adFormat:(OpenMediationAdFormat)initAdTypes {
    [self initWithAppKey:appKey baseHost:@"https://s.openmediation.com" adFormat:initAdTypes];
}

/// Initializes OpenMediation's SDK with the requested ad types.
+ (void)initWithAppKey:(NSString *)appKey baseHost:(NSString*)host adFormat:(OpenMediationAdFormat)initAdTypes {
    [self initWithAppKey:appKey baseHost:host completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            if (initAdTypes & OpenMediationAdFormatInterstitial) {
                [[OMInterstitial sharedInstance]preload];
            }
            if (initAdTypes & OpenMediationAdFormatRewardedVideo) {
                [[OMRewardedVideo sharedInstance]preload];
            }
            if (initAdTypes & OpenMediationAdFormatCrossPromotion) {
                [[OMCrossPromotion sharedInstance]preload];
            }
        }
    }];
    
    if (SDKInitCheckTimer) {
        [SDKInitCheckTimer invalidate];
        SDKInitCheckTimer = nil;
    }
    SDKInitCheckTimer = [NSTimer scheduledTimerWithTimeInterval:SDKInitCheckInterval target:self selector:@selector(checkSDKInit) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:SDKInitCheckTimer forMode:NSRunLoopCommonModes];
}


+ (void)checkSDKInit {
    if ([[OMConfig sharedInstance].appKey length]>0 && ![OpenMediation isInitialized] && [OMNetMonitor sharedInstance].netStatus) {
        [self initWithAppKey:[OMConfig sharedInstance].appKey baseHost:[OMConfig sharedInstance].baseHost];
    }
}

+ (void)initWithAppKey:(NSString*)appKey baseHost:(NSString*)host completionHandler:(initCompletionHandler)completionHandler {
    OMConfig *config = [OMConfig sharedInstance];
    if (config.initState == OMInitStateInitializing || config.initState == OMInitStateInitialized) {
        if (config.initState == OMInitStateInitialized) {
            completionHandler(nil);
        }
        return;
    }
    OMLogI(@"OpenMediation SDK init Version %@",OPENMEDIATION_SDK_VERSION);
    [[OMNetMonitor sharedInstance] startMonitor];
    [OMInitRequest configureWithAppKey:appKey baseHost:host completionHandler:^(NSError *error) {
        if (!error) {
            [self settingWithConfig];
            OMLogI(@"OpenMediation SDK init success");
            completionHandler(nil);
        } else {
            [[OMEventManager sharedInstance]addEvent:INIT_FAILED extraData:nil];
            OMLogI(@"OpenMediation SDK init error: %@",error.localizedDescription);
            completionHandler(error);
        }
    }];
}

+ (void)settingWithConfig {
    OMConfig *config = [OMConfig sharedInstance];
    if (config.openDebug) {
        [OMLogMoudle setDebugMode];
    }

    [[OMCrashHandle sharedInstance]sendCrashLog];
    if (!OM_STR_EMPTY(config.erUrl)) {
        [[OMCrashHandle sharedInstance]install];
    }

}

/// Check that `OpenMediation` has been initialized
+ (BOOL)isInitialized {
    return [OMConfig sharedInstance].initSuccess;
}

#pragma mark - Segments
/// user in-app purchase
+ (void)userPurchase:(CGFloat)amount currency:(NSString*)currencyUnit {

     [[OMAudience sharedInstance]userPurchase:amount currency:currencyUnit];
}

+ (void)setUserAge:(NSInteger)userAge {
    [[OMConfig sharedInstance] setUserAge:userAge];
    //pass user age to adn
    OMConfig *config = [OMConfig sharedInstance];
    for (NSString *adnID in config.adnAppkeyMap) {
        
        Class adapterClass = [[OMMediations sharedInstance] adnAdapterClass:[adnID integerValue]];
        
        if (adapterClass && [adapterClass respondsToSelector:@selector(setUserAge:)]) {
            [adapterClass setUserAge:[OMConfig sharedInstance].userAge];
        }
    }

}

+ (void)setUserGender:(OMGender)userGender {
    [[OMConfig sharedInstance] setUserGender:(NSInteger)userGender];
    
    //pass user gender to adn
    OMConfig *config = [OMConfig sharedInstance];
    for (NSString *adnID in config.adnAppkeyMap) {
        
        Class adapterClass = [[OMMediations sharedInstance] adnAdapterClass:[adnID integerValue]];
        
        if (adapterClass && [adapterClass respondsToSelector:@selector(setUserGender:)]) {
            [adapterClass setUserGender:[OMConfig sharedInstance].userAge];
        }
    }
}

#pragma mark - ROAS
/// calculate each Media Source, Campaign level ROAS, and LTV data
+ (void)sendAFConversionData:(NSDictionary*)conversionInfo {
    [OMCDRequest postWithType:0 data:conversionInfo completionHandler:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            OMLogD(@"send af conversion data success");
        }
    }];
}

+ (void)sendAFDeepLinkData:(NSDictionary*)attributionData {
    [OMCDRequest postWithType:1 data:attributionData completionHandler:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            OMLogD(@"send af deep link data success");
        }
    }];
}

#pragma mark - GDPR/CCPA
+ (void)setGDPRConsent:(BOOL)consent {
    [[OMConfig sharedInstance] setConsent:consent];
    [[NSUserDefaults standardUserDefaults] setBool:consent forKey:@"OMConsentStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (OMConsentStatus)currentConsentStatus {
    if (OM_IS_NULL([[NSUserDefaults standardUserDefaults] stringForKey:@"OMConsentStatus"])) {
        return OMConsentStatusUnknown;
    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"OMConsentStatus"] == YES) {
        return OMConsentStatusConsented;
    }else{
        return OMConsentStatusDenied;
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    [[OMConfig sharedInstance] setUSPrivacy:privacyLimit];
    
}

#pragma mark - Debug
/// current SDK version
+ (NSString *)SDKVersion {
    return OPENMEDIATION_SDK_VERSION;
}

/// A tool to verify a successful integration of the OpenMediation SDK and any additional adapters.
+ (void)validateIntegration{
    [OMMediations validateIntegration];
}

/// log enable,default is YES
+ (void)setLogEnable:(BOOL)logEnable {
    [OMLogMoudle openLog:logEnable];
}



@end
