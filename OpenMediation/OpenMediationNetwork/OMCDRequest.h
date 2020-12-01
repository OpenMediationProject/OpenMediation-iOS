// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cdCompletionHandler)(NSDictionary *_Nullable object,  NSError *_Nullable error);

@interface OMCDRequest : NSObject

+ (void)postWithType:(NSInteger)type data:(NSDictionary*)data completionHandler:(cdCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
