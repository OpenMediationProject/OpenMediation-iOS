// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAppLovinClass_h
#define OMAppLovinClass_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ALAd;
@class ALAdService;

@interface ALSdk : NSObject
@property (class, nonatomic, assign, readonly) NSUInteger versionCode;
@property (strong, nonatomic, readonly) ALAdService *adService;
+ (ALSdk *)shared;
+ (ALSdk *)sharedWithKey:(NSString *)sdkKey;
@end

NS_ASSUME_NONNULL_END

#endif /* OMAppLovinClass_h */
