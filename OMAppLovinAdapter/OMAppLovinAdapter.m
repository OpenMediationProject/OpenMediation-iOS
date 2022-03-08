// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAppLovinAdapter.h"
static ALSdk *alShareSDK = nil;
static BOOL logEnabled = NO;

@implementation OMAppLovinAdapter

+ (NSString*)adapterVerison {
    return AppLovinAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    
    Class privacySettings = NSClassFromString(@"ALPrivacySettings");
    if (privacySettings && [privacySettings respondsToSelector:@selector(setHasUserConsent:)]) {
        [privacySettings setHasUserConsent:consent];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class privacySettings = NSClassFromString(@"ALPrivacySettings");
    if (privacySettings && [privacySettings respondsToSelector:@selector(setDoNotSell:)]) {
        [privacySettings setDoNotSell:privacyLimit];
    }
}

+(void)setUserAgeRestricted:(BOOL)restricted {
    Class privacySettings = NSClassFromString(@"ALPrivacySettings");
    if (privacySettings && [privacySettings respondsToSelector:@selector(setIsAgeRestrictedUser:)]) {
        [privacySettings setIsAgeRestrictedUser:restricted];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    
    
    Class applovinClass = NSClassFromString(@"ALSdk");
    if (!applovinClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.applovinadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"AppLovin SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(applovinClass && [applovinClass respondsToSelector:@selector(sharedWithKey:)]) {
        alShareSDK = [applovinClass sharedWithKey:key];
        if (alShareSDK && [alShareSDK respondsToSelector:@selector(settings)]) {
            ALSdkSettings *settings =  [alShareSDK settings];
            if (settings && [settings respondsToSelector:@selector(setIsVerboseLogging:)]) {
                [settings setIsVerboseLogging:logEnabled];
            }
        }
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.applovinadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (ALSdk*)alShareSdk{
    return alShareSDK;
}

+ (UIWindow *)currentWindow{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

+ (void)setLogEnable:(BOOL)logEnable {
    logEnabled = logEnable;
}

@end
