// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMAdColonyClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const AdColonyAdapterVersion = @"1.0.2";

@interface OMAdColonyAdapter : NSObject<OMMediationAdapter>

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
