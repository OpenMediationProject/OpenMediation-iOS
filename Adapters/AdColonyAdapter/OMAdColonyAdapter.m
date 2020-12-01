// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdColonyAdapter.h"

NSString *gdprConsentString = nil;

static NSInteger omAdcUserAge;
static NSInteger omAdcUserGender;

@implementation OMAdColonyAdapter

+ (NSString*)adapterVerison {
    return AdColonyAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    gdprConsentString = (consent?@"1":@"0");
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
            if (gdprConsentString) {
                options.gdprRequired = YES;
                options.gdprConsentString = gdprConsentString;
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
                    completionHandler(nil);
            }];
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.adcolonyadapter"
                                                        code:400
                                                    userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
            completionHandler(error);
        }
}

@end
