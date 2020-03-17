// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (OMEncrypt)

- (NSString *)omMd5;
- (NSString*)omSha1;
- (NSString *)omURLEncode;
- (NSString *)omURLDecode;
@end

NS_ASSUME_NONNULL_END
