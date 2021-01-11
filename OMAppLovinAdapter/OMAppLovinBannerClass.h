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
 *  This enum contains possible error codes that should be returned when the ad view fails to display an ad.
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
 * This method is invoked after the ad view presents fullscreen content.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that the ad view presented fullscreen content for.
 * @param adView Ad view that presented fullscreen content.
 */
- (void)ad:(ALAd *)ad didPresentFullscreenForAdView:(ALAdView *)adView;

/**
 * This method is invoked before the fullscreen content is dismissed.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad for which the fullscreen content is to be dismissed for.
 * @param adView Ad view for which the fullscreen content it presented will be dismissed for.
 */
- (void)ad:(ALAd *)ad willDismissFullscreenForAdView:(ALAdView *)adView;

/**
 * This method is invoked after the fullscreen content is dismissed.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad for which the fullscreen content is dismissed for.
 * @param adView Ad view for which the fullscreen content it presented is dismissed for.
 */
- (void)ad:(ALAd *)ad didDismissFullscreenForAdView:(ALAdView *)adView;

/**
 * This method is invoked before the user is taken out of the application after a click.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad for which the user will be taken out of the application for.
 * @param adView Ad view containing the ad for which the user will be taken out of the application for.
 */
- (void)ad:(ALAd *)ad willLeaveApplicationForAdView:(ALAdView *)adView;

/**
 * This method is invoked after the user returns to the application after a click.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad for which the user will return to the application for.
 * @param adView Ad view containing the ad for which the user will return to the application for.
 */
- (void)ad:(ALAd *)ad didReturnToApplicationForAdView:(ALAdView *)adView;

/**
 * This method is invoked if the ad view fails to display an ad.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad for which the ad view failed to display for.
 * @param adView Ad view which failed to display the ad.
 * @param code   Error code specifying the reason why the ad view failed to display ad.
 */
- (void)ad:(ALAd *)ad didFailToDisplayInAdView:(ALAdView *)adView withError:(ALAdViewDisplayErrorCode)code;

@end



/**
 * This class represents a view-based ad - i.e. banner, mrec or leader.
 */
@interface ALAdView : UIView

/**
 * @name Ad Delegates
 */

/**
 *  An object conforming to the ALAdLoadDelegate protocol, which, if set, will be notified of ad load events.
 *
 *  Please note: This delegate is retained strongly and might lead to retain cycles if delegate holds strong reference to this ALAdView.
 */
@property (nonatomic, strong, nullable) IBOutlet id<ALAdLoadDelegate> adLoadDelegate;

/**
 *  An object conforming to the ALAdDisplayDelegate protocol, which, if set, will be notified of ad show/hide events.
 *
 *  Please note: This delegate is retained strongly and might lead to retain cycles if delegate holds strong reference to this ALAdView.
 */
@property (nonatomic, strong, nullable) IBOutlet id<ALAdDisplayDelegate> adDisplayDelegate;

/**
 *  An object conforming to the ALAdViewEventDelegate protocol, which, if set, will be notified of ALAdView-specific events.
 *
 *  Please note: This delegate is retained strongly and might lead to retain cycles if delegate holds strong reference to this ALAdView.
 */
@property (nonatomic, strong, nullable) IBOutlet id<ALAdViewEventDelegate> adEventDelegate;

// Primarily for internal use; banners and mrecs cannot contain videos.
@property (nonatomic, strong, nullable) IBOutlet id<ALAdVideoPlaybackDelegate> adVideoPlaybackDelegate;

/**
 * @name Ad View Configuration
 */

/**
 *  The size of ads to be loaded within this ALAdView.
 */
@property (nonatomic, strong) ALAdSize *adSize;

/**
 *  The zone identifier this ALAdView was initialized with and is loading ads for, if any.
 */
@property (nonatomic, copy, readonly, nullable) NSString *zoneIdentifier;

/**
 *  Whether or not this ALAdView should automatically load and rotate banners.
 *
 *  If YES, ads will be automatically loaded and updated. If NO, you are reponsible for this behavior via [ALAdView loadNextAd]. Defaults to YES.
 */
@property (nonatomic, assign, getter=isAutoloadEnabled, setter=setAutoloadEnabled:) BOOL autoload;
@property (nonatomic, assign, getter=isAutoloadEnabled, setter=setAutoloadEnabled:) BOOL shouldAutoload;

/**
 * @name Loading and Rendering Ads
 */

/**
 * Loads AND displays an ad into the view. This method will return immediately.
 *
 * Please note: To load ad but not display it, use `[[ALSdk shared].adService loadNextAd: ... andNotify: ...]` then `[adView renderAd: ...]` to render it.
 */
- (void)loadNextAd;

/**
 * Render a specific ad that was loaded via ALAdService.
 *
 * @param ad Ad to render. Must not be nil.
 */
- (void)render:(ALAd *)ad;

/**
 * @name Initialization
 */

/**
 *  Initialize the ad view with a given size.
 *
 *  @param size ALAdSize representing the size of this ad. For example, ALAdSize.banner.
 *
 *  @return A new instance of ALAdView.
 */
- (instancetype)initWithSize:(ALAdSize *)size;

/**
 *  Initialize the ad view for a given size and zone.
 *
 *  @param size           ALAdSize representing the size of this ad. For example, ALAdSize.banner.
 *  @param zoneIdentifier Identifier for the zone this ALAdView should load ads for.
 *
 *  @return A new instance of ALAdView.
 */
- (instancetype)initWithSize:(ALAdSize *)size zoneIdentifier:(nullable NSString *)zoneIdentifier;

/**
 *  Initialize the ad view with a given sdk and size.
 *
 *  @param sdk  Instance of ALSdk to use.
 *  @param size ALAdSize representing the size of this ad. For example, ALAdSize.banner.
 *
 *  @return A new instance of ALAdView.
 */
- (instancetype)initWithSdk:(ALSdk *)sdk size:(ALAdSize *)size;

/**
 *  Initialize the ad view with a given sdk, size, and zone.
 *
 *  @param sdk            Instance of ALSdk to use.
 *  @param size           ALAdSize representing the size of this ad. For example, ALAdSize.banner.
 *  @param zoneIdentifier Identifier for the zone this ALAdView should load ads for.
 *
 *  @return A new instance of ALAdView.
 */
- (instancetype)initWithSdk:(ALSdk *)sdk size:(ALAdSize *)size zoneIdentifier:(nullable NSString *)zoneIdentifier;

/**
 * Initialize ad view with a given frame, ad size, and ALSdk instance.
 *
 * @param frame  Frame to use.
 * @param size   Ad size to use.
 * @param sdk    Instance of ALSdk to use.
 *
 * @return A new instance of ALAdView.
 */
- (instancetype)initWithFrame:(CGRect)frame size:(ALAdSize *)size sdk:(ALSdk *)sdk;
- (instancetype)init __attribute__((unavailable("Use one of the other provided initializers")));

@end

@interface ALAdView(ALDeprecated)
@property (strong, atomic, nullable) UIViewController *parentController __deprecated_msg("This property is deprecated and will be removed in a future SDK version.");
- (void)render:(ALAd *)ad overPlacement:(nullable NSString *)placement __deprecated_msg("Placements have been deprecated and will be removed in a future SDK version. Please configure zones from the UI and use them instead.");
@property (readonly, atomic, getter=isReadyForDisplay) BOOL readyForDisplay __deprecated_msg("Checking whether an ad is ready for display has been deprecated and will be removed in a future SDK version. Please use `loadNextAd` or `renderAd:` to display an ad.");
@end

/**
 * This class defines the possible sizes of an ad.
 */
@interface ALAdSize : NSObject

/**
 * Represents the size of a 320x50 banner advertisement.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *banner;

/**
 * Represents the size of a 300x250 rectangular advertisement.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *mrec;

/**
 * Represents the size of a 728x90 leaderboard advertisement (for tablets).
 */
@property (class, nonatomic, strong, readonly) ALAdSize *leader;

/**
 * Represents the size of a full-screen advertisement.
 */
@property (class, nonatomic, strong, readonly) ALAdSize *interstitial;


- (instancetype)init NS_UNAVAILABLE;

@end

@interface ALAdSize(ALDeprecated)
@property (assign, nonatomic, readonly) CGFloat width __deprecated;
@property (assign, nonatomic, readonly) CGFloat height __deprecated;
+ (NSArray *)allSizes __deprecated_msg("Retrieval of all sizes is deprecated and will be removed in a future SDK version.");
+ (ALAdSize *)sizeWithLabel:(NSString *)label orDefault:(ALAdSize *)defaultSize __deprecated_msg("Custom ad sizes are no longer supported; use an existing singleton size like ALAdSize.banner");
@property (nonatomic, strong, readonly, class) ALAdSize *sizeNative __deprecated;
@property (nonatomic, copy, readonly) NSString *label __deprecated_msg("Retrieval of underlying string is deprecated and will be removed in a future SDK version.");
+ (ALAdSize *)sizeBanner __deprecated_msg("Class method `sizeBanner` is deprecated and will be removed in a future SDK version. Please use ALAdSize.banner instead.");
+ (ALAdSize *)sizeMRec __deprecated_msg("Class method `sizeMRec` is deprecated and will be removed in a future SDK version. Please use ALAdSize.mrec instead.");
+ (ALAdSize *)sizeLeader __deprecated_msg("Class method `sizeLeader` is deprecated and will be removed in a future SDK version. Please use ALAdSize.leader instead.");
+ (ALAdSize *)sizeInterstitial __deprecated_msg("Class method `sizeInterstitial` is deprecated and will be removed in a future SDK version. Please use ALAdSize.interstitial instead.");
@end


NS_ASSUME_NONNULL_END

#endif /* OMAppLovinBannerClass_h */
