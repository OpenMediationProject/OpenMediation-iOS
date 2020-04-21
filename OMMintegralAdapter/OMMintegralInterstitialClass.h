// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralInterstitialClass_h
#define OMMintegralInterstitialClass_h
#import <UIKit/UIKit.h>


/**
 We will call back the time when the user saw the alert message. The timing depends on the way you set MTGIVRewardMode
*/
typedef NS_ENUM(NSInteger,MTGIVRewardMode) {
    MTGIVRewardCloseMode,//The alert was shown when the user tried to close the ad.
    MTGIVRewardPlayMode//The alert was shown when the ad played to a certain extent
};

/**
 We will call back whether the alert information has shown to the user and decision of the user.
*/
typedef NS_ENUM(NSInteger,MTGIVAlertWindowStatus) {
    MTGIVAlertNotShown, //The alert window was not shown
    MTGIVAlertChooseContinue,//The alert window has shown and the user chooses to continue which means he wants the reward.
    MTGIVAlertChooseCancel //The alert window has shown and the user chooses to cancel which means he doesn’t want the reward.
};

@class MTGInterstitialVideoAdManager;
@class MTGBidInterstitialVideoAdManager;
/**
 *  This protocol defines a listener for ad video load events.
 */
@protocol MTGInterstitialVideoDelegate <NSObject>
@optional

/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait load video
 completely
 */
- (void)onInterstitialAdLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 */
- (void)onInterstitialVideoLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when there was an error loading the ad.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager;


/**
 *  Called when the ad display success
 */
- (void)onInterstitialVideoShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad failed to display for some reason
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)onInterstitialVideoPlayCompleted:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */
- (void)onInterstitialVideoEndCardShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager;


/**
 *  Called when the ad is clicked
 */
- (void)onInterstitialVideoAdClick:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *  @param converted   - BOOL describing whether the ad has converted
 */
- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

/**
 *  Called when the ad  did closed;
 */
- (void) onInterstitialVideoAdDidClosed:(MTGInterstitialVideoAdManager *_Nonnull)adManager;

@end

@class MTGInterstitialVideoDelegate;

@interface MTGInterstitialVideoAdManager :  NSObject

@property (nonatomic, weak) id  <MTGInterstitialVideoDelegate> _Nullable delegate;

@property (nonatomic, readonly)   NSString * _Nonnull currentUnitId;

@property (nonatomic, readonly)   NSString * _Nullable placementId;

/**
 * Play the video is mute in the beginning ,defult is NO
 *
 */
@property (nonatomic, assign) BOOL  playVideoMute;

- (nonnull instancetype)initWithPlacementId:(nullable NSString *)placementId
                                     unitId:(nonnull NSString *)unitId
                                   delegate:(nullable id<MTGInterstitialVideoDelegate>)delegate;

/**
 * Begins loading ad content for the interstitialVideo.
 *
 * You can implement the `onInterstitialVideoLoadSuccess:` and `onInterstitialVideoLoadFail: adManager:` methods of
 * `MTGInterstitialVideoDelegate` if you would like to be notified as loading succeeds or
 * fails.
 */
- (void)loadAd;


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

#endif /* OMMintegralInterstitialClass_h */
