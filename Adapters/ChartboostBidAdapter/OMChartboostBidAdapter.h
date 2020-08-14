//
//  OMChartboostBidAdapter.h
//  AdTimingHeliumAdapter
//
//  Created by ylm on 2020/6/17.
//  Copyright © 2020 AdTiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMChartboostBidClass.h"
NS_ASSUME_NONNULL_BEGIN

static NSString * const HeliumAdapterVersion = @"3.1.0";


@interface OMChartboostBidAdapter : NSObject<OMMediationAdapter,HeliumSdkDelegate>

@property (nonatomic, copy, nullable) OMMediationAdapterInitCompletionBlock initBlock;

+ (NSString*)adapterVerison;

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;

@end


NS_ASSUME_NONNULL_END
