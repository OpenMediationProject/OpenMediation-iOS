// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const PangleAdapterVersion = @"2.0.9";

@interface OMPangleAdapter : NSObject<OMMediationAdapter>
@property (class, nonatomic) BOOL internalAPI;

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (void)setConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;
+ (void)setUserAgeRestricted:(BOOL)restricted;
@end

NS_ASSUME_NONNULL_END
