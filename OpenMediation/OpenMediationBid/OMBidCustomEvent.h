// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMBidCustomEvent_h
#define OMBidCustomEvent_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OMBidNetworkItem;
@protocol OMBidCustomEvent <NSObject>

@optional

+ (void)bidWithNetworkItem:(OMBidNetworkItem*)networkItem adFormat:(NSString*)format adSize:(CGSize)size responseCallback:(void(^)(NSDictionary *bidResponseData))callback;
+ (NSString*)bidderToken;
@end

#endif /* OMBidCustomEvent_h */
