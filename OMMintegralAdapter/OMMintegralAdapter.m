// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMMintegralAdapter.h"
#import "OMMintegralClass.h"

static OMMintegralAdapter *_instance = nil;

@implementation OMMintegralAdapter
+ (NSString*)adapterVerison {
    return MintegralAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSString *key = [configuration objectForKey:@"appKey"];
    Class MTGSDKClass = NSClassFromString(@"MTGSDK");
    NSArray *keys = [key componentsSeparatedByString:@"#"];
    if ([MTGSDKClass sharedInstance] && [[MTGSDKClass sharedInstance] respondsToSelector:@selector(setAppID:ApiKey:)] && keys.count > 1) {
        [[MTGSDKClass sharedInstance] setAppID:keys[0] ApiKey:keys[1]];
        completionHandler(nil);
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
            code:400
        userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
    
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
