// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPangleNativeClass_h
#define OMPangleNativeClass_h
#import <UIKit/UIKit.h>
#import "OMPangleClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface BUImage : NSObject <NSCoding>

// image address URL
@property (nonatomic, copy) NSString *imageURL;

// image width
@property (nonatomic, assign) float width;

// image height
@property (nonatomic, assign) float height;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (NSDictionary *)dictionaryValue;

@end


@interface BUMaterialMeta : NSObject <NSCoding>

/// interaction types supported by ads.
@property (nonatomic, assign) BUInteractionType interactionType;

/// material pictures.
@property (nonatomic, strong) NSArray<BUImage *> *imageAry;

/// ad logo icon.
@property (nonatomic, strong) BUImage *icon;

/// ad headline.
@property (nonatomic, copy) NSString *AdTitle;

/// ad description.
@property (nonatomic, copy) NSString *AdDescription;

/// ad source.
@property (nonatomic, copy) NSString *source;

/// text displayed on the creative button.
@property (nonatomic, copy) NSString *buttonText;

/// display format of the in-feed ad, other ads ignores it.
@property (nonatomic, assign) BUFeedADMode imageMode;

/// Star rating, range from 1 to 5.
@property (nonatomic, assign) NSInteger score;

/// Number of comments.
@property (nonatomic, assign) NSInteger commentNum;

/// ad installation package size, unit byte.
@property (nonatomic, assign) NSInteger appSize;

/// video duration
@property (nonatomic, assign) NSInteger videoDuration;

/// media configuration parameters.
@property (nonatomic, copy) NSDictionary *mediaExt;

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError * __autoreleasing *)error;

@end

@interface BUDislikeWords : NSObject <NSCoding>
@property (nonatomic, copy, readonly) NSString *dislikeID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) BOOL isSelected;
@property (nonatomic, copy,readonly) NSArray<BUDislikeWords *> *options;

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError **)error;
@end


@protocol BUNativeAdDelegate;




/**
 Abstract ad slot containing ad data loading, response callbacks.
 BUNativeAd currently supports native ads.
 Native ads include in-feed ad (multiple ads, image + video), general native ad (single ad, image + video), native banner ad, and native interstitial ad.
 Support interstitial ad, banner ad, splash ad, rewarded video ad, full-screen video ad.
 */
@interface BUNativeAd : NSObject

/**
 Ad slot description.
 */
@property (nonatomic, strong, readwrite, nullable) BUAdSlot *adslot;

/**
 Ad slot material.
 */
@property (atomic, strong, readonly, nullable) BUMaterialMeta *data;

/**
 The delegate for receiving state change messages.
 The delegate is not limited to viewcontroller.
 The delegate can be set to any object which conforming to <BUNativeAdDelegate>.
 */
@property (nonatomic, weak, readwrite, nullable) id<BUNativeAdDelegate> delegate;

/**
 required.
 Root view controller for handling ad actions.
 Action method includes is 'presentViewController'.
 */
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

/**
 Initializes native ad with ad slot.
 @param slot : ad slot description.
               including slotID,adType,adPosition,etc.
 @return BUNativeAd
 */
- (instancetype)initWithSlot:(BUAdSlot *)slot;

/**
 Register clickable views in native ads view.
 Interaction types can be configured on TikTok Audience Network.
 Interaction types include view video ad details page, make a call, send email, download the app, open the webpage using a browser,open the webpage within the app, etc.
 @param containerView : required.
                        container view of the native ad.
 @param clickableViews : optional.
                        Array of views that are clickable.
 */
- (void)registerContainer:(__kindof UIView *)containerView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;

/**
 Unregister ad view from the native ad.
 */
- (void)unregisterView;

/**
 Actively request nativeAd datas.
 */
- (void)loadAdData;

/**
 Ad slot material id
 */
- (NSString *)getAdCreativeToken;

@end


@protocol BUVideoAdViewDelegate;


@interface BUVideoAdView : UIView

@property (nonatomic, weak, nullable) id<BUVideoAdViewDelegate> delegate;
/**
required. Root view controller for handling ad actions.
 **/
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

/**
 Whether to allow pausing the video by clicking, default NO. Only for draw video(vertical video ads).
 **/
@property (nonatomic, assign) BOOL drawVideoClickEnable;

/**
 material information.
 */
@property (nonatomic, strong, readwrite, nullable) BUMaterialMeta *materialMeta;

/**
 Set your Video autoPlayMode when you support CustomMode
 if support CustomMode , default autoplay Video
 **/
@property (nonatomic, assign) BOOL supportAutoPlay;


- (instancetype)initWithMaterial:(BUMaterialMeta *)materialMeta;

/**
 Resume to the corresponding time.
 */
- (void)playerSeekToTime:(CGFloat)time;

/**
 Support configuration for pause button.
 @param playImg : the image of the button
 @param playSize : the size of the button. Set as cgsizezero to use default icon size.
 */
- (void)playerPlayIncon:(UIImage *)playImg playInconSize:(CGSize)playSize;

@end

@protocol BUVideoAdViewDelegate <NSObject>

@optional

/**
 This method is called when videoadview failed to play.
 @param error : the reason of error
 */
- (void)videoAdView:(BUVideoAdView *)videoAdView didLoadFailWithError:(NSError *_Nullable)error;

/**
 This method is called when videoadview playback status changed.
 @param playerState : player state after changed
 */
- (void)videoAdView:(BUVideoAdView *)videoAdView stateDidChanged:(BUPlayerPlayState)playerState;

/**
 This method is called when videoadview end of play.
 */
- (void)playerDidPlayFinish:(BUVideoAdView *)videoAdView;

/**
 This method is called when videoadview is clicked.
 */
- (void)videoAdViewDidClick:(BUVideoAdView *)videoAdView;

/**
 This method is called when videoadview's finish view is clicked.
 */
- (void)videoAdViewFinishViewDidClick:(BUVideoAdView *)videoAdView;

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)videoAdViewDidCloseOtherController:(BUVideoAdView *)videoAdView interactionType:(BUInteractionType)interactionType;

@end

@protocol BUNativeAdDelegate <NSObject>

@optional

/**
 This method is called when native ad material loaded successfully. This method will be deprecated. Use nativeAdDidLoad:view: instead
 */
- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd;


/**
 This method is called when native ad material loaded successfully.
 */
- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd view:(UIView *_Nullable)view;

/**
 This method is called when native ad materia failed to load.
 @param error : the reason of error
 */
- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error;

/**
 This method is called when native ad slot has been shown.
 */
- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd;

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeAdDidCloseOtherController:(BUNativeAd *)nativeAd interactionType:(BUInteractionType)interactionType;

/**
 This method is called when native ad is clicked.
 */
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view;

/**
 This method is called when the user clicked dislike reasons.
 Only used for dislikeButton in BUNativeAdRelatedView.h
 @param filterWords : reasons for dislike
 */
- (void)nativeAd:(BUNativeAd *_Nullable)nativeAd dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterWords;

/**
 This method is called when the Ad view container is forced to be removed.
 @param nativeAd : Ad material
 @param adContainerView : Ad view container
 */
- (void)nativeAd:(BUNativeAd *_Nullable)nativeAd adContainerViewDidRemoved:(UIView *)adContainerView;
@end


@interface BUNativeAdRelatedView : NSObject

/**
 Need to actively add to the view in order to deal with the feedback and improve the accuracy of ad.
 */
@property (nonatomic, strong, readonly, nullable) UIButton *dislikeButton;

/**
 Promotion label.Need to actively add to the view.
 */
@property (nonatomic, strong, readonly, nullable) UILabel *adLabel;

/**
 Ad logo.Need to actively add to the view.
 */
@property (nonatomic, strong, readonly, nullable) UIImageView *logoImageView;
/**
 Ad logo + Promotion label.Need to actively add to the view.
 */
@property (nonatomic, strong, readonly, nullable) UIImageView *logoADImageView;

/**
 Video ad view. Need to actively add to the view.
 */
@property (nonatomic, strong, readonly, nullable) BUVideoAdView *videoAdView;

/**
 Refresh the data every time you get new datas in order to show ad perfectly.
 */
- (void)refreshData:(BUNativeAd *)nativeAd;

@end

//  ***************************  模板渲染

@class BUAdSlot;

@protocol BUNativeAdsManagerDelegate;



@interface BUNativeExpressAdView : UIView
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


@end

@class BUNativeExpressAdManager;

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


NS_ASSUME_NONNULL_END

#endif /* OMPangleNativeClass_h */
