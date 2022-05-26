// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleClass_h
#define OMPangleClass_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///CN china, NO_CN is not china
typedef NS_ENUM(NSUInteger, BUAdSDKTerritory) {
    BUAdSDKTerritory_CN = 1,
    BUAdSDKTerritory_NO_CN,
};


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

typedef NS_ENUM(NSInteger, BUAdSDKLogLevel) {
    BUAdSDKLogLevelNone,
    BUAdSDKLogLevelError,
    BUAdSDKLogLevelWarning,
    BUAdSDKLogLevelInfo,
    BUAdSDKLogLevelDebug,
    BUAdSDKLogLevelVerbose,
};


typedef NS_ENUM(NSInteger, BUProposalSize) {
    BUProposalSize_Banner600_90,
    BUProposalSize_Banner600_100,
    BUProposalSize_Banner600_150,
    BUProposalSize_Banner600_260,
    BUProposalSize_Banner600_286,
    BUProposalSize_Banner600_300,
    BUProposalSize_Banner600_388,
    BUProposalSize_Banner600_400,
    BUProposalSize_Banner600_500,
    BUProposalSize_Feed228_150,
    BUProposalSize_Feed690_388,
    BUProposalSize_Interstitial600_400,
    BUProposalSize_Interstitial600_600,
    BUProposalSize_Interstitial600_900,
    BUProposalSize_DrawFullScreen
};


typedef NS_ENUM(NSInteger, BUAdSlotAdType) {
    BUAdSlotAdTypeUnknown       = 0,
    BUAdSlotAdTypeBanner        = 1,       // banner ads
    BUAdSlotAdTypeInterstitial  = 2,       // interstitial ads
    BUAdSlotAdTypeSplash        = 3,       // splash ads
    BUAdSlotAdTypeSplash_Cache  = 4,       // cache splash ads
    BUAdSlotAdTypeFeed          = 5,       // feed ads
    BUAdSlotAdTypePaster        = 6,       // paster ads
    BUAdSlotAdTypeRewardVideo   = 7,       // rewarded video ads
    BUAdSlotAdTypeFullscreenVideo = 8,     // full-screen video ads
    BUAdSlotAdTypeDrawVideo     = 9,       // vertical (immersive) video ads
};

typedef NS_ENUM(NSInteger, BUAdSlotPosition) {
    BUAdSlotPositionTop = 1,
    BUAdSlotPositionBottom = 2,
    BUAdSlotPositionFeed = 3,
    BUAdSlotPositionMiddle = 4, // for interstitial ad only
    BUAdSlotPositionFullscreen = 5,
};

typedef NS_ENUM(NSInteger, BUPlayerPlayState) {
    BUPlayerStateFailed    = 0,
    BUPlayerStateBuffering = 1,
    BUPlayerStatePlaying   = 2,
    BUPlayerStateStopped   = 3,
    BUPlayerStatePause     = 4,
    BUPlayerStateDefalt    = 5
};

@protocol BUMopubAdMarkUpDelegate <NSObject>
@optional

/** Mopub AdMarkUp
  */
- (void)setMopubAdMarkUp:(NSString *)adm;

/// Bidding Token. Now for MSDK in domestic, used for every ad type.
- (NSString *)biddingToken;

/** Mopub Adaptor get AD type from rit
  *   @return  @{@"adSlotType": @(1), @"renderType": @(1)}
  *   adSlotType refer from BUAdSlotAdType in "BUAdSlot.h"
  *   showType: @"1" express AD   @"2" native AD
  */
+ (nullable NSDictionary *)AdTypeWithRit:(NSString *)rit error:(NSError **)error;

/** Mopub bidding Adaptor get AD type from adm
  *  @return  @{@"adSlotType": @(1), @"renderType": @(1)}
  *  adSlotType refer from BUAdSlotAdType in "BUAdSlot.h"
  *  showType: @"1" express AD   @"2" native AD
  */
+ (NSDictionary *)AdTypeWithAdMarkUp:(NSString *)adm;


/// Mopub Bidding Token
+ (NSString *)mopubBiddingToken;

@end

typedef NS_ENUM(NSInteger, BUAdSDKInitializationState) {
    BUAdSDKInitializationStateNotReady = 0,
    BUAdSDKInitializationStateReady = 1
};

@interface BUInterfaceBaseObject : NSObject

@end

typedef void (^BUConfirmGDPR)(BOOL isAgreed);

typedef void (^BUCompletionHandler)(BOOL success,NSError *error);

 __attribute__((objc_subclassing_restricted))

@interface BUAdSDKManager : BUInterfaceBaseObject

@property (nonatomic, copy, readonly, class) NSString *SDKVersion;

/// The SDK initialization state
@property (nonatomic, assign, readonly, class) BUAdSDKInitializationState initializationState;

/// The synchronize initialization method
/// @param completionHandler Callback to the initialization state of the calling thread
+ (void)startWithSyncCompletionHandler:(BUCompletionHandler)completionHandler;

/// The asynchronize initialization method
/// @param completionHandler Callback to the initialization state of the non-main thread
+ (void)startWithAsyncCompletionHandler:(BUCompletionHandler)completionHandler;

/// Open GDPR Privacy for the user to choose before setAppID.
+ (void)openGDPRPrivacyFromRootViewController:(UIViewController *)rootViewController confirm:(BUConfirmGDPR)confirm;

@end

@interface BUAdSDKConfiguration : NSObject

+ (instancetype)configuration;

/// This property should be set when integrating non-China and china areas at the same time,
/// otherwise it need'nt to be set.you‘d better set Territory first,  if you need to set them
@property (nonatomic, assign) BUAdSDKTerritory territory;

///Register the App key that’s already been applied before requesting an ad from TikTok Audience Network.
/// the unique identifier of the App
@property (nonatomic, copy) NSString *appID;

/// the unique identifier of the App, more safely
@property (nonatomic, copy) NSString *secretKey;

/// Configure development mode. default BUAdSDKLogLevelNone
@property (nonatomic, assign) BUAdSDKLogLevel logLevel;

/// the age group of the user
/// only works in CN environment
//@property (nonatomic, assign) BUAdSDKAgeGroup ageGroup;

/// the COPPA of the user, COPPA is the short of Children's Online Privacy Protection Rule,
/// the interface only works in the United States.
/// Coppa 0 adult, 1 child
/// You can change its value at any time
@property (nonatomic, strong) NSNumber *coppa;

/// additional user information.
@property (nonatomic, copy) NSString *userExtData;

/// Solve the problem when your WKWebview post message empty,
/// default is BUOfflineTypeWebview
//@property (nonatomic, assign) BUOfflineType webViewOfflineType;

/// Custom set the GDPR of the user,GDPR is the short of General Data Protection Regulation,the interface only works in The European.
/// GDPR 0 close privacy protection, 1 open privacy protection
/// You can change its value at any time
@property (nonatomic, strong) NSNumber *GDPR;

/// Custom set the CCPA of the user,CCPA is the short of General Data Protection Regulation,the interface only works in USA.
/// CCPA  0: "sale" of personal information is permitted, 1: user has opted out of "sale" of personal information -1: default
@property (nonatomic, strong) NSNumber *CCPA;
@end

@interface BUAdSDKManager (InterfaceReadyReplacement)
+ (void)setAppID:(NSString *)appID;
+ (void)setGDPR:(NSInteger)GDPR;
+ (void)setTerritory:(BUAdSDKTerritory)territory;
+ (void)setLoglevel:(BUAdSDKLogLevel)level;
+ (void)setCoppa:(NSInteger)coppa;
+ (void)setCCPA:(NSInteger)CCPA;
@end;

@interface BUSize : NSObject

// width unit pixel.
@property (nonatomic, assign) NSInteger width;

// height unit pixel.
@property (nonatomic, assign) NSInteger height;

- (NSDictionary *)dictionaryValue;

@end

@interface BUSize (BU_SizeFactory)
+ (instancetype)sizeBy:(BUProposalSize)proposalSize;
@end

@interface BUAdSlot : NSObject

/// required. The unique identifier of a native ad.
@property (nonatomic, copy) NSString *ID;

/// required. Ad type.
@property (nonatomic, assign) BUAdSlotAdType AdType;

/// required. Ad display location.
@property (nonatomic, assign) BUAdSlotPosition position;

/// Accept a set of image sizes, please pass in the BUSize object.
@property (nonatomic, strong) NSMutableArray<BUSize *> *imgSizeArray;

/// required. Image size.
@property (nonatomic, strong) BUSize *imgSize;

/// Icon size.
@property (nonatomic, strong) BUSize *iconSize;

/// Maximum length of the title.
@property (nonatomic, assign) NSInteger titleLengthLimit;

/// Maximum length of description.
@property (nonatomic, assign) NSInteger descLengthLimit;

/// Whether to support deeplink.
@property (nonatomic, assign) BOOL isSupportDeepLink;

/// Native banner ads and native interstitial ads are set to 1, other ad types are 0, the default is 0.
@property (nonatomic, assign) BOOL isOriginAd;

- (NSDictionary *)dictionaryValue;

@end

NS_ASSUME_NONNULL_END

#endif /* OMPangleClass_h */
