// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralBannerClass_h
#define OMMintegralBannerClass_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OMMintegralClass.h"

NS_ASSUME_NONNULL_BEGIN

@class MTGBannerAdView;
@class MTGAdSize;

typedef NS_ENUM(NSInteger,MTGBannerSizeType) {
    /*Represents the fixed banner ad size - 320pt by 50pt.*/
    MTGStandardBannerType320x50,
    
    /*Represents the fixed banner ad size - 320pt by 90pt.*/
    MTGLargeBannerType320x90,
    
    /*Represents the fixed banner ad size - 300pt by 250pt.*/
    MTGMediumRectangularBanner300x250,
    
    /*if device height <=720,Represents the fixed banner ad size - 320pt by 50pt;
      if device height > 720,Represents the fixed banner ad size - 728pt by 90pt*/
    MTGSmartBannerType
};

@class MTGBannerAdView;

@protocol MTGBannerAdViewDelegate <NSObject>

- (void)adViewLoadSuccess:(MTGBannerAdView *)adView;

- (void)adViewLoadFailedWithError:(NSError *)error adView:(MTGBannerAdView *)adView;


- (void)adViewWillLogImpression:(MTGBannerAdView *)adView;


- (void)adViewDidClicked:(MTGBannerAdView *)adView;


- (void)adViewWillLeaveApplication:(MTGBannerAdView *)adView;


- (void)adViewWillOpenFullScreen:(MTGBannerAdView *)adView;


- (void)adViewCloseFullScreen:(MTGBannerAdView *)adView;


- (void)adViewClosed:(MTGBannerAdView *)adView;


@end



@interface MTGBannerAdView : UIView


@property(nonatomic,assign) NSInteger autoRefreshTime;

@property(nonatomic,assign) MTGBool showCloseButton;


@property(nonatomic,copy,readonly) NSString *_Nullable placementId;


@property(nonatomic,copy,readonly) NSString * _Nonnull unitId;


@property(nonatomic,weak,nullable) id <MTGBannerAdViewDelegate> delegate;


@property (nonatomic, weak) UIViewController * _Nullable  viewController;


- (nonnull instancetype)initBannerAdViewWithAdSize:(CGSize)adSize
                                       placementId:(nullable NSString *)placementId
                                            unitId:(nonnull NSString *) unitId
                                rootViewController:(nullable UIViewController *)rootViewController;


- (nonnull instancetype)initBannerAdViewWithBannerSizeType:(MTGBannerSizeType)bannerSizeType
                                               placementId:(nullable NSString *)placementId
                                                    unitId:(nonnull NSString *) unitId
                                        rootViewController:(nullable UIViewController *)rootViewController;

- (void)loadBannerAd;


- (void)loadBannerAdWithBidToken:(nonnull NSString *)bidToken;

- (void)destroyBannerAdView;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMintegralBannerClass_h */
