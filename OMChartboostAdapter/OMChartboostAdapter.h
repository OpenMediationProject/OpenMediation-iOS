// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMChartboostClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const ChartboostAdapterVersion = @"3.1.0";

@interface OMChartboostAdapter : NSObject<OMMediationAdapter>

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (void)setConsent:(BOOL)consent;
@end

NS_ASSUME_NONNULL_END
