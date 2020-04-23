// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMFyberClass_h
#define OMFyberClass_h

@interface IASDKCore : NSObject

@property (atomic, strong, nullable, readonly) NSString *appID;
- (void)initWithAppID:(NSString * _Nonnull)appID;



@end

#endif /* OMFyberClass_h */
