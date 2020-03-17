// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMEventRequest : NSObject
+ (void)postEvents:(NSArray*)events url:(NSString*)uploadUrl completionHandler:(postCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
