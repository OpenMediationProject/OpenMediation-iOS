// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OpenMediationAdFormats.h"


NS_ASSUME_NONNULL_BEGIN

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

/// current SDK version
+ (NSString *)SDKVersion;

/// setUserConsent @"0" is Refuse，@"1" is Accepted. Default is @"1"//GDPR
+ (void)setUserConsent:(NSString *)consent;

/// log enable,default is YES
+ (void)setLogEnable:(BOOL)logEnable;

/// user in-app purchase
+ (void)userPurchase:(CGFloat)amount currency:(NSString*)currencyUnit;

/// A tool to verify a successful integration of the OpenMediation SDK and any additional adapters.
+ (void)validateIntegration;

@end

NS_ASSUME_NONNULL_END
