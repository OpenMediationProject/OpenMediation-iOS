// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMopubNativeClass_h
#define OMMopubNativeClass_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MPNativeAd;
@class MPNativeAdRequest;
@class MPNativeAdRequestTargeting;

typedef CGSize (^MPNativeViewSizeHandler)(CGFloat maximumWidth);

@protocol MPNativeAdRendererSettings <NSObject>

@optional

/**
 * The viewSizeHandler is used to allow the app to configure its native ad view size
 * given a maximum width when using ad placer solutions. This is not called when the
 * app is manually integrating native ads.
 *
 * Your renderer settings object should expose a settable viewSizeHandler property so the
 * application can choose how it wants to size its ad views. Your renderer will be able
 * to use the view size handler from your settings object.
 */
@property (nonatomic, readwrite, copy) MPNativeViewSizeHandler viewSizeHandler;

@end

@interface MPStaticNativeAdRendererSettings : NSObject <MPNativeAdRendererSettings>

/**
 * A rendering class that must be a UIView that implements the MPNativeAdRendering protocol.
 * The ad will be rendered to a view of this class type.
 */
@property (nonatomic, assign) Class renderingViewClass;

/**
 * A block that returns the size of the view given a maximum width. This needs to be set when
 * used in conjunction with ad placer classes so the ad placers can correctly size the cells
 * that contain the ads.
 *
 * viewSizeHandler is not used for manual native ad integration. You must set the
 * frame of your manually integrated native ad view.
 */
@property (nonatomic, readwrite, copy) MPNativeViewSizeHandler viewSizeHandler;

@end


@interface MPNativeAdRendererConfiguration : NSObject

/*
 * The settings that inform the ad renderer about how it should render the ad.
 */
@property (nonatomic, strong) id<MPNativeAdRendererSettings> rendererSettings;

/*
 * The renderer class used to render supported custom events.
 */
@property (nonatomic, assign) Class rendererClass;

/*
 * An array of custom event class names (as strings) that the renderClass can
 * render.
 */
@property (nonatomic, strong) NSArray *supportedCustomEvents;

@end


@class CLLocation;

/**
 Optional targeting parameters to use when requesting an ad.
 */
@interface MPAdTargeting : NSObject

/**
 The maximum creative size that can be safely rendered in the ad container.
 The size should be in points.
 */
@property (nonatomic, assign) CGSize creativeSafeSize;

/**
 A string representing a set of non-personally identifiable keywords that should be passed
 to the MoPub ad server to receive more relevant advertising.

 @remark If a user is in General Data Protection Regulation (GDPR) region and MoPub doesn't obtain
 consent from the user, @c keywords will still be sent to the server.
 */
@property (nonatomic, copy) NSString * keywords;

/**
 Key-value pairs that are locally available to the custom event.
 */
@property (nonatomic, copy) NSDictionary * localExtras;

/**
 A user's location that should be passed to the MoPub ad server to receive more relevant advertising.
 */
@property (nonatomic, copy) CLLocation * location;

/**
 A string representing a set of personally identifiable keywords that should be passed to the MoPub ad server to receive
 more relevant advertising.

 Keywords are typically used to target ad campaigns at specific user segments. They should be
 formatted as comma-separated key-value pairs (e.g. "marital:single,age:24").

 On the MoPub website, keyword targeting options can be found under the "Advanced Targeting"
 section when managing campaigns.

 @remark If a user is in General Data Protection Regulation (GDPR) region and MoPub doesn't obtain
 consent from the user, @c userDataKeywords will not be sent to the server.
 */
@property (nonatomic, copy) NSString * userDataKeywords;

/**
 Initializes ad targeting information.
 @param size The maximum creative size that can be safely rendered in the ad container.
 The size should be in points.
 */
- (instancetype)initWithCreativeSafeSize:(CGSize)size;

/**
 Initializes ad targeting information.
 @param size The maximum creative size that can be safely rendered in the ad container.
 The size should be in points.
 */
+ (instancetype)targetingWithCreativeSafeSize:(CGSize)size;

#pragma mark - Unavailable Initializers

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end


@interface MPNativeAdRequestTargeting : MPAdTargeting

/**
 Creates and returns an empty @c MPNativeAdRequestTargeting object.
 @return A newly initialized @c MPNativeAdRequestTargeting object.
 */
+ (MPNativeAdRequestTargeting *)targeting;

/**
 A set of defined strings that correspond to assets for the intended native ad
 object. This set should contain only those assets that will be displayed in the ad.

 The MoPub ad server will attempt to only return the assets in @c desiredAssets.
 */
@property (nonatomic, strong) NSSet * desiredAssets;

@end


typedef void(^MPNativeAdRequestHandler)(MPNativeAdRequest *request,
                                      MPNativeAd *response,
                                      NSError *error);

////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * The `MPNativeAdRequest` class is used to manage individual requests to the MoPub ad server for
 * native ads.
 *
 * @warning **Note:** This class is meant for one-off requests for which you intend to manually
 * process the native ad response. If you are using `MPTableViewAdPlacer` or
 * `MPCollectionViewAdPlacer` to display ads, there should be no need for you to use this class.
 */

@interface MPNativeAdRequest : NSObject

/** @name Targeting Information */

/**
 * An object representing targeting parameters that can be passed to the MoPub ad server to
 * serve more relevant advertising.
 */
@property (nonatomic, strong) MPNativeAdRequestTargeting *targeting;

/** @name Initializing and Starting an Ad Request */

/**
 * Initializes a request object.
 *
 * @param identifier The ad unit identifier for this request. An ad unit is a defined placement in
 * your application set aside for advertising. Ad unit IDs are created on the MoPub website.
 *
 * @param rendererConfigurations An array of MPNativeAdRendererConfiguration objects that control how
 * the native ad is rendered.
 *
 * @return An `MPNativeAdRequest` object.
 */
+ (MPNativeAdRequest *)requestWithAdUnitIdentifier:(NSString *)identifier rendererConfigurations:(NSArray *)rendererConfigurations;

/**
 * Executes a request to the MoPub ad server.
 *
 * @param handler A block to execute when the request finishes. The block includes as parameters the
 * request itself and either a valid MPNativeAd or an NSError object indicating failure.
 */
- (void)startWithCompletionHandler:(MPNativeAdRequestHandler)handler;

@end

@protocol MPNativeAdAdapter;

/**
 * Classes that conform to the `MPNativeAdAdapter` protocol can have an
 * `MPNativeAdAdapterDelegate` delegate object. You use this delegate to communicate
 * native ad events (such as impressions and clicks occurring) back to the MoPub SDK.
 */
@protocol MPNativeAdAdapterDelegate <NSObject>

@required

/**
 * Asks the delegate for a view controller to use for presenting modal content, such as the in-app
 * browser that can appear when an ad is tapped.
 *
 * @return A view controller that should be used for presenting modal content.
 */
- (UIViewController *)viewControllerForPresentingModalView;

/**
 * You should call this method when your adapter's modal is about to be presented.
 *
 * @param adapter The adapter that will present the modal.
 */
- (void)nativeAdWillPresentModalForAdapter:(id<MPNativeAdAdapter>)adapter;

/**
 * You should call this method when your adapter's modal has been dismissed.
 *
 * @param adapter The adapter that dismissed the modal.
 */
- (void)nativeAdDidDismissModalForAdapter:(id<MPNativeAdAdapter>)adapter;

/**
 * You should call this method when your the user will leave the application due to interaction with the ad.
 *
 * @param adapter The adapter that represents the ad that caused the user to leave the application.
 */
- (void)nativeAdWillLeaveApplicationFromAdapter:(id<MPNativeAdAdapter>)adapter;

@optional

/**
 * This method is called before the backing native ad logs an impression.
 *
 * @param adAdapter You should pass `self` to allow the MoPub SDK to associate this event with the
 * correct instance of your ad adapter.
 */
- (void)nativeAdWillLogImpression:(id<MPNativeAdAdapter>)adAdapter;

/**
 * This method is called when the user interacts with the ad.
 *
 * @param adAdapter You should pass `self` to allow the MoPub SDK to associate this event with the
 * correct instance of your ad adapter.
 */
- (void)nativeAdDidClick:(id<MPNativeAdAdapter>)adAdapter;

@end

@protocol MPNativeAdAdapter <NSObject>

@required

/** @name Ad Resources */

/**
 * Provides a dictionary of all publicly accessible assets (such as title and text) for the
 * native ad.
 *
 * When possible, you should place values in the returned dictionary such that they correspond to
 * the pre-defined keys in the @c MPNativeAdConstants header file.
 */
@property (nonatomic, readonly) NSDictionary *properties;

/**
 * The default click-through URL for the ad.
 *
 * This may safely be set to nil if your network doesn't expose this value (for example, it may only
 * provide a method to handle a click, lacking another for retrieving the URL itself).
 */
@property (nonatomic, readonly) NSURL *defaultActionURL;

/** @name Handling Ad Interactions */

@optional

/**
 * Tells the object to open the specified URL using an appropriate mechanism.
 *
 * @param URL The URL to be opened.
 * @param controller The view controller that should be used to present the modal view controller.
 *
 * Your implementation of this method should either forward the request to the underlying
 * third-party ad object (if it has built-in support for handling ad interactions), or open an
 * in-application modal web browser or a modal App Store controller.
 */
- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller;

/**
 * Determines whether MPNativeAd should track clicks
 *
 * If not implemented, this will be assumed to return NO, and MPNativeAd will track clicks.
 * If this returns YES, then MPNativeAd will defer to the MPNativeAdAdapterDelegate callbacks to
 * track clicks.
 */
- (BOOL)enableThirdPartyClickTracking;

/**
 * Tracks a click for this ad.
 *
 * To avoid reporting discrepancies, you should only implement this method if the third-party ad
 * network requires clicks to be reported manually.
 */
- (void)trackClick;

/**
 * The `MPNativeAdAdapterDelegate` to send messages to as events occur.
 *
 * The `delegate` object defines several methods that you should call in order to inform MoPub
 * of interactions with the ad. This delegate needs to be implemented if third party impression and/or
 * click tracking is enabled.
 */
@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

/** @name Responding to an Ad Being Attached to a View */

/**
 * This method will be called when your ad's content is about to be loaded into a view.
 *
 * @param view A view that will contain the ad content.
 *
 * You should implement this method if the underlying third-party ad object needs to be informed
 * of this event.
 */
- (void)willAttachToView:(UIView *)view;

/**
 * This method will be called when your ad's content is about to be loaded into a view; subviews which contain ad
 * contents are also included.
 *
 * Note: If both this method and `willAttachToView:` are implemented, ONLY this method will be called.
 *
 * @param view A view that will contain the ad content.
 * @param adContentViews Array of views that contains the ad's content views.
 *
 * You should implement this method if the underlying third-party ad object needs to be informed of this event.
 */
- (void)willAttachToView:(UIView *)view withAdContentViews:(NSArray *)adContentViews;

/**
 * This method will be called if your implementation provides a privacy icon through the properties dictionary
 * and the user has tapped the icon.
 */
- (void)displayContentForDAAIconTap;

/**
 * Return your ad's privacy information icon view.
 *
 * You should implement this method if your ad supplies its own view for its privacy information icon.
 */
- (UIView *)privacyInformationIconView;

/**
 * Return your ad's main media view.
 *
 * You should implement this method if your ad supplies its own view for the main media view which is typically
 * an image or video. If you implement this method, the SDK will not make any other attempts at retrieving
 * the main media asset.
 */
- (UIView *)mainMediaView;

/**
 * Return your ad's icon view.
 *
 * You should implement this method if your ad supplies its own view for the icon view which is typically
 * an image. If you implement this method, the SDK will not make any other attempts at retrieving
 * the icon asset.
 */
- (UIView *)iconMediaView;

@end

@protocol MPNativeAdRenderer <NSObject>

@required

/**
 * You must construct and return an MPNativeAdRendererConfiguration object specific for your renderer. You must
 * set all the properties on the configuration object.
 *
 * @param rendererSettings Application defined settings that you should store in the configuration object that you
 * construct.
 *
 * @return A configuration object that allows the MoPub SDK to instantiate your renderer with the application
 * settings and for the supported ad types.
 */
+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings;

/**
 * This is the init method that will be called when the MoPub SDK initializes your renderer.
 *
 * @param rendererSettings The renderer settings object that corresponds to your renderer.
 */
- (instancetype)initWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings;

/**
 * You must return a native ad view when `-retrieveViewWithAdapter:error:` is called. Ideally, you should create a native view
 * each time this is called as holding onto the view may end up consuming a lot of memory when many ads are being shown.
 * However, it is OK to hold a strong reference to the view if you must.
 *
 * @param adapter Your custom event's adapter class that contains the network specific data necessary to render the ad to
 * a view.
 * @param error If you can't construct a view for whatever reason, you must fill in this error object.
 *
 * @return If successful, the method will return a native view presenting the ad. If it
 * is unsuccessful at retrieving a view, it will return nil and create
 * an error object for the error parameter.
 */
- (UIView *)retrieveViewWithAdapter:(id<MPNativeAdAdapter>)adapter error:(NSError **)error;

@optional

/**
 * The viewSizeHandler is used to allow the app to configure its native ad view size
 * given a maximum width when using ad placer solutions. This is not called when the
 * app is manually integrating native ads.
 *
 * You should obtain the renderer's viewSizeHandler from the settings object in
 * `-initWithRendererSettings:`.
 */
@property (nonatomic, readonly) MPNativeViewSizeHandler viewSizeHandler;

/**
 * The MoPubSDK will notify your renderer when your native ad's view has moved in
 * the hierarchy. superview will be nil if the native ad's view has been removed
 * from the view hierarchy.
 *
 * The view your renderer creates is attached to another view before being added
 * to the view hierarchy. As a result, the superview argument will not be the renderer's ad view's superview.
 *
 * @param superview The app's view that contains the native ad view. There is an
 * intermediate view between the renderer's ad view and the app's view.
 */
- (void)adViewWillMoveToSuperview:(UIView *)superview;

/**
 *
 * The MoPubSDK will call this method when the user has tapped the ad and will
 * invoke the clickthrough action.
 *
 */
- (void)nativeAdTapped;

@end


@interface MPBaseNativeAdRenderer : NSObject

@end

@interface MPStaticNativeAdRenderer : MPBaseNativeAdRenderer <MPNativeAdRenderer>

@property (nonatomic, readonly) MPNativeViewSizeHandler viewSizeHandler;

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings;

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings
                                               additionalSupportedCustomEvents:(NSArray *)additionalSupportedCustomEvents;

@end

@interface MPImpressionData : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)impressionDataDictionary NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, copy, readonly) NSNumber * _Nullable publisherRevenue;
@property (nonatomic, copy, readonly) NSString * _Nullable impressionID;
@property (nonatomic, copy, readonly) NSString * _Nullable adUnitID;
@property (nonatomic, copy, readonly) NSString * _Nullable adUnitName;
@property (nonatomic, copy, readonly) NSString * _Nullable adUnitFormat;
@property (nonatomic, copy, readonly) NSString * _Nullable currency;
@property (nonatomic, copy, readonly) NSString * _Nullable adGroupID;
@property (nonatomic, copy, readonly) NSString * _Nullable adGroupName;
@property (nonatomic, copy, readonly) NSString * _Nullable adGroupType;
@property (nonatomic, copy, readonly) NSNumber * _Nullable adGroupPriority;
@property (nonatomic, copy, readonly) NSString * _Nullable country;
@property (nonatomic, assign, readonly) id precision;
@property (nonatomic, copy, readonly) NSString * _Nullable networkName;
@property (nonatomic, copy, readonly) NSString * _Nullable networkPlacementID;

@property (nonatomic, copy, readonly) NSData * _Nullable jsonRepresentation;

@end


@protocol MPMoPubAdDelegate;

/**
 This protocol defines functionality that is shared between all MoPub ads.
 */
@protocol MPMoPubAd <NSObject>

@required
/**
 All MoPub ads have a delegate to call back when certain events occur.
 */
@property (nonatomic, weak, nullable) id<MPMoPubAdDelegate> delegate;

@end

/**
 This protocol defines callback events shared between all MoPub ads.
 */
@protocol MPMoPubAdDelegate <NSObject>

@optional
/**
 Called when an impression is fired on the @c MPMoPubAd instance. Includes information about the impression if applicable.

 @param ad The @c MPMoPubAd instance that fired the impression
 @param impressionData Information about the impression, or @c nil if the server didn't return any information.
 */
- (void)mopubAd:(id<MPMoPubAd>)ad didTrackImpressionWithImpressionData:(MPImpressionData * _Nullable)impressionData;

@end

@protocol MPNativeAdDelegate;

@interface MPNativeAd : NSObject

/** @name Ad Resources */

/**
 * The delegate of the `MPNativeAd` object.
 */
@property (nonatomic, weak) id<MPNativeAdDelegate> delegate;

/**
 * A dictionary representing the native ad properties.
 */
@property (nonatomic, readonly) NSDictionary *properties;

- (instancetype)initWithAdAdapter:(id<MPNativeAdAdapter>)adAdapter;

/** @name Retrieving Ad View */

/**
 * Retrieves a rendered view containing the ad.
 *
 * @param error A pointer to an error object. If an error occurs, this pointer will be set to an
 * actual error object containing the error information.
 *
 * @return If successful, the method will return a view containing the rendered ad. The method will
 * return nil if it cannot render the ad data to a view.
 */
- (UIView *)retrieveAdViewWithError:(NSError **)error;

- (void)trackMetricForURL:(NSURL *)URL;

- (void)adViewTapped;

@end

@class MPNativeAd;
@protocol MPNativeAdDelegate <MPMoPubAdDelegate>

@optional

/**
 * Sent when the native ad will present its modal content.
 *
 * @param nativeAd The native ad sending the message.
 */
- (void)willPresentModalForNativeAd:(MPNativeAd *)nativeAd;

/**
 * Sent when a native ad has dismissed its modal content, returning control to your application.
 *
 * @param nativeAd The native ad sending the message.
 */
- (void)didDismissModalForNativeAd:(MPNativeAd *)nativeAd;

/**
 * Sent when a user is about to leave your application as a result of tapping this native ad.
 *
 * @param nativeAd The native ad sending the message.
 */
- (void)willLeaveApplicationFromNativeAd:(MPNativeAd *)nativeAd;

@required

/** @name Managing Modal Content Presentation */

/**
 * Asks the delegate for a view controller to use for presenting modal content, such as the in-app
 * browser that can appear when an ad is tapped.
 *
 * @return A view controller that should be used for presenting modal content.
 */
- (UIViewController *)viewControllerForPresentingModalView;

@end

typedef void (^MPImageDownloadQueueCompletionBlock)(NSDictionary <NSURL *, UIImage *> *result, NSArray *errors);

@interface MPImageDownloadQueue : NSObject

/**
 Return cached image from @c MPNativeCache if available.
 */
- (void)addDownloadImageURLs:(NSArray<NSURL *> *)imageURLs
             completionBlock:(MPImageDownloadQueueCompletionBlock)completionBlock;

- (void)cancelAllDownloads;

@end

@interface MPNativeCache : NSObject

+ (instancetype)sharedCache;

/*
 * Do NOT call any of the following methods on the main thread, potentially lengthy wait for disk IO
 */
- (BOOL)cachedDataExistsForKey:(NSString *)key;
- (NSData *)retrieveDataForKey:(NSString *)key;
- (void)storeData:(NSData *)data forKey:(NSString *)key;
- (void)removeAllDataFromCache;
- (void)setInMemoryCacheEnabled:(BOOL)enabled;

@end

@protocol MPNativeAdRendering <NSObject>

@optional

/**
 * Return the UILabel that your view is using for the main text.
 *
 * @return a UILabel that is used for the main text.
 */
- (UILabel *)nativeMainTextLabel;

/**
 * Return the UILabel that your view is using for the title text.
 *
 * @return a UILabel that is used for the title text.
 */
- (UILabel *)nativeTitleTextLabel;

/**
 * Return the UIImageView that your view is using for the icon image.
 *
 * @return a UIImageView that is used for the icon image.
 */
- (UIImageView *)nativeIconImageView;

/**
 * Return the UIImageView that your view is using for the main image.
 *
 * @return a UIImageView that is used for the main image.
 */
- (UIImageView *)nativeMainImageView;

/**
 * Return the @c UILabel that your view is using for text indicating the
 * sponsor that sponsored the ad.
 *
 * Sometimes sponsor information is not included with the advertisement; in that
 * case, MoPub will set the label's @c text to empty string and the label's @c hidden
 * property to @c YES. Please configure your view to be ready for this possibility.
 *
 * @return a @c UILabel to be used for "Sponsored by Example" text
 */
- (UILabel *)nativeSponsoredByCompanyTextLabel;

/**
 * Specifies custom text for @c nativeSponsoredByCompanyTextLabel, primarily to be used
 * for localization, but also can be used for custom copy, e.g., "Brought to you by Example"
 * rather than the default "Sponsored by Example".
 *
 * If this method is not implemented, or is implemented to return @c nil or empty string, we
 * will use the default "Sponsored by Example"
 *
 * @param sponsorName The name of the sponsor who sponored the native ad
 * @return an assembled string containing @c sponsorName indicating something to the effect
 * of "Sponsored by <sponsorName>"
 */
+ (NSString *)localizedSponsoredByTextWithSponsorName:(NSString *)sponsorName;

/**
 * Return the UIView that your view is using for the video.
 * You only need to implement this when you are serving video ads.
 *
 * @return a UIView that is used to hold the video.
 */
- (UIView *)nativeVideoView;

/**
 * Returns the UILabel that your view is using for the call to action (cta) text.
 *
 * @return a UILabel that is used for the cta text.
 */
- (UILabel *)nativeCallToActionTextLabel;

/**
 * Returns the UIImageView that your view is using for the privacy information icon.
 *
 * @return a UIImageView that is used for the privacy information icon.
 */
- (UIImageView *)nativePrivacyInformationIconImageView;

/**
 * This method is called if the ad contains a star rating.
 *
 * Implement this method if you expect and wish to display a star rating.
 *
 * @param starRating An NSNumber that is a float in the range of 0.0f and 5.0f.
 */
- (void)layoutStarRating:(NSNumber *)starRating;

/**
 * This method allows you to insert your custom native ad elements into your view.
 *
 * This method will be called when your ad view is added to the view hierarchy.
 *
 * @param customProperties Dictionary that contains custom native ad elements.
 * @param imageLoader Use this object to load your custom images by calling `loadImageForURL:intoImageView:`.
 */
- (void)layoutCustomAssetsWithProperties:(NSDictionary *)customProperties imageLoader:(id )imageLoader;

/**
 * Specifies a nib object containing a view that should be used to render ads.
 *
 * If you want to use a nib object to render ads, you must implement this method.
 *
 * @return an initialized UINib object. This is not allowed to be `nil`.
 */
+ (UINib *)nibForAd;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMopubNativeClass_h */
