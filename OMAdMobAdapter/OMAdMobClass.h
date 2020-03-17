// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdMobClass_h
#define OMAdMobClass_h

NS_ASSUME_NONNULL_BEGIN

@interface GADRequest : NSObject

+ (instancetype)request;
+ (Class)shimmedClass;

@end

@interface GADRequestError : NSError

@end

@class GADInitializationStatus;

typedef void (^GADInitializationCompletionHandler)(GADInitializationStatus *_Nonnull status);

@interface GADMobileAds : NSObject

+ (nonnull GADMobileAds *)sharedInstance;
+ (void)configureWithApplicationID:(NSString *)applicationID;
- (void)startWithCompletionHandler:(nullable GADInitializationCompletionHandler)completionHandler;

@end
NS_ASSUME_NONNULL_END

#endif /* OMAdMobClass_h */
