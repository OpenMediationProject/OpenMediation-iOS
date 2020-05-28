// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdAdapter.h"

@implementation OMTencentAdAdapter

+ (NSString*)adapterVerison {
    return GdtAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    Class GDTClass = NSClassFromString(@"GDTSDKConfig");
    if (GDTClass && [GDTClass respondsToSelector:@selector(registerAppId:)]) {
        BOOL result = [GDTClass registerAppId:key];
        if (result) {
            completionHandler(nil);
        }
    }
}

@end
