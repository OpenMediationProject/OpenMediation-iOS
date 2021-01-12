// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMTikTokClass_h
#define OMTikTokClass_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BUInteractionType) {
    BUInteractionTypeCustorm = 0,
    BUInteractionTypeNO_INTERACTION = 1,  // pure ad display
    BUInteractionTypeURL = 2,             // open the webpage using a browser
    BUInteractionTypePage = 3,            // open the webpage within the app
    BUInteractionTypeDownload = 4,        // download the app
    BUInteractionTypePhone = 5,           // make a call
    BUInteractionTypeMessage = 6,         // send messages
    BUInteractionTypeEmail = 7,           // send email
    BUInteractionTypeVideoAdDetail = 8    // video ad details page
};

typedef NS_ENUM(NSInteger, BUFeedADMode) {
    BUFeedADModeSmallImage = 2,
    BUFeedADModeLargeImage = 3,
    BUFeedADModeGroupImage = 4,
    BUFeedVideoAdModeImage = 5, // video ad || rewarded video ad horizontal screen
    BUFeedVideoAdModePortrait = 15, // rewarded video ad vertical screen
    BUFeedADModeImagePortrait = 16
};

@interface BUAdSDKManager : NSObject
@property (nonatomic, copy, readonly, class) NSString *SDKVersion;
+ (void)setAppID:(NSString *)appID;
@end;

NS_ASSUME_NONNULL_END

#endif /* OMTikTokClass_h */
