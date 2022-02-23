// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralInterstitialClass_h
#define OMMintegralInterstitialClass_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 We will call back the time when the user saw the alert message. The timing depends on the way you set MTGNIRewardMode
*/
typedef NS_ENUM(NSInteger,MTGNIRewardMode) {
    MTGNIRewardCloseMode,//The alert was shown when the user tried to close the ad.
    MTGNIRewardPlayMode//The alert was shown when the ad played to a certain extent
};

/**
 We will call back whether the alert information has shown to the user and decision of the user.
*/
typedef NS_ENUM(NSInteger,MTGNIAlertWindowStatus) {
    MTGNIAlertNotShown, //The alert window was not shown
    MTGNIAlertChooseContinue,//The alert window has shown and the user chooses to continue which means he wants the reward.
    MTGNIAlertChooseCancel //The alert window has shown and the user chooses to cancel which means he doesn’t want the reward.
};

@class MTGNewInterstitialAdManager;
@class MTGNewInterstitialBidAdManager;

/**
 *  This protocol defines a listener for ad events.
 */
@protocol MTGNewInterstitialAdDelegate <NSObject>
@optional

/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait load resources completely
 */
- (void)newInterstitialAdLoadSuccess:(MTGNewInterstitialAdManager *_Nonnull)adManager;

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 */
- (void)newInterstitialAdResourceLoadSuccess:(MTGNewInterstitialAdManager *_Nonnull)adManager;

/**
 *  Called when there was an error loading the ad.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)newInterstitialAdLoadFail:(nonnull NSError *)error adManager:(MTGNewInterstitialAdManager *_Nonnull)adManager;


/**
 *  Called when the ad displayed successfully
 */
- (void)newInterstitialAdShowSuccess:(MTGNewInterstitialAdManager *_Nonnull)adManager;

/**
 *  Called when the ad failed to display
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)newInterstitialAdShowFail:(nonnull NSError *)error adManager:(MTGNewInterstitialAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)newInterstitialAdPlayCompleted:(MTGNewInterstitialAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */
- (void)newInterstitialAdEndCardShowSuccess:(MTGNewInterstitialAdManager *_Nonnull)adManager;


/**
 *  Called when the ad is clicked
 */
- (void)newInterstitialAdClicked:(MTGNewInterstitialAdManager *_Nonnull)adManager;

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *  @param converted   - BOOL describing whether the ad has converted
 */
- (void)newInterstitialAdDismissedWithConverted:(BOOL)converted adManager:(MTGNewInterstitialAdManager *_Nonnull)adManager;

/**
 *  Called when the ad  did closed;
 */
- (void)newInterstitialAdDidClosed:(MTGNewInterstitialAdManager *_Nonnull)adManager;

 /**
*  If NewInterstitial reward is set, you will receive this callback
*  @param rewardedOrNot  Whether the video played to required rate
*  @param alertWindowStatus  {@link MTGNIAlertWindowStatus} for list of            supported types
  NOTE:You can decide whether or not to give the reward based on this callback
 */
- (void)newInterstitialAdRewarded:(BOOL)rewardedOrNot alertWindowStatus:(MTGNIAlertWindowStatus)alertWindowStatus adManager:(MTGNewInterstitialAdManager *_Nonnull)adManager;

@end

/**
 *  This protocol defines a listener for ad events.
 */
@protocol MTGNewInterstitialBidAdDelegate <NSObject>
@optional

/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait load resources completely
 */
- (void)newInterstitialBidAdLoadSuccess:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 */
- (void)newInterstitialBidAdResourceLoadSuccess:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Called when there was an error loading the ad.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)newInterstitialBidAdLoadFail:(nonnull NSError *)error adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;


/**
 *  Called when the ad display success
 */
- (void)newInterstitialBidAdShowSuccess:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Only called when displaying bidding ad.
 */
- (void)newInterstitialBidAdShowSuccessWithBidToken:(nonnull NSString * )bidToken adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Called when the ad failed to display
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)newInterstitialBidAdShowFail:(nonnull NSError *)error adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)newInterstitialBidAdPlayCompleted:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */
- (void)newInterstitialBidAdEndCardShowSuccess:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;


/**
 *  Called when the ad is clicked
 */
- (void)newInterstitialBidAdClicked:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *  @param converted   - BOOL describing whether the ad has converted
 */
- (void)newInterstitialBidAdDismissedWithConverted:(BOOL)converted adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

/**
 *  Called when the ad  did closed;
 */
- (void)newInterstitialBidAdDidClosed:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

 /**
*  If New Interstitial  reward is set, you will receive this callback
*  @param rewardedOrNot  Whether the video played to required rate
* @param alertWindowStatus  {@link MTGNIAlertWindowStatus} for list of supported types
  NOTE:You can decide whether or not to give the reward based on this callback
 */
- (void)newInterstitialBidAdRewarded:(BOOL)rewardedOrNot alertWindowStatus:(MTGNIAlertWindowStatus)alertWindowStatus adManager:(MTGNewInterstitialBidAdManager *_Nonnull)adManager;

@end

@interface MTGNewInterstitialAdManager : NSObject

@property (nonatomic, readonly, weak) id  <MTGNewInterstitialAdDelegate> _Nullable delegate;

@property (nonatomic, readonly, copy)   NSString * _Nonnull currentUnitId;

@property (nonatomic, readonly, copy)   NSString * _Nullable placementId;

/** Play the video is mute in the beginning ,defult is NO */
@property (nonatomic, assign) BOOL  playVideoMute;

- (nonnull instancetype)initWithPlacementId:(nonnull NSString *)placementId
                                     unitId:(nonnull NSString *)unitId
                                   delegate:(nullable id<MTGNewInterstitialAdDelegate>)delegate;


/** Begins loading ad content. */
- (void)loadAd;

/**
*  Whether or not if there was an available ad to show.
 @return YES means there was a available ad, otherwise NO.
*/
- (BOOL)isAdReady;

/**
 * Presents the NewInterstitial ad modally from the specified view controller.
 *
 * @param viewController The view controller that should be used to present the  ad.
 */
- (void)showFromViewController:(UIViewController *_Nonnull)viewController;




/**
  * Set NewInterstitial  reward if you need，call before loadAd.
  * @param rewardMode  {@link MTGNIRewardMode} for list of supported types
  * @param playRate Set the timing of the reward alertView,range of 0~1(eg:set 0.6,indicates 60%).
  NOTE:In MTGNIRewardPlayMode, playRate value indicates that a reward alertView will appear when the playback reaches the set playRate.
       In MTGNIRewardCloseMode, playRate value indicates that when the close button is clicked, if the video playback time is less than the set playRate, reward alertView will appear.
 */
- (void)setRewardMode:(MTGNIRewardMode)rewardMode playRate:(CGFloat)playRate;

/**
 * Set NewInterstitial reward if you need，call before loadAd.
 * @param rewardMode  {@link MTGNIRewardMode} for list of supported types
 * @param playTime Set the timing of the reward alertView,range of 0~100s.
 NOTE:In MTGNIRewardPlayMode, playTime value indicates that a reward alertView will appear when the playback reaches the set playTime.
      In MTGNIRewardCloseMode, playTime value indicates that when the close button is clicked, if the video playback time is less than the set playTime, reward alertView will appear.
*/
- (void)setRewardMode:(MTGNIRewardMode)rewardMode playTime:(NSInteger)playTime;

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

/**
* get the id of this request ad,call  after onInterstitialAdLoadSuccess.
*/
- (NSString *_Nullable)getRequestIdWithUnitId:(nonnull NSString *)unitId;

@end

@interface MTGNewInterstitialBidAdManager : NSObject

@property (nonatomic, readonly, weak) id  <MTGNewInterstitialBidAdDelegate> _Nullable delegate;

@property (nonatomic, readonly, copy)   NSString * _Nonnull currentUnitId;

@property (nonatomic, readonly, copy)   NSString * _Nullable placementId;

/**
 * Play the video is mute in the beginning ,defult is NO
 *
 */
@property (nonatomic, assign) BOOL  playVideoMute;

- (nonnull instancetype)initWithPlacementId:(nonnull NSString *)placementId
                                     unitId:(nonnull NSString *)unitId
                                   delegate:(nullable id<MTGNewInterstitialBidAdDelegate>)delegate;


/**
 Begins loading header bidding ad content.

 @param bidToken token from bid request.
*/
- (void)loadAdWithBidToken:(nonnull NSString *)bidToken;

/**
 Whether or not if there was a available bidding ad to show.
 
 @return YES means there was a available bidding ad, otherwise NO.
*/
- (BOOL)isAdReady;

/**
 * Presents the NewInterstitial ad modally from the specified view controller.
 *
 * @param viewController The view controller that should be used to present the  ad.
 */
- (void)showFromViewController:(UIViewController *_Nonnull)viewController;




/**
  * Set NewInterstitial  reward if you need，call before loadAd.
  * @param rewardMode  {@link MTGNIRewardMode} for list of supported types
  * @param playRate Set the timing of the reward alertView,range of 0~1(eg:set 0.6,indicates 60%).
  NOTE:In MTGNIRewardPlayMode, playRate value indicates that a reward alertView will appear when the playback reaches the set playRate.
       In MTGNIRewardCloseMode, playRate value indicates that when the close button is clicked, if the video playback time is less than the set playRate, reward alertView will appear.
 */
- (void)setRewardMode:(MTGNIRewardMode)rewardMode playRate:(CGFloat)playRate;

/**
 * Set NewInterstitial reward if you need，call before loadAd.
 * @param rewardMode  {@link MTGNIRewardMode} for list of supported types
 * @param playTime Set the timing of the reward alertView,range of 0~100s.
 NOTE:In MTGNIRewardPlayMode, playTime value indicates that a reward alertView will appear when the playback reaches the set playTime.
      In MTGNIRewardCloseMode, playTime value indicates that when the close button is clicked, if the video playback time is less than the set playTime, reward alertView will appear.
*/
- (void)setRewardMode:(MTGNIRewardMode)rewardMode playTime:(NSInteger)playTime;

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

/**
* get the id of this request ad,call  after onInterstitialAdLoadSuccess.
*/
- (NSString *_Nullable)getRequestIdWithUnitId:(nonnull NSString *)unitId;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMintegralInterstitialClass_h */
