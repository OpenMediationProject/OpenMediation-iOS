// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMRequest.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^hbCompletionHandler)(NSDictionary *_Nullable ins,  NSError *_Nullable error);


@interface OMHbRequest : NSObject

+ (void)requestDataWithPid:(NSString *)pid
       actionType:(NSInteger)actionType
completionHandler:(hbCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
