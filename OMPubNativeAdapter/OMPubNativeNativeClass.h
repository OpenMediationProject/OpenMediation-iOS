// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMPubNativeNativeClass_h
#define OMPubNativeNativeClass_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class HyBidNativeAd;
@class HyBidTargetingModel;
@class HyBidReportingManager;


@protocol HyBidNativeAdDelegate <NSObject>

- (void)nativeAd:(HyBidNativeAd *)nativeAd impressionConfirmedWithView:(UIView *)view;
- (void)nativeAdDidClick:(HyBidNativeAd *)nativeAd;

@end

@protocol HyBidNativeAdFetchDelegate <NSObject>

- (void)nativeAdDidFinishFetching:(HyBidNativeAd *)nativeAd;
- (void)nativeAd:(HyBidNativeAd *)nativeAd didFailFetchingWithError:(NSError *)error;

@end

@protocol HyBidNativeAdLoaderDelegate<NSObject>

- (void)nativeLoaderDidLoadWithNativeAd:(HyBidNativeAd *)nativeAd;
- (void)nativeLoaderDidFailWithError:(NSError *)error;

@end

@interface HyBidNativeAdLoader : NSObject

@property (nonatomic, assign) BOOL isMediation;

- (void)loadNativeAdWithDelegate:(NSObject<HyBidNativeAdLoaderDelegate> *)delegate withZoneID:(NSString *)zoneID;

@end

@class HyBidAd;
@class HyBidNativeAdRenderer;

@protocol HyBidContentInfoViewDelegate<NSObject>

- (void)contentInfoViewWidthNeedsUpdate:(NSNumber *)width;

@end

@interface HyBidContentInfoView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, weak) NSObject <HyBidContentInfoViewDelegate> *delegate;

@end

@interface HyBidNativeAd : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) NSString *callToActionTitle;
@property (nonatomic, readonly) NSString *iconUrl;
@property (nonatomic, readonly) NSString *bannerUrl;
@property (nonatomic, readonly) NSString *clickUrl;
@property (nonatomic, readonly) NSNumber *rating;
@property (nonatomic, readonly) UIView *banner;
@property (nonatomic, readonly) UIImage *bannerImage;
@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, strong) HyBidAd *ad;
@property (nonatomic, readonly) HyBidContentInfoView *contentInfo;

@property (nonatomic, weak) NSObject<HyBidNativeAdDelegate> *delegate;

- (instancetype)initWithAd:(HyBidAd *)ad;
- (void)renderAd:(HyBidNativeAdRenderer *)renderer;
- (void)fetchNativeAdAssetsWithDelegate:(NSObject<HyBidNativeAdFetchDelegate> *)delegate;
- (void)startTrackingView:(UIView *)view withDelegate:(NSObject<HyBidNativeAdDelegate> *)delegate;
- (void)stopTracking;

@end

typedef BOOL(^PNLiteStarRatingViewShouldBeginGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizer);

IB_DESIGNABLE
@interface HyBidStarRatingView : UIControl
@property (nonatomic) IBInspectable NSUInteger maximumValue;
@property (nonatomic) IBInspectable CGFloat minimumValue;
@property (nonatomic) IBInspectable CGFloat value;
@property (nonatomic) IBInspectable CGFloat spacing;
@property (nonatomic) IBInspectable BOOL allowsHalfStars;
@property (nonatomic) IBInspectable BOOL accurateHalfStars;
@property (nonatomic) IBInspectable BOOL continuous;

@property (nonatomic) BOOL shouldBecomeFirstResponder;

// Optional: if `nil` method will return `NO`.
@property (nonatomic, copy) PNLiteStarRatingViewShouldBeginGestureRecognizerBlock shouldBeginGestureRecognizerBlock;

@property (nonatomic, strong) IBInspectable UIColor *starBorderColor;
@property (nonatomic) IBInspectable CGFloat starBorderWidth;
@property (nonatomic, strong) IBInspectable UIColor *emptyStarColor;
@property (nonatomic, strong) IBInspectable UIImage *emptyStarImage;
@property (nonatomic, strong) IBInspectable UIImage *halfStarImage;
@property (nonatomic, strong) IBInspectable UIImage *filledStarImage;
@end

@interface HyBidNativeAdRenderer : NSObject

@property (nonatomic, weak) UILabel *titleView;
@property (nonatomic, weak) UILabel *bodyView;
@property (nonatomic, weak) UIView *callToActionView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIView *bannerView;
@property (nonatomic, weak) UIView *contentInfoView;
@property (nonatomic, weak) HyBidStarRatingView *starRatingView;

@end

#endif /* OMPubNativeNativeClass_h */
