// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdmostRewardedVideoClass_h
#define OMAdmostRewardedVideoClass_h
#import "OMAdmostClass.h"

@class AMRRewardedVideo, AMRError;

/**
 * @protocol AMRRewardedVideoDelegate
 * @brief The AMRRewardedVideoDelegate protocol.
 * This protocol is used as a delegate for rewarded video events.
 */
@protocol AMRRewardedVideoDelegate <NSObject>

/**
 * Successfully received a rewarded video. Call AMRRewardedVideo's showFromViewController method to start rewarded video.
 * Example usage:
 * @code
 * [rewardedVideo showFromViewController:myViewController];
 * @endcode
 * @param rewardedVideo AMRRewardedVideo object to show.
 */
- (void)didReceiveRewardedVideo:(AMRRewardedVideo *)rewardedVideo;

/**
 * Failed to receive an rewarded video. Inspect AMRError's errorCode and errorDescription properties to identify the problem.
 * @param rewardedVideo Failed AMRRewardedVideo object.
 * @param error AMRError object with error code and descriptions.
 */
- (void)didFailToReceiveRewardedVideo:(AMRRewardedVideo *)rewardedVideo error:(AMRError *)error;

@optional

/**
 * Successfully shown received rewarded video.
 * @param rewardedVideo Shown AMRRewardedVideo object.
 */
- (void)didShowRewardedVideo:(AMRRewardedVideo *)rewardedVideo;

/**
 * Failed to show rewarded video. This delegate expected to be called very rarely.
 * @param rewardedVideo Failed AMRRewardedVideo object.
 * @param error AMRError object with error code and descriptions.
 */
- (void)didFailToShowRewardedVideo:(AMRRewardedVideo *)rewardedVideo error:(AMRError *)error;

/**
 * @deprecated This method is deprecated starting in version 1.3.84
 * Failed to show rewarded video. This delegate expected to be called very rarely.
 * @param rewardedVideo Failed AMRRewardedVideo object.
 */
- (void)didFailToShowRewardedVideo:(AMRRewardedVideo *)rewardedVideo __attribute__((deprecated));

/**
 * User clicked rewarded video.
 * @param rewardedVideo Clicked AMRRewardedVideo object.
 */
- (void)didClickRewardedVideo:(AMRRewardedVideo *)rewardedVideo;

/**
 * User watched rewarded video till end. User can get the reward.
 * @param rewardedVideo AMRRewardedVideo object.
 */
- (void)didCompleteRewardedVideo:(AMRRewardedVideo *)rewardedVideo;

/**
 * Presented rewarded video is dismissed. Continue stopped tasks while the rewardedvideo ad is present. Called after didCompleteRewardedVideo delegate callback.
 * @param rewardedVideo Dismissed AMRRewardedVideo object.
 */
- (void)didDismissRewardedVideo:(AMRRewardedVideo *)rewardedVideo;

/**
 * Rewarded video state changed.
 * @param rewardedVideo AMRRewardedVideo object.
 * @param state AMRRewardedVideo new state.
 */
- (void)didRewardedVideoStateChanged:(AMRRewardedVideo *)rewardedVideo state:(AMRAdState)state;

@end

@interface AMRRewardedVideo : AMRAd

/// An object conforms to <AMRRewardedVideoDelegate> protocol.
@property (weak) id<AMRRewardedVideoDelegate> delegate;
/// Returns YES if the rewarded video is requested.
@property (nonatomic, readonly) BOOL isLoading;
/// Returns YES if the rewarded video is loaded.
@property (nonatomic, readonly) BOOL isLoaded;

/// Parameter to move your custom data.
@property (nonatomic, strong) NSDictionary *customData;

/// Parameter to set reward amount.
@property (nonatomic, assign) CGFloat completionReward;

/// Server Key for server to server.
@property (nonatomic, strong) NSString *ssvServerKey;

/**
 * Create an instance of AMRRewardedVideo to show in your application.
 * Example usage:
 * @code
 * [AMRRewardedVideo rewardedVideoForZoneId:@"<zoneId>"];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param zoneId Your rewardedvideo's zone ID displayed on AMR Dashboard.
 * @return An instance of AMRRewardedVideo created by zoneId provided.
 */
+ (instancetype)rewardedVideoForZoneId:(NSString *)zoneId;

/**
 * Start rewardedvideo load request. Delegate must be set before loading an rewardedvideo.
 * Example usage:
 * @code
 * [rewardedVideo loadRewardedVideo];
 * @endcode
 */
- (void)loadRewardedVideo;

/**
 * Use to show rewardedvideo after delegate callback of AMRRewardedVideoDelegate's didReceiveRewardedVideo method.
 * Example usage:
 * @code
 * [rewardedVideo showFromViewController:myViewController];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param viewController Your rewardedvideo's presenting viewcontroller.
 */
- (void)showFromViewController:(UIViewController * )viewController;

/**
 * Use to show rewardedvideo after delegate callback of AMRRewardedVideoDelegate's didReceiveRewardedVideo method.
 * Example usage:
 * @code
 * [rewardedVideo showFromViewController:myViewController withTag:@"<myTag>"];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param viewController Your rewardedvideo's presenting viewcontroller.
 * @param tag Distinction value for ads that used in multiple purposes.
 */
- (void)showFromViewController:(UIViewController * )viewController withTag:(NSString *)tag;

@end


#endif /* OMAdmostRewardedVideoClass_h */
