// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMHeliumClass_h
#define OMHeliumClass_h

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM( NSUInteger, HeliumErrorCode ) {
    HeliumErrorCode_NoAdFound,
    HeliumErrorCode_NoBid,
    HeliumErrorCode_NoNetwork,
    HeliumErrorCode_ServerError,
    HeliumErrorCode_PartnerError,
    HeliumErrorCode_StartUpError,
    HeliumErrorCode_Unknown
};
@interface HeliumError : NSObject
@property (assign,readonly) HeliumErrorCode errorCode;
@property (nonatomic,readonly) NSString *errorDescription;
@end


@class UIViewController;
@class HeliumError;


// Forward Swift declarations
@class HeliumError;
@class HeliumKeywords;

#pragma mark - CHBHBannerSize

/// Helium banner size to request.
typedef NS_ENUM(NSInteger, CHBHBannerSize) {
    /// Standard 320x50 size.
    CHBHBannerSize_Standard    = 0,
    
    /// Medium Rectangle 300x250 size.
    CHBHBannerSize_Medium      = 1,
    
    /// Leaderboard 728x90 size.
    CHBHBannerSize_Leaderboard = 2
};

#pragma mark - HeliumSdkDelegate

/// Delegate for receiving Helium SDK initialization callbacks.
@protocol HeliumSdkDelegate <NSObject>
/// Helium SDK has finished initializing.
/// @param error Optional error if the Helium SDK did not initialize properly.
- (void)heliumDidStartWithError:(nullable HeliumError *)error;
@end

#pragma mark - HeliumInterstitialAd

/// Helium interstitial ad.
@protocol HeliumInterstitialAd <NSObject>

/// Optional keywords that can be associated with the advertisement placement.
@property (nonatomic, retain, nullable) HeliumKeywords *keywords;

/// Asynchronously loads an ad.
/// When complete, the delegate method @c heliumInterstitialAdWithPlacementName:didLoadWithError: will
/// be invoked.
/// @returns A unique identifier for the load request. It can be ignored in most SDK integrations.
- (NSString *)loadAd;

/// Clears the loaded ad.
/// @returns @c YES if the loaded ad was cleared; @c NO is returned when there is no ad loaded.
- (BOOL)clearLoadedAd;

/// Asynchronously shows the ad with the specified view controller.
/// When complete, the delegate method @c heliumInterstitialAdWithPlacementName:didShowWithError: will
/// be invoked.
/// @param vc View controller used to present the ad.
- (void)showAdWithViewController:(UIViewController *)vc;

/// Indicates that the ad is ready to show.
- (BOOL)readyToShow;
@end

#pragma mark - CHBHeliumInterstitialAdDelegate

/// Callbacks for @c HeliumInterstitialAd
@protocol CHBHeliumInterstitialAdDelegate <NSObject>
/// Ad finished loading with an optional error.
/// @param placementName Placement associated with the load completion.
/// @param error Optional error associated with the ad load.
- (void)heliumInterstitialAdWithPlacementName:(NSString *)placementName
                             didLoadWithError:(nullable HeliumError *)error;

/// Ad finished showing with an optional error.
/// @param placementName Placement associated with the show completion.
/// @param error Optional error associated with the ad show.
- (void)heliumInterstitialAdWithPlacementName:(NSString *)placementName
                             didShowWithError:(nullable HeliumError *)error;

/// Ad finished closing with an optional error.
/// @param placementName Placement associated with the close completion.
/// @param error Optional error associated with the ad close.
- (void)heliumInterstitialAdWithPlacementName:(NSString *)placementName
                            didCloseWithError:(nullable HeliumError *)error;
@optional
/// Ad finished loading the winning bid.
/// This callback will be invoked only upon a load success, and will be triggered after the
/// @c heliumInterstitialAdWithPlacementName:didLoadWithError: callback.
/// @param placementName Placement associated with the winning bid load completion.
/// @param bidInfo Bid information JSON.
- (void)heliumInterstitialAdWithPlacementName:(NSString *)placementName
                    didLoadWinningBidWithInfo:(NSDictionary<NSString *, id> *)bidInfo;

/// Ad click event with an optional error.
/// @param placementName Placement associated with the click event.
/// @param error Optional error associated with the click event.
- (void)heliumInterstitialAdWithPlacementName:(NSString *)placementName
                            didClickWithError:(nullable HeliumError *)error;

/// Ad impression recorded by Helium as result of an ad being shown.
/// @param placementName Placement associated with the impression event.
- (void)heliumInterstitialAdDidRecordImpressionWithPlacementName:(NSString *)placementName;
@end

#pragma mark - HeliumRewardedAd

/// Helium rewarded ad.
@protocol HeliumRewardedAd <NSObject>

/// Optional keywords that can be associated with the advertisement placement.
@property (nonatomic, retain, nullable) HeliumKeywords *keywords;

/// Optional custom data that will be sent on every rewarded callback.
/// This property has a maximum length of 1000 characters. If the length exceeds the maximum,
/// an error will be logged and this property will be set to @c nil.
@property (nonatomic, copy, nullable) NSString *customData;

/// Asynchronously loads an ad.
/// When complete, the delegate method @c heliumRewardedAdWithPlacementName:didLoadWithError: will
/// be invoked.
/// @returns A unique identifier for the load request. It can be ignored in most SDK integrations.
- (NSString *)loadAd;

/// Clears the loaded ad.
/// @returns @c YES if the loaded ad was cleared; @c NO is returned when there is no ad loaded.
- (BOOL)clearLoadedAd;

/// Asynchronously shows the ad with the specified view controller.
/// When complete, the delegate method @c heliumRewardedAdWithPlacementName:didShowWithError: will
/// be invoked.
/// @param vc View controller used to present the ad.
- (void)showAdWithViewController:(UIViewController *)vc;

/// Indicates that the ad is ready to show.
- (BOOL)readyToShow;
@end

#pragma mark - CHBHeliumRewardedAdDelegate

/// Callbacks for @c HeliumRewardedAd
@protocol CHBHeliumRewardedAdDelegate <NSObject>
/// Ad finished loading with an optional error.
/// @param placementName Placement associated with the load completion.
/// @param error Optional error associated with the ad load.
- (void)heliumRewardedAdWithPlacementName:(NSString *)placementName
                         didLoadWithError:(nullable HeliumError *)error;

/// Ad finished showing with an optional error.
/// @param placementName Placement associated with the show completion.
/// @param error Optional error associated with the ad show.
- (void)heliumRewardedAdWithPlacementName:(NSString *)placementName
                         didShowWithError:(nullable HeliumError *)error;

/// Ad finished closing with an optional error.
/// @param placementName Placement associated with the close completion.
/// @param error Optional error associated with the ad close.
- (void)heliumRewardedAdWithPlacementName:(NSString *)placementName
                        didCloseWithError:(nullable HeliumError *)error;

/// Ad finished playing allowing the user to earn a reward.
/// @param placementName Placement associated with the reward event.
/// @param reward The earned reward.
- (void)heliumRewardedAdWithPlacementName:(NSString *)placementName
                             didGetReward:(NSInteger)reward;
@optional

/// Ad finished loading the winning bid.
/// This callback will be invoked only upon a load success, and will be triggered after the
/// @c heliumRewardedAdWithPlacementName:didLoadWithError: callback.
/// @param placementName Placement associated with the winning bid load completion.
/// @param bidInfo Bid information JSON.
- (void)heliumRewardedAdWithPlacementName:(NSString *)placementName
                didLoadWinningBidWithInfo:(NSDictionary<NSString *, id> *)bidInfo;

/// Ad click event with an optional error.
/// @param placementName Placement associated with the click event.
/// @param error Optional error associated with the click event.
- (void)heliumRewardedAdWithPlacementName:(NSString *)placementName
                        didClickWithError:(nullable HeliumError *)error;

/// Ad impression recorded by Helium as result of an ad being shown.
/// @param placementName Placement associated with the impression event.
- (void)heliumRewardedAdDidRecordImpressionWithPlacementName:(NSString *)placementName;
@end

#pragma mark - HeliumBannerAd

/// Helium banner ad.
@protocol HeliumBannerAd <NSObject>

/// Optional keywords that can be associated with the advertisement placement.
/// Note that changing the keywords for an already-loaded banner will not take effect until the
/// next auto-refresh load.
@property (nonatomic, retain, nullable) HeliumKeywords *keywords;

/// Asynchronously loads an ad.
/// When complete, the delegate method @c heliumBannerAdWithPlacementName:didLoadWithError: will
/// be invoked.
/// When the banner view is visible in the app's view hierarchy it will automatically present the loaded ad.
/// Calling this method will start the banner auto-refresh process.
/// Only one @c heliumBannerAdWithPlacementName:didLoadWithError: call will be made per @c loadAdWithViewController:
/// call, even if more ads are loaded as result of the banner auto-refresh process.
/// @param viewController View controller used to present the ad.
/// @returns A unique identifier for the load request. It can be ignored in most SDK integrations.
- (NSString *)loadAdWithViewController:(UIViewController *)viewController;

/// Clears the loaded ad, removes the currently presented ad if any, and stops the auto-refresh process.
/// @returns @c YES if the loaded ad was cleared; @c NO is returned when there is no ad loaded.
- (BOOL)clearAd;

@end

// Forward Swift declarations
@protocol CHBHeliumBannerAdDelegate;

@class HeliumBannerView;

/// Helium SDK entrypoint.
@interface Helium : NSObject

/// Shared instance of the Helium SDK.
/// @returns Shared instance of the Helium SDK.
+ (Helium *)sharedHelium;

#pragma mark - Initialization

/// Initializes the Helium SDK.
/// This method must be called before ads can be served.
/// @param appId Application identifier from the Chartboost dashboard.
/// @param appSignature Application signature from the Chartboost dashboard.
/// @param delegate Optional delegate used to listen for the SDK initialization callback.
- (void)startWithAppId:(NSString *)appId andAppSignature:(NSString *)appSignature delegate:(nullable id<HeliumSdkDelegate>)delegate;

#pragma mark - Ad Providers

/// Factory method to create a @c HeliumInterstitialAd which will be used to load and show interstitial ads.
/// @param delegate Delegate to receive interstitial ad callbacks.
/// @param placementName Interstitial ad placement from the Chartboost dashboard.
/// @returns The interstitial ad provider if successful; otherwise @c nil will be returned.
- (nullable id<HeliumInterstitialAd>)interstitialAdProviderWithDelegate:(nullable id<CHBHeliumInterstitialAdDelegate>)delegate
                                                       andPlacementName:(NSString *)placementName;

/// Factory method to create a @c HeliumRewardedAd which will be used to load and show rewarded ads.
/// @param delegate Delegate to receive rewarded ad callbacks.
/// @param placementName Rewarded ad placement from the Chartboost dashboard.
/// @returns The rewarded ad provider if successful; otherwise @c nil will be returned.
- (nullable id<HeliumRewardedAd>)rewardedAdProviderWithDelegate:(nullable id<CHBHeliumRewardedAdDelegate>)delegate
                                               andPlacementName:(NSString *)placementName;

/// Factory method to create a @c HeliumBannerView which will be used to load and show banner ads.
/// @param delegate Delegate to receive banner ad callbacks.
/// @param placementName Banner ad placement from the Chartboost dashboard.
/// @param bannerSize Size of the banner to request.
/// @returns The banner ad provider if successful; otherwise @c nil will be returned.
- (nullable HeliumBannerView *)bannerProviderWithDelegate:(nullable id<CHBHeliumBannerAdDelegate>)delegate
                                         andPlacementName:(NSString *)placementName
                                                  andSize:(CHBHBannerSize)bannerSize;

#pragma mark - COPPA and Consent

/// Indicates that the user is subject to COPPA.
/// For more information about COPPA, see: https://answers.chartboost.com/en-us/articles/115001488494
/// @param isSubject User is subject to COPPA.
- (void)setSubjectToCoppa:(BOOL)isSubject;

/// Indicates that the user is subject to GDPR.
/// For more information about GDPR, see: https://answers.chartboost.com/en-us/articles/115001489613
/// @param isSubject User is subject to GDPR.
- (void)setSubjectToGDPR:(BOOL)isSubject;

/// Indicates that the GDPR-applicable user has granted consent to the collection of Personally Identifiable Information.
/// For more information about GDPR, see: https://answers.chartboost.com/en-us/articles/115001489613
/// @param hasGivenConsent GDPR-applicable user has granted consent.
- (void)setUserHasGivenConsent:(BOOL)hasGivenConsent;

/// Indicates that the CCPA-applicable user has granted consent to the collection of Personally Identifiable Information.
/// For more information about CCPA, see: https://answers.chartboost.com/en-us/articles/115001490031
/// @param hasGivenConsent CCPA-applicable user has granted consent.
- (void)setCCPAConsent:(BOOL)hasGivenConsent;

#pragma mark - User Information

/// Optional user identifier sent on every ad request.
@property (nonatomic, copy, nullable) NSString *userIdentifier;

#pragma mark - Game Engine

/// Specifies to the Helium SDK the game engine environment that it is running in.
/// This method should be called before loading ads.
/// @param name Game engine name.
/// @param version Game engine version.
- (void)setGameEngineName:(nullable NSString *)name version:(nullable NSString *)version;

@end


NS_ASSUME_NONNULL_END

#endif /* OMHeliumClass_h */
