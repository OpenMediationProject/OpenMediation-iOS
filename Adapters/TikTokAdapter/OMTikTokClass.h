// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMTikTokClass_h
#define OMTikTokClass_h

NS_ASSUME_NONNULL_BEGIN

@interface BUAdSDKManager : NSObject
@property (nonatomic, copy, readonly, class) NSString *SDKVersion;
+ (void)setAppID:(NSString *)appID;
@end;

NS_ASSUME_NONNULL_END

#endif /* OMTikTokClass_h */
