// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMError.h"
#import "OMLogMoudle.h"
#import "OMMacros.h"
NSString *const OMErrorDomain = @"com.openmediation.ads";


@implementation OMError



+ (NSError*)omRequestError:(OMErrorModule)module error:(NSError*)requestError {
    NSInteger errorCode = 0;
    NSString *errorMsg = OM_SAFE_STRING(requestError.description);
    switch (module) {
        case OMErrorModuleInit:
            {
                errorCode = OMErrorInitServerError*1000+requestError.code;
                if (requestError.code == OMRequestErrorNetworkNotReachable) {
                    errorCode = OMErrorInitNetworkError;
                }
                else if (requestError.code == 403) {
                    errorCode = OMErrorInitAppKeyNotFound;
                }
            }
            break;
        case OMErrorModuleLoad:
            {
                errorCode = OMErrorLoadServerError*1000+requestError.code;
                if (requestError.code == OMRequestErrorNetworkNotReachable) {
                    errorCode = OMErrorLoadNetworkError;
                }
            }
            break;
        default:
            break;
    }
     return [[NSError alloc]initWithDomain:OMErrorDomain code:errorCode userInfo: @{NSLocalizedDescriptionKey:errorMsg}];
}


+ (NSError*)omErrorWithCode:(OMErrorCode)code {
    
    NSString *errorMsg = @"";
    switch (code) {
        case OMErrorInitAppKeyEmpty:
            errorMsg = @"Appkey empty";
            break;
        case OMErrorInitNetworkError:
            errorMsg = @"Init network error";
            break;
        case OMErrorInitServerError:
            errorMsg = @"Init server error";
            break;
        case OMErrorInitAppKeyNotFound:
            errorMsg = @"Appkey not found on server";
            break;
        case OMErrorLoadInitFailed:
            errorMsg = @"Load sdk init failed";
            break;
        case OMErrorLoadGDPRRefuse:
            errorMsg = @"Load gdpr refuse";
            break;
        case OMErrorLoadPlacementEmpty:
            errorMsg = @"Load placement empty";
            break;
        case OMErrorLoadPlacementNotFound:
            errorMsg = @"Load Placement not found in app config";
            break;
        case OMErrorLoadPlacementAdTypeIncorrect:
            errorMsg = @"Load placement ad format wrong";
            break;
        case OMErrorLoadFrequencry:
            errorMsg = @"Load frequencry";
            break;
        case OMErrorLoadNetworkError:
            errorMsg = @"Load network error";
            break;
        case OMErrorLoadServerError:
            errorMsg = @"Load server error";
            break;
        case OMErrorLoadEmptyInstance:
            errorMsg = @"Load instance empty";
            break;
        case OMErrorLoadWaterfallFail:
            errorMsg = @"Load waterfall failed";
            break;
        case OMErrorLoadInstanceNotFound:
            errorMsg = @"Load instance not found";
            break;
        case OMErrorLoadInstanceLoadFrequencry:
            errorMsg = @"Load instance frequencry";
            break;
        case OMErrorLoadInstanceSDKNotFound:
            errorMsg = @"Load instance sdk not found";
            break;
        case OMErrorLoadInstanceInitKeyEmpty:
            errorMsg = @"Load instance mediation key empty";
            break;
        case OMErrorLoadInstanceInitFailed:
            errorMsg = @"Load instance init failed";
            break;
        case OMErrorLoadInstanceLoadFail:
            errorMsg = @"Load instance failed";
            break;
        case OMErrorShowPlacementEmpty:
            errorMsg = @"Show placement empty";
            break;
        case OMErrorShowPlacementNotFound:
            errorMsg = @"Show placement placement not found in app config";
            break;
        case OMErrorShowPlacementAdFormatIncorrect:
            errorMsg = @"Show placement ad format wrong";
            break;
        case OMErrorShowNotInitialized:
            errorMsg = @"show not initlized";
            break;
        case OMErrorShowFailNotReady:
            errorMsg = @"Show failed ad not ready";
            break;
        case OMErrorShowFailSceneCapped:
            errorMsg = @"Show failed capped";
            break;
        case OMErrorShowAdError:
            errorMsg = @"Show ad error";
            break;
        default:
            break;
    }
    return [[NSError alloc]initWithDomain:OMErrorDomain code:code userInfo: @{NSLocalizedDescriptionKey:errorMsg}];
}

@end
