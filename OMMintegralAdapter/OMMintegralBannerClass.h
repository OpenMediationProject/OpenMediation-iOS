// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMMintegralBannerClass_h
#define OMMintegralBannerClass_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class MTGBannerAdView;
@class MTGAdSize;

/**
 Tri-state boolean.
 */
typedef NS_ENUM(NSInteger, MTGBool) {
    /**
     No
     */
    MTGBoolNo = -1,
    
    /**
     Unknown
     */
    MTGBoolUnknown = 0,
    
    /**
     Yes
     */
    MTGBoolYes = 1,
};

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
/**
 This method is called when adView ad slot is loaded successfully.
 
 @param adView : view for adView
 */
- (void)adViewLoadSuccess:(MTGBannerAdView *)adView;

/**
 This method is called when adView ad slot failed to load.
 
 @param adView : view for adView
 @param error : error
 */
- (void)adViewLoadFailedWithError:(NSError *)error adView:(MTGBannerAdView *)adView;

/**
 Sent immediately before the impression of an MTGBannerAdView object will be logged.
 
 @param adView An MTGBannerAdView object sending the message.
 */
- (void)adViewWillLogImpression:(MTGBannerAdView *)adView;

/**
 This method is called when ad is clicked.
 
 @param adView : view for adView
 */
- (void)adViewDidClicked:(MTGBannerAdView *)adView;

/**
 Called when the application is about to leave as a result of tapping.
 Your application will be moved to the background shortly after this method is called.
 
@param adView : view for adView
 */
- (void)adViewWillLeaveApplication:(MTGBannerAdView *)adView;

/**
 Will open the full screen view
 Called when opening storekit or opening the webpage in app
 
 @param adView : view for adView
 */
- (void)adViewWillOpenFullScreen:(MTGBannerAdView *)adView;

/**
 Close the full screen view
 Called when closing storekit or closing the webpage in app
 
 @param adView : view for adView
 */
- (void)adViewCloseFullScreen:(MTGBannerAdView *)adView;

/**
 This method is called when ad is Closed.

 @param adView : view for adView
 */
- (void)adViewClosed:(MTGBannerAdView *)adView;


@end



@interface MTGBannerAdView : UIView

/**
 Automatic refresh time, the time interval of banner view displaying new ads, is set in the range of 10s~180s.
 If set 0, it will not be refreshed.
 You need to set it before loading ad.
 */
@property(nonatomic,assign) NSInteger autoRefreshTime;

/**
 Whether to show the close button
 MTGBoolNo means off,MTGBoolYes means on
 */
@property(nonatomic,assign) MTGBool showCloseButton;

/**
placementId
*/
@property(nonatomic,copy,readonly) NSString *_Nullable placementId;

/**
 unitId
 */
@property(nonatomic,copy,readonly) NSString * _Nonnull unitId;

/**
 the delegate
 */
@property(nonatomic,weak,nullable) id <MTGBannerAdViewDelegate> delegate;

/**
 The current ViewController of display ad.
 */
@property (nonatomic, weak) UIViewController * _Nullable  viewController;


- (nonnull instancetype)initBannerAdViewWithAdSize:(CGSize)adSize
                                       placementId:(nullable NSString *)placementId
                                            unitId:(nonnull NSString *) unitId
                                rootViewController:(nullable UIViewController *)rootViewController;


- (nonnull instancetype)initBannerAdViewWithBannerSizeType:(MTGBannerSizeType)bannerSizeType
                                               placementId:(nullable NSString *)placementId
                                                    unitId:(nonnull NSString *) unitId
                                        rootViewController:(nullable UIViewController *)rootViewController;
/**
 Begin to load banner ads
 */
- (void)loadBannerAd;

/*!
 This method is used to request ads with the token you got previously
 
 @param bidToken    - the token from bid request within MTGBidFramework.
 */

- (void)loadBannerAdWithBidToken:(nonnull NSString *)bidToken;

/**
 Call this method when you want to relase MTGBannerAdView. It's optional.
 
 NOTE: After calling this method, if you need to continue using the MTGBannerAdView, you must reinitialize a MTGBannerAdView
 */
- (void)destroyBannerAdView;

@end

NS_ASSUME_NONNULL_END

#endif /* OMMintegralBannerClass_h */
