// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMErrorRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"

@implementation OMErrorRequest

+ (void)postWithErrorMsg:(NSDictionary *)errorInfo completionHandler:(postCompletionHandler)completionHandler {
    NSDictionary *parameters = [self errorParametersWithErrorMsg:errorInfo];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (!jsonError && jsonData) {
        [OMRequest postWithUrl:[self errorUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                completionHandler(object,nil);
                
            } else {
                completionHandler(nil,error);
            }
        }];
    }
    
}

+ (NSString*)errorUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@&k=%@",[OMConfig sharedInstance].erUrl,OPENMEDIATION_SDK_VERSION,[OMConfig sharedInstance].appKey];
}

+ (NSDictionary *)errorParametersWithErrorMsg:(NSDictionary *)errorInfo {
    NSMutableDictionary *errorParameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    [errorParameters addEntriesFromDictionary:errorInfo];
    return [errorParameters copy];
}

@end
