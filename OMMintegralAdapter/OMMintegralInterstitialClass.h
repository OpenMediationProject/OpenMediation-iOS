// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralInterstitialClass_h
#define OMMintegralInterstitialClass_h
#import <UIKit/UIKit.h>

@class MTGInterstitialVideoAd;
@class MTGInterstitialVideoAdManager;
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

/**
 * Play the video is mute in the beginning ,defult is NO
 *
 */
@property (nonatomic, assign) BOOL  playVideoMute;



- (nonnull instancetype)initWithUnitID:(nonnull NSString *)unitId delegate:(nullable id<MTGInterstitialVideoDelegate>)delegate;


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
 *
 *  @param unitId - adPositionId value in Self Service.
 *
 *  @return - YES if the unitId is loaded and ready to be shown, otherwise NO.
 */
- (BOOL)isVideoReadyToPlay:(nonnull NSString *)unitId;

/**
 *  Clean all the video file cache from the disk.
 */
- (void)cleanAllVideoFileCache;


@end



#endif /* OMMintegralInterstitialClass_h */
