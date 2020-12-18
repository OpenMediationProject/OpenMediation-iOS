// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMBidCustomEvent_h
#define OMBidCustomEvent_h

@class OMBidNetworkItem;
@protocol OMBidCustomEvent <NSObject>

@optional

+ (void)bidWithNetworkItem:(OMBidNetworkItem*)networkItem adFormat:(NSString*)format responseCallback:(void(^)(NSDictionary *bidResponseData))callback;
+ (NSString*)bidderToken;
@end

#endif /* OMBidCustomEvent_h */
