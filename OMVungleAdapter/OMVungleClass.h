// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BannerSize) {
/// 320x50
  BannerSizeRegular = 0,
/// 300x50
  BannerSizeShort = 1,
/// 728x90
  BannerSizeLeaderboard = 2,
/// 300x250
  BannerSizeMrec = 3,
};

@class NSString;
@class NSNumber;

@interface BasePublicAd : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull appId;
@property (nonatomic, readonly, copy) NSString * _Nonnull placementId;
@property (nonatomic, readonly, copy) NSString * _Nonnull eventId;
@property (nonatomic, readonly, copy) NSString * _Nonnull creativeId;
/// This method returns the playability status of the ad for the specified placement.
///
/// returns:
/// Bool value to determine if this ad can be played at this time.
- (BOOL)canPlayAd ;
/// This method prepares an ad with the provided bid payload, if provided.
/// If the bid payload is nil, the waterfall flow will be executed.
/// This method will always invoke a <code>DidLoad</code> or a <code>DidFailToLoad</code> callback
/// \param bidPayload The bid payload for bidding feature.
///
- (void)load:(NSString * _Nullable)bidPayload;
@end

typedef NS_ENUM(NSInteger, ConsentStatus) {
  ConsentStatusAccepted = 0,
  ConsentStatusDenied = 1,
};

@class NSCoder;


@interface MediaView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame ;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder ;
@end

typedef NS_ENUM(NSInteger, NativeAdOptionsPosition) {
  NativeAdOptionsPositionTopLeft = 1,
  NativeAdOptionsPositionTopRight = 2,
  NativeAdOptionsPositionBottomLeft = 3,
  NativeAdOptionsPositionBottomRight = 4,
};




@class NSError;


@interface VungleAds : NSObject

+ (NSString * _Nonnull)sdkVersion ;
/// This method initializes the Vungle SDK with the provided app id and calls the completion block
/// when finished.
/// \param appId The Vungle App ID.
///
/// \param completion The completion block that will be called when initialization finishes.
/// If there are no errors during initialization, the returned value will be nil. And vice versa.
///
+ (void)initWithAppId:(NSString * _Nonnull)appId completion:(void (^ _Nonnull)(NSError * _Nullable))completion ;
/// This method returns the bool to check if the SDK has already been initialized successfully or not.
///
/// returns:
/// Bool to check if the SDK has already been initialized successfully or not.
+ (BOOL)isInitialized ;
/// This method returns the encoded token to be used for the bidding feature.
///
/// returns:
/// The encoded string token
/// Note: The current bidding token version is 3. And, the format is:
/// “<biddingTokenVersionPrefix> + “:” <compressed/encoded token data>”
+ (NSString * _Nonnull)getBiddingToken ;
/// This method sets the plugin name and version for internal identification purposes.
/// \param integrationName The plugin or adapter name.
///
/// \param version The version of the plugin or adapter.
///
+ (void)setIntegrationName:(NSString * _Nonnull)integrationName version:(NSString * _Nonnull)version;
@end

@protocol VungleBannerDelegate;

@interface VungleBanner : BasePublicAd
/// The delegate to receive banner ad lifecycle callbacks
@property (nonatomic, weak) id <VungleBannerDelegate> _Nullable delegate;
/// The bool value to determine whether the ad should auto-refresh.
@property (nonatomic) BOOL enableRefresh;
/// This method initializes the Vungle banner ad object.
/// \param placementId The placement id of the banner ad.
///
/// \param size The desired banner size for the banner ad.
///
- (nonnull instancetype)initWithPlacementId:(NSString * _Nonnull)placementId size:(enum BannerSize)size ;
/// This method will present the banner ad in the provided UIView.
/// This view container may be placed in random positions.
/// If presentation fails, the <code>DidFailToPresent</code> callback will be invoked.
/// \param publisherView The UIView container for the banner ad.
/// The size of this container should match the specified size when this object is created.
///
- (void)presentOn:(UIView * _Nonnull)publisherView;
@end




@protocol VungleBannerDelegate <NSObject>
@optional
- (void)bannerAdDidLoad:(VungleBanner * _Nonnull)banner;
- (void)bannerAdDidFailToLoad:(VungleBanner * _Nonnull)banner withError:(NSError * _Nonnull)withError;
- (void)bannerAdWillPresent:(VungleBanner * _Nonnull)banner;
- (void)bannerAdDidPresent:(VungleBanner * _Nonnull)banner;
- (void)bannerAdDidFailToPresent:(VungleBanner * _Nonnull)banner withError:(NSError * _Nonnull)withError;
- (void)bannerAdWillClose:(VungleBanner * _Nonnull)banner;
- (void)bannerAdDidClose:(VungleBanner * _Nonnull)banner;
- (void)bannerAdDidTrackImpression:(VungleBanner * _Nonnull)banner;
- (void)bannerAdDidClick:(VungleBanner * _Nonnull)banner;
- (void)bannerAdWillLeaveApplication:(VungleBanner * _Nonnull)banner;
@end

@protocol VungleInterstitialDelegate;
@class UIViewController;


@interface VungleInterstitial : BasePublicAd
/// The delegate to receive interstitial ad lifecycle callbacks
@property (nonatomic, weak) id <VungleInterstitialDelegate> _Nullable delegate;
- (nonnull instancetype)initWithPlacementId:(NSString * _Nonnull)placementId;
/// This method will play the ad unit, presenting it over the <code>viewController</code> parameter
/// If presentation fails, the <code>DidFailToPresent</code> callback will be invoked.
/// \param viewController The UIViewController for presenting the interstitial ad.
/// This viewController should correspond to the ViewController at the top of the ViewController hierarchy.
///
- (void)presentWith:(UIViewController * _Nonnull)viewController;
@end



@protocol VungleInterstitialDelegate <NSObject>
@optional
- (void)interstitialAdDidLoad:(VungleInterstitial * _Nonnull)interstitial;
- (void)interstitialAdDidFailToLoad:(VungleInterstitial * _Nonnull)interstitial withError:(NSError * _Nonnull)withError;
- (void)interstitialAdWillPresent:(VungleInterstitial * _Nonnull)interstitial;
- (void)interstitialAdDidPresent:(VungleInterstitial * _Nonnull)interstitial;
- (void)interstitialAdDidFailToPresent:(VungleInterstitial * _Nonnull)interstitial withError:(NSError * _Nonnull)withError;
- (void)interstitialAdWillClose:(VungleInterstitial * _Nonnull)interstitial;
- (void)interstitialAdDidClose:(VungleInterstitial * _Nonnull)interstitial;
- (void)interstitialAdDidTrackImpression:(VungleInterstitial * _Nonnull)interstitial;
- (void)interstitialAdDidClick:(VungleInterstitial * _Nonnull)interstitial;
- (void)interstitialAdWillLeaveApplication:(VungleInterstitial * _Nonnull)interstitial;
@end

@protocol VungleNativeDelegate;
@class UIImage;
@class UIImageView;

@interface VungleNative : BasePublicAd
/// The delegate to receive native ad lifecycle callbacks
@property (nonatomic, weak) id <VungleNativeDelegate> _Nullable delegate;
/// The application name that the ad advertises.
@property (nonatomic, readonly, copy) NSString * _Nonnull title;
/// The description of the application that the ad advertises.
@property (nonatomic, readonly, copy) NSString * _Nonnull bodyText;
/// The call to action phrase of the ad.
@property (nonatomic, readonly, copy) NSString * _Nonnull callToAction;
/// The rating for the application that the ad advertises.
@property (nonatomic, readonly) double adStarRating;
/// The sponsored text, normally “sponsored by”.
@property (nonatomic, readonly, copy) NSString * _Nonnull sponsoredText;
/// The app icon image of the ad.
@property (nonatomic, readonly, strong) UIImage * _Nullable iconImage;
/// The position for the ad choices icon. Default is TOP_RIGHT.
@property (nonatomic) enum NativeAdOptionsPosition adOptionsPosition;
- (nonnull instancetype)initWithPlacementId:(NSString * _Nonnull)placementId;
/// Pass UIViews and UIViewController to prepare and display a Native ad.
/// \param view a container view in which a native ad will be displayed. This view will be clickable.
///
/// \param mediaView a MediaView to display the ad’s image or video
///
/// \param iconImageView a UIImageView to display the app icon
///
/// \param viewController a UIViewController to present SKStoreProductViewController
///
- (void)registerViewForInteractionWithView:(UIView * _Nonnull)view mediaView:(MediaView * _Nonnull)mediaView iconImageView:(UIImageView * _Nullable)iconImageView viewController:(UIViewController * _Nullable)viewController;
/// Pass UIViews and UIViewController to prepare and display a Native ad.
/// \param view a container view in which a native ad will be displayed.
///
/// \param mediaView a MediaView to display the ad’s image or video.
///
/// \param iconImageView a UIImageView to display the app icon.
///
/// \param viewController a UIViewController to present SKStoreProductViewController.
///
/// \param clickableViews an array of UIViews that you would like to set clickable.
/// If nil or empty, the mediaView will be clickable.
///
- (void)registerViewForInteractionWithView:(UIView * _Nonnull)view mediaView:(MediaView * _Nonnull)mediaView iconImageView:(UIImageView * _Nullable)iconImageView viewController:(UIViewController * _Nullable)viewController clickableViews:(NSArray<UIView *> * _Nullable)clickableViews;
/// Dismiss the currently displaying Native ad.
- (void)unregisterView;
@end



@protocol VungleNativeDelegate <NSObject>
@optional
- (void)nativeAdDidLoad:(VungleNative * _Nonnull)native;
- (void)nativeAdDidFailToLoad:(VungleNative * _Nonnull)native withError:(NSError * _Nonnull)withError;
- (void)nativeAdDidFailToPresent:(VungleNative * _Nonnull)native withError:(NSError * _Nonnull)withError;
- (void)nativeAdDidTrackImpression:(VungleNative * _Nonnull)native;
- (void)nativeAdDidClick:(VungleNative * _Nonnull)native;
@end


@interface VunglePrivacySettings : NSObject
+ (void)setGDPRStatus:(BOOL)optIn;
+ (void)setGDPRMessageVersion:(NSString * _Nonnull)version;
+ (void)setCCPAStatus:(BOOL)optIn;
+ (void)setCOPPAStatus:(BOOL)isUserCoppa;
+ (void)setPublishIdfv:(BOOL)publish;
@end

@protocol VungleRewardedDelegate;

@interface VungleRewarded : BasePublicAd
/// The delegate to receive rewarded ad lifecycle callbacks
@property (nonatomic, weak) id <VungleRewardedDelegate> _Nullable delegate;
- (nonnull instancetype)initWithPlacementId:(NSString * _Nonnull)placementId;
/// This method will play the ad unit, presenting it over the <code>viewController</code> parameter
/// If presentation fails, the <code>DidFailToPresent</code> callback will be invoked.
/// \param viewController The UIViewController for presenting the interstitial ad.
/// This viewController should correspond to the ViewController at the top of the ViewController hierarchy.
///
- (void)presentWith:(UIViewController * _Nonnull)viewController;
- (void)setUserIdWithUserId:(NSString * _Nonnull)userId;
- (void)setAlertTitleText:(NSString * _Nonnull)text;
- (void)setAlertBodyText:(NSString * _Nonnull)text;
- (void)setAlertCloseButtonText:(NSString * _Nonnull)text;
- (void)setAlertContinueButtonText:(NSString * _Nonnull)text;
@end



@protocol VungleRewardedDelegate <NSObject>
@optional
- (void)rewardedAdDidLoad:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdDidFailToLoad:(VungleRewarded * _Nonnull)rewarded withError:(NSError * _Nonnull)withError;
- (void)rewardedAdWillPresent:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdDidPresent:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdDidFailToPresent:(VungleRewarded * _Nonnull)rewarded withError:(NSError * _Nonnull)withError;
- (void)rewardedAdWillClose:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdDidClose:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdDidTrackImpression:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdDidClick:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdWillLeaveApplication:(VungleRewarded * _Nonnull)rewarded;
- (void)rewardedAdDidRewardUser:(VungleRewarded * _Nonnull)rewarded;
@end


