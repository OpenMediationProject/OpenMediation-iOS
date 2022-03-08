// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAppLovinBannerClass_h
#define OMAppLovinBannerClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMAppLovinClass.h"

NS_ASSUME_NONNULL_BEGIN

@class ALAd;
@class ALSdk;
@class ALAdService;
@class ALAdSize;
@class ALAdView;
@class ALAdViewEventDelegate;

/**
 * This enum contains possible error codes that are returned when the ad view fails to display an ad.
 */
typedef NS_ENUM(NSInteger, ALAdViewDisplayErrorCode)
{
    /**
     * The ad view failed to display an ad for an unspecified reason.
     */
    ALAdViewDisplayErrorCodeUnspecified
};

/**
 * This protocol defines a listener for ad view events.
 */
@protocol ALAdViewEventDelegate <NSObject>

@optional

/**
 * The SDK invokes this method after the ad view begins to present fullscreen content.
 *
 * The SDK invokes this method on the main UI thread.
 *
 * Note: Some banners, when clicked, will expand into fullscreen content, whereupon the SDK will call this method.
 *
 * @param ad     Ad for which the ad view presented fullscreen content.
 * @param adView Ad view that presented fullscreen content.
 */
- (void)ad:(ALAd *)ad didPresentFullscreenForAdView:(ALAdView *)adView;

/**
 * The SDK invokes this method as the fullscreen content is about to be dismissed.
 *
 * The SDK invokes this method on the main UI thread.
 *
 * @param ad     Ad for which the fullscreen content is to be dismissed.
 * @param adView Ad view that contains the ad for which the fullscreen content is to be dismissed.
 */
- (void)ad:(ALAd *)ad willDismissFullscreenForAdView:(ALAdView *)adView;

/**
 * The SDK invokes this method after the fullscreen content is dismissed.
 *
 * The SDK invokes this method on the main UI thread.
 *
 * @param ad     Ad for which the fullscreen content is dismissed.
 * @param adView Ad view that contains the ad for which the fullscreen content is dismissed.
 */
- (void)ad:(ALAd *)ad didDismissFullscreenForAdView:(ALAdView *)adView;

/**
 * The SDK invokes this method when the user is about to be taken out of the application after the user clicks on the ad.
 *
 * The SDK invokes this method on the main UI thread.
 *
 * @param ad     Ad for which the user will be taken out of the application.
 * @param adView Ad view that contains the ad for which the user will be taken out of the application.
 */
- (void)ad:(ALAd *)ad willLeaveApplicationForAdView:(ALAdView *)adView;

/**
 * The SDK invokes this method when the user returns to the application after the user clicks on the ad.
 *
 * The SDK invokes this method on the main UI thread.
 *
 * @param ad     Ad from which the user will return to the application.
 * @param adView Ad view that contains the ad from which the user will return to the application.
 */
- (void)ad:(ALAd *)ad didReturnToApplicationForAdView:(ALAdView *)adView;

/**
 * The SDK invokes this method if the ad view fails to display an ad.
 *
 * The SDK invokes this method on the main UI thread.
 *
 * @param ad     Ad that the ad view failed to display.
 * @param adView Ad view that failed to display the ad.
 * @param code   Error code that specifies the reason why the ad view failed to display the ad.
 */
- (void)ad:(ALAd *)ad didFailToDisplayInAdView:(ALAdView *)adView withError:(ALAdViewDisplayErrorCode)code;

@end



@interface ALAdView : UIView

/**
 * @name Ad Delegates
 */

/**
 * An object that conforms to the @c ALAdLoadDelegate protocol. If you provide a value for @c adLoadDelegate in your instance, the SDK will notify
 * this delegate of ad load events.
 *
 * @warning This delegate is retained strongly and might lead to retain cycles if delegate holds strong reference to this @c ALAdView.
 */
@property (nonatomic, strong, nullable) IBOutlet id<ALAdLoadDelegate> adLoadDelegate;

/**
 * An object that conforms to the @c ALAdDisplayDelegate protocol. If you provide a value for @c adDisplayDelegate in your instance, the SDK will
 * notify this delegate of ad show/hide events.
 *
 * @warning This delegate is retained strongly and might lead to retain cycles if delegate holds strong reference to this @c ALAdView.
 */
@property (nonatomic, strong, nullable) IBOutlet id<ALAdDisplayDelegate> adDisplayDelegate;

/**
 * An object that conforms to the @c ALAdViewEventDelegate protocol. If you provide a value for @c adEventDelegate in your instance, the SDK will
 * notify this delegate of @c ALAdView -specific events.
 *
 * @warning This delegate is retained strongly and might lead to retain cycles if delegate holds strong reference to this @c ALAdView.
 */
@property (nonatomic, strong, nullable) IBOutlet id<ALAdViewEventDelegate> adEventDelegate;

/**
 * @name Ad View Configuration
 */

/**
 * The size of ads to load within this @c ALAdView.
 */
@property (nonatomic, strong) ALAdSize *adSize;

/**
 * The zone identifier this @c ALAdView was initialized with and is loading ads for, if any.
 */
@property (nonatomic, copy, readonly, nullable) NSString *zoneIdentifier;

/**
 * Whether or not this ad view should automatically load the ad when iOS inflates it from a StoryBoard or from a nib file (when
 * @code -[UIView awakeFromNib] @endcode is called). The default value is @c NO which means you are responsible for loading the ad by invoking
 * @code -[ALAdView loadNextAd] @endcode.
 */
@property (nonatomic, assign, getter=isAutoloadEnabled, setter=setAutoloadEnabled:) BOOL autoload;

/**
 * @name Loading and Rendering Ads
 */

/**
 * Loads <em>and</em> displays an ad into the view. This method returns immediately.
 *
 * <b>Note:</b> To load the ad but not display it, use @code +[ALSdk shared] @endcode ⇒ @code [ALSDK adService] @endcode
 *              ⇒ @code -[ALAdService loadNextAd:andNotify:] @endcode, then @code -[ALAdView render:] @endcode to render it.
 */
- (void)loadNextAd;

/**
 * Renders a specific ad that was loaded via @c ALAdService.
 *
 * @param ad Ad to render.
 */
- (void)render:(ALAd *)ad;

/**
 * @name Initialization
 */

/**
 * Initializes the ad view with a given size.
 *
 * @param size @c ALAdSize that represents the size of this ad. For example, @code [ALAdSize banner] @endcode.
 *
 * @return A new instance of @c ALAdView.
 */
- (instancetype)initWithSize:(ALAdSize *)size;

/**
 * Initializes the ad view for a given size and zone.
 *
 * @param size           @c ALAdSize that represents the size of this ad. For example, @code [ALAdSize banner] @endcode.
 * @param zoneIdentifier Identifier for the zone this @c ALAdView should load ads for.
 *
 * @return A new instance of @c ALAdView.
 */
- (instancetype)initWithSize:(ALAdSize *)size zoneIdentifier:(nullable NSString *)zoneIdentifier;

/**
 * Initializes the ad view with a given SDK and size.
 *
 * @param sdk  Instance of @c ALSdk to use.
 * @param size @c ALAdSize that represents the size of this ad. For example, @code [ALAdSize banner] @endcode.
 *
 * @return A new instance of @c ALAdView.
 */
- (instancetype)initWithSdk:(ALSdk *)sdk size:(ALAdSize *)size;

/**
 * Initializes the ad view with a given SDK, size, and zone.
 *
 * @param sdk            Instance of @c ALSdk to use.
 * @param size           @c ALAdSize that represents the size of this ad. For example, @code [ALAdSize banner] @endcode.
 * @param zoneIdentifier Identifier for the zone that this @c ALAdView should load ads for.
 *
 * @return A new instance of @c ALAdView.
 */
- (instancetype)initWithSdk:(ALSdk *)sdk size:(ALAdSize *)size zoneIdentifier:(nullable NSString *)zoneIdentifier;

/**
 * Initializes the ad view with a given frame, ad size, and SDK instance.
 *
 * @param frame  Describes the position and dimensions of the ad.
 * @param size   @c ALAdSize that represents the size of this ad. For example, @code [ALAdSize banner] @endcode.
 * @param sdk    Instance of @c ALSdk to use.
 *
 * @return A new instance of @c ALAdView.
 */
- (instancetype)initWithFrame:(CGRect)frame size:(ALAdSize *)size sdk:(ALSdk *)sdk;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

/**
 * This class defines the possible sizes of an ad.
 */
@interface ALAdSize : NSObject

/**
 * Represents the size of a 320×50 banner advertisement.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *banner;

/**
 * Represents the size of a 728×90 leaderboard advertisement (for tablets).
 */
@property (class, nonatomic, strong, readonly) ALAdSize *leader;

/**
 * Represents the size of a 300x250 rectangular advertisement.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *mrec;

/**
 * Represents the size of a full-screen advertisement.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *interstitial;

/**
 * Represents the size of a cross promo advertisement.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *crossPromo;

/**
 * Represents a native ad which can be integrated seemlessly into the environment of your app.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *native;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END

#endif /* OMAppLovinBannerClass_h */
