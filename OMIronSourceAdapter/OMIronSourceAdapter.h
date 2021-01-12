// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMMediationAdapter.h"
#import "OMIronSourceClass.h"

NS_ASSUME_NONNULL_BEGIN


@interface OMIronSourceAdapter : NSObject<OMMediationAdapter>
@property (class, nonatomic) BOOL mediationAPI;
+ (NSString*)adapterVerison;
+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;
+ (void)setConsent:(BOOL)consent;
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;
+ (void)setUserAge:(NSInteger)userAge;
+ (void)setUserGender:(NSInteger)userGender;
@end

NS_ASSUME_NONNULL_END
