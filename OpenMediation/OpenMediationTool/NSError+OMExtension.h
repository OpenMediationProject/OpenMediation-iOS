// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const OMRequestErrorDomain;

typedef NS_ENUM(NSInteger, OMRequestError) {
    OMRequestErrorNetworkNotReachable = 1001,
    OMRequestErrorUseAgent,
    OMRequestErrorInvalidRequest,
    OMRequestErrorInvalidResponse,
    OMRequestErrorNetworkError,
    OMRequestErrorEmptyResponseData,
    OMRequestErrorInvalidResponseData,
};


FOUNDATION_EXPORT NSString *const OMCampaignErrorDomain;


typedef NS_ENUM(NSInteger, OMCampaignError) {
    OMCampaignErrorNoFill = 2001,
};


@interface NSError (OMExtension)

+ (NSError *)omNetworkError:(OMRequestError)code;

@end

NS_ASSUME_NONNULL_END
