// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdAdapter.h"

@implementation OMTencentAdAdapter

+ (NSString*)adapterVerison {
    return GdtAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    Class gdtClass = NSClassFromString(@"GDTSDKConfig");
    
    if (!gdtClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.gdtadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"GDT SDK not found"}];
        completionHandler(error);
        return;
    }
    
    NSString *key = [configuration objectForKey:@"appKey"];
    if (gdtClass && [gdtClass respondsToSelector:@selector(registerAppId:)] && [key length]>0) {
        [gdtClass registerAppId:key];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.gdtadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key."}];
        completionHandler(error);
    }
}

@end
