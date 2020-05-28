// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMBidCustomEvent_h
#define OMBidCustomEvent_h
#import "OMBidNetworkItem.h"
#import "OpenMediationAdFormats.h"


@interface OMCustomEventBid : NSObject
+ (void)bidWithNetworkItem:(OMBidNetworkItem*)networkItem adFormat:(OpenMediationAdFormat)format responseCallback:(void(^)(OMBidResponse *bidResponse))callback;
+ (NSString*)bidderToken;
@end

#endif /* OMBidCustomEvent_h */
