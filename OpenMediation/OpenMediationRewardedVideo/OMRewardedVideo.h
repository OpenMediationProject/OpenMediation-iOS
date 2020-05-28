// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMAdSingletonInterface.h"
#import "OMRewardedVideoDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// A modal view controller to represent a rewarded video ad. This is a full-screen ad shown in your application.
@interface OMRewardedVideo : OMAdSingletonInterface

/// Returns the singleton instance.
+ (instancetype)sharedInstance;

/// Add delegate
- (void)addDelegate:(id<OMRewardedVideoDelegate>)delegate;

/// Remove delegate
- (void)removeDelegate:(id<OMRewardedVideoDelegate>)delegate;

/// Indicates whether the rewarded video is ready to show ad.
- (BOOL)isReady;

/// Indicates whether the scene has reached the display frequency.
- (BOOL)isCappedForScene:(NSString *)sceneName;

/// Presents the rewarded video ad modally from the specified view controller.
/// Parameter viewController: The view controller that will be used to present the video ad.
/// Parameter sceneName: The name of th ad scene.
- (void)showWithViewController:(UIViewController *)viewController scene:(NSString *)sceneName;

/// Presents the rewarded video ad modally from the specified view controller.
/// Parameter viewController: The view controller that will be used to present the video ad.
/// Parameter sceneName: The name of th ad scene. Default scene if null.
/// Parameter extraParams: Exciting video Id.
- (void)showWithViewController:(UIViewController *)viewController scene:(NSString *)sceneName extraParams:(NSString*)extraParams;

@end

NS_ASSUME_NONNULL_END
