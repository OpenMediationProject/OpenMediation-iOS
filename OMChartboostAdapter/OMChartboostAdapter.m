// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMChartboostAdapter.h"
#import "OMChartboostRouter.h"

@interface OMChartboostAdapter()

@property (nonatomic, copy) OMMediationAdapterInitCompletionBlock initBlock;

@end

static OMChartboostAdapter * _instance = nil;


@implementation OMChartboostAdapter

+ (NSString*)adapterVerison {
    return ChartboostAdapterVersion;
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    [OMChartboostAdapter sharedInstance].initBlock = completionHandler;
    NSString *key = [configuration objectForKey:@"appKey"];
    Class chartboostClass = NSClassFromString(@"Chartboost");
    NSArray *keys = [key componentsSeparatedByString:@"#"];
    if (chartboostClass && [chartboostClass respondsToSelector:@selector(startWithAppId:appSignature:delegate:)] && keys.count > 1) {
        [chartboostClass startWithAppId:keys[0] appSignature:keys[1] delegate:[OMChartboostRouter sharedInstance]];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.om.mediation"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        [OMChartboostAdapter sharedInstance].initBlock(error);
        [OMChartboostAdapter sharedInstance].initBlock = nil;
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
