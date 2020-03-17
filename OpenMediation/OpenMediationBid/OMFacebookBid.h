// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import "OpenMediationAdFormats.h"
#import "OMBidResponse.h"
#import "OMBidNetworkItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMFacebookBid : NSObject
+ (void)bidWithNetworkItem:(OMBidNetworkItem*)networkItem adFormat:(OpenMediationAdFormat)format responseCallback:(void(^)(OMBidResponse *bidResponse))callback;

@end

NS_ASSUME_NONNULL_END
