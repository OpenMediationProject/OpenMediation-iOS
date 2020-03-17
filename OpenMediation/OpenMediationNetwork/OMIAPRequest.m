// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMIAPRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"

@implementation OMIAPRequest

+ (void)iapWithPurchase:(CGFloat)purchase
                  total:(CGFloat)total
               currency:(NSString *)currency
      completionHandler:(iapCompletionHandler)completionHandler {
    NSDictionary *parameters = [self iapParametersWithPurchase:purchase total:total currency:currency];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (jsonData && !jsonError && [[OMConfig sharedInstance].iapUrl length]>0) {
        [OMRequest postWithUrl:[self iapUrl] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                completionHandler((NSDictionary*)object,nil);
            } else {
                completionHandler([NSDictionary dictionary],error);
            }
        }];
    }
}

+ (NSString *)iapUrl {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@&k=%@",[OMConfig sharedInstance].iapUrl,OPENMEDIATION_SDK_VERSION,[OMConfig sharedInstance].appKey];
}

+ (NSDictionary *)iapParametersWithPurchase:(CGFloat)purchase
                                      total:(CGFloat)total
                                   currency:(NSString *)currency {
    NSMutableDictionary *iapParameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    iapParameters[@"cur"] = currency;
    iapParameters[@"iap"] = [NSNumber numberWithInteger:purchase];
    iapParameters[@"iapt"] = [NSNumber numberWithInteger:total];
    return [iapParameters copy];
    return nil;
}

@end
