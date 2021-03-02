// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdColonyClass_h
#define OMAdColonyClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum representing AdColony ad request error codes
 */
typedef NS_ENUM(NSUInteger, AdColonyRequestError) {

    /** An invalid app id or zone id was specified by the developer or an invalid configuration was received from the server (unlikely). */
    AdColonyRequestErrorInvalidRequest = 0,

    /** The ad was skipped due to the skip interval setting on the control panel. */
    AdColonyRequestErrorSkippedRequest,

    /** The current zone has no ad fill. */
    AdColonyRequestErrorNoFillForRequest,

    /** Either AdColony has not been configured, is still in the process of configuring, is still downloading assets, or is already showing an ad. */
    AdColonyRequestErrorUnready
};

/**
 Enum representing in-app purchase (IAP) engagement types
 */
typedef NS_ENUM(NSUInteger, AdColonyIAPEngagement) {

    /** IAP was enabled for the ad, and the user engaged via a dynamic end card (DEC). */
    AdColonyIAPEngagementEndCard = 0,

    /** IAP was enabled for the ad, and the user engaged via an in-vdeo engagement (Overlay). */
    AdColonyIAPEngagementOverlay
};

/**
 Enum representing supported ad orientations
 */
typedef NS_ENUM(NSInteger, AdColonyOrientation) {

    /** Portrait and upside down */
    AdColonyOrientationPortrait = 0,

    /** Landscape left and landscape right */
    AdColonyOrientationLandscape = 1,

    /** All orientations supported */
    AdColonyOrientationAll = 2
};

/**
 Enum representing zone types
 */
typedef NS_ENUM(NSInteger, AdColonyZoneType) {

    /** Invalid zone type */
    AdColonyZoneTypeInvalid = -1,
    
    /** Interstitial zone type */
    AdColonyZoneTypeInterstitial = 0,
    
    /** Banner zone type */
    AdColonyZoneTypeBanner = 1,

    /** Native zone type */
    AdColonyZoneTypeNative __attribute__((deprecated("It will be removed in a future release"))) = 2
};

@class AdColonyUserMetadata;
@class AdColonyZone;
@class AdColonyAdOptions;
@class AdColonyAppOptions;
@class AdColonyNativeAdView;

/**
 AdColonyZone objects aggregate informative data about an AdColony zone such as its unique identifier, its `ADCOLONY_ZONE_TYPE`, etc.
 AdColonyZones also provide a block-based handler for zone-level reward events.
 Note that you should never instantiate one of these objects directly. You only need to use them when they are passed to you.
 */
@interface AdColonyZone : NSObject

/** @name Zone */

/**
 @abstract Represents the given zone's unique string identifier.
 @discussion AdColony zone IDs can be created at the [Control Panel](http://clients.adcolony.com).
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 @abstract Represents the zone type - interstitial, banner, or native.
 @discussion You can set the type for your zones at the [Control Panel](http://clients.adcolony.com).
 @see AdColonyZoneType
 */
@property (nonatomic, readonly) AdColonyZoneType type;

/**
 @abstract Indicates whether or not the zone is enabled.
 @discussion Sending invalid zone id strings to `configureWithAppID:zoneIDs:options:completion:` will cause this value to be `NO`.
 */
@property (nonatomic, readonly) BOOL enabled;

/** @name Rewards */

/**
 @abstract Indicates whether or not the zone is configured for rewards.
 @discussion You can configure rewards in your zones at the [Control Panel](http://clients.adcolony.com).
 Sending invalid zone id strings to `configureWithAppID:zoneIDs:options:completion:` will cause this value to be `NO`.
 */
@property (nonatomic, readonly) BOOL rewarded;

/**
 @abstract Represents the number of completed ad views required to receive a reward for the given zone.
 @discussion This value will be 0 if the given zone is not configured for rewards.
 */
@property (nonatomic, readonly) NSUInteger viewsPerReward;

/**
 @abstract Represents the number of ads that must be watched before a reward is given.
 @discussion This value will be 0 if the given zone is not configured for rewards.
 */
@property (nonatomic, readonly) NSUInteger viewsUntilReward;

/**
 @abstract Represents the reward amount for each completed rewarded ad view.
 @discussion This value will be 0 if the given zone is not configured for rewards.
 */
@property (nonatomic, readonly) NSUInteger rewardAmount;

/**
 @abstract Represents the singular form of the reward name based on the reward amount.
 @discussion This value will be an empty string if the given zone is not configured for rewards.
 */
@property (nonatomic, readonly) NSString *rewardName;

/** @name Handling Rewards */

/**
 @abstract Sets a block-based reward handler for your zone.
 @discussion Based on the success parameter, client-side reward implementations should consider incrementing the user's currency balance in this method.
 Server-side reward implementations, however, should consider the success parameter and then contact the game server to determine the current total balance for the virtual currency.
 Note that the associated block of code will be dispatched on the main thread.
 @param reward Callback for reward grant
 */
- (void)setReward:(nullable void (^)(BOOL success, NSString *name, int amount))reward;

@end



@interface AdColonyUserMetadata : NSObject

/** @name Pre-defined Aspects of User Metadata */

/**
 @abstract Configures the user's age.
 @discussion Set this property to configure the user's age.
 */
@property (nonatomic) NSInteger userAge;

/**
 @abstract Configures the user's gender.
 @discussion Set this property to configure the user's gender.
 Note that you should use one of the pre-defined constants below to configure this property.
 */
@property (nonatomic, strong, nullable) NSString *userGender;

@end

/**
 AdColonyOptions is a superclass for all types of AdColonyOptions.
 Note that AdColonyOptions classes should never be instantiated directly.
 Instead, create one of the subclasses and set options on it using its properties as well as the string-based constants defined in its header file.
 */
@interface AdColonyOptions : NSObject

/** @name Properties */

/**
 @abstract Represents an AdColonyUserMetadata object.
 @discussion Configure and set this property to improve ad targeting.
 @see AdColonyUserMetadata
 */
@property (nonatomic, strong, nullable) AdColonyUserMetadata *userMetadata;

/** @name Setting Options */

/**
 @abstract Sets a supported option.
 @discussion Use this method to set a string-based option with an arbitrary, string-based value.
 @param option An NSString representing the option.
 @param value An NSString used to configure the option. Strings must be 128 characters or less.
 @return A BOOL indicating whether or not the option was set successfully.
 @see AdColonyAppOptions
 @see AdColonyAdOptions
 */
- (BOOL)setOption:(NSString *)option withStringValue:(NSString *)value;

/**
 @abstract Sets a supported option.
 @discussion Use this method to set a string-based option with an arbitrary, numerial value.
 @param option An NSString representing the option. Strings must be 128 characters or less.
 @param value An NSNumber used to configure the option.
 @return A BOOL indicating whether or not the option was set successfully.
 @see AdColonyAppOptions
 @see AdColonyAdOptions
 */
- (BOOL)setOption:(NSString *)option withNumericValue:(NSNumber *)value;

/** @name Option Retrieval */

/**
 @abstract Returns the string-based option associated with the given key.
 @discussion Call this method to obtain the string-based value associated with the given string-based key.
 @param key A string-based option key.
 @return The string-based value associated with the given key. Returns `nil` if the option has not been set.
 @see AdColonyAppOptions
 @see AdColonyAdOptions
 */
- (nullable NSString *)getStringOptionWithKey:(NSString *)key;

/**
 @abstract Returns the numerical option associated with the given key.
 @discussion Call this method to obtain the numerical value associated with the given string-based key.
 @param key A string-based option key.
 @return The option value associated with the given key. Returns `nil` if the option has not been set.
 @see AdColonyAppOptions
 @see AdColonyAdOptions
 */
- (nullable NSNumber *)getNumericOptionWithKey:(NSString *)key;
@end


@interface AdColonyAppOptions : AdColonyOptions

@property (nonatomic, assign) BOOL gdprRequired;

@property (nonatomic, nullable, strong) NSString *gdprConsentString;

@end

@interface AdColonyAdOptions : AdColonyOptions

/** @name Properties */

/**
 @abstract Enables reward dialogs to be shown before an advertisement.
 @discussion These popups are disabled by default.
 Set this property with a corresponding value of `YES` to enable.
 */
@property (nonatomic) BOOL showPrePopup;

/**
 @abstract Enables reward dialogs to be shown after an advertisement.
 @discussion These popups are disabled by default.
 Set this property with a corresponding value of `YES` to enable.
 */
@property (nonatomic) BOOL showPostPopup;

@end



@class AdColonyTypes;
@class AdColonyInterstitial;

@interface AdColonyAdRequestError : NSError

@end

/**
 * The delegate of an AdColonyInterstitial object. This delegate receives interstitial lifecycle notifications.
 */
@protocol AdColonyInterstitialDelegate <NSObject>

@required

/**
 @abstract Did load notification
 @discussion Notifies you when interstitial has been created, received an ad and is ready to use. Call is dispatched on main thread.
 @param interstitial Loaded interstitial
 */
- (void)adColonyInterstitialDidLoad:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract No ad notification
 @discussion Notifies you when SDK was not able to load an ad for requested zone. Call is dispatched on main thread.
 @param error Error with failure explanation
 */
- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError * _Nonnull)error;

@optional

/**
 @abstract Open notification
 @discussion Notifies you when interstitial is going to show fullscreen content. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialWillOpen:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Close notification
 @discussion Notifies you when interstitial dismissed fullscreen content. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialDidClose:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Expire notification
 @discussion Notifies you when an interstitial expires and is no longer valid for playback. This does not get triggered when the expired flag is set because it has been viewed. It's recommended to request a new ad within this callback. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialExpired:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Will leave application notification
 @discussion Notifies you when an ad action cause the user to leave application. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialWillLeaveApplication:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Click notification
 @discussion Notifies you when the user taps on the interstitial causing the action to be taken. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialDidReceiveClick:(AdColonyInterstitial * _Nonnull)interstitial;

/** @name Videos For Purchase (V4P) */

/**
 @abstract IAP opportunity notification
 @discussion Notifies you when the ad triggers an IAP opportunity.
 @param interstitial interstitial ad object
 @param iapProductID IAP product id
 @param engagement engagement type
 */
- (void)adColonyInterstitial:(AdColonyInterstitial * _Nonnull)interstitial iapOpportunityWithProductId:(NSString * _Nonnull)iapProductID andEngagement:(AdColonyIAPEngagement)engagement;

@end


/**
 Ad object returned from a request. This is used to show and receive callbacks once the ad is presented.
 */
@interface AdColonyInterstitial : NSObject

/** @name Properties */

/**
 @abstract Interstitial delegate
 @discussion Delegate object that receives interstitial lifecycle notifications.
 */
@property (nonatomic, nullable, weak) id<AdColonyInterstitialDelegate> delegate;

/**
 @abstract Represents the unique zone identifier string from which the interstitial was requested.
 @discussion AdColony zone IDs can be created at the [Control Panel](http://clients.adcolony.com).
 */
@property (nonatomic, strong, readonly) NSString *zoneID;

/**
 @abstract Indicates whether or not the interstitial has been played or if it has met its expiration time.
 @discussion AdColony interstitials become expired as soon as the ad launches or just before they have met their expiration time.
 */
@property (atomic, assign, readonly) BOOL expired;

/**
 @abstract Indicates whether or not the interstitial has audio enabled.
 @discussion Leverage this property to determine if the application's audio should be paused while the ad is playing.
 */
@property (nonatomic, assign, readonly) BOOL audioEnabled;

/**
 @abstract Indicates whether or not the interstitial is configured to trigger IAPs.
 @discussion Leverage this property to determine if the interstitial is configured to trigger IAPs.
 */
@property (nonatomic, assign, readonly) BOOL iapEnabled;



/** @name Ad Playback */

/**
 @abstract Triggers a fullscreen ad experience.
 @param viewController The view controller on which the interstitial will display itself.
 @return Whether the SDK was ready to begin playback.
 */
- (BOOL)showWithPresentingViewController:(UIViewController *)viewController;

/**
 @abstract Cancels the interstitial and returns control back to the application.
 @discussion Call this method to cancel the interstitial.
 Note that canceling interstitials before they finish will diminish publisher revenue.
 */
- (void)cancel;

/** @name Ad Event Handlers */

/**
 @abstract Sets the block of code to be executed when the interstitial is displayed to the user.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param open The block of code to be executed.
 */
- (void)setOpen:(nullable void (^)(void))open __attribute__((deprecated("Deprecated in v4.0.0, use delegate")));

/**
 @abstract Sets the block of code to be executed when the interstitial is removed from the view hierarchy. It's recommended to request a new ad within this callback.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param close The block of code to be executed.
 */
- (void)setClose:(nullable void (^)(void))close __attribute__((deprecated("Deprecated in v4.0.0, use delegate")));

/**
 @abstract Sets the block of code to be executed when an interstitial expires and is no longer valid for playback. This does not get triggered when the expired flag is set because it has been viewed. It's recommended to request a new ad within this callback.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param expire The block of code to be executed.
 */
- (void)setExpire:(nullable void (^)(void))expire __attribute__((deprecated("Deprecated in v4.0.0, use delegate")));

/**
 @abstract Sets the block of code to be executed when an action causes the user to leave the application.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param leftApplication The block of code to be executed.
 */
- (void)setLeftApplication:(nullable void (^)(void))leftApplication __attribute__((deprecated("Deprecated in v4.0.0, use delegate")));

/**
 @abstract Sets the block of code to be executed when the user taps on the interstitial ad, causing an action to be taken.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param click The block of code to be executed.
 */
- (void)setClick:(nullable void (^)(void))click __attribute__((deprecated("Deprecated in v4.0.0, use delegate")));

/** @name Videos For Purchase (V4P) */

/**
 @abstract Sets the block of code to be executed when the ad triggers an IAP opportunity.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param iapOpportunity The block of code to be executed.
 */
- (void)setIapOpportunity:(nullable void (^)(NSString *iapProductID, AdColonyIAPEngagement engagement))iapOpportunity __attribute__((deprecated("Deprecated in v4.0.0, use delegate")));

/**
 @abstract Sets the block of code to be executed when the interstitial begins playing audio.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param audioStart The block of code to be executed.
 */
- (void)setAudioStart:(nullable void (^)(void))audioStart __attribute__((deprecated("Deprecated in v3.3.6, use the open callback")));

/**
 @abstract Sets the block of code to be executed when the interstitial stops playing audio.
 @discussion Note that the associated code block will be dispatched on the main thread.
 @param audioStop The block of code to be executed.
 */
- (void)setAudioStop:(nullable void (^)(void))audioStop __attribute__((deprecated("Deprecated in v3.3.6, use the close callback")));

@end


/**
 @struct AdColonyAdSize
 @abstract Size for banner ads
 */


/** AdColony ad size */
typedef struct AdColonyAdSize AdColonyAdSize;

/**
 @function AdColonyAdSizeMake
 @abstract Get a custom AdColonyAdSize
 @discussion Use this method if you want to display non-standard ad size banner. Otherwise, use one of the standard size constants.
 @param width height for a banner ad.
 @param height width for a banner ad.
 */
extern AdColonyAdSize AdColonyAdSizeMake(CGFloat width, CGFloat height);

/**
 @function AdColonyAdSizeFromCGSize
 @abstract Get a custom AdColonyAdSize from CGSize.
 @discussion Use this method if you want to display non-standard ad size banner. Otherwise, use one of the standard size constants.
 @param size The size for a banner ad.
 */
extern AdColonyAdSize AdColonyAdSizeFromCGSize(CGSize size);

/**
 @const kAdColonyAdSizeBanner
 @abstract 320 x 50
 @discussion The constant for a banner with 320 in width and 50 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeBanner;

/**
 @const kAdColonyAdSizeMediumRectangle
 @abstract 300 x 250
 @discussion The constant for a banner with 300 in width and 250 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeMediumRectangle;

/**
 @const kAdColonyAdSizeLeaderboard
 @abstract 728 x 90
 @discussion The constant for a banner with 728 in width and 90 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeLeaderboard;

/**
 @const kAdColonyAdSizeSkyscraper
 @abstract 160 x 600
 @discussion The constant for a banner with 160 in width and 600 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeSkyscraper;

@interface AdColony : NSObject

/** @name Starting AdColony */

/**
 @abstract Configures AdColony specifically for your app; required for usage of the rest of the API.
 @discussion This method returns immediately; any long-running work such as network connections are performed in the background.
 AdColony does not begin preparing ads for display or performing reporting until after it is configured by your app.
 The required appID and zoneIDs parameters for this method can be created and retrieved at the [Control Panel](http://clients.adcolony.com).
 If either of these are `nil`, app will be unable to play ads and AdColony will only provide limited reporting and install-tracking functionality.
 Please note the completion handler. You should not start requesting ads until it has fired.
 If there is a configuration error, the set of zones passed to the completion handler will be nil.
 @param appID The AdColony app ID for your app.
 @param zoneIDs An array of at least one AdColony zone ID string.
 @param options (optional) Configuration options for your app.
 @param completion (optional) A block of code to be executed upon completion of the configuration operation. Dispatched on main thread.
 @see AdColonyAppOptions
 @see AdColonyZone
 */
+ (void)configureWithAppID:(NSString *)appID zoneIDs:(NSArray<NSString *> *)zoneIDs options:(nullable AdColonyAppOptions *)options completion:(nullable void (^)(NSArray<AdColonyZone *> *zones))completion;

/** @name Requesting Ads */

/**
 @abstract Requests an AdColonyInterstitial.
 @discussion This method returns immediately, before the ad request completes.
 If the request is successful, an AdColonyInterstitial object will be passed to the success block.
 If the request is unsuccessful, the failure block will be called and an AdColonyAdRequestError will be passed to the handler.
 @param zoneID The AdColony zone identifier string indicating which zone the ad request is for.
 @param options An AdColonyAdOptions object used to set configurable aspects of the ad request.
 @param success A block of code to be executed if the ad request succeeds. Dispatched on main thread.
 @param failure (optional) A block of code to be executed if the ad request does not succeed. Dispatched on main thread.
 @see AdColonyAdOptions
 @see AdColonyInterstitial
 @see AdColonyAdRequestError
 */
+ (void)requestInterstitialInZone:(NSString *)zoneID options:(nullable AdColonyAdOptions *)options success:(void (^)(AdColonyInterstitial *ad))success failure:(nullable void (^)(AdColonyAdRequestError *error))failure __attribute__((deprecated("Deprecated in v4.0.0, use delgate object instead of callback blocks.")));

/**
 @abstract Requests an AdColonyInterstitial.
 @discussion This method returns immediately, before the ad request completes.
 If the request is successful, an AdColonyInterstitial object will be passed to the success block.
 If the request is unsuccessful, the failure block will be called and an AdColonyAdRequestError will be passed to the handler.
 @param zoneID The AdColony zone identifier string indicating which zone the ad request is for.
 @param options An AdColonyAdOptions object used to set configurable aspects of the ad request.
 @param delegate Interstitial delegate object
 @see AdColonyAdOptions
 @see AdColonyInterstitial
 @see AdColonyInterstitialDelegate
 @see AdColonyAdRequestError
 */
+ (void)requestInterstitialInZone:(NSString *)zoneID options:(nullable AdColonyAdOptions *)options andDelegate:(id<AdColonyInterstitialDelegate> _Nonnull)delegate;

/**
 @abstract Requests an AdColonyNativeAdView.
 @discussion This method returns immediately, before the ad request completes.
 If the request is successful, an AdColonyNativeAdView object will be passed to the success block.
 If the request is unsuccessful, the failure block will be called and an AdColonyAdRequestError will be passed to the handler.
 @param zoneID The AdColony zone identifier string indicating which zone the ad request is for.
 @param size The desired width and height of the native ad view.
 @param options An AdColonyAdOptions object used to set configurable aspects of the ad request.
 @param viewController Host view controller
 @param success A block of code to be executed if the ad request succeeds. Dispatched on main thread.
 @param failure (optional) A block of code to be executed if the ad request does not succeed. Dispatched on main thread.
 @see AdColonyAdOptions
 @see AdColonyNativeAdView
 @see AdColonyAdRequestError
 */
+ (void)requestNativeAdViewInZone:(NSString *)zoneID size:(CGSize)size options:(nullable AdColonyAdOptions *)options viewController:(UIViewController *)viewController success:(void (^)(AdColonyNativeAdView *ad))success failure:(nullable void (^)(AdColonyAdRequestError *error))failure __attribute__((deprecated("Deprecated in v3.3.6, Native Ads will be removed in a future release")));

/** @name Zone */

/**
 @abstract Retrieves an AdColonyZone object.
 @discussion AdColonyZone objects aggregate informative data about unique AdColony zones such as their identifiers, whether or not they are configured for rewards, etc.
 AdColony zone IDs can be created and retrieved at the [Control Panel](http://clients.adcolony.com).
 @param zoneID The AdColony zone identifier string indicating which zone to return.
 @return An AdColonyZone object. Returns `nil` if an invalid zone ID is passed.
 @see AdColonyZone
 */
+ (nullable AdColonyZone *)zoneForID:(NSString *)zoneID;

/** @name Device Identifiers */

/**
 @abstract Retrieves the device's current advertising identifier.
 @discussion The identifier is an alphanumeric string unique to each device, used by systems to facilitate ad serving.
 Note that this method can be called before `configureWithAppID:zoneIDs:options:completion`.
 @return The device's current advertising identifier.
 */
+ (NSString *)getAdvertisingID;

/**
 @abstract Retrieves a custom identifier for the current user if it has been set.
 @discussion This is an arbitrary, application-specific identifier string for the current user.
 To configure this identifier, use the `setOption:withStringValue` method of the AdColonyAppOptions object you pass to `configureWithAppID:zoneIDs:options:completion`.
 Note that if this method is called before `configureWithAppID:zoneIDs:options:completion`, it will return an empty string.
 @return The identifier for the current user.
 @see AdColonyAppOptions
 */
+ (NSString *)getUserID;

/** @name App Options */

/**
 @abstract Sets the current, global set of AdColonyAppOptions.
 @discussion Use the object's option-setting methods to configure currently-supported options.
 @param options The AdColonyAppOptions object to be used for configuring global options such as a custom user identifier.
 @see AdColonyAppOptions
 */
+ (void)setAppOptions:(AdColonyAppOptions *)options;

/**
 @abstract Returns the current, global set of AdColonyAppOptions.
 @discussion Use this method to obtain the current set of app options used to configure SDK behavior.
 If no options object has been set, this method will return `nil`.
 @return The current AdColonyAppOptions object being used by the SDK.
 @see AdColonyAppOptions
 */
+ (nullable AdColonyAppOptions *)getAppOptions;

/** @name Custom Messages */

/**
 @abstract Sends a custom message to the AdColony SDK.
 @discussion Use this method to send custom messages to the AdColony SDK.
 @param type The type of the custom message. Must be 128 characters or less.
 @param content The content of the custom message. Must be 1024 characters or less.
 @param reply A block of code to be executed when a reply is sent to the custom message.
 */
+ (void)sendCustomMessageOfType:(NSString *)type withContent:(nullable NSString *)content reply:(nullable void (^)(_Nullable id reply))reply;

/** @name In-app purchase (IAP) Tracking */

/**
 @abstract Reports IAPs within your application.
 @discussion Note that this API can be used to report standard IAPs as well as those triggered by AdColony’s IAP Promo (IAPP) advertisements.
 Leveraging this API will improve overall ad targeting for your application.
 @param transactionID An NSString representing the unique SKPaymentTransaction identifier for the IAP. Must be 128 chars or less.
 @param productID An NSString identifying the purchased product. Must be 128 chars or less.
 @param price (optional) An NSNumber indicating the total price of the items purchased.
 @param currencyCode (optional) An NSString indicating the real-world, three-letter ISO 4217 (e.g. USD) currency code of the transaction.
 */
+ (void)iapCompleteWithTransactionID:(NSString *)transactionID productID:(NSString *)productID price:(nullable NSNumber *)price currencyCode:(nullable NSString *)currencyCode;

/** @name SDK Version */

/**
 @abstract Retrieve a string-based representation of the SDK version.
 @discussion The returned string will be in the form of "<Major Version>.<Minor Version>.<External Revision>.<Internal Revision>"
 @return The current AdColony SDK version string.
 */
+ (NSString *)getSDKVersion;
@end
NS_ASSUME_NONNULL_END

#endif /* OMAdColonyClass_h */
