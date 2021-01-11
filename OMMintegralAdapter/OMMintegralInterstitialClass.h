// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralInterstitialClass_h
#define OMMintegralInterstitialClass_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,MTGIVRewardMode) {
    MTGIVRewardCloseMode,//The alert was shown when the user tried to close the ad.
    MTGIVRewardPlayMode//The alert was shown when the ad played to a certain extent
};


typedef NS_ENUM(NSInteger,MTGIVAlertWindowStatus) {
    MTGIVAlertNotShown, //The alert window was not shown
    MTGIVAlertChooseContinue,//The alert window has shown and the user chooses to continue which means he wants the reward.
    MTGIVAlertChooseCancel //The alert window has shown and the user chooses to cancel which means he doesn’t want the reward.
};

@class MTGInterstitialVideoAdManager;
@class MTGBidInterstitialVideoAdManager;

@protocol MTGInterstitialVideoDelegate <NSObject>
@optional


- (void)onInterstitialAdLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;


- (void)onInterstitialVideoLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;


- (void)onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager;



- (void)onInterstitialVideoShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;


- (void)onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager;


- (void)onInterstitialVideoPlayCompleted:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

- (void)onInterstitialVideoEndCardShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;



- (void)onInterstitialVideoAdClick:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

- (void) onInterstitialVideoAdDidClosed:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

@end

@class MTGInterstitialVideoDelegate;

@interface MTGInterstitialVideoAdManager :  NSObject

@property (nonatomic, weak) id  <MTGInterstitialVideoDelegate> _Nullable delegate;

@property (nonatomic, readonly)   NSString * _Nonnull currentUnitId;

@property (nonatomic, readonly)   NSString * _Nullable placementId;

@property (nonatomic, assign) BOOL  playVideoMute;

- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitId:(nonnull NSString *)unitId
                                   delegate:(nullable id<MTGInterstitialVideoDelegate>)delegate;

- (void)loadAd;


- (void)showFromViewController:(UIViewController *_Nonnull)viewController;


- (BOOL)isVideoReadyToPlayWithPlacementId:(nullable NSString *)placementId unitId:(nonnull NSString *)unitId;

- (void)cleanAllVideoFileCache;


- (void)setIVRewardMode:(MTGIVRewardMode)ivRewardMode playRate:(CGFloat)playRate;


- (void)setIVRewardMode:(MTGIVRewardMode)ivRewardMode playTime:(NSInteger)playTime;

- (void)setAlertWithTitle:(NSString *_Nullable)title
                  content:(NSString *_Nullable)content
              confirmText:(NSString *_Nullable)confirmText
               cancelText:(NSString *_Nullable)cancelText;

@end

@protocol MTGBidInterstitialVideoDelegate <NSObject>
@optional

/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait load video
 completely
 */
- (void)onInterstitialAdLoadSuccess:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 */
- (void)onInterstitialVideoLoadSuccess:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when there was an error loading the ad.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;


/**
 *  Called when the ad display success
 */
- (void)onInterstitialVideoShowSuccess:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad failed to display for some reason
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)onInterstitialVideoPlayCompleted:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */
- (void)onInterstitialVideoEndCardShowSuccess:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;


/**
 *  Called when the ad is clicked
 */
- (void)onInterstitialVideoAdClick:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *  @param converted   - BOOL describing whether the ad has converted
 */
- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad  did closed;
 */
- (void)onInterstitialVideoAdDidClosed:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

 /**
*  If Interstitial Video  reward is set, you will receive this callback
*  @param achieved  Whether the video played to required rate
* @param alertWindowStatus  {@link MTGIVAlertWindowStatus} fro list of supported types
  NOTE:You can decide whether to give the reward based on that callback
 */
- (void)onInterstitialVideoAdPlayVideo:(BOOL)achieved alertWindowStatus:(MTGIVAlertWindowStatus)alertWindowStatus adManager:(MTGBidInterstitialVideoAdManager *_Nonnull)adManager;

@end


@interface MTGBidInterstitialVideoAdManager : NSObject

@property (nonatomic, weak) id  <MTGBidInterstitialVideoDelegate> _Nullable delegate;

@property (nonatomic, readonly)   NSString * _Nonnull currentUnitId;

@property (nonatomic, readonly)   NSString * _Nullable placementId;

/**
 * Play the video is mute in the beginning ,defult is NO
 *
 */
@property (nonatomic, assign) BOOL  playVideoMute;

- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitId:(nonnull NSString *)unitId
                                   delegate:(nullable id<MTGBidInterstitialVideoDelegate>)delegate;
/**
 * Begins loading bidding ad content for the interstitialVideo.
 *
 * You can implement the `onInterstitialVideoLoadSuccess:` and `onInterstitialVideoLoadFail: adManager:` methods of
 * `MTGInterstitialVideoDelegate` if you would like to be notified as loading succeeds or
 * fails.
 * @param bidToken - the token from bid request within MTGBidFramework.
 */
- (void)loadAdWithBidToken:(nonnull NSString *)bidToken;

/** @name Presenting an interstitialVideo Ad */

/**
 * Presents the interstitialVideo ad modally from the specified view controller.
 *
 * @param viewController The view controller that should be used to present the interstitialVideo ad.
 */
- (void)showFromViewController:(UIViewController *_Nonnull)viewController;


/**
*  Whether the given unitId is loaded and ready to be shown.
 
* @param placementId   - the placementId string of the Ad that display.
*  @param unitId - adPositionId value in Self Service.
*
*  @return - YES if the unitId is loaded and ready to be shown, otherwise NO.
*/
- (BOOL)isVideoReadyToPlayWithPlacementId:(nullable NSString *)placementId unitId:(nonnull NSString *)unitId;


/**
 *  Clean all the video file cache from the disk.
 */
- (void)cleanAllVideoFileCache;

/**
  * Set interstitial video reward if you need，call before loadAd.
  * @param MTGIVRewardMode  {@link MTGIVRewardMode} fro list of supported types
  * @param playRate Set the timing of the reward alertView,range of 0~1(eg:set 0.6,indicates 60%).
  NOTE:In MTGIVRewardPlayMode, playRate value indicates that a reward alertView will appear when the playback reaches the set playRate.
       In MTGIVRewardCloseMode, playRate value indicates that when the close button is clicked, if the video playback time is less than the set playRate, reward alertView will appear.
 */
- (void)setIVRewardMode:(MTGIVRewardMode)ivRewardMode playRate:(CGFloat)playRate;

/**
 * Set interstitial video reward if you need，call before loadAd.
 * @param MTGIVRewardMode  {@link MTGIVRewardMode} fro list of supported types
 * @param playTime Set the timing of the reward alertView,range of 0~100s.
  NOTE:In MTGIVRewardPlayMode, playTime value indicates that a reward alertView will appear when the playback reaches the set playTime.
      In MTGIVRewardCloseMode, playTime value indicates that when the close button is clicked, if the video playback time is less than the set playTime, reward alertView will appear.
*/
- (void)setIVRewardMode:(MTGIVRewardMode)ivRewardMode playTime:(NSInteger)playTime;

/**
*  Call this method when you want custom the reward alert  display text.
*
* @param title  alert title
* @param content    alertcontent
* @param confirmText    confirm button text
* @param cancelText     cancel button text
 
 NOTE:Must be called before loadAd
*/
- (void)setAlertWithTitle:(NSString *_Nullable)title
                  content:(NSString *_Nullable)content
              confirmText:(NSString *_Nullable)confirmText
               cancelText:(NSString *_Nullable)cancelText;
@end

NS_ASSUME_NONNULL_END

#endif /* OMMintegralInterstitialClass_h */
