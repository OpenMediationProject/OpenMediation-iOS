// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMAdSingletonInterface.h"
#import "OMInterstitialDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface OMInterstitial : OMAdSingletonInterface

/// Returns the singleton instance.
+ (instancetype)sharedInstance;

/// Add delegate
- (void)addDelegate:(id<OMInterstitialDelegate>)delegate;

/// Remove delegate
- (void)removeDelegate:(id<OMInterstitialDelegate>)delegate;

/// Indicates whether the interstitial video is ready to show ad.
- (BOOL)isReady;

/// Indicates whether the scene has reached the display frequency.
- (BOOL)isCappedForScene:(NSString *)sceneName;

/// Presents the interstitial video ad modally from the specified view controller.
/// Parameter viewController: The view controller that will be used to present the video ad.
/// Parameter sceneName: The name of th ad scene. Default scene if null.
- (void)showWithViewController:(UIViewController *)viewController scene:(NSString *)sceneName;

@end

NS_ASSUME_NONNULL_END
