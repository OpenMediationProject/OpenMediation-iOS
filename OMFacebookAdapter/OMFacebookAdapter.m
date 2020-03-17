// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookAdapter.h"
#import "OMFacebookClass.h"

@implementation OMFacebookAdapter
+ (NSString*)adapterVerison {
    return FacebookAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    completionHandler(nil);
    
}

@end
