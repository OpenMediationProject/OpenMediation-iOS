// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCDRequest.h"
#import "OMRequest.h"
#import "OMConfig.h"

@implementation OMCDRequest

//type 0:Install, 1:Retargeting
+ (void)postWithType:(NSInteger)type data:(NSDictionary*)data completionHandler:(cdCompletionHandler)completionHandler {

    NSDictionary *parameters = [self parametersWithType:type data:data];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (jsonData && !jsonError && [[OMConfig sharedInstance].cdUrl length]>0) {
        [OMRequest postWithUrl:[self cdUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (error) {
                OMLogD(@"ic report error");
            }
        }];
    }

}

+ (NSString *)cdUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@&k=%@",[OMConfig sharedInstance].cdUrl,OPENMEDIATION_SDK_VERSION,[OMConfig sharedInstance].appKey];
}

+ (NSDictionary*)parametersWithType:(NSInteger)type data:(NSDictionary*)data {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    parameters[@"type"] = @(type);
    if ([data isKindOfClass:[NSDictionary class]]) {
        parameters[@"cd"] = data;
    }

    return [parameters copy];
}

@end
