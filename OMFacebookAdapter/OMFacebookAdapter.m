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

// doc :https://developers.facebook.com/docs/audience-network/support/faq/ccpa
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class facebookClass = NSClassFromString(@"FBAdSettings");
    if (facebookClass && [facebookClass respondsToSelector:@selector(setDataProcessingOptions:country:state:)] && [facebookClass respondsToSelector:@selector(setDataProcessingOptions:)]) {
        if (privacyLimit) {
            [facebookClass setDataProcessingOptions:@[@"LDU"] country:1 state:1000];
        }else{
            [facebookClass setDataProcessingOptions:@[]];
        }
    }
}

@end
