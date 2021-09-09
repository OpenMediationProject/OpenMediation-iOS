// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdTimingNativeClass_h
#define OMAdTimingNativeClass_h
#import <UIKit/UIKit.h>

@class AdTimingBidNative;
@class AdTimingBidNativeAd;
@class AdTimingBidNativeMediaView;
@class AdTimingBidAdBase;
@class AdTimingBidNativeDelegate;

NS_ASSUME_NONNULL_BEGIN

/// The methods declared by the AdTimingNativeDelegate protocol allow the adopting delegate to respond to messages from the AdTimingNative class and thus respond to operations such as whether the native ad has been loaded.
@protocol AdTimingBidNativeDelegate<NSObject>

@optional

/// Sent when an AdTimingNative has been successfully loaded.
- (void)AdTimingBidNative:(AdTimingBidNative*)native didLoad:(AdTimingBidNativeAd*)nativeAd;

/// Sent when an AdTimingNative is failed to load.
- (void)AdTimingBidNative:(AdTimingBidNative*)native didFailWithError:(NSError*)error;

@end

/// The AdTimingNative represents ad metadata to allow you to construct custom ad views.
@interface AdTimingBidNative : NSObject

/// the delegate
@property(nonatomic, weak, nullable) id<AdTimingBidNativeDelegate> delegate;

/// The native's ad placement ID.
- (NSString*)placementID;

/// This is a method to initialize an AdTimingBidNative.
/// placementID: Typed access to the id of the ad placement.
- (instancetype)initWithPlacementID:(NSString*)placementID;

/// This is a method to initialize an AdTimingBidNative.
/// placementID: Typed access to the id of the ad placement.
/// viewController: The view controller that will be used to present the ad and the app store view.
- (instancetype)initWithPlacementID:(NSString*)placementID rootViewController:(UIViewController*)viewController;

///load ad with bid payload
- (void)loadAdWithPayLoad:(NSString*)bidPayload;

@end

@protocol AdTimingBidNativeAdDelegate<NSObject>

@optional

/// Sent immediately before the impression of an AdTimingBidNativeAd will be logged.
- (void)AdTimingBidNativeAdWillShow:(AdTimingBidNativeAd*)nativeAd;

/// Sent after an ad has been clicked by the person.
- (void)AdTimingBidNativeAdDidClick:(AdTimingBidNativeAd*)nativeAd;

@end

/// The AdTimingNative represents ad metadata to allow you to construct custom ad views.
@interface AdTimingBidNativeAd : NSObject

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

@property (nonatomic, strong) id <AdTimingBidNativeAdDelegate> delegate;

@end

/// A customized UIView to represent a ad (native ad).
@interface AdTimingBidNativeView : UIView

@property (nonatomic, strong) AdTimingBidNativeAd *nativeAd;
@property (nonatomic, strong) AdTimingBidNativeMediaView *mediaView;

/// This is a method to initialize an AdTimingNativeView.
/// Parameter frame: the AdTimingNativeView frame.
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setFbNativeClickableViews:(NSArray<UIView *> *)clickableViews;

@end

@interface AdTimingBidNativeMediaView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdTimingNativeClass_h */
