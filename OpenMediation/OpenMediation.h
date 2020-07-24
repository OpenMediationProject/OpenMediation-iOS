// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OpenMediationAdFormats.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMGender) {
    OMGenderUnknown,
    OMGenderMale,
    OMGenderFemale,
};

typedef void(^initCompletionHandler)(NSError *_Nullable error);

///OpenMeidation init success notification
extern NSString *kOpenMediatonInitSuccessNotification;

@interface OpenMediation : NSObject

/// Initializes OpenMediation's SDK with all the ad types that are defined in the platform.
+ (void)initWithAppKey:(NSString*)appKey;

/// Initializes OpenMediation's SDK with the requested ad types.
+ (void)initWithAppKey:(NSString *)appKey adFormat:(OpenMediationAdFormat)initAdFormats;

/// Check that `OpenMediation` has been initialized
+ (BOOL)isInitialized;

/// user in-app purchase
+ (void)userPurchase:(CGFloat)amount currency:(NSString*)currencyUnit;

/// Set this property to configure the user's age.
+ (void)setUserAge:(NSInteger)userAge;

/// Set the gender of the current user
+ (void)setUserGender:(OMGender)userGender;

/// setUserConsent "NO" is Refuse，"YES" is Accepted. //GDPR
/// According to the GDPR, set method of this property must be called before "initWithAppKey:", or by default will collect user's information.
+ (void)setGDPRConsent:(BOOL)consent;

///According to the CCPA, set method of this property must be called before "initWithAppKey:", or by default will collect user's information.
+ (void)setUSPrivacyLimit:(BOOL)privacyLimit;

/// current SDK version
+ (NSString *)SDKVersion;

/// A tool to verify a successful integration of the OpenMediation SDK and any additional adapters.
+ (void)validateIntegration;

/// log enable,default is YES
+ (void)setLogEnable:(BOOL)logEnable;

@end

NS_ASSUME_NONNULL_END
