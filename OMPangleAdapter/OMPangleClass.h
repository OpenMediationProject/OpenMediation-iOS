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

// 国内

@interface BUInterfaceBaseView : UIView

@end

@protocol BUAdClientBiddingProtocol <NSObject>

@optional

/// invoke this method to set this actual auction price 调用此方法设置当前实际结算价
/// @param auctionPrice auction price 实际结算价格
- (void)setPrice:(nullable NSNumber *)auctionPrice;

/// invoke this method when the bidding  succeeds (strongly recommended)  当竞价成功调用此方法(强烈推荐)
/// @param auctionBidToWin the seccond place bidder's price 竞价方第二名的价格
- (void)win:(nullable NSNumber*)auctionBidToWin;

/// invoke this method when the bidding  fails (strongly recommended)  当竞价失败调用此方法(强烈推荐)
/// @param auctionPrice auction price  竞价
/// @param lossReason Reasons for failed bidding 失败的原因
/// @param winBidder Who won the bid 谁赢了竞价
- (void)loss:(nullable NSNumber*)auctionPrice lossReason:(nullable NSString*)lossReason winBidder:(nullable NSString*)winBidder;

@end


// 海外基础协议方法

@interface PAGRequest : NSObject
+ (instancetype)request;
@end

@protocol PAGAdClientBiddingProtocol;

@protocol PAGAdProtocol <NSObject>
/// return extra info
- (nullable NSDictionary *)getMediaExtraInfo;
@end

@protocol PAGAdDelegate <NSObject>
@optional
- (void)adDidShow:(id<PAGAdProtocol>)ad;
- (void)adDidClick:(id<PAGAdProtocol>)ad;
- (void)adDidDismiss:(id<PAGAdProtocol>)ad;
@end

typedef NS_ENUM(NSInteger, PAGAdSDKThemeStatus) {
    PAGAdSDKThemeStatus_Normal = 0, //Light mode
    PAGAdSDKThemeStatus_Night  = 1, //Dark mode
};

typedef NS_ENUM(NSInteger, PAGChildDirectedType) {
    PAGChildDirectedTypeDefault = -1,//default
    PAGChildDirectedTypeNonChild = 0,// user is not a child
    PAGChildDirectedTypeChild = 1,// user is a child
};

typedef NS_ENUM(NSInteger, PAGDoNotSellType) {
    PAGDoNotSellTypeDefault = -1,//default
    PAGDoNotSellTypeSell = 0,//“sale” of personal information is permitted
    PAGDoNotSellTypeNotSell = 1,//user has opted out of “sale” of personal information
};

typedef NS_ENUM(NSInteger, PAGGDPRConsentType) {
    PAGGDPRConsentTypeDefault = -1,//default
    PAGGDPRConsentTypeNoConsent = 0,//user did not consent
    PAGGDPRConsentTypeConsent = 1,//user provided consent
};

///Pangle SDK configuration class
@interface PAGConfig : NSObject

///appId the unique identifier of the App
///@warning required
@property (nonatomic, copy) NSString *appID;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
/// Initialization method of PAGConfig
+ (instancetype)shareConfig;

@end

@interface PAGConfig (Settings)

///Set the COPPA of the user, COPPA is the short of Children's Online Privacy Protection Rule, the interface only works in the United States.
@property (nonatomic, assign) PAGChildDirectedType childDirected;

///Custom set the GDPR of the user,GDPR is the short of General Data Protection Regulation,the interface only works in The European.
@property (nonatomic, assign) PAGGDPRConsentType GDPRConsent;

/// Custom set the CCPA of the user,CCPA is the short of General Data Protection Regulation,the interface only works in USA.
@property (nonatomic, assign) PAGDoNotSellType doNotSell;

@property (nonatomic, assign) PAGAdSDKThemeStatus  themeStatus;

/// Custom set the debugLog to print debug Log.
/// debugLog NO: close debug log, YES: open debug log.
@property (nonatomic, assign) BOOL debugLog;

/// App logo image. If set, it will be displayed in the App open ad.
@property (nonatomic, strong, nullable) UIImage *appLogoImage;

/// additional user information.
@property (nonatomic, copy) NSString *userDataString;

///Whether to allow SDK to modify the category and options of AVAudioSession when playing audio, default is NO.
///The category set by the SDK is AVAudioSessionCategoryAmbient, and the options are AVAudioSessionCategoryOptionDuckOthers
@property (nonatomic, assign) BOOL allowModifyAudioSessionSetting;

@end

typedef NS_ENUM(NSInteger, PAGSDKInitializationState) {
    PAGSDKInitializationStateNotReady = 0,
    PAGSDKInitializationStateReady = 1
};

typedef void (^PAGAdsCompletionHandler)(BOOL success,NSError *error);

@interface PAGSdk : NSObject

/// Pangle SDK version
@property (nonatomic, copy, readonly, class) NSString *SDKVersion;

/// The SDK initialization state
@property (nonatomic, assign, readonly, class) PAGSDKInitializationState initializationState;

/// Starts the Pangle SDK
/// @warning Call this method as early as possible to reduce  ad request fail.
/// @param config SDK configuration
/// @param completionHandler Callback for starting the Pangle SDK
+ (void)startWithConfig:(PAGConfig *)config completionHandler:(nullable PAGAdsCompletionHandler)completionHandler;

/// Get bidding token
/// @param slotID the unique identifier of  ad.
+ (NSString *)getBiddingToken:(nullable NSString *)slotID;

@end

NS_ASSUME_NONNULL_END

#endif /* OMPangleClass_h */
