//
//  OMNative.h
//  OM SDK
//
//  Copyright 2017 OM Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMAdBase.h"
#import "OMNativeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// The OMNative represents ad metadata to allow you to construct custom ad views.
@interface OMNative : OMAdBase

/// the delegate
@property(nonatomic, weak, nullable) id<OMNativeDelegate> delegate;

/// The native's ad placement ID.
- (NSString*)placementID;

/// This is a method to initialize an OMNative.
/// placementID: Typed access to the id of the ad placement.
- (instancetype)initWithPlacementID:(NSString*)placementID;

/// This is a method to initialize an OMNative.
/// placementID: Typed access to the id of the ad placement.
/// viewController: The view controller that will be used to present the ad and the app store view.
- (instancetype)initWithPlacementID:(NSString*)placementID rootViewController:(UIViewController*)viewController;

/// Begins loading the OMNative content.
- (void)loadAd;
@end

NS_ASSUME_NONNULL_END
