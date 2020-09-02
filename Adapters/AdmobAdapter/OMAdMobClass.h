// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobClass_h
#define OMAdMobClass_h

NS_ASSUME_NONNULL_BEGIN

@protocol GADAdNetworkExtras <NSObject>
@end

@interface GADExtras : NSObject <GADAdNetworkExtras>

/// Additional parameters to be sent to Google networks.
@property(nonatomic, copy, nullable) NSDictionary *additionalParameters;

@end

@interface GADRequest : NSObject<NSCopying>

+ (nonnull NSString *)sdkVersion;
+ (instancetype)request;
+ (Class)shimmedClass;
- (void)registerAdNetworkExtras:(nonnull id<GADAdNetworkExtras>)extras;

@end

@interface GADRequestError : NSError

@end

@class GADInitializationStatus;

typedef void (^GADInitializationCompletionHandler)(GADInitializationStatus *_Nonnull status);

@interface GADRequestConfiguration : NSObject
- (void)tagForUnderAgeOfConsent:(BOOL)underAgeOfConsent;
@end

@interface GADMobileAds : NSObject
+ (nonnull GADMobileAds *)sharedInstance;
@property(nonatomic, nonnull, readonly) NSString *sdkVersion;
@property(nonatomic, readonly, strong, nonnull) GADRequestConfiguration *requestConfiguration;
+ (void)configureWithApplicationID:(NSString *)applicationID;
- (void)startWithCompletionHandler:(nullable GADInitializationCompletionHandler)completionHandler;
@end



NS_ASSUME_NONNULL_END

#endif /* OMAdMobClass_h */
