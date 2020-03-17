#ifndef OMAdMobBannerClass_h
#define OMAdMobBannerClass_h
#import "OMAdMobClass.h"
@class GADBannerView;
@class GADRequest;
@class GADRequestError;

NS_ASSUME_NONNULL_BEGIN

@protocol GADBannerViewDelegate<NSObject>
@optional
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView;

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error;

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView;

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView;

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView;

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView;

@end

@interface GADBannerView : UIView

@property(nonatomic, copy, nullable) IBInspectable NSString *adUnitID;

@property(nonatomic, weak, nullable) UIViewController *rootViewController;

@property(nonatomic, weak, nullable) id<GADBannerViewDelegate> delegate;

- (void)loadRequest:(nullable GADRequest *)request;

@end

NS_ASSUME_NONNULL_END

#endif /* OMAdMobBannerClass_h */
