// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdMobAdapter : NSObject<OMMediationAdapter>

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (void)setConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;
+ (BOOL)npaAd;
@end

NS_ASSUME_NONNULL_END
