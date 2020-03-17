// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMTapjoyAdapter.h"

static OMTapjoyAdapter * _instance = nil;

@implementation OMTapjoyAdapter
+ (NSString*)adapterVerison {
    return TapjoyAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    
    [OMTapjoyAdapter sharedInstance].initBlock = completionHandler;
    NSString *key = [configuration objectForKey:@"appKey"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_LIMITED_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFailed:) name:TJC_CONNECT_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFailed:) name:TJC_LIMITED_CONNECT_FAILED object:nil];
    Class tapjoyClass = NSClassFromString(@"Tapjoy");
    if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(limitedConnect:)] && [key length]>0) {
        [tapjoyClass limitedConnect:key];
    } else if (tapjoyClass && [tapjoyClass respondsToSelector:@selector(connect:)] && [key length]>0) {
        [tapjoyClass connect:key];;
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        completionHandler(error);
    }
}

+(void)tjcConnectSuccess:(NSNotification*)notifyObj{
    if ([OMTapjoyAdapter sharedInstance].initBlock) {
        [OMTapjoyAdapter sharedInstance].initBlock(nil);
        [OMTapjoyAdapter sharedInstance].initBlock = nil;
    }
}

+(void)tjcConnectFailed:(NSNotification*)notifyObj{
    if ([OMTapjoyAdapter sharedInstance].initBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Init failed"}];
        [OMTapjoyAdapter sharedInstance].initBlock(error);
        [OMTapjoyAdapter sharedInstance].initBlock = nil;
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
