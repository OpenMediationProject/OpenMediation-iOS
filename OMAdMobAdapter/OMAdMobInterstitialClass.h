#ifndef OMAdMobInterstitialClass_h
#define OMAdMobInterstitialClass_h
#import <UIKit/UIKit.h>
#import "OMAdMobClass.h"

@class GADInterstitial;

NS_ASSUME_NONNULL_BEGIN

@protocol GADInterstitialDelegate<NSObject>
@optional

#pragma mark Ad Request Lifecycle Notifications

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad;

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error;

#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad;

/// Called when |ad| fails to present.
- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad;

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad;

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad;

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad;

@end

@interface GADInterstitial : NSObject

- (instancetype)initWithAdUnitID:(NSString *)adUnitID NS_DESIGNATED_INITIALIZER;

@property(nonatomic, readonly, copy, nullable) NSString *adUnitID;

@property(nonatomic, weak, nullable) id<GADInterstitialDelegate> delegate;

- (void)loadRequest:(nullable GADRequest *)request;

@property(nonatomic, readonly, assign) BOOL isReady;

@property(nonatomic, readonly, assign) BOOL hasBeenUsed;

@property(nonatomic, readonly, copy, nullable) NSString *adNetworkClassName;

- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdMobInterstitialClass_h */
