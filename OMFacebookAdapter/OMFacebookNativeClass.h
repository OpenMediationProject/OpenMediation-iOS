// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMFacebookNativeClass_h
#define OMFacebookNativeClass_h
#import <UIKit/UIKit.h>

@class FBNativeAd;
@class FBMediaView;

NS_ASSUME_NONNULL_BEGIN

@protocol FBNativeAdDelegate <NSObject>

@optional

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd;

- (void)nativeAdDidDownloadMedia:(FBNativeAd *)nativeAd;

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd;

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error;

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd;

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd;

@end

struct FBAdStarRating {
    /// The value of the star rating, X in X/5
    CGFloat value;
    // The total possible star rating, Y in 4/Y
    NSInteger scale;
};

@interface FBAdImage : NSObject

@property (nonatomic, copy, readonly) NSURL *url;

@property (nonatomic, assign, readonly) NSInteger width;

@property (nonatomic, assign, readonly) NSInteger height;

@end

@interface FBNativeAd : NSObject
@property (nonatomic, assign, readonly) struct FBAdStarRating starRating;
@property (nonatomic, copy, readonly, nullable) NSString *headline;
@property (nonatomic, copy, readonly, nullable) NSString *advertiserName;
@property (nonatomic, copy, readonly, nullable) NSString *bodyText;
@property (nonatomic, strong, readonly, nullable) FBAdImage *adChoicesIcon;
@property (nonatomic, copy, readonly, nullable) NSString *callToAction;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;

@property (nonatomic, weak, nullable) id<FBNativeAdDelegate> delegate;

- (instancetype)initWithPlacementID:(NSString *)placementID;

- (void)loadAd;

- (void)loadAdWithBidPayload:(NSString *)bidPayload;

- (void)unregisterView;

- (void)registerViewForInteraction:(UIView *)view
                         mediaView:(FBMediaView *)mediaView
                          iconView:(nullable UIView *)iconView
                    viewController:(nullable UIViewController *)viewController
                    clickableViews:(nullable NSArray<UIView *> *)clickableViews;

@end

@protocol FBMediaViewDelegate <NSObject>

@optional


- (void)mediaViewDidLoad:(FBMediaView *)mediaView;

- (void)mediaViewWillEnterFullscreen:(FBMediaView *)mediaView;

- (void)mediaViewDidExitFullscreen:(FBMediaView *)mediaView;

- (void)mediaView:(FBMediaView *)mediaView videoVolumeDidChange:(float)volume;

- (void)mediaViewVideoDidPause:(FBMediaView *)mediaView;

- (void)mediaViewVideoDidPlay:(FBMediaView *)mediaView;

- (void)mediaViewVideoDidComplete:(FBMediaView *)mediaView;

@end

@interface FBMediaView : UIView
@property (nonatomic, weak, nullable) id<FBMediaViewDelegate> delegate;

@end


@interface FBAdChoicesView : UIView
@property (nonatomic, weak, readwrite, nullable) FBNativeAd *nativeAd;
@property (nonatomic, assign, readwrite) UIRectCorner corner;
- (instancetype)initWithNativeAd:(FBNativeAd *)nativeAd;
@end

NS_ASSUME_NONNULL_END

#endif /* ATNativeFacebookClass_h */
