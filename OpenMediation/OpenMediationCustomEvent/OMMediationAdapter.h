// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^OMMediationAdapterInitCompletionBlock)(NSError *_Nullable error);

@protocol OMMediationAdapter <NSObject>

+ (NSString*)adapterVerison;

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration
             completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler;


@optional

+ (void)setConsent:(BOOL)consent;

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;

+ (void)setUserAge:(NSInteger)userAge;

+ (void)setUserGender:(NSInteger)userGender;

@end

NS_ASSUME_NONNULL_END
