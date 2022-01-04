// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralRewardedVideoClass_h
#define OMMintegralRewardedVideoClass_h
#import <UIKit/UIKit.h>

@class MTGRewardAdInfo;
/**
 *  This protocol defines a listener for ad video load events.
 */
@protocol MTGRewardAdLoadDelegate <NSObject>
@optional

/**
*  Called when the ad is loaded , but not ready to be displayed,need to wait load video
completely
 
*  @param placementId - the placementId string of the Ad that was loaded.
*  @param unitId - the unitId string of the Ad that was loaded.
*/
- (void)onAdLoadSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId;

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 
 *  @param placementId - the placementId string of the Ad that was loaded.
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onVideoAdLoadSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId;

/**
 *  Called when there was an error loading the ad.
 
 *  @param placementId - the placementId string of the Ad that was loaded.
 *  @param unitId      - the unitId string of the Ad that failed to load.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)onVideoAdLoadFailed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId error:(nonnull NSError *)error;

@end

/**
 *  This protocol defines a listener for ad video show events.
 */
@protocol MTGRewardAdShowDelegate <NSObject>
@optional

/**
 *  Called when the ad display success
 
 *  @param placementId - the placementId string of the Ad that display success.
 *  @param unitId - the unitId string of the Ad that display success.
 */
- (void)onVideoAdShowSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId;

/**
 *  Called when the ad display success,It will be called only when bidding is used.
 
 *  @param placementId - the placementId string of the Ad that display success.
 *  @param unitId - the unitId string of the Ad that display success.
 *  @param bidToken - the bidToken string of the Ad that display success.
 */
- (void)onVideoAdShowSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId bidToken:(nullable NSString *)bidToken;

/**
 *  Called when the ad failed to display for some reason
 
 *  @param placementId      - the placementId string of the Ad that failed to be displayed.
 *  @param unitId      - the unitId string of the Ad that failed to be displayed.
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)onVideoAdShowFailed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId withError:(nonnull NSError *)error;

/**
 *  Called only when the ad has a video content, and called when the video play completed.
 
 *  @param placementId - the placementId string of the Ad that video play completed.
 *  @param unitId - the unitId string of the Ad that video play completed.
 */
- (void) onVideoPlayCompleted:(nullable NSString *)placementId unitId:(nullable NSString *)unitId;

/**
 *  Called only when the ad has a endcard content, and called when the endcard show.
 
 *  @param placementId - the placementId string of the Ad that endcard show.
 *  @param unitId - the unitId string of the Ad that endcard show.
 */
- (void) onVideoEndCardShowSuccess:(nullable NSString *)placementId unitId:(nullable NSString *)unitId;

/**
 *  Called when the ad is clicked
 *
 *  @param placementId - the placementId string of the Ad clicked.
 *  @param unitId - the unitId string of the Ad clicked.
 */
- (void)onVideoAdClicked:(nullable NSString *)placementId unitId:(nullable NSString *)unitId;

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *
 *  @param placementId      - the placementId string of the Ad that has been dismissed
 *  @param unitId      - the unitId string of the Ad that has been dismissed
 *  @param converted   - BOOL describing whether the ad has converted
 *  @param rewardInfo  - the rewardInfo object containing the info that should be given to your user.
 */
- (void)onVideoAdDismissed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo;

/**
 *  Called when the ad  did closed;
 *
 *  @param unitId - the unitId string of the Ad that video play did closed.
 *  @param placementId - the placementId string of the Ad that video play did closed.
 */
- (void)onVideoAdDidClosed:(nullable NSString *)placementId unitId:(nullable NSString *)unitId;

@end


@interface MTGRewardAdManager : NSObject

/* Play the video mute or not in the beginning, defult is NO. */
@property (nonatomic, assign) BOOL  playVideoMute;


/**
 * The shared instance of the video.
 *
 * @return The video singleton.
 */
+ (nonnull instancetype)sharedInstance;

/**
*  Called when load the video
 
*  @param placementId   - the placementId string of the Ad that display.
*  @param unitId      - the unitId string of the Ad that was loaded.
*  @param delegate    - reference to the object that implements MTGRewardAdLoadDelegate protocol; will receive load events for the given unitId.
*/
- (void)loadVideoWithPlacementId:(nullable NSString *)placementId
                          unitId:(nonnull NSString *)unitId
                        delegate:(nullable id <MTGRewardAdLoadDelegate>)delegate;

/**
*  Called when show the video
*
*  @param placementId         - the placementId string of the Ad that display.
*  @param unitId         - the unitId string of the Ad that display.
*  @param rewardId       - the reward info you can set in mintegral portal
*  @param userId       - The user's unique identifier in your system
*  @param delegate       - reference to the object that implements MTGRewardAdShowDelegate protocol; will receive show events for the given unitId.
*  @param viewController - UIViewController that shouold be set as the root view controller for the ad
*/
- (void)showVideoWithPlacementId:(nullable NSString *)placementId
                          unitId:(nonnull NSString *)unitId
                    withRewardId:(nullable NSString *)rewardId
                          userId:(nullable NSString *)userId
                        delegate:(nullable id <MTGRewardAdShowDelegate>)delegate
                  viewController:(nonnull UIViewController*)viewController;

/**
 *  Will return whether the given unitId is loaded and ready to be shown.
 *
 *  @param placementId - adPositionId value in Self Service
 *  @param unitId - adPositionId value in Self Service
 *
 *  @return - YES if the unitId is loaded and ready to be shown, otherwise NO.
 */
- (BOOL)isVideoReadyToPlayWithPlacementId:(nullable NSString *)placementId unitId:(nonnull NSString *)unitId;

/**
 *  Clean all the video file cache from the disk.
 */
- (void)cleanAllVideoFileCache;


/**
*  Set  alertView text,if you want to change the alertView text.
*
* @param title  alert title
* @param content    alertcontent
* @param confirmText    confirm button text
* @param cancelText     cancel button text
* @param unitId     unitId

 NOTE:called before loadAd
*/
- (void)setAlertWithTitle:(NSString *_Nullable)title
                  content:(NSString *_Nullable)content
              confirmText:(NSString *_Nullable)confirmText
               cancelText:(NSString *_Nullable)cancelText
                   unitId:(NSString *_Nullable)unitId;
@end

@interface MTGBidRewardAdManager : NSObject

/* Play the video mute or not in the beginning, defult is NO */
@property (nonatomic, assign) BOOL  playVideoMute;


/**
 * The shared instance of the video.
 *
 * @return The video singleton.
 */
+ (nonnull instancetype)sharedInstance;

/**
*  Called when load the video
*
*  @param bidToken    - the token from bid request within MTGBidFramework.
*  @param placementId       - the placementId string of the Ad that display.
*  @param unitId        - the unitId string of the Ad that was loaded.
*  @param delegate    - reference to the object that implements MTGRewardAdLoadDelegate protocol; will receive load events for the given unitId.
*/
- (void)loadVideoWithBidToken:(nonnull NSString *)bidToken
                  placementId:(nullable NSString *)placementId
                       unitId:(nonnull NSString *)unitId
                     delegate:(nullable id <MTGRewardAdLoadDelegate>)delegate;
/**
*  Called when show the video
*
*  @param placementId         - the placementId string of the Ad that display.
*  @param unitId         - the unitId string of the Ad that display.
*  @param rewardId       - the reward info you can set in mintegral portal
*  @param userId       - The user's unique identifier in your system
*  @param delegate       - reference to the object that implements MTGRewardAdShowDelegate protocol; will receive show events for the given unitId.
*  @param viewController - UIViewController that shouold be set as the root view controller for the ad
*/
- (void)showVideoWithPlacementId:(nullable NSString *)placementId
                          unitId:(nonnull  NSString *)unitId
                    withRewardId:(nullable NSString *)rewardId
                          userId:(nullable NSString *)userId
                        delegate:(nullable id <MTGRewardAdShowDelegate>)delegate
                  viewController:(nonnull UIViewController*)viewController;

/**
 *  Will return whether the given unitId is loaded and ready to be shown.
 *
 *  @param placementId - adPositionId value in Self Service
 *  @param unitId - adPositionId value in Self Service
 *
 *  @return - YES if the unitId is loaded and ready to be shown, otherwise NO.
 */
- (BOOL)isVideoReadyToPlayWithPlacementId:(nullable NSString *)placementId unitId:(nonnull NSString *)unitId;

/**
 *  Clean all the video file cache from the disk.
 */
- (void)cleanAllVideoFileCache;


/**
*  Set  alertView text,if you want to change the alertView text.
*
* @param title  alert title
* @param content    alertcontent
* @param confirmText    confirm button text
* @param cancelText     cancel button text
* @param unitId     unitId

 NOTE:called before loadAd
*/
- (void)setAlertWithTitle:(NSString *_Nullable)title
                  content:(NSString *_Nullable)content
              confirmText:(NSString *_Nullable)confirmText
               cancelText:(NSString *_Nullable)cancelText
                   unitId:(NSString *_Nullable)unitId;

@end

#endif /* OMMintegralRewardedVideoClass_h */
