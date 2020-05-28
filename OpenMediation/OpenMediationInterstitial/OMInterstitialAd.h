// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMAdBase.h"

NS_ASSUME_NONNULL_BEGIN

@class OMInterstitialAd;

@protocol InterstitialDelegate<NSObject>

@optional

/// Sent after an OMInterstitialAdfails to load the ad.
- (void)interstitialChangedAvailability:(OMInterstitialAd*)interstitial newValue:(BOOL)available;

/// Sent immediately before the impression of an OMInterstitialAdobject will be logged.
- (void)interstitialDidOpen:(OMInterstitialAd*)interstitial;

- (void)interstitialDidShow:(OMInterstitialAd*)interstitial;

/// Sent after an ad has been clicked by the person.
- (void)interstitialDidClick:(OMInterstitialAd*)interstitial;

/// Sent after an OMInterstitialAdobject has been dismissed from the screen, returning control to your application.
- (void)interstitialDidClose:(OMInterstitialAd*)interstitial;

- (void)interstitialDidFailToShow:(OMInterstitialAd*)interstitial error:(NSError*)error;

@end




/// A modal view controller to represent a OM interstitial ad. This is a full-screen ad shown in your application.
@interface OMInterstitialAd : OMAdBase

/// the delegate
@property (nonatomic, weak)id<InterstitialDelegate> delegate;

/// The interstitial's ad placement ID.
- (NSString*)placementID;

/// This is a method to initialize an OMInterstitialAdmatching the given placement id.
/// Parameter placementID: The id of the ad placement.
- (instancetype)initWithPlacementID:(NSString *)placementID;


/// Indicates whether the video is ready to show ad.
- (BOOL)isReady;


/// Begins loading the OMInterstitialAdcontent.
/// You can implement `OMInterstitialDidLoad:` and `OMInterstitial:didFailWithError:` methods of `InterstitialDelegate` if you would like to be notified as loading succeeds or fails.
- (void)loadAd;

- (void)preload;

/// Presents the interstitial ad modally from the specified view controller.
/// You can implement `OMInterstitialDidClick:` and `OMInterstitialDidClose:`methods of `InterstitialDelegate` if you would like to stay informed for thoses events
- (void)show;

/// Presents the interstitial ad modally from the specified view controller.
/// Parameter viewController: The view controller that will be used to present the interstitial ad.
- (void)showWithRootViewController:(UIViewController *)rootViewController scene:(NSString*)sceneName;

@end

NS_ASSUME_NONNULL_END
