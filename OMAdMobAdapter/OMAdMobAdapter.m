// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdMobAdapter.h"
#import "OMAdMobClass.h"

@implementation OMAdMobAdapter

+ (NSString*)adapterVerison {
    return AdmobAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    if ([key length] == 38) {//admob key length
        [[NSBundle mainBundle].infoDictionary setValue:key forKey:@"GADApplicationIdentifier"];
    }
    Class admobClass = NSClassFromString(@"GADMobileAds");
    if (admobClass && [admobClass respondsToSelector:@selector(sharedInstance)]) {
        GADMobileAds *ac = [admobClass sharedInstance];
        if (ac && [ac respondsToSelector:@selector(startWithCompletionHandler:)]) {
            [ac startWithCompletionHandler:nil];
            completionHandler(nil);
        }
    } else if (admobClass && [admobClass respondsToSelector:@selector(configureWithApplicationID:)]) {
        [admobClass configureWithApplicationID:key];
        completionHandler(nil);
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
