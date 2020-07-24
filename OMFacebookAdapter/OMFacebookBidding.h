// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import "OpenMediationAdFormats.h"
#import "OMBiddingResponse.h"
#import "OMBiddingNetworkItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMFacebookBidding : NSObject
+ (void)bidWithNetworkItem:(OMBiddingNetworkItem*)networkItem adFormat:(OpenMediationAdFormat)format responseCallback:(void(^)(OMBiddingResponse *bidResponse))callback;
+ (NSString*)bidderToken;
@end

NS_ASSUME_NONNULL_END
