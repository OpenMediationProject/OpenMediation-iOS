// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMWaterfallRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"
#import "OMAudience.h"
#import "OMLoadFrequencryControl.h"

@implementation OMWaterfallRequest

+ (void)requestDataWithPid:(NSString *)pid
                      size:(CGSize)size
                actionType:(NSInteger)actionType
              bidResponses:(NSArray*)bidResponses
                    tokens:(NSArray*)tokens
             instanceState:(NSArray*)instanceState
         completionHandler:(wfCompletionHandler)completionHandler {
    NSDictionary *parameters = [self wfParametersWithPid:pid size:size actionType:actionType bidResponses:bidResponses tokens:tokens instanceState:instanceState];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (jsonData && !jsonError && [[OMConfig sharedInstance].wfUrl length]>0) {
        [OMRequest postWithUrl:[self waterfallUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    completionHandler((NSDictionary *)object, nil);
                } else {
                    completionHandler(nil,[NSError omNetworkError:OMRequestErrorInvalidResponseData]);
                }
            } else {
                completionHandler([NSDictionary dictionary],error);
            }
        }];
    }
}

+ (NSString*)waterfallUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@",[OMConfig sharedInstance].wfUrl,OPENMEDIATION_SDK_VERSION];
}

+ (NSDictionary*)wfParametersWithPid:(NSString*)pid
                                size:(CGSize)size
                          actionType:(NSInteger)actionType
                        bidResponses:(NSArray*)bidResponses
                              tokens:(NSArray*)tokens
                       instanceState:(NSArray*)instanceState {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    parameters[@"pid"] = @([pid integerValue]);
    parameters[@"width"] = [NSNumber numberWithInt:size.width];
    parameters[@"height"] = [NSNumber numberWithInt:size.height];
    parameters[@"iap"] = [NSNumber numberWithFloat:[OMAudience sharedInstance].purchaseAmount];
    parameters[@"imprTimes"] = [NSNumber numberWithInteger:[[OMLoadFrequencryControl sharedInstance]todayimprCountOnPlacment:pid]];
    parameters[@"act"] = [NSNumber numberWithInteger:actionType];
    if (bidResponses.count>0) {
        parameters[@"bid"] = bidResponses;
    }
    if (tokens.count>0) {
        parameters[@"bids2s"] = tokens;
    }
    if (instanceState.count>0) {
        parameters[@"ils"] = instanceState;
    }
    
    return [parameters copy];
}

@end
