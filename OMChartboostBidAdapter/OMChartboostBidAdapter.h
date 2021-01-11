// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMChartboostBidClass.h"
NS_ASSUME_NONNULL_BEGIN

static NSString * const HeliumAdapterVersion = @"2.0.2";


@interface OMChartboostBidAdapter : NSObject<OMMediationAdapter,HeliumSdkDelegate>

@property (nonatomic, copy, nullable) OMMediationAdapterInitCompletionBlock initBlock;

+ (NSString*)adapterVerison;

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;

@end


NS_ASSUME_NONNULL_END
