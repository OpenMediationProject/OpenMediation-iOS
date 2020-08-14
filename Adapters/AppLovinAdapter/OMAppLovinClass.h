// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAppLovinClass_h
#define OMAppLovinClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAd;
@class ALAdService;


@interface ALPrivacySettings : NSObject

/**
* Set whether or not user has provided consent for information sharing with AppLovin.
*
* @param hasUserConsent 'YES' if the user has provided consent for information sharing with AppLovin. 'false' by default.
*/
+ (void)setHasUserConsent:(BOOL)hasUserConsent;

/**
 * Set whether or not user has opted out of the sale of their personal information.
 *
 * @param doNotSell 'YES' if the user has opted out of the sale of their personal information.
 */
+ (void)setDoNotSell:(BOOL)doNotSell;

@end


@interface ALSdk : NSObject
@property (class, nonatomic, assign, readonly) NSUInteger versionCode;
@property (strong, nonatomic, readonly) ALAdService *adService;
+ (ALSdk *)shared;
+ (ALSdk *)sharedWithKey:(NSString *)sdkKey;
@end

NS_ASSUME_NONNULL_END

#endif /* OMAppLovinClass_h */
