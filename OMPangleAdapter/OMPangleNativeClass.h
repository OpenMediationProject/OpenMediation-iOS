// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleNativeClass_h
#define OMPangleNativeClass_h
#import <UIKit/UIKit.h>
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN

//  ***************************  模板渲染
@protocol BUNativeAdsManagerDelegate;

@interface BUNativeExpressAdView : BUInterfaceBaseView<BUAdClientBiddingProtocol>
/**
 * Whether render is ready
 */
@property (nonatomic, assign, readonly) BOOL isReady;

/// media configuration parameters.
@property (nonatomic, copy, readonly) NSDictionary *mediaExt;

/// video duration.
@property (nonatomic,assign, readonly) NSInteger videoDuration;

/// Get the already played time.
@property (nonatomic,assign, readonly) CGFloat currentPlayedTime;

/*
 required.
 Root view controller for handling ad actions.
 */
@property (nonatomic, weak) UIViewController *rootViewController;

/**
 required
 */
- (void)render;

/**
 Ad slot material id
 */
- (NSString *)getAdCreativeToken;

@end

@class BUNativeExpressAdManager;
@class BUDislikeWords;

@protocol BUNativeExpressAdViewDelegate <NSObject>

@optional
/**
 * Sent when views successfully load ad
 */
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views;

/**
 * Sent when views fail to load ad
 */
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *_Nullable)error;

/**
 * This method is called when rendering a nativeExpressAdView successed, and nativeExpressAdView.size.height has been updated
 */
- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView;

/**
 * This method is called when a nativeExpressAdView failed to render
 */
- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *_Nullable)error;

/**
 * Sent when an ad view is about to present modal content
 */
- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView;

/**
 * Sent when an ad view is clicked
 */
- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView;

/**
Sent when a playerw playback status changed.
@param playerState : player state after changed
*/
- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState;

/**
 * Sent when a player finished
 * @param error : error of player
 */
- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error;

/**
 * Sent when a user clicked dislike reasons.
 * @param filterWords : the array of reasons why the user dislikes the ad
 */
- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords;

/**
 * Sent after an ad view is clicked, a ad landscape view will present modal content
 */
- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView;

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressAdViewDidCloseOtherController:(BUNativeExpressAdView *)nativeExpressAdView interactionType:(BUInteractionType)interactionType;


/**
 This method is called when the Ad view container is forced to be removed.
 @param nativeExpressAdView : Ad view container
 */
- (void)nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView;
@end

@interface BUNativeExpressAdManager : BUInterfaceBaseObject <BUMopubAdMarkUpDelegate>

@property (nonatomic, strong, nullable) BUAdSlot *adslot;

@property (nonatomic, assign, readwrite) CGSize adSize;

/**
 The delegate for receiving state change messages from a BUNativeExpressAdManager
 */
@property (nonatomic, weak, nullable) id<BUNativeExpressAdViewDelegate> delegate;


/**
 @param size expected ad view size，when size.height is zero, acture height will match size.width
 */
- (instancetype)initWithSlot:(BUAdSlot * _Nullable)slot adSize:(CGSize)size;

/**
 The number of ads requested,The maximum is 3
 */
- (void)loadAdDataWithCount:(NSInteger)count;

@end

@interface BUNativeExpressAdManager (Deprecated)
- (void)loadAd:(NSInteger)count __attribute__((deprecated("Use loadAdDataWithCount: instead.")));
@end


// 海外

/// A view that wraps a fixed ad style to display an image or video
@interface PAGMediaView : UIView

@end

@class PAGLNativeAd;

/// A class that encapsulates a fixed ad style
@interface PAGLNativeAdRelatedView : NSObject

/// Need to actively add to the view in order to deal with the feedback and improve the accuracy of ad.
@property (nonatomic, strong, readonly) UIButton *dislikeButton;

/// Ad logo + Promotion label.Need to actively add to the view.
@property (nonatomic, strong, readonly) UIImageView *logoADImageView;

/// A view used to display a video or image, which can be added directly to the ad view.
@property (nonatomic, strong, readonly) PAGMediaView *mediaView;

/// Refresh the data every time you get new datas in order to show ad perfectly.
/// @param nativeAd PAGLNativeAd instance.
- (void)refreshWithNativeAd:(PAGLNativeAd *)nativeAd;

@end

@class PAGLNativeAd, PAGLMaterialMeta, PAGNativeRequest;

@interface PAGLImage : NSObject

/// image address URL
@property (nonatomic, copy, readonly) NSString *imageURL;

/// image width
@property (nonatomic, assign, readonly) CGFloat width;

/// image height
@property (nonatomic, assign, readonly) CGFloat height;

@end

/// A class that encapsulates advertising information
@interface PAGLMaterialMeta : NSObject

/// ad logo icon.
@property (nonatomic, strong, readonly) PAGLImage *icon;

/// ad headline.
@property (nonatomic, copy, readonly) NSString *AdTitle;

/// ad description.
@property (nonatomic, copy, readonly) NSString *AdDescription;

/// text displayed on the creative button.
@property (nonatomic, copy, readonly) NSString *buttonText;


@end

@protocol PAGLNativeAdDelegate <PAGAdDelegate>

@end

typedef void (^PAGNativeADLoadCompletionHandler)(PAGLNativeAd * _Nullable nativeAd,
                                                  NSError * _Nullable error);

/// Abstract ad slot containing ad data loading, response callbacks.
@interface PAGLNativeAd : NSObject <PAGAdProtocol, PAGAdClientBiddingProtocol>

/// Ad material.
@property (nonatomic, strong, readonly) PAGLMaterialMeta *data;

/// The delegate for receiving state change messages.
/// The delegate is not limited to viewcontroller.
/// The delegate can be set to any object which conforming to <PAGLNativeAdDelegate>.
@property (nonatomic, weak, nullable) id<PAGLNativeAdDelegate> delegate;

/// required.
/// Root view controller for handling ad actions.
/// Action method includes is 'presentViewController'.
@property (nonatomic, weak) UIViewController *rootViewController;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

/// Actively request nativeAd datas.
/// @param slotID required. The unique identifier of a native ad.
/// @param request required. PAGNativeRequest instance.
/// @param completionHandler required. Callback when ad is loaded.
+ (void)loadAdWithSlotID:(NSString *)slotID
                 request:(PAGNativeRequest *)request
       completionHandler:(PAGNativeADLoadCompletionHandler)completionHandler;

/// Register clickable views in native ads view.
/// Interaction types can be configured on TikTok Audience Network.
/// Interaction types include view video ad details page, open the webpage using a browser, open the webpage within the app, etc.
/// @param containerView required. Container view of the native ad.
/// @param clickableViews optional. Array of views that are clickable.
- (void)registerContainer:(__kindof UIView *)containerView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;

/// Unregister ad view from the native ad.
- (void)unregisterView;

@end


NS_ASSUME_NONNULL_END

#endif /* OMPangleNativeClass_h */
