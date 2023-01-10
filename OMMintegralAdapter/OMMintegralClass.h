// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralClass_h
#define OMMintegralClass_h

/**
 Tri-state boolean.
 */
typedef NS_ENUM(NSInteger, MTGBool) {
    /* No */
    MTGBoolNo = -1,
    
    /* Unknown */
    MTGBoolUnknown = 0,
    
    /* Yes */
    MTGBoolYes = 1,
};

@interface MTGSDK : NSObject
/**
Set user GDPR authorization information

Set YES to indicate the user's data will be collected otherwise NO. Default to be YES.
@abstract According to the GDPR, set method of this property must be called before "setAppID: ApiKey:", or by default will collect user's information.
@Attention Do not mix the usage of `setConsentStatus:` and `setUserPrivateInfoType:agree` simultaneously in your app.
 */
@property (nonatomic, assign) BOOL consentStatus;

/// Set the COPPA status of the user. YES means follow the coppa rules, NO means no need to follow the coppa rules, default is Unknown (depend on your app's coppa setting on the dev setting page).
@property (nonatomic, assign) MTGBool coppa;

/**
 If set to YES, the server will not display personalized ads based on the user's personal information
 When receiving the user's request, and will not synchronize the user's information to other third-party partners.
 Default is NO
 */
@property (nonatomic, assign) BOOL doNotTrackStatus;


- (void)setAppID:(nonnull NSString *)appID ApiKey:(nonnull NSString *)appKey;
@end;

#endif /* OMMintegralClass_h */
