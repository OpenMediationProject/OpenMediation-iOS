// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMUnityClass.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const UnityAdapterVersion = @"2.0.5";

@interface OMUnityAdapter : NSObject<OMMediationAdapter,UnityAdsInitializationDelegate>
@property (nonatomic, copy, nullable) OMMediationAdapterInitCompletionBlock initBlock;

+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (void)setConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;
@end

NS_ASSUME_NONNULL_END
