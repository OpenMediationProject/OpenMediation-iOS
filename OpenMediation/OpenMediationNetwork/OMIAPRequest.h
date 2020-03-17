// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^iapCompletionHandler)(NSDictionary *_Nullable object,  NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface OMIAPRequest : NSObject

+ (void)iapWithPurchase:(CGFloat)purchase total:(CGFloat)total currency:(NSString *)currency completionHandler:(iapCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
