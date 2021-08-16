// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInMobiAdapter.h"

static NSInteger GDPRConsent = -1;

@implementation OMInMobiAdapter

+ (NSString*)adapterVerison {
    return InMobiAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    GDPRConsent = consent?1:0;
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
            //TODO:GDPR
            NSMutableDictionary *consentDic = [NSMutableDictionary dictionary];
            if (GDPRConsent >=0) {
                [consentDic setObject:(GDPRConsent == 1)?@"true":@"false" forKey:@"gdpr_consent_available"];
                [consentDic setObject:@"1" forKey:@"gdpr"];
                
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
