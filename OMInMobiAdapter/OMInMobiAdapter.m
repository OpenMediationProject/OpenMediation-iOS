// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInMobiAdapter.h"

NSString *imGdprString = nil;
NSString *imPrivacyString = nil;

@implementation OMInMobiAdapter

+ (NSString*)adapterVerison {
    return InMobiAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    imGdprString = (consent?@"1":@"0");
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    imPrivacyString = (privacyLimit?@"true":@"false");
}

+ (void)setUserAgeRestricted:(BOOL)restricted {
    Class inmobiClass = NSClassFromString(@"IMSdk");
    if (inmobiClass && [inmobiClass respondsToSelector:@selector(setIsAgeRestricted:)]) {
        [inmobiClass setIsAgeRestricted:restricted];
    }
}

+ (void)setUserAge:(NSInteger)userAge {
    Class inmobiClass = NSClassFromString(@"IMSdk");
    if (inmobiClass && [inmobiClass respondsToSelector:@selector(setAge:)]) {
        [inmobiClass setAge:userAge];
    }
}

+ (void)setUserGender:(NSInteger)userGender {
    Class inmobiClass = NSClassFromString(@"IMSdk");
    if (inmobiClass && [inmobiClass respondsToSelector:@selector(setGender:)]) {
        [inmobiClass setGender:(IMSDKGender)userGender];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    NSArray *keys = [key componentsSeparatedByString:@"#"];
    if (keys.count>0) {
        key = keys[0];
    }
    Class inmobiClass = NSClassFromString(@"IMSdk");
    if (!inmobiClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.inmobiadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"InMobi SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if (inmobiClass && [inmobiClass respondsToSelector:@selector(initWithAccountID:consentDictionary:andCompletionHandler:)]) {
        NSMutableDictionary *consentDic = [NSMutableDictionary dictionary];
        if (imGdprString.length>0) {
            [consentDic setObject:imGdprString forKey:@"gdpr"];
        }
        if (imPrivacyString.length>0) {
            [consentDic setObject:imPrivacyString forKey:@"IM_GDPR_CONSENT_AVAILABLE"];
        }
        [inmobiClass initWithAccountID:key consentDictionary:consentDic andCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                completionHandler(nil);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.inmobiadapter"
                                                            code:401
                                                        userInfo:@{NSLocalizedDescriptionKey:@"Failed to get Zone Ids"}];
                completionHandler(error);
            }
            
        }];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.inmobiadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class inmobiClass = NSClassFromString(@"IMSdk");
    if (inmobiClass && [inmobiClass respondsToSelector:@selector(setLogLevel:)]) {
        [inmobiClass setLogLevel:(logEnable?kIMSDKLogLevelDebug:kIMSDKLogLevelNone)];
    }
}

@end
