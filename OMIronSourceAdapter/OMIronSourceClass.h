// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMIronSourceClass_h
#define OMIronSourceClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ISSegment;
@class ISPlacementInfo;

static NSString * const kSizeBanner = @"BANNER";
static NSString * const kSizeLarge = @"LARGE";
static NSString * const kSizeRectangle = @"RECTANGLE";
static NSString * const kSizeLeaderboard = @"LEADERBOARD";
static NSString * const kSizeSmart = @"SMART";
static NSString * const kSizeCustom = @"CUSTOM";

#define ISBannerSize_BANNER [[NSClassFromString(@"ISBannerSize") alloc] initWithDescription:kSizeBanner width:320 height:50]
#define ISBannerSize_LARGE [[NSClassFromString(@"ISBannerSize") alloc] initWithDescription:kSizeLarge width:320 height:90]
#define ISBannerSize_RECTANGLE [[NSClassFromString(@"ISBannerSize") alloc] initWithDescription:kSizeRectangle width:300 height:250]
#define ISBannerSize_SMART [[NSClassFromString(@"ISBannerSize") alloc] initWithDescription:kSizeSmart width:0 height:0]

@interface ISBannerSize : NSObject

#define ISBannerSize_LEADERBOARD [[NSClassFromString(@"ISBannerSize") alloc] initWithDescription:kSizeSmart width:728 height:90]

- (instancetype)initWithWidth:(NSInteger)width andHeight:(NSInteger)height;
- (instancetype)initWithDescription:(NSString *)description width:(NSInteger)width height:(NSInteger)height;
- (BOOL)isSmart;

@property (readonly) NSString* sizeDescription;
@property (readonly) NSInteger width;
@property (readonly) NSInteger height;

@end

static NSString * const kBannerWillMoveToSuperView = @"ISBANNER_WILL_MOVE_TO_SUPERVIEW";

@interface ISBannerView : UIView {
}


@end


#define IS_REWARDED_VIDEO @"rewardedvideo"
#define IS_INTERSTITIAL @"interstitial"
#define IS_OFFERWALL @"offerwall"
#define IS_BANNER @"banner"

typedef NS_ENUM(NSInteger, ISGender) {
    IRONSOURCE_USER_UNKNOWN,
    IRONSOURCE_USER_MALE,
    IRONSOURCE_USER_FEMALE
};

#define kISGenderString(enum) [@[@"unknown",@"male",@"female"] objectAtIndex:enum]


typedef enum LogLevelValues
{
    IS_LOG_NONE = -1,
    IS_LOG_INTERNAL = 0,
    IS_LOG_INFO = 1,
    IS_LOG_WARNING = 2,
    IS_LOG_ERROR = 3,
    IS_LOG_CRITICAL = 4,
    
} ISLogLevel;

typedef enum LogTagValue
{
    TAG_API,
    TAG_DELEGATE,
    TAG_ADAPTER_API,
    TAG_ADAPTER_DELEGATE,
    TAG_NETWORK,
    TAG_NATIVE,
    TAG_INTERNAL,
    TAG_EVENT
    
} LogTag;



static NSString * const MEDIATION_SDK_VERSION     = @"6.15.0";
static NSString * GitHash = @"b4c67f001";

@protocol ISLogDelegate <NSObject>

@required

- (void)sendLog:(NSString *)log level:(ISLogLevel)level tag:(LogTag)tag;

@end

@protocol ISDemandOnlyRewardedVideoDelegate <NSObject>
@required
- (void)rewardedVideoDidLoad:(NSString *)instanceId;

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId;

- (void)rewardedVideoDidOpen:(NSString *)instanceId;

- (void)rewardedVideoDidClose:(NSString *)instanceId;

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId;

- (void)rewardedVideoDidClick:(NSString *)instanceId;

- (void)rewardedVideoAdRewarded:(NSString *)instanceId;

@end

@protocol ISDemandOnlyInterstitialDelegate <NSObject>

@required
/**
 Called after an interstitial has been loaded
 */
- (void)interstitialDidLoad:(NSString *)instanceId;

/**
 Called after an interstitial has attempted to load but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId;

/**
 Called after an interstitial has been opened.
 */
- (void)interstitialDidOpen:(NSString *)instanceId;

/**
 Called after an interstitial has been dismissed.
 */
- (void)interstitialDidClose:(NSString *)instanceId;

/**
 Called after an interstitial has attempted to show but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId;

/**
 Called after an interstitial has been clicked.
 */
- (void)didClickInterstitial:(NSString *)instanceId;

@end

@protocol ISSegmentDelegate <NSObject>

@required
/**
 Called after a segment recived successfully
 */
- (void)didReceiveSegement:(NSString *)segment;

@end

@protocol ISOfferwallDelegate <NSObject>

@required
/**
 Called after the offerwall has changed its availability.
 
 @param available The new offerwall availability. YES if available and ready to be shown, NO otherwise.
 */
- (void)offerwallHasChangedAvailability:(BOOL)available;

/**
 Called after the offerwall has been displayed on the screen.
 */
- (void)offerwallDidShow;

/**
 Called after the offerwall has attempted to show but failed.
 
 @param error The reason for the error.
 */
- (void)offerwallDidFailToShowWithError:(NSError *)error;

/**
 Called after the offerwall has been dismissed.
 */
- (void)offerwallDidClose;

/**
 @abstract Called each time the user completes an offer.
 @discussion creditInfo is a dictionary with the following key-value pairs:
 
 "credits" - (int) The number of credits the user has Earned since the last didReceiveOfferwallCredits event that returned YES. Note that the credits may represent multiple completions (see return parameter).
 
 "totalCredits" - (int) The total number of credits ever earned by the user.
 
 "totalCreditsFlag" - (BOOL) In some cases, we won’t be able to provide the exact amount of credits since the last event (specifically if the user clears the app’s data). In this case the ‘credits’ will be equal to the "totalCredits", and this flag will be YES.
 
 @param creditInfo Offerwall credit info.
 
 @return The publisher should return a BOOL stating if he handled this call (notified the user for example). if the return value is NO, the 'credits' value will be added to the next call.
 */
- (BOOL)didReceiveOfferwallCredits:(NSDictionary *)creditInfo;

/**
 Called after the 'offerwallCredits' method has attempted to retrieve user's credits info but failed.
 
 @param error The reason for the error.
 */
- (void)didFailToReceiveOfferwallCreditsWithError:(NSError *)error;

@end

@protocol ISInterstitialDelegate <NSObject>

@required
/**
 Called after an interstitial has been loaded
 */
- (void)interstitialDidLoad;

/**
 Called after an interstitial has attempted to load but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToLoadWithError:(NSError *)error;

/**
 Called after an interstitial has been opened.
 */
- (void)interstitialDidOpen;

/**
 Called after an interstitial has been dismissed.
 */
- (void)interstitialDidClose;

/**
 Called after an interstitial has been displayed on the screen.
 */
- (void)interstitialDidShow;

/**
 Called after an interstitial has attempted to show but failed.
 
 @param error The reason for the error
 */
- (void)interstitialDidFailToShowWithError:(NSError *)error;

/**
 Called after an interstitial has been clicked.
 */
- (void)didClickInterstitial;

@end

@protocol ISRewardedInterstitialDelegate <NSObject>

@required
- (void)didReceiveRewardForInterstitial;

@end




@protocol ISRewardedVideoDelegate <NSObject>

@required
/**
 Called after a rewarded video has changed its availability.
 
 @param available The new rewarded video availability. YES if available and ready to be shown, NO otherwise.
 */
- (void)rewardedVideoHasChangedAvailability:(BOOL)available;

/**
 Called after a rewarded video has been viewed completely and the user is eligible for reward.
 
 @param placementInfo An object that contains the placement's reward name and amount.
 */
- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo;

/**
 Called after a rewarded video has attempted to show but failed.
 
 @param error The reason for the error
 */
- (void)rewardedVideoDidFailToShowWithError:(NSError *)error;

/**
 Called after a rewarded video has been opened.
 */
- (void)rewardedVideoDidOpen;

/**
 Called after a rewarded video has been dismissed.
 */
- (void)rewardedVideoDidClose;

/**
 * Note: the events below are not available for all supported rewarded video ad networks.
 * Check which events are available per ad network you choose to include in your build.
 * We recommend only using events which register to ALL ad networks you include in your build.
 */

/**
 Called after a rewarded video has started playing.
 */
- (void)rewardedVideoDidStart;

/**
 Called after a rewarded video has finished playing.
 */
- (void)rewardedVideoDidEnd;

/**
 Called after a video has been clicked.
 */
- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo;

@end



@protocol ISBannerDelegate <NSObject>

@required
/**
 Called after a banner ad has been successfully loaded
 */
- (void)bannerDidLoad:(ISBannerView *)bannerView;

/**
 Called after a banner has attempted to load an ad but failed.

 @param error The reason for the error
 */
- (void)bannerDidFailToLoadWithError:(NSError *)error;

/**
 Called after a banner has been clicked.
 */
- (void)didClickBanner;

/**
 Called when a banner is about to present a full screen content.
 */
- (void)bannerWillPresentScreen;

/**
 Called after a full screen content has been dismissed.
 */
- (void)bannerDidDismissScreen;

/**
 Called when a user would be taken out of the application context.
 */
- (void)bannerWillLeaveApplication;

/**
 Called when a banner was shown
 */
- (void)bannerDidShow;

@end


@interface IronSource : NSObject

/**
 @abstact Retrieve a string-based representation of the SDK version.
 @discussion The returned value will be in the form of "<Major>.<Minor>.<Revision>".
 
 @return NSString representing the current IronSource SDK version.
 */
+ (NSString *)sdkVersion;


/**
 @abstact Sets a numeric representation of the current user's age.
 @discussion This value will be passed to the supporting ad networks.
 
 @param age The user's age. Should be between 5 and 120.
 */
+ (void)setAge:(NSInteger)age;

/**
 @abstact Sets the gender of the current user.
 @discussion This value will be passed to the supporting ad networks.
 
 @param gender The user's gender.
 */
+ (void)setGender:(ISGender)gender;

/**
 @abstract Sets if IronSource SDK should track network changes.
 @discussion Enables the SDK to change the availability according to network modifications, i.e. in the case of no network connection, the availability will turn to FALSE.
 
 Default is NO.
 
 @param flag YES if allowed to track network changes, NO otherwise.
 */
+ (void)shouldTrackReachability:(BOOL)flag;

/**
 @abstract Sets if IronSource SDK should allow ad networks debug logs.
 @discussion This value will be passed to the supporting ad networks.
 
 Default is NO.
 
 @param flag YES to allow ad networks debug logs, NO otherwise.
 */
+ (void)setAdaptersDebug:(BOOL)flag;

/**
 @abstract Sets a dynamic identifier for the current user.
 @discussion This parameter can be changed throughout the session and will be received in the server-to-server ad rewarded callbacks.
 
 It helps verify AdRewarded transactions and must be set before calling showRewardedVideo.
 
 @param dynamicUserId Dynamic user identifier. Should be between 1-128 chars in length.
 @return BOOL that indicates if the dynamic identifier is valid.
 */
+ (BOOL)setDynamicUserId:(NSString *)dynamicUserId;

/**
 @abstract Retrieves the device's current advertising identifier.
 @discussion Will first try to retrive IDFA, if impossible, will try to retrive IDFV.
 
 @return The device's current advertising identifier.
 */
+ (NSString *)advertiserId;

/**
 @abstract Sets a mediation type.
 @discussion This method is used only for IronSource's SDK, and will be passed as a custom param.
 
 @param mediationType a mediation type name. Should be alphanumeric and between 1-64 chars in length.
 */
+ (void)setMediationType:(NSString *)mediationType;

/**
 @abstract Sets a mediation segment.
 @discussion This method is used only for IronSource's SDK, and will be passed as a custom param.
 
 @param segment A segment name, which should not exceed 64 characters.
 */
+ (void)setMediationSegment:(NSString *)segment;

/**
 @abstract Sets a segment.
 @discussion This method is used to start a session with a spesific segment.
 
 @param segment A segment object.
 */
+ (void)setSegment:(ISSegment *)segment;

/**
 @abstract Sets the delegate for segment callback.
 
 @param delegate The 'ISSegmentDelegate' for IronSource to send callbacks to.
 */
+ (void)setSegmentDelegate:(id<ISSegmentDelegate>)delegate;


/**
 @abstact Sets the meta data with a key and value.
 @discussion This value will be passed to the supporting ad networks.
 
 @param key The meta data key.
 @param value The meta data value
 
 */
+ (void)setMetaDataWithKey:(NSString *)key value:(NSString *)value;

/**
 @abstact used for demand only API, return the bidding data token.
 */
+ (NSString *) getISDemandOnlyBiddingData;


#pragma mark - SDK Initialization

/**
 @abstract Sets an identifier for the current user.
 
 @param userId User identifier. Should be between 1-64 chars in length.
 */
+ (void)setUserId:(NSString *)userId;

/**
 @abstract Initializes IronSource's SDK with all the ad units that are defined in the platform.
 
 @param appKey Application key.
 */
+ (void)initWithAppKey:(NSString *)appKey;

/**
 @abstract Initializes IronSource's SDK with the requested ad units.
 @discussion This method checks if the requested ad units are defined in the platform, and initializes them.
 
 The adUnits array should contain string values that represent the ad units.
 
 It is recommended to use predefined constansts:
 
 IS_REWARDED_VIDEO, IS_INTERSTITIAL, IS_OFFERWALL, IS_BANNER
 
 e.g: [IronSource initWithAppKey:appKey adUnits:@[IS_REWARDED_VIDEO, IS_INTERSTITIAL, IS_OFFERWALL, IS_BANNER]];
 
 @param appKey Application key.
 @param adUnits An array of ad units to initialize.
 */
+ (void)initWithAppKey:(NSString *)appKey adUnits:(NSArray<NSString *> *)adUnits;

/**
 @abstract Initializes ironSource SDK in demand only mode.
 @discussion This method initializes IS_REWARDED_VIDEO and/or IS_INTERSTITIAL ad units.
 @param appKey Application key.
 @param adUnits An array containing IS_REWARDED_VIDEO and/or IS_INTERSTITIAL.
 */
+ (void)initISDemandOnly:(NSString *)appKey adUnits:(NSArray<NSString *> *)adUnits;

#pragma mark - Rewarded Video

/**
 @abstract Sets the delegate for rewarded video callbacks.
 
 @param delegate The 'ISRewardedVideoDelegate' for IronSource to send callbacks to.
 */
+ (void)setRewardedVideoDelegate:(id<ISRewardedVideoDelegate>)delegate;

/**
 @abstract Shows a rewarded video using the default placement.
 
 @param viewController The UIViewController to display the rewarded video within.
 */
+ (void)showRewardedVideoWithViewController:(UIViewController *)viewController;

/**
 @abstract Shows a rewarded video using the provided placement name.
 
 @param viewController The UIViewController to display the rewarded video within.
 @param placementName The placement name as was defined in the platform. If nil is passed, a default placement will be used.
 */
+ (void)showRewardedVideoWithViewController:(UIViewController *)viewController placement:(nullable NSString *)placementName;

/**
 @abstract Determine if a locally cached rewarded video exists on the mediation level.
 @discussion A return value of YES here indicates that there is a cached rewarded video for one of the ad networks.
 
 @return YES if rewarded video is ready to be played, NO otherwise.
 */
+ (BOOL)hasRewardedVideo;

/**
 @abstract Verify if a certain placement has reached its ad limit.
 @discussion This is to ensure you don’t portray the Rewarded Video button when the placement has been capped or paced and thus will not serve the video ad.
 
 @param placementName The placement name as was defined in the platform.
 @return YES if capped or paced, NO otherwise.
 */
+ (BOOL)isRewardedVideoCappedForPlacement:(NSString *)placementName;

/**
 @abstract Retrive an object containing the placement's reward name and amount.
 
 @param placementName The placement name as was defined in the platform.
 @return ISPlacementInfo representing the placement's information.
 */
+ (ISPlacementInfo *)rewardedVideoPlacementInfo:(NSString *)placementName;

/**
 @abstract Enables sending server side parameters on successful rewarded video
 
 @param parameters A dictionary containing the parameters.
 */
+ (void)setRewardedVideoServerParameters:(NSDictionary *)parameters;

/**
 @abstract Disables sending server side parameters on successful rewarded video
 */
+ (void)clearRewardedVideoServerParameters;

#pragma mark - Demand Only Rewarded Video
/**
 @abstract Sets the delegate for demand only rewarded video callbacks.
 @param delegate The 'ISDemandOnlyRewardedVideoDelegate' for IronSource to send callbacks to.
 */
+ (void)setISDemandOnlyRewardedVideoDelegate:(id<ISDemandOnlyRewardedVideoDelegate>)delegate;

/**
 @abstract Loads a demand only rewarded video for a non bidder instance.
 @discussion This method will load a demand only rewarded video ad for a non bidder instance.
 @param instanceId The demand only instance id to be used to display the rewarded video.
 */
+ (void)loadISDemandOnlyRewardedVideo:(NSString *)instanceId;

/**
 @abstract Loads a demand only rewarded video for a bidder instance.
 @discussion This method will load a demand only rewarded video ad for a bidder instance.
 @param instanceId The demand only instance id to be used to display the rewarded video.
 */
+ (void)loadISDemandOnlyRewardedVideoWithAdm:(NSString *)instanceId adm:(NSString *)adm;

/**
 @abstract Shows a demand only rewarded video using the default placement.
 @param viewController The UIViewController to display the rewarded video within.
 @param instanceId The demand only instance id to be used to display the rewarded video.
 */
+ (void)showISDemandOnlyRewardedVideo:(UIViewController *)viewController instanceId:(NSString *)instanceId;

/**
 @abstract Determine if a locally cached demand only rewarded video exists for an instance id.
 @discussion A return value of YES here indicates that there is a cached rewarded video for the instance id.
 @param instanceId The demand only instance id to be used to display the rewarded video.
 @return YES if rewarded video is ready to be played, NO otherwise.
 */
+ (BOOL)hasISDemandOnlyRewardedVideo:(NSString *)instanceId;

#pragma mark - Interstitial

/**
 @abstract Sets the delegate for interstitial callbacks.
 
 @param delegate The 'ISInterstitialDelegate' for IronSource to send callbacks to.
 */
+ (void)setInterstitialDelegate:(id<ISInterstitialDelegate>)delegate;

/**
 @abstract Sets the delegate for rewarded interstitial callbacks.
 
 @param delegate The 'ISRewardedInterstitialDelegate' for IronSource to send callbacks to.
 */
+ (void)setRewardedInterstitialDelegate:(id<ISRewardedInterstitialDelegate>)delegate;

/**
 @abstract Loads an interstitial.
 @discussion This method will load interstitial ads from the underlying ad networks according to their priority.
 */
+ (void)loadInterstitial;

/**
 @abstract Show a rewarded video using the default placement.
 
 @param viewController The UIViewController to display the interstitial within.
 */
+ (void)showInterstitialWithViewController:(UIViewController *)viewController;

/**
 @abstract Show a rewarded video using the provided placement name.
 
 @param viewController The UIViewController to display the interstitial within.
 @param placementName The placement name as was defined in the platform. If nil is passed, a default placement will be used.
 */
+ (void)showInterstitialWithViewController:(UIViewController *)viewController placement:(nullable NSString *)placementName;

/**
 @abstract Determine if a locally cached interstitial exists on the mediation level.
 @discussion A return value of YES here indicates that there is a cached interstitial for one of the ad networks.
 
 @return YES if there is a locally cached interstitial, NO otherwise.
 */
+ (BOOL)hasInterstitial;

/**
 @abstract Verify if a certain placement has reached its ad limit.
 @discussion This is to ensure you don’t try to show interstitial when the placement has been capped or paced and thus will not serve the interstitial ad.
 
 @param placementName The placement name as was defined in the platform.
 @return YES if capped or paced, NO otherwise.
 */
+ (BOOL)isInterstitialCappedForPlacement:(NSString *)placementName;

#pragma mark - Demand Only Interstitial

/**
 @abstract Sets the delegate for demand only interstitial callbacks.
 @param delegate The 'ISDemandOnlyInterstitialDelegate' for IronSource to send callbacks to.
 */
+ (void)setISDemandOnlyInterstitialDelegate:(id<ISDemandOnlyInterstitialDelegate>)delegate;

/**
 @abstract Loads a demand only interstitial.
 @discussion This method will load a demand only interstitial ad.
 @param instanceId The demand only instance id to be used to display the interstitial.
 */
+ (void)loadISDemandOnlyInterstitial:(NSString *)instanceId;

/**
 @abstract Loads a demand only interstitial bidder instance.
 @discussion This method will load a demand only interstitial ad bidder instance.
 @param instanceId The demand only instance id to be used to display the interstitial.
 */
+ (void)loadISDemandOnlyInterstitialWithAdm:(NSString *)instanceId adm:(NSString *)adm;


/**
 @abstract Show a demand only interstitial using the default placement.
 @param viewController The UIViewController to display the interstitial within.
 @param instanceId The demand only instance id to be used to display the interstitial.
 */
+ (void)showISDemandOnlyInterstitial:(UIViewController *)viewController instanceId:(NSString *)instanceId;

/**
 @abstract Determine if a locally cached interstitial exists for a demand only instance id.
 @discussion A return value of YES here indicates that there is a cached interstitial for the instance id.
 @param instanceId The demand only instance id to be used to display the interstitial.
 @return YES if there is a locally cached interstitial, NO otherwise.
 */
+ (BOOL)hasISDemandOnlyInterstitial:(NSString *)instanceId;

#pragma mark - Offerwall

/**
 @abstract Sets the delegate for offerwall callbacks.
 
 @param delegate The 'ISOfferwallDelegate' for IronSource to send callbacks to.
 */
+ (void)setOfferwallDelegate:(id<ISOfferwallDelegate>)delegate;

/**
 @abstract Show an offerwall using the default placement.
 
 @param viewController The UIViewController to display the offerwall within.
 */
+ (void)showOfferwallWithViewController:(UIViewController *)viewController;

/**
 @abstract Show an offerwall using the provided placement name.
 
 @param viewController The UIViewController to display the offerwall within.
 @param placementName The placement name as was defined in the platform. If nil is passed, a default placement will be used.
 */
+ (void)showOfferwallWithViewController:(UIViewController *)viewController placement:(nullable NSString *)placementName;

/**
 @abstract Retrive information on the user’s total credits and any new credits the user has earned.
 @discussion The function can be called at any point during the user’s engagement with the app.
 */
+ (void)offerwallCredits;

/**
 @abstract Determine if the offerwall is prepared.
 
 @return YES if there is an available offerwall, NO otherwise.
 */
+ (BOOL)hasOfferwall;

#pragma mark - Banner

/**
 @abstract Sets the delegate for banner callbacks.
 
 @param delegate The 'ISBannerDelegate' for IronSource to send callbacks to.
 */
+ (void)setBannerDelegate:(id<ISBannerDelegate>)delegate;

/**
 @abstract Loads a banner using the default placement.
 @discussion This method will load banner ads of the requested size from the underlying ad networks according to their priority.
 
 The size should contain ISBannerSize value that represent the required banner ad size.
 e.g. [IronSource loadBannerWithViewController:self size:ISBannerSize_BANNER];
 
 Custom banner size:
 ISBannerSize* bannerSize = [[ISBannerSize alloc] initWithWidth:320 andHeight:50];
 [IronSource loadBannerWithViewController:self size:bannerSize];
 
 @param viewController The UIViewController to display the banner within.
 @param size The required banner ad size
 */
+ (void)loadBannerWithViewController:(UIViewController *)viewController size:(ISBannerSize *)size;

/**
 @abstract Loads a banner using the provided placement name.
 @discussion This method will load banner ads of the requested size from the underlying ad networks according to their priority.
 
 The size should contain ISBannerSize value that represent the required banner ad size.
 e.g. [IronSource loadBannerWithViewController:self size:ISBannerSize_BANNER placement:@"your_placement_name"];
 
 Custom banner size:
 ISBannerSize* bannerSize = [[ISBannerSize alloc] initWithWidth:320 andHeight:50];
 [IronSource loadBannerWithViewController:self size:bannerSize placement:@"your_placement_name"];
 
 @param viewController The UIViewController to display the banner within.
 @param size The required banner ad size
 @param placementName The placement name as was defined in the platform. If nil is passed, the default placement will be used.
 */
+ (void)loadBannerWithViewController:(UIViewController *)viewController size:(ISBannerSize *)size placement:(nullable NSString *)placementName;

/**
 @abstract Removes the banner from memory.
 @param banner The ISBannerView to remove.
 */
+ (void)destroyBanner:(ISBannerView *)banner;

/**
 @abstract Verify if a certain placement has reached its ad limit.
 @discussion This is to ensure you don’t try to load a banner when the placement has been capped or paced and thus will not serve the banner ad.
 
 @param placementName The placement name as was defined in the platform.
 @return YES if capped or paced, NO otherwise.
 */
+ (BOOL)isBannerCappedForPlacement:(NSString *)placementName;

#pragma mark - Logging

/**
 @abstract Sets the delegate for log callbacks.
 
 @param delegate The 'ISLogDelegate' for IronSource to send callbacks to.
 */
+ (void)setLogDelegate:(id<ISLogDelegate>)delegate;

+ (void)setConsent:(BOOL)consent;

@end

NS_ASSUME_NONNULL_END

#endif /* OMIronSourceClass_h */
