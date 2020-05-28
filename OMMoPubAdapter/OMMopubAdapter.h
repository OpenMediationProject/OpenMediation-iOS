// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

#import "OMMediationAdapter.h"
#import "OMMopubClass.h"

static NSString * const MopubAdapterVersion = @"1.2.0";

@interface OMMopubAdapter : NSObject<OMMediationAdapter>

+ (NSString*)adapterVerison;

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;

@end

