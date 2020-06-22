// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMAppLovinClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const AppLovinAdapterVersion = @"1.2.1";

@interface OMAppLovinAdapter : NSObject<OMMediationAdapter>
+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (ALSdk*)alShareSdk;
+ (UIWindow *)currentWindow;
@end

NS_ASSUME_NONNULL_END
