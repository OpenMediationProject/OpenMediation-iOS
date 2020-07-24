// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMBiddingCustomEvent_h
#define OMBiddingCustomEvent_h
#import "OMBiddingNetworkItem.h"
#import "OMBiddingResponse.h"
#import "OpenMediationAdFormats.h"

@protocol OMCustomEventBid <NSObject>

@optional

+ (void)bidWithNetworkItem:(OMBiddingNetworkItem*)networkItem adFormat:(OpenMediationAdFormat)format responseCallback:(void(^)(OMBiddingResponse *bidResponse))callback;
+ (NSString*)bidderToken;
@end

#endif /* OMBiddingCustomEvent_h */
