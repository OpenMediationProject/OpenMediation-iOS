// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMyTargetAdapter.h"

@interface MTRGPrivacy : NSObject

+ (BOOL)isConsentSpecified;

+ (BOOL)userConsent;

+ (void)setUserConsent:(BOOL)userConsent;

+ (BOOL)userAgeRestricted;

+ (void)setUserAgeRestricted:(BOOL)userAgeRestricted;

@end

static NSNumber *mtgUserAge;
static NSString *mtgUserGender;


@implementation OMMyTargetAdapter

+ (NSString*)adapterVerison{
    return MyTargetAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    Class privacyClass = NSClassFromString(@"MTRGPrivacy");
    if (privacyClass && [privacyClass respondsToSelector:@selector(setConsent:)]) {
        [privacyClass setConsent:consent];
    }
}


+ (void)setUserAge:(NSInteger)userAge {
    mtgUserAge = [NSNumber numberWithInteger:userAge];
}

+ (void)setUserGender:(NSInteger)userGender {
    mtgUserGender = [NSString stringWithFormat:@"%ld", (long)userGender];
}

+ (NSNumber*)mtgAge {
    return mtgUserAge;
}

+ (NSString*)mtgGender {
    return mtgUserGender;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler{
    
    Class sdkClass = NSClassFromString(@"MTRGVersion");
    if (!sdkClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.mytargetadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"MyTarget SDK not found"}];
        completionHandler(error);
        return;
    }
    completionHandler(nil);
}

@end
