// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdmostInterstitialClass_h
#define OMAdmostInterstitialClass_h
#import "OMAdmostClass.h"

@class AMRInterstitial, AMRError;

/**
 * @protocol AMRInterstitialDelegate
 * @brief The AMRInterstitialDelegate protocol.
 * This protocol is used as a delegate for interstitial events.
 */
@protocol AMRInterstitialDelegate <NSObject>

/**
 * Successfully received an interstitial. Call AMRInterstitial's showFromViewController method to show interstitial.
 * Example usage:
 * @code
 * [interstitial showFromViewController:myViewController];
 * @endcode
 * @param interstitial AMRInterstitial object to show.
 */
- (void)didReceiveInterstitial:(AMRInterstitial *)interstitial;

/**
 * Failed to receive an interstitial. Inspect AMRError's errorCode and errorDescription properties to identify the problem.
 * @param interstitial Failed AMRInterstitial object.
 * @param error AMRError object with error code and descriptions.
 */
- (void)didFailToReceiveInterstitial:(AMRInterstitial *)interstitial error:(AMRError * )error;

@optional

/**
 * Successfully shown received interstital.
 * @param interstitial Shown AMRInterstitial object.
 */
- (void)didShowInterstitial:(AMRInterstitial *)interstitial;

/**
 * Failed to show interstitial. This delegate expected to be called very rarely.
 * @param interstitial Failed AMRInterstitial object.
 * @param error AMRError object with error code and descriptions.
 */
- (void)didFailToShowInterstitial:(AMRInterstitial *)interstitial error:(AMRError *)error;

/**
 * User clicked interstital.
 * @param interstitial Clicked AMRInterstitial object.
 */
- (void)didClickInterstitial:(AMRInterstitial *)interstitial;

/**
 * Presented interstital is dismissed. Continue stopped tasks while the interstital ad is present.
 * @param interstitial Dismissed AMRInterstitial object.
 */
- (void)didDismissInterstitial:(AMRInterstitial *)interstitial;

/**
 * Intersitital state changed.
 * @param interstitial AMRInterstitial object.
 * @param state AMRInterstitial new state.
 */
- (void)didInterstitialStateChanged:(AMRInterstitial *)interstitial state:(AMRAdState)state;

@end

@interface AMRInterstitial : AMRAd

/// An object conforms to <AMRInterstitialDelegate> protocol.
@property (weak) id<AMRInterstitialDelegate> delegate;
/// Returns YES if the interstitial is requested.
@property (nonatomic, readonly) BOOL isLoading;
/// Returns YES if the interstitial is loaded.
@property (nonatomic, readonly) BOOL isLoaded;

/**
 * Create an instance of AMRInterstitial to show in your application.
 * Example usage:
 * @code
 * [AMRInterstitial interstitialForZoneId:@"<zoneId>"];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param zoneId Your interstitial's zone ID displayed on AMR Dashboard.
 * @return An instance of AMRInterstitial created by zoneId provided.
 */
+ (instancetype)interstitialForZoneId:(NSString *)zoneId;

/**
 * Start interstitial load request. Delegate must be set before loading an interstitial ad.
 * Example usage:
 * @code
 * [interstitial loadInterstitial];
 * @endcode
 */
- (void)loadInterstitial;

/**
 * Use to show interstitial after delegate callback of AMRInterstitialDelegate's didReceiveInterstitial method.
 * Example usage:
 * @code
 * [interstitial showFromViewController:myViewController];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param viewController Your interstitial's presenting viewcontroller.
 */
- (void)showFromViewController:(UIViewController * )viewController;

/**
 * Use to show interstitial after delegate callback of AMRInterstitialDelegate's didReceiveInterstitial method.
 * Example usage:
 * @code
 * [interstitial showFromViewController:myViewController withTag:@"<myTag>"];
 * @endcode
 * @see https://admost.github.io/amrios for more information.
 * @param viewController Your interstitial's presenting viewcontroller.
 * @param tag Distinction value for ads that used in multiple purposes.
 */
- (void)showFromViewController:(UIViewController * )viewController withTag:(NSString *)tag;

@end



#endif /* OMAdmostInterstitialClass_h */
