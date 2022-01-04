// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralNativeClass_h
#define OMMintegralNativeClass_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MTGAdCategory) {
    MTGAD_CATEGORY_ALL  = 0,
    MTGAD_CATEGORY_GAME = 1,
    MTGAD_CATEGORY_APP  = 2,
};

typedef NS_ENUM(NSInteger, MTGAdSourceType) {
    MTGAD_SOURCE_API_OFFER = 1,
    MTGAD_SOURCE_MY_OFFER  = 2,
    MTGAD_SOURCE_FACEBOOK  = 3,
    MTGAD_SOURCE_Mintegral = 4,
    MTGAD_SOURCE_PUBNATIVE = 5,
    MTGAD_SOURCE_MYTARGET  = 7,
    MTGAD_SOURCE_NATIVEX   = 8,
    MTGAD_SOURCE_APPLOVIN  = 9,
};

typedef NS_ENUM(NSInteger, MTGAdTemplateType) {
    MTGAD_TEMPLATE_BIG_IMAGE  = 2,
    MTGAD_TEMPLATE_ONLY_ICON  = 3,
};


@interface MTGCampaign : NSObject

/*!
 @property
 
 @abstract The unique id of the ad
 */
@property (nonatomic, copy  ) NSString       *adId;

/*!
 @property
 
 @abstract The app's package name of the campaign
 */
@property (nonatomic, copy  ) NSString       *packageName;

/*!
 @property
 
 @abstract The app name of the campaign
 */
@property (nonatomic, copy  ) NSString       *appName;

/*!
 @property
 
 @abstract The description of the campaign
 */
@property (nonatomic, copy  ) NSString       *appDesc;

/*!
 @property
 
 @abstract The app size of the campaign
 */
@property (nonatomic, copy  ) NSString       *appSize;

/*!
 @property
 
 @abstract The icon url of the campaign
 */
@property (nonatomic, copy  ) NSString       *iconUrl;

/*!
 @property
 
 @abstract The image url of the campaign. The image size will be 1200px * 627px.
 */
@property (nonatomic, copy  ) NSString       *imageUrl;

/*!
 @property
 
 @abstract The string to show in the clickbutton
 */
@property (nonatomic, copy  ) NSString       *adCall;

/*!
 @property
 
 @abstract The ad source of the campaign
 */
@property (nonatomic, assign) MTGAdSourceType type;

/*!
 @property
 
 @abstract The timestap of the campaign
 */
@property (nonatomic, assign) double      timestamp;

/*!
 @property
 
 @abstract The dataTemplate of the campaign
 */
@property (nonatomic,assign) MTGAdTemplateType    dataTemplate;

/* The size info about adChoice icon */
@property (nonatomic) CGSize adChoiceIconSize;

/*!
@property

@abstract The video  duration of the campaign
*/
@property (nonatomic,assign) NSInteger     videoLength;

/*!
 @method
 
 @abstract
 Loads an icon image from self.iconUrl over the network, or returns the cached image immediately.
 
 @param block Block to handle the loaded image. The image may be nil if error happened.
 */
- (void)loadIconUrlAsyncWithBlock:(void (^)(UIImage *image))block;

/*!
 @method
 
 @abstract
 Loads an image from self.imageUrl over the network, or returns the cached image immediately.
 
 @param block Block to handle the loaded image. The image may be nil if error happened.
 */
- (void)loadImageUrlAsyncWithBlock:(void (^)(UIImage *image))block;


@end


@class MTGNativeAdManager;
@class MTGBidNativeAdManager;

/*!
 @protocol MTGNativeAdManagerDelegate
 @abstract Messages from MTGNativeAdManager indicating success or failure loading ads.
 */

@protocol MTGNativeAdManagerDelegate <NSObject>

@optional


/*!
 
 When the MTGNativeAdManager has finished loading a batch of ads this message will be sent. A batch of ads may be loaded in response to calling loadAds.
 @param nativeAds A array contains native ads (MTGCampaign).
 
 */
- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds DEPRECATED_ATTRIBUTE;
- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


/*!
 
 When the MTGNativeAdManager has reached a failure while attempting to load a batch of ads this message will be sent to the application.
 @param error An NSError object with information about the failure.
 
 */
- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error DEPRECATED_ATTRIBUTE;
- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error nativeManager:(nonnull MTGNativeAdManager *)nativeManager;

/*!
 
 When the MTGNativeAdManager has finished loading a batch of frames this message will be sent. A batch of frames may be loaded in response to calling loadAds.
 @param nativeFrames A array contains native frames (MTGFrame).
 
 @deprecated This method has been deprecated.
 */
- (void)nativeFramesLoaded:(nullable NSArray *)nativeFrames DEPRECATED_ATTRIBUTE;

/*!
 
 When the MTGNativeAdManager has reached a failure while attempting to load a batch of frames this message will be sent to the application.
 @param error An NSError object with information about the failure.
 
 @deprecated This method has been deprecated.
 */
- (void)nativeFramesFailedToLoadWithError:(nonnull NSError *)error DEPRECATED_ATTRIBUTE;

/*!
 
 Sent after an ad has been clicked by a user.
 
 @param nativeAd An MTGCampaign object sending the message.
 */
- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd DEPRECATED_ATTRIBUTE;
- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


/*!
 
 Sent after an ad url did start to resolve.
 
 @param clickUrl The click url of the ad.
 */
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl DEPRECATED_ATTRIBUTE;
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl nativeManager:(nonnull MTGNativeAdManager *)nativeManager;
/*!
 
 Sent after an ad url has jumped to a new url.
 
 @param jumpUrl The url during jumping.
 
 @discussion It will not be called if a ad's final jump url has been cached
 */
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl DEPRECATED_ATTRIBUTE;
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


/*!
 
 Sent after an ad url did reach the final jump url.
 
 @param finalUrl the final jump url of the click url.
 @param error the error generated between jumping.
 */
- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error DEPRECATED_ATTRIBUTE;

- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


- (void)nativeAdImpressionWithType:(MTGAdSourceType)type nativeManager:(nonnull MTGNativeAdManager *)nativeManager;


@end


/*!
 @protocol MTGBidNativeAdManagerDelegate
 @abstract Messages from MTGBidNativeAdManager indicating success or failure loading ads.
 */

@protocol MTGBidNativeAdManagerDelegate <NSObject>

@optional


/*!
 
 When the MTGBidNativeAdManager has finished loading a batch of ads this message will be sent. A batch of ads may be loaded in response to calling loadAds.
 @param nativeAds A array contains native ads (MTGCampaign).
 
 */
- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds bidNativeManager:(nonnull MTGBidNativeAdManager *)bidNativeManager;


/*!
 
 When the MTGBidNativeAdManager has reached a failure while attempting to load a batch of ads this message will be sent to the application.
 @param error An NSError object with information about the failure.
 
 */
- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error bidNativeManager:(nonnull MTGBidNativeAdManager *)bidNativeManager;

/*!
 
 Sent after an ad has been clicked by a user.
 
 @param nativeAd An MTGCampaign object sending the message.
 */
- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd bidNativeManager:(nonnull MTGBidNativeAdManager *)bidNativeManager;


/*!
 
 Sent after an ad url did start to resolve.
 
 @param clickUrl The click url of the ad.
 */
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl bidNativeManager:(nonnull MTGBidNativeAdManager *)bidNativeManager;
/*!
 
 Sent after an ad url has jumped to a new url.
 
 @param jumpUrl The url during jumping.
 
 @discussion It will not be called if a ad's final jump url has been cached
 */
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl bidNativeManager:(nonnull MTGBidNativeAdManager *)bidNativeManager;


/*!
 
 Sent after an ad url did reach the final jump url.
 
 @param finalUrl the final jump url of the click url.
 @param error the error generated between jumping.
 */

- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error bidNativeManager:(nonnull MTGBidNativeAdManager *)bidNativeManager;


- (void)nativeAdImpressionWithType:(MTGAdSourceType)type bidNativeManager:(nonnull MTGBidNativeAdManager *)bidNativeManager;



@end

@interface MTGNativeAdManager : NSObject

/*!
 @property
 
 @abstract The delegate
 
 @discussion All delegate method will be called in main thread.
 */
@property (nonatomic, weak, nullable) id <MTGNativeAdManagerDelegate> delegate;

/*!
 @property
 
 @discussion Show the  loading view when to click on ads.
 The default is yes
 */
@property (nonatomic, assign) BOOL showLoadingView;

/*!
 @property
 
 @discussion DEPRECATED_ATTRIBUTE
 Mintegral support configuration： https://www.mintegral.net
 */
@property (nonatomic, readonly) BOOL videoSupport DEPRECATED_ATTRIBUTE;

/*!
@property

@discussion ad current placementId .
*/

@property (nonatomic, readonly) NSString *_Nullable placementId;

/*!
 @property
 
 @discussion ad current UnitId .
 */
@property (nonatomic, readonly) NSString * _Nonnull currentUnitId;

/**
* get the id of this request ad,call  after nativeAdsLoaded.
*/
@property (nonatomic, readonly) NSString *_Nullable requestId;

/*!
 @property
 
 @discussion The current ViewController of display ad.
 the "ViewController" parameters are assigned as calling the init or Registerview method
 */
@property (nonatomic, weak) UIViewController * _Nullable  viewController;

/*!
 
 Initialize the native ads manager which is for loading ads with more options.
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param templates This array contains objects of MTGTemplate. See more detail in definition of MTGTemplate.
 @param autoCacheImage If you pass YES, SDK will download the image resource automatically when you get the campaign. The default is NO.
 @param adCategory Decide what kind of ads you want to retrieve. Games, apps or all of them. The default is All.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitID:(nonnull NSString *)unitId
                         supportedTemplates:(nullable NSArray *)templates
                             autoCacheImage:(BOOL)autoCacheImage
                                 adCategory:(MTGAdCategory)adCategory
                   presentingViewController:(nullable UIViewController *)viewController;

/*!
 
 The method that kicks off the loading of ads. It may be called again in the future to refresh the ads manually.
 
 @discussion It only works if you init the manager by the 2 method above.
 */
- (void)loadAds;


/*!
 
 This is a method to associate a MTGCampaign with the UIView you will use to display the native ads.
 
 @param view The UIView you created to render all the native ads data elements.
 @param campaign The campaign you associate with the view.
 
 @discussion The whole area of the UIView will be clickable.
 */
- (void)registerViewForInteraction:(nonnull UIView *)view
                      withCampaign:(nonnull MTGCampaign *)campaign;

/*!
 
 This is a method to disconnect a MTGCampaign with the UIView you used to display the native ads.
 
 @param view The UIView you created to render all the native ads data elements.
 
 */
- (void)unregisterView:(nonnull UIView *)view;

/*!
 
 This is a method to associate a MTGCampaign with the UIView you will use to display the native ads and set clickable areas.
 
 @param view The UIView you created to render all the native ads data elements.
 @param clickableViews An array of UIView you created to render the native ads data element, e.g. CallToAction button, Icon image, which you want to specify as clickable.
 @param campaign The campaign you associate with the view.
 
 */
- (void)registerViewForInteraction:(nonnull UIView *)view
                withClickableViews:(nonnull NSArray *)clickableViews
                      withCampaign:(nonnull MTGCampaign *)campaign;

/*!
 
 This is a method to disconnect a MTGCampaign with the UIView you used to display the native ads.
 
 @param view The UIView you created to render all the native ads data elements.
 @param clickableViews An array of UIView you created to render the native ads data element, e.g. CallToAction button, Icon image, which you want to specify as clickable.
 
 */
- (void)unregisterView:(nonnull UIView *)view clickableViews:(nonnull NSArray *)clickableViews;

/*!
 
 This is a method to clean the cache nativeAd.
 
 */
- (void)cleanAdsCache;

/*!
 
 Set the video display area size.
 
 @param size The display area size.
 
 */
-(void)setVideoViewSize:(CGSize)size;

/*!
 
 Set the video display area size.
 
 @param width The display area width.
 @param height The display area height.
 */
-(void)setVideoViewSizeWithWidth:(CGFloat)width height:(CGFloat)height;



/*!
 
 The method that kicks off the loading of frames. It may be called again in the future to refresh the frames manually.
 
 @discussion It only works if you init the manager by the the method above.
 
 @deprecated This method has been deprecated.
 */
- (void)loadFrames DEPRECATED_ATTRIBUTE;


/*!
 Initialize the native ads manager which is for loading frames (MTGFrame).
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param frameNum The number of frame you would like the native ad manager to retrieve.
 @param templates This array contains objects of MTGTemplate. See more detail in definition of MTGTemplate.
 @param autoCacheImage If you pass YES, SDK will download the image resource automatically when you get the campaign. The default is NO.
 @param adCategory Decide what kind of ads you want to retrieve. Games, apps or all of them. The default is All.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 
 @discussion It's different with the method initWithUnitID:fbPlacementId:forNumAdsRequested:presentingViewController: We will return arrays of MTGFrame rather than MTGCampaign to you. A MTGFrame may contain multiple MTGCampaigns. See more detail in MTGFrame.
 
 @deprecated This method has been deprecated.
 */
- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitID:(nonnull NSString *)unitId
                              fbPlacementId:(nullable NSString *)fbPlacementId
                                   frameNum:(NSUInteger)frameNum
                         supportedTemplates:(nullable NSArray *)templates
                             autoCacheImage:(BOOL)autoCacheImage
                                 adCategory:(MTGAdCategory)adCategory
                   presentingViewController:(nullable UIViewController *)viewController DEPRECATED_ATTRIBUTE;


/*!
 
 Initialize the native ads manager which is for loading ads. (MTGCampaign)
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param numAdsRequested The number of ads you would like the native ad manager to retrieve. Max number is 10. If you pass any number bigger than 10, it will be reset to 10.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitID:(nonnull NSString *)unitId
                              fbPlacementId:(nullable NSString *)fbPlacementId
                         forNumAdsRequested:(NSUInteger)numAdsRequested
                   presentingViewController:(nullable UIViewController *)viewController DEPRECATED_ATTRIBUTE;

/*!
 
 Initialize the native ads manager which is for loading ads. (MTGCampaign)
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param videoSupport DEPRECATED_ATTRIBUTE Mintegral support configuration： https://www.mintegral.net
 @param numAdsRequested The number of ads you would like the native ad manager to retrieve. Max number is 10. If you pass any number bigger than 10, it will be reset to 10.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitID:(nonnull NSString *)unitId
                              fbPlacementId:(nullable NSString *)fbPlacementId
                               videoSupport:(BOOL)videoSupport
                         forNumAdsRequested:(NSUInteger)numAdsRequested
                   presentingViewController:(nullable UIViewController *)viewController DEPRECATED_ATTRIBUTE;

/*!
 
 Initialize the native ads manager which is for loading ads with more options.
 
 @param unitId The id of the ad unit. You can create your unit id from our Portal.
 @param fbPlacementId The Facebook PlacementID is used to request ads from Facebook. You can also set the placementID in our portal. The ID you set in our web portal will replace the ID you set here in future.
 @param templates This array contains objects of MTGTemplate. See more detail in definition of MTGTemplate.
 @param autoCacheImage If you pass YES, SDK will download the image resource automatically when you get the campaign. The default is NO.
 @param adCategory Decide what kind of ads you want to retrieve. Games, apps or all of them. The default is All.
 @param viewController The UIViewController that will be used to present SKStoreProductViewController
 (iTunes Store product information) or the in-app browser. If not set, it will be the root viewController of your current UIWindow. But it may failed to present our view controller if your rootViewController is presenting other view controller. So set this property is necessary.
 */
- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitID:(nonnull NSString *)unitId
                              fbPlacementId:(nullable NSString *)fbPlacementId
                         supportedTemplates:(nullable NSArray *)templates
                             autoCacheImage:(BOOL)autoCacheImage
                                 adCategory:(MTGAdCategory)adCategory
                   presentingViewController:(nullable UIViewController *)viewController DEPRECATED_ATTRIBUTE;



@end

/*!
 @class MTGTemplate
 
 @abstract This class defines what type of ads and how many ads you want to retrive in one template.
 */
@interface MTGTemplate : NSObject

/*!
 @property
 
 @abstract It is an enumeration value. The default value is MTGAD_TEMPLATE_ONLY_ICON. It defines what type of ads you want to retrive in one template.
 */
@property (nonatomic, assign) MTGAdTemplateType templateType;

/*!
 @property
 
 @abstract It defines how many ads you want to retrive in one template.
 */
@property (nonatomic, assign) NSUInteger adsNum;

/**
 *
 @method
 
 @abstract The method defines which kinds of template you want to retrive.
 
 @param templateType It is an enumeration value. The default value is MTGAD_TEMPLATE_ONLY_ICON. It defines what type of ads you want to retrive in one template.
 @param adsNum It defines how many ads you want to retrive in one template.
 */
+ (MTGTemplate *)templateWithType:(MTGAdTemplateType)templateType adsNum:(NSUInteger)adsNum;

@end


@protocol MTGMediaViewDelegate;

@interface MTGMediaView : UIView

/* For best user experience, keep the aspect ratio of the mediaView at 16:9 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
the media source, can be set again to reuse this view.
*/
- (void)setMediaSourceWithCampaign:(MTGCampaign *)campaign unitId:(NSString*)unitId;


@property (nonatomic, weak, nullable) id<MTGMediaViewDelegate> delegate;

// Whether to allow full-screen playback, default YES
@property (nonatomic, assign) BOOL  allowFullscreen;

// Whether update to video from static image when video is ready to be played, default YES
@property (nonatomic, assign) BOOL  videoRefresh;

// Auto replay, default YES
@property (nonatomic, assign) BOOL  autoLoopPlay;
/* show video process view or not. Default to be YES. */
@property (nonatomic, assign) BOOL  showVideoProcessView;
/* show sound indicator view or not. Default to be YES. */
@property (nonatomic, assign) BOOL  showSoundIndicatorView;
/* mute audio output of the video player or not. Default to be YES, means video player is muted. */
@property (nonatomic, assign) BOOL mute;

@property (nonatomic, strong, readonly) MTGCampaign *campaign;

@property (nonatomic, readonly) NSString *unitId;

/**
 After called 'setMediaSourceWithCampaign:(MTGCampaign *)campaign unitId:(NSString*)unitId',
 you can check this MediaView whether has video content via isVideoContent if needed;
 */
@property (nonatomic,readonly,getter = isVideoContent) BOOL videoContent;

@end

@protocol MTGMediaViewDelegate <NSObject>

@optional

/*!
 @method
 
 @abstract
 Sent just before an MTGMediaView will enter the fullscreen layout.
 
 @param mediaView  An mediaView object sending the message.
 */
- (void)MTGMediaViewWillEnterFullscreen:(MTGMediaView *)mediaView;

/*!
 @method
 
 @abstract
 Sent after an FBMediaView has exited the fullscreen layout.
 
 @param mediaView  An mediaView object sending the message.
 */
- (void)MTGMediaViewDidExitFullscreen:(MTGMediaView *)mediaView;


/**
 *  Called when the native video was starting to play.
 *
 *  @param mediaView  An mediaView object sending the message.
 */
- (void)MTGMediaViewVideoDidStart:(MTGMediaView *)mediaView;

/**
*  Called when  the video play completed.
*
*  @param mediaView  An mediaView object sending the message.
*/
- (void)MTGMediaViewVideoPlayCompleted:(MTGMediaView *)mediaView;

/*!
 @method
 
 @abstract
 Sent after an ad has been clicked by a user.
 
 @param nativeAd An MTGCampaign object sending the message.
 */
- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd;
- (void)nativeAdDidClick:(nonnull MTGCampaign *)nativeAd mediaView:(MTGMediaView *)mediaView;


/*!
 @method
 
 @abstract
 Sent after an ad url did start to resolve.
 
 @param clickUrl The click url of the ad.
 */
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl;
- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl mediaView:(MTGMediaView *)mediaView;

/*!
 @method
 
 @abstract
 Sent after an ad url has jumped to a new url.
 
 @param jumpUrl The url during jumping.
 
 @discussion It will not be called if a ad's final jump url has been cached
 */
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl;
- (void)nativeAdClickUrlDidJumpToUrl:(nonnull NSURL *)jumpUrl  mediaView:(MTGMediaView *)mediaView;

/*!
 @method
 
 @abstract
 Sent after an ad url did reach the final jump url.
 
 @param finalUrl the final jump url of the click url.
 @param error the error generated between jumping.
 */
- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error;
- (void)nativeAdClickUrlDidEndJump:(nullable NSURL *)finalUrl
                             error:(nullable NSError *)error  mediaView:(MTGMediaView *)mediaView;

- (void)nativeAdImpressionWithType:(MTGAdSourceType)type mediaView:(MTGMediaView *)mediaView;


@end

/**
MTGAdChoicesView offers a simple way to display a AdChoice icon.
Since the image icon's size changes, you need to update this view's size too. Additional size info can be pulled from the `MTGCampaign` instance.
 */
@interface MTGAdChoicesView : UIView

/**
 Initialize this view with a given frame.

 @param frame For best user experience, keep the size of this view the same as AdChoiceIcon's, which can be pulled from MTGCampaign's -adChoiceIconSize
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 The campaign obj that provides AdChoices info, such as the image url, and click url.
 */
@property (nonatomic, weak, readwrite, nullable) MTGCampaign *campaign;


@end

NS_ASSUME_NONNULL_END

#endif /* OMMintegralNativeClass_h */
