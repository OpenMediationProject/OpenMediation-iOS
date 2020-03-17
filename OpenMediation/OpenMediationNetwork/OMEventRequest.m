// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMEventRequest.h"
#import "OMConfig.h"

@implementation OMEventRequest
+ (void)postEvents:(NSArray*)events url:(NSString*)uploadUrl completionHandler:(postCompletionHandler)completionHandler {

    NSDictionary *parameters = [self parametersWithEvents:events];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (!jsonError && jsonData) {        
        [OMRequest postWithUrl:[NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@&k=%@",uploadUrl,OPENMEDIATION_SDK_VERSION,[OMConfig sharedInstance].appKey] data:jsonData  completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                completionHandler(object,nil);
                
            } else {
                completionHandler(nil,error);
            }
        }];
    }
}


+ (NSDictionary*)parametersWithEvents:(NSArray*)events {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];

    [parameters setObject:events forKey:@"events"];
    return [parameters copy];
}
@end
