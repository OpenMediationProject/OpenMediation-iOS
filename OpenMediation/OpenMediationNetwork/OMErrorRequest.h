// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMErrorRequest : NSObject

+ (void)postWithErrorMsg:(NSDictionary *)errorInfo completionHandler:(postCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
