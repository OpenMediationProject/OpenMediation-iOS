// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionClRequest.h"
#import "OMRequest.h"
#import "OMToolUmbrella.h"
#import "OMUserData.h"
#import "OMLoadFrequencryControl.h"
#import "OMCrossPromotionCampaignManager.h"
#import "OMConfig.h"

@implementation OMCrossPromotionClRequest

+ (void)requestCampaignWithPid:(NSString *)pid size:(CGSize)size reqId:(NSString*)reqId actionType:(NSInteger)actionType payload:(NSString*)payload completionHandler:(clCompletionHandler)completionHandler {
    if (OM_STR_EMPTY(pid)) {
        OMLogD(@"adn cl pid empty");
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self clParametersWithPid:pid size:size reqId:reqId actionType:actionType payload:payload]];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&jsonError];
    if (!jsonError && jsonData) {
        [OMRequest postWithUrl:[self requestUrl:([payload length]>0)] data:jsonData completionHandler:^(NSObject *object, NSError *error) {
            if (!error) {
                completionHandler((NSDictionary*)object,nil);
                
            } else {
                completionHandler([NSDictionary dictionary],error);
            }
        }];
    }
}

+ (NSString*)requestUrl:(BOOL)bidMode {
    return [NSString stringWithFormat:@"%@?v=1&plat=0&sdkv=%@",(bidMode?[OMConfig sharedInstance].plUrl:[OMConfig sharedInstance].clUrl),OPENMEDIATION_SDK_VERSION];
}

+ (NSDictionary*)clParametersWithPid:(NSString*)pid size:(CGSize)size           reqId:(NSString*)reqId actionType:(NSInteger)actionType payload:(NSString*)payload {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[OMRequest commonDeviceInfo]];
    parameters[@"reqId"] = OM_SAFE_STRING(reqId);
    parameters[@"width"] = [NSNumber numberWithInt:size.width];
    parameters[@"height"] = [NSNumber numberWithInt:size.height];
    parameters[@"pid"] = @([pid integerValue]);
    if([payload length]>0) { //bidding payload
        parameters[@"token"] = payload;
    }else{
        parameters[@"iap"] = [NSNumber numberWithFloat:[OMUserData sharedInstance].purchaseAmount];
        parameters[@"imprTimes"] = [NSNumber numberWithInteger:[[OMLoadFrequencryControl sharedInstance]todayimprCountOnPlacment:pid]];
        parameters[@"act"] = [NSNumber numberWithInteger:actionType];
        
    }
    return [parameters copy];
}
@end
