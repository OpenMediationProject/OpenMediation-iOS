// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingNativeClass_h
#define OMAdTimingNativeClass_h
#import <UIKit/UIKit.h>

@class AdTimingNative;
@class AdTimingNativeAd;
@class AdTimingNativeMediaView;
@class AdTimingAdBase;
@class AdTimingNativeDelegate;

NS_ASSUME_NONNULL_BEGIN

/// The methods declared by the AdTimingNativeDelegate protocol allow the adopting delegate to respond to messages from the AdTimingNative class and thus respond to operations such as whether the native ad has been loaded.
@protocol AdTimingNativeDelegate<NSObject>

@optional

/// Sent when an AdTimingNative has been successfully loaded.
- (void)adtimingNative:(AdTimingNative*)native didLoad:(AdTimingNativeAd*)nativeAd;

/// Sent when an AdTimingNative is failed to load.
- (void)adtimingNative:(AdTimingNative*)native didFailWithError:(NSError*)error;

/// Sent immediately before the impression of an AdTimingNative object will be logged.
- (void)adtimingNativeWillExposure:(AdTimingNative*)native;

/// Sent after an ad has been clicked by the person.
- (void)adtimingNativeDidClick:(AdTimingNative*)native;

@end

/// The AdTimingNative represents ad metadata to allow you to construct custom ad views.
@interface AdTimingNative : NSObject

/// the delegate
@property(nonatomic, weak, nullable) id<AdTimingNativeDelegate> delegate;

/// The native's ad placement ID.
- (NSString*)placementID;

/// This is a method to initialize an AdTimingNative.
/// placementID: Typed access to the id of the ad placement.
- (instancetype)initWithPlacementID:(NSString*)placementID;

/// This is a method to initialize an AdTimingNative.
/// placementID: Typed access to the id of the ad placement.
/// viewController: The view controller that will be used to present the ad and the app store view.
- (instancetype)initWithPlacementID:(NSString*)placementID rootViewController:(UIViewController*)viewController;

/// Begins loading the AdTimingNative content.
- (void)loadAd;

@end

/// The AdTimingNative represents ad metadata to allow you to construct custom ad views.
@interface AdTimingNativeAd : NSObject

/// Typed access to the ad title.
@property (nonatomic, copy) NSString *title;

/// Typed access to the body text, usually a longer description of the ad.
@property (nonatomic, copy) NSString *body;

/// Typed access to the ad icon.
@property (nonatomic, copy) NSString *iconUrl;

/// Typed access to the call to action phrase of the ad.
@property (nonatomic, copy) NSString *callToAction;

/// Typed access to the ad star rating.
@property (nonatomic, assign) double rating;

@end

/// A customized UIView to represent a ad (native ad).
@interface AdTimingNativeView : UIView

@property (nonatomic, strong) AdTimingNativeAd *nativeAd;
@property (nonatomic, strong) AdTimingNativeMediaView *mediaView;

/// This is a method to initialize an AdTimingNativeView.
/// Parameter frame: the AdTimingNativeView frame.
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setFbNativeClickableViews:(NSArray<UIView *> *)clickableViews;

@end

@interface AdTimingNativeMediaView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdTimingNativeClass_h */
