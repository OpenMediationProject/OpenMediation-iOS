// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMTikTokClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const TikTokAdapterVersion = @"2.0.1";

@interface OMTikTokAdapter : NSObject<OMMediationAdapter>
@property (class, nonatomic) BOOL expressAdAPI;
+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
@end

NS_ASSUME_NONNULL_END
