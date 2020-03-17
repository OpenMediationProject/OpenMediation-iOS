// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^OMMediationAdapterInitCompletionBlock)(NSError *_Nullable error);

@protocol OMMediationAdapter <NSObject>

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration
             completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
