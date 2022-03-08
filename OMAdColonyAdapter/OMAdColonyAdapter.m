// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdColonyAdapter.h"

NSString *adcGdprString = nil;
NSString *adcPrivacyString = nil;
NSString *adcAgeRestrictedString = nil;

static NSInteger omAdcUserAge;
static NSInteger omAdcUserGender;
static BOOL logEnabled = NO;

@implementation OMAdColonyAdapter

+ (NSString*)adapterVerison {
    return AdColonyAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    adcGdprString = (consent?@"1":@"0");
}

+(void)setUSPrivacyLimit:(BOOL)privacyLimit {
    adcPrivacyString = (privacyLimit?@"1":@"0");
}

+(void)setUserAgeRestricted:(BOOL)restricted {
    adcAgeRestrictedString = (restricted?@"1":@"0");
}

+ (void)setUserAge:(NSInteger)userAge {
    
    omAdcUserAge = userAge;
}

+ (void)setUserGender:(NSInteger)userGender {
    
    omAdcUserGender = userGender;
}

+ (NSInteger)getUserAge {
    return omAdcUserAge;
}

+ (NSInteger)getUserGender {
    return omAdcUserGender;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    NSArray *pids = [configuration objectForKey:@"pids"];
    Class adColonyClass = NSClassFromString(@"AdColony");
    if (!adColonyClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.adcolonyadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"AdColony SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if (adColonyClass && [adColonyClass respondsToSelector:@selector(configureWithAppID:zoneIDs:options:completion:)]) {
        AdColonyAppOptions *options = [NSClassFromString(@"AdColonyAppOptions") new];
        options.disableLogging = !logEnabled;
        
        if ([options respondsToSelector:@selector(setPrivacyFrameworkOfType:isRequired:)] && [options respondsToSelector:@selector(setPrivacyConsentString:forType:)]) {
            if (adcGdprString.length>0) {
                [options setPrivacyFrameworkOfType:ADC_GDPR isRequired:YES];
                [options setPrivacyConsentString:adcGdprString forType:ADC_GDPR];
            }
            if (adcPrivacyString.length>0) {
                [options setPrivacyFrameworkOfType:ADC_CCPA isRequired:YES];
                [options setPrivacyConsentString:adcPrivacyString forType:ADC_CCPA];
            }
            if (adcAgeRestrictedString.length>0) {
                [options setPrivacyFrameworkOfType:ADC_COPPA isRequired:YES];
                [options setPrivacyConsentString:adcAgeRestrictedString forType:ADC_COPPA];
            }
        }
        
        
        if (omAdcUserAge) {
            if (!options.userMetadata) {
                Class userClass = NSClassFromString(@"AdColonyUserMetadata");
                if (userClass) {
                    options.userMetadata = [[userClass alloc]init];
                }
            }
            options.userMetadata.userAge = omAdcUserAge;
        }
        if (omAdcUserGender) {
            if (!options.userMetadata) {
                Class userClass = NSClassFromString(@"AdColonyUserMetadata");
                if (userClass) {
                    options.userMetadata = [[userClass alloc]init];
                }
            }
            options.userMetadata.userGender = ((omAdcUserGender==1)?@"male":@"female");
        }
        
        
        
        [adColonyClass configureWithAppID:key zoneIDs:pids options:options completion:^(NSArray<AdColonyZone *> *zones) {
            if (zones.count>0) {
                completionHandler(nil);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.adcolonyadapter"
                                                            code:401
                                                        userInfo:@{NSLocalizedDescriptionKey:@"Failed to get Zone Ids"}];
                completionHandler(error);
            }
            
        }];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.adcolonyadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    logEnabled = logEnable;
}

@end
