// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMPubNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const PubNativeAdapterVersion = @"2.1.1";

@interface OMPubNativeAdapter : NSObject<OMMediationAdapter>

+ (NSString*)adapterVerison;

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;

+(void)setConsent:(BOOL)consent;
+(void)setUSPrivacyLimit:(BOOL)privacyLimit;
+(void)setUserAgeRestricted:(BOOL)restricted;

@end

NS_ASSUME_NONNULL_END
