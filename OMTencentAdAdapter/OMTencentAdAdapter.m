// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTencentAdAdapter.h"

@implementation OMTencentAdAdapter

+ (NSString*)adapterVerison {
    return GdtAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    completionHandler(nil);
    
}

@end
