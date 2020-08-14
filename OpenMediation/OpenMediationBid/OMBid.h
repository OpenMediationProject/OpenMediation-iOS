// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMBidResponse.h"
#import "OMBidCustomEvent.h"
#import "OpenMediationAdFormats.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^bidCompletionHandler)(NSDictionary *bidTokens,NSDictionary *bidResponses);

@interface OMBid : NSObject
@property (nonatomic, strong) NSArray *bidNetworkItems;
@property (nonatomic, copy, nullable)  bidCompletionHandler completionHandler;
@property (nonatomic, strong) NSMutableDictionary *bidTokens;
@property (nonatomic, strong) NSMutableDictionary *bidResponses;
@property (nonatomic, strong) NSTimer *bidTimer;

- (void)bidWithNetworkItems:(NSArray*)networkItems adFormat:(NSString*)format completionHandler:(bidCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
