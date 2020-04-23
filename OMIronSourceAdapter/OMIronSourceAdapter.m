// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIronSourceAdapter.h"

@implementation OMIronSourceAdapter

+ (NSString *)adapterVerison{
    return IronSourceAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler{
    NSString *key = [configuration objectForKey:@"appKey"];
    Class ironsourceClass = NSClassFromString(@"IronSource");
    if(ironsourceClass && [ironsourceClass respondsToSelector:@selector(initISDemandOnly:adUnits:)]){
        [ironsourceClass initISDemandOnly:key adUnits:@[IS_REWARDED_VIDEO,IS_INTERSTITIAL]];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.adt.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
