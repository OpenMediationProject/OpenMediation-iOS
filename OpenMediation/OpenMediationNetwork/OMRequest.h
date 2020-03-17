// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^postCompletionHandler)(NSObject *_Nullable object,  NSError *_Nullable error);

@interface OMRequest : NSObject
+ (NSDictionary*)iosInfo;
+ (NSDictionary*)commonDeviceInfo;
+ (void)postWithUrl:(NSString*)url data:(NSData*)data completionHandler:(requestCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
