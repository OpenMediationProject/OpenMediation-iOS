// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMBidResponse.h"
#import "OMBidCustomEvent.h"
#import "OpenMediationAdFormats.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMBidDelegate<NSObject>

@optional

- (void)omBidRequest:(NSString *)instance;

- (void)omBidComplete:(NSDictionary*)bidResponses;

@end

@interface OMBid : NSObject
@property (nonatomic, strong) NSArray *bidNetworkItems;
@property (nonatomic, strong) NSMutableDictionary *bidResponses;
@property (nonatomic, strong) NSTimer *bidTimer;
@property (nonatomic, assign) BOOL bidding;
@property (nonatomic, weak) id<OMBidDelegate> delegate;

- (void)bidWithNetworkItems:(NSArray*)networkItems adFormat:(NSString*)format adSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
