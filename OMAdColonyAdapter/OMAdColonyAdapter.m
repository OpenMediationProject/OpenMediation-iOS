// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMAdColonyAdapter.h"

@implementation OMAdColonyAdapter

+ (NSString*)adapterVerison {
    return AdColonyAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
        NSString *key = [configuration objectForKey:@"appKey"];
        NSArray *pids = [configuration objectForKey:@"pids"];
    Class adColonyClass = NSClassFromString(@"AdColony");
    if (adColonyClass && [adColonyClass respondsToSelector:@selector(configureWithAppID:zoneIDs:options:completion:)]) {
        [adColonyClass configureWithAppID:key zoneIDs:pids options:nil completion:^(NSArray<AdColonyZone *> *zones) {
                completionHandler(nil);
        }];
    }else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.adcolonyadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}
@end
