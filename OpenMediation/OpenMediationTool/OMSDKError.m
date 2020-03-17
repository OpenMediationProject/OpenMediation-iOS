// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMSDKError.h"
#import "OMLogMoudle.h"
#import "OMMacros.h"

#define ErrorUrl @""

NSString *const OMSDKErrorDomain = @"com.openmediaiton.mediationsdk";

@implementation OMSDKError

+ (NSError*)errorWithAdtError:(NSError*)error {
    
    NSString *errorMsg = @"";
    NSInteger errorCode = error.code;
    if (errorCode>1000) {
        errorCode = errorCode/1000;
    }
    NSInteger developerCode = 0;
    
    switch (errorCode) {
        case OMErrorInitAppKeyEmpty:
            {
                developerCode = OMSDKErrorInitInvalidRequest;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"SDK init: invalid request. ", [ErrorUrl stringByAppendingString:@"111-iOS"]];
            }
            break;
        case OMErrorInitNetworkError:
            {
                developerCode = OMSDKErrorInitNetworkError;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"SDK init: network error. ", [ErrorUrl stringByAppendingString:@"121-iOS"]];
            }
            break;
        case OMErrorInitServerError:
            {
                developerCode = OMSDKErrorInitServerError;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"SDK init: server error. ", [ErrorUrl stringByAppendingString:@"131-iOS"]];
            }
            break;
        case OMErrorInitAppKeyNotFound:
            {
                developerCode = OMSDKErrorInitInvalidRequest;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"SDK init: invalid request. ", [ErrorUrl stringByAppendingString:@"111-iOS"]];
            }
            break;
        case OMErrorLoadInitFailed:
            {
                developerCode = OMSDKErrorLoadNotInitialized;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"Ad loading: SDK not initialized. ", [ErrorUrl stringByAppendingString:@"242-iOS"]];
            }
            break;
        case OMErrorLoadGDPRRefuse:
            {
                developerCode = OMSDKErrorLoadInvalidRequest;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"Ad loading: GDPR refuse. ", [ErrorUrl stringByAppendingString:@"211-iOS"]];
            }
            break;
        case OMErrorLoadPlacementEmpty:
        case OMErrorLoadPlacementNotFound:
        case OMErrorLoadPlacementAdTypeIncorrect:
            {
                developerCode = OMSDKErrorLoadInvalidRequest;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"Ad loading: invalid request. ", [ErrorUrl stringByAppendingString:@"211-iOS"]];
            }
            break;
        case OMErrorLoadFrequencry:
            {
                developerCode = OMSDKErrorLoadCapped;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"Ad loading: reached impression cap. ", [ErrorUrl stringByAppendingString:@"243-iOS"]];
            }
            break;
        case OMErrorLoadNetworkError:
            {
                developerCode = OMSDKErrorLoadNetworkError;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"Ad loading: network error. ", [ErrorUrl stringByAppendingString:@"221-iOS"]];
            }
            break;
        case OMErrorLoadServerError:
            {
                developerCode = OMSDKErrorLoadServerError;
                errorMsg = [NSString stringWithFormat:@"%@%@",@"Ad loading: server error. ", [ErrorUrl stringByAppendingString:@"231-iOS"]];
            }
            break;
        case OMErrorLoadEmptyInstance:
        case OMErrorLoadWaterfallFail:
            {
                developerCode = OMSDKErrorNoAdFill;
                errorMsg =  [NSString stringWithFormat:@"%@%@",@"No ad fill. ", [ErrorUrl stringByAppendingString:@"241-iOS"]];
            }
            break;
        case OMErrorShowPlacementEmpty:
        case OMErrorShowPlacementNotFound:
        case OMErrorShowPlacementAdFormatIncorrect:
            {
                developerCode = OMSDKErrorShowInvalidRequest;
                errorMsg =  [NSString stringWithFormat:@"%@%@",@"Ad showing: invalid request. ", [ErrorUrl stringByAppendingString:@"311-iOS"]];
            }
            break;
        case OMErrorShowNotInitialized:
            {
                developerCode = OMSDKErrorShowNotInitialized;
                errorMsg =  [NSString stringWithFormat:@"%@%@",@"Ad showing: SDK not initialized. ", [ErrorUrl stringByAppendingString:@"342-iOS"]];
            }
            break;
        case OMErrorShowFailNotReady:
            {
                developerCode = OMSDKErrorNoAdReady;
                errorMsg =  [NSString stringWithFormat:@"%@%@",@"Ad showing: ad isn't ready. ", [ErrorUrl stringByAppendingString:@"341-iOS"]];
            }
            break;
        case OMErrorShowFailSceneCapped:
            {
                developerCode = OMSDKErrorShowSceneCapped;
                errorMsg =  [NSString stringWithFormat:@"%@%@",@"Ad showing: reached scene impression cap. ", [ErrorUrl stringByAppendingString:@"343-iOS"]];
            }
            break;
        case OMErrorShowAdError:
            {
                developerCode = OMSDKErrorShowError;
                errorMsg =  [NSString stringWithFormat:@"%@%@",@"Ad showing failure. ", [ErrorUrl stringByAppendingString:@"345-iOS"]];
            }
            break;
        default:
            break;
    }
    
    return [[NSError alloc]initWithDomain:OMSDKErrorDomain code:developerCode userInfo: @{NSLocalizedDescriptionKey:errorMsg,NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"%zd",error.code]}];
    
}

+ (void)throwDeveloperError:(NSError*)error {
    if (error) {
        OMLogE(@"%@,code:%ld,reason:%@",OM_SAFE_STRING(error.localizedDescription),(long)error.code,OM_SAFE_STRING(error.localizedFailureReason));
    }
}

@end
