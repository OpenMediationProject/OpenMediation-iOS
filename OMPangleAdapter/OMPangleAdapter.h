// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const PangleAdapterVersion = @"2.0.5";

@interface OMPangleAdapter : NSObject<OMMediationAdapter>
@property (class, nonatomic) BOOL internalAPI;

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (void)setConsent:(BOOL)consent;

@end

NS_ASSUME_NONNULL_END
