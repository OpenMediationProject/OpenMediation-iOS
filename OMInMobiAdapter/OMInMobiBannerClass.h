// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMInMobiBannerClass_h
#define OMInMobiBannerClass_h
#import "OMInMobiClass.h"

NS_ASSUME_NONNULL_BEGIN

@class IMBanner;
@protocol IMBannerDelegate <NSObject>
@optional
/**
 *Notifies the delegate that the banner got signals
 */
-(void)banner:(IMBanner*)banner gotSignals:(NSData*)signals;
/**
 *Notifies the delegate that the banner has failed to get Signals with some error
 */
-(void)banner:(IMBanner *)banner failedToGetSignalsWithError:(IMRequestStatus*)status;
/**
 * Notifies the delegate that the banner has finished loading
 */
-(void)bannerDidFinishLoading:(IMBanner*)banner;
/**
 * Notifies the delegate that the banner has recieved the ad with the meta/transaction info.
*/
-(void)banner:(IMBanner*)banner didReceiveWithMetaInfo:(IMAdMetaInfo*)info;
/**
 * Notifies the delegate that the banner has failed to preload with some error.
 * It will only be recieved when preload is called.
 */
-(void)banner:(IMBanner*)banner didFailToReceiveWithError:(IMRequestStatus*)error;
/**
 * Notifies the delegate that the banner has failed to load with some error.
 */
-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error;
/**
 * Notifies the delegate that the banner was interacted with.
 */
-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params;
/**
 * Notifies the delegate that the user would be taken out of the application context.
 */
-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner;
/**
 * Notifies the delegate that the banner would be presenting a full screen content.
 */
-(void)bannerWillPresentScreen:(IMBanner*)banner;
/**
 * Notifies the delegate that the banner has finished presenting screen.
 */
-(void)bannerDidPresentScreen:(IMBanner*)banner;
/**
 * Notifies the delegate that the banner will start dismissing the presented screen.
 */
-(void)bannerWillDismissScreen:(IMBanner*)banner;
/**
 * Notifies the delegate that the banner has dismissed the presented screen.
 */
-(void)bannerDidDismissScreen:(IMBanner*)banner;
/**
 * Notifies the delegate that the user has completed the action to be incentivised with.
 */
-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards;

@end

@interface IMBannerPreloadManager : NSObject

-(instancetype)init NS_UNAVAILABLE;
/**
 * Preloads a Banner ad and returns the following callback.
 *       Meta Information will be recieved from the callback banner:didReceiveWithMetaInfo
 *       Failure of Preload will be recieved from the callback banner:didFailToReceiveWithError
 */
-(void)preload;
/**
 * Loads a Preloaded Banner ad.
 */
-(void)load;

@end


@interface IMBanner : UIView
/**
 * The delegate for the banner to notify of events.
 */
@property (nonatomic, weak) id<IMBannerDelegate> delegate;
/**
 * The refresh interval for the banner specified in seconds.
 */
@property (nonatomic) NSInteger refreshInterval;
/**
 * A free form set of keywords, separated by ',' to be sent with the ad request.
 * E.g: "sports,cars,bikes"
 */
@property (nonatomic, strong) NSString* keywords;
/**
 * Any additional information to be passed to InMobi.
 */
@property (nonatomic, strong) NSDictionary* extras;
/**
 * The placement ID for this banner.
 */
@property (nonatomic) long long placementId;
/**
 * The transition animation to be performed between refreshes.
 */
@property (nonatomic) UIViewAnimationTransition transitionAnimation;
/**
 * A unique identifier for the creative.
 */
@property (nonatomic, strong, readonly) NSString* creativeId;
/**
 *The prelaod Manager for Preload flow.
*/
@property (nonatomic, strong, readonly) IMBannerPreloadManager* preloadManager;

/**
 * Initializes an IMBanner instance with the specified placementId.
 * @param frame CGRect for this view, according to the requested size.
 * @param placementId  the placement Id registered on the InMobi portal.
 */
-(instancetype)initWithFrame:(CGRect)frame placementId:(long long)placementId;
/**
 * Initializes an IMBanner instance with the specified placementId and delegate.
 * @param frame CGRect for this view, according to the requested size.
 * @param placementId  the placement Id registered on the InMobi portal.
 * @param delegate The delegate to receive callbacks
 */
-(instancetype)initWithFrame:(CGRect)frame placementId:(long long)placementId delegate:(id<IMBannerDelegate>)delegate;
/**
 *Get a Signal packet from the InMobi SDK. Signals are used in the Open Auction scenarios and are an abstraction of InMobi'sAd Request. Signals are asynchronously passed via IMBannerDelegate Protocol method "banner:gotSignals:"
 */
- (void)getSignals;
/**
 * Loads a banner with default values.
 */
-(void)load;
/**
 * Loads a Banner Ad with a response Object. This is used for Open Auction use cases
 * @param response An NSData object which contains the InMobi Banner Ad
 */
-(void)load:(NSData*)response;
/**
 * Specifies if the banner should auto refresh
 * @param refresh if the banner should be refreshed
 */
-(void)shouldAutoRefresh:(BOOL)refresh;
-(void)setRefreshInterval:(NSInteger)interval;

/**
 * Contains additional information of ad.
 */
- (NSDictionary *)getAdMetaInfo;

/**
 * Releases memory and remove ad from screen.
 */
- (void)cancel;

@end

#endif /* OMInMobiBannerClass_h */

NS_ASSUME_NONNULL_END
