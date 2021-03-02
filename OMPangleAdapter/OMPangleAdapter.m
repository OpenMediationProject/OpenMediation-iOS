// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMPangleAdapter.h"

static BOOL _expressAdAPI = NO;

@implementation OMPangleAdapter

+ (NSString*)adapterVerison {
    return PangleAdapterVersion;
}

+ (BOOL)expressAdAPI {
    return _expressAdAPI;
}

+ (void)setExpressAdAPI:(BOOL)expressAdAPI {
    _expressAdAPI = expressAdAPI;
}

+ (void)setConsent:(BOOL)consent {
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (buadClass && [buadClass respondsToSelector:@selector(setGDPR:)]) {
        [buadClass setGDPR:(consent?1:0)];
    }
}


+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {

    NSString *key = [configuration objectForKey:@"appKey"];
    Class buadClass = NSClassFromString(@"BUAdSDKManager");
    if (!buadClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Pangle SDK not found"}];
        completionHandler(error);
        return;
    }
    
    if(buadClass && [buadClass respondsToSelector:@selector(setAppID:)]) {
        [buadClass setAppID:key];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.pangleadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

@end
