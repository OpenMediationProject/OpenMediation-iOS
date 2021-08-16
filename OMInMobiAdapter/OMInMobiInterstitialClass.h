// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMInMobiInterstitialClass_h
#define OMInMobiInterstitialClass_h
#import "OMInMobiClass.h"

typedef NS_ENUM(NSInteger, IMInterstitialAnimationType) {
    kIMInterstitialAnimationTypeCoverVertical,
    kIMInterstitialAnimationTypeFlipHorizontal,
    kIMInterstitialAnimationTypeNone
};

@interface IMInterstitialPreloadManager : NSObject

-(instancetype)init NS_UNAVAILABLE;
/**
 * Preload a Interstitial ad and returns the following callbacks.
 *       Meta Information will be recieved from the callback interstitial:didReceiveWithMetaInfo
 *       Failure of Preload will be recieved from the callback interstitial:didFailToReceiveWithError
 */
-(void)preload;
/**
 * Loads a Preloaded Interstitial ad.
 */
-(void)load;

@end

@class IMInterstitial;
@protocol IMInterstitialDelegate <NSObject>
@optional

/**
 * Notifies the delegate that the ad server has returned an ad. Assets are not yet available.
 * Please use interstitialDidFinishLoading: to receive a callback when assets are also available.
 */
-(void)interstitial:(IMInterstitial*)interstitial didReceiveWithMetaInfo:(IMAdMetaInfo*)metaInfo;
/**
 * Notifies the delegate that the interstitial has failed to recieve an Ad(failed to preload an ad) with some error.
 * This callback will only be recieved when Preload is called.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToReceiveWithError:(NSError*)error;
/**
 *Notifies the delegate that the Interstitial got signals
 */
-(void)interstitial:(IMInterstitial*)interstitial gotSignals:(NSData*)signals;
/**
 *Notifies the delegate that the Interstitial has failed to get Signals with some error
 */
-(void)interstitial:(IMInterstitial*)interstitial failedToGetSignalsWithError:(IMRequestStatus*)status;
/**
 * Notifies the delegate that the ad server has returned an ad. Assets are not yet available.
 * Please use interstitialDidFinishLoading: to receive a callback when assets are also available.
 */
-(void)interstitialDidReceiveAd:(IMInterstitial*)interstitial __attribute((deprecated("Please use new API interstitial:didReceiveWithMetaInfo: as this API can be removed in future")));
/**
 * Notifies the delegate that the interstitial has finished loading and can be shown instantly.
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial;
/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus *)error;
/**
 * Notifies the delegate that the interstitial would be presented.
 */
-(void)interstitialWillPresent:(IMInterstitial*)interstitial;
/**
 * Notifies the delegate that the interstitial has been presented.
 */
-(void)interstitialDidPresent:(IMInterstitial*)interstitial;
/**
 * Notifies the delegate that the interstitial has failed to present with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error;
/**
 * Notifies the delegate that the interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial;
/**
 * Notifies the delegate that the interstitial has been dismissed.
 */
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial;
/**
 * Notifies the delegate that the interstitial has been interacted with.
 */
-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params;
/**
 * Notifies the delegate that the user has performed the action to be incentivised with.
 */
-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards;
/**
 * Notifies the delegate that the user will leave application context.
 */
-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial;

@end

@interface IMInterstitial : NSObject

/**
 * The placement ID for this Interstitial.
 */
@property (nonatomic, assign) long long placementId;
/**
 * The delegate to receive callbacks
 */
@property (nonatomic, weak) id<IMInterstitialDelegate> delegate;
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
 * A unique identifier for the creative.
 */
@property (nonatomic, strong, readonly) NSString* creativeId;
/**
 *The prelaod Manager for Preload flow.
*/
@property (nonatomic, strong, readonly) IMInterstitialPreloadManager* preloadManager;

/**
 * init and new methods are unavailable for this class
 * use "initWithPlacementId:" or "initWithPlacementId:delegate:" method.
 */
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 * Initialize an Interstitial with the given PlacementId
 * @param placementId The placementId for loading the interstitial
 */
-(instancetype)initWithPlacementId:(long long)placementId;
/**
 * Initialize an Interstitial with the given PlacementId
 * @param placementId The placementId for loading the interstitial
 * @param delegate The delegate to receive callbacks
 */
-(instancetype)initWithPlacementId:(long long)placementId delegate:(id<IMInterstitialDelegate>)delegate NS_DESIGNATED_INITIALIZER;
/**
 *Get a Signal packet from the InMobi SDK. Signals are used in the Open Auction scenarios and are an abstraction of InMobi'sAd Request. Signals are asynchronously passed via IMInterstitialDelegate Protocol method "Interstitial:gotSignals:"
 */
- (void)getSignals;
/**
 * Loads an Interstitial
 */
-(void)load;
/**
 * Loads an Interstitial Ad with a response Object. This is used for Open Auction use cases
 * @param response An NSData object which contains the InMobi Banner Ad
 */
-(void)load:(NSData*)response;
/**
 * To query if the interstitial is ready to be shown
 */
-(BOOL)isReady;
/**
 * Displays the interstitial on the screen
 * @param viewController , this view controller will be used to present interestitial.
 */
-(void)showFromViewController:(UIViewController *)viewController;
/**
 * Displays the interstitial on the screen
 * @param viewController , this view controller will be used to present interestitial.
 * @param type The transition type for interstitial presentation.
 */
-(void)showFromViewController:(UIViewController *)viewController withAnimation:(IMInterstitialAnimationType)type;
/**
 * Contains additional information of ad.
 */
- (NSDictionary *)getAdMetaInfo;
/**
 * Releases memory and remove ad from screen.
 */
- (void)cancel;

@end

#endif /* OMInMobiInterstitialClass_h */
