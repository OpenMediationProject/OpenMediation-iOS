// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#define KEY_UUID  @"com.om.uuid"
#define KEY_FIRSTLAUNCHTIME  @"com.om.firstlaunchtime"
#define KEY_USERKEYCHAIN  @"com.om.user"

NS_ASSUME_NONNULL_BEGIN

@interface OMKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
