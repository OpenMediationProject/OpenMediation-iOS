// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMBidCustomEvent.h"


NS_ASSUME_NONNULL_BEGIN

@interface OMFacebookBid : NSObject <OMBidCustomEvent>

+ (NSString*)bidderToken;

@end

NS_ASSUME_NONNULL_END
