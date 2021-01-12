// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const MintegralAdapterVersion = @"2.0.2";

@interface OMMintegralAdapter : NSObject<OMMediationAdapter>

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (void)setConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;

@end

NS_ASSUME_NONNULL_END
