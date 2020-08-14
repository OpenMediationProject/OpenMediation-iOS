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

+ (NSString*)adNetworkVersion {
    NSString *sdkVersion = @"";
    Class sdkClass = NSClassFromString(@"MTRGVersion");
    if (sdkClass && [sdkClass respondsToSelector:@selector(currentVersion)]) {
        sdkVersion = [sdkClass currentVersion];
    }
    return sdkVersion;
}

+ (NSString*)minimumSupportVersion {
    return @"5.4.8";
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
    
    if ([[self adNetworkVersion]compare:[self minimumSupportVersion]options:NSNumericSearch] == NSOrderedAscending) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.mytargetadapter"
                                                    code:505
                                                userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The current ad network(%@) is below the minimum required version(%@)",[self adNetworkVersion],[self minimumSupportVersion]]}];
        completionHandler(error);
        return;
    }
    completionHandler(nil);
}

@end
