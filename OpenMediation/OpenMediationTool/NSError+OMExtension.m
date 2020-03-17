// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "NSError+OMExtension.h"

NSString *const OMRequestErrorDomain = @"com.om.request";

@implementation NSError (OMExtension)

+ (NSError *)omNetworkError:(OMRequestError)code {
    NSString *description = @"";
    switch (code) {
        case OMRequestErrorNetworkNotReachable:
            description = @"network not erachable";
            break;
        case OMRequestErrorUseAgent:
            description = @"use agent";
            break;
        case OMRequestErrorInvalidRequest:
            description = @"invalid request";
            break;
        case OMRequestErrorInvalidResponse:
            description = @"invalid response";
            break;
        case OMRequestErrorNetworkError:
            description = @"response error";
            break;
        case OMRequestErrorEmptyResponseData:
            description = @"empty response data";
            break;
        case OMRequestErrorInvalidResponseData:
            description = @"invalid response data";
            break;
        default:
            break;
    }
    NSError *error = [NSError errorWithDomain:OMRequestErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:description}];
    return error;
}


@end
