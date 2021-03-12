#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OMBannerCustomEvent.h"
#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
    #import <GoogleMobileAds/GoogleMobileAds.h>
#else
    #import "OMAdMobBannerClass.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface OMAdMobBanner : UIView <OMBannerCustomEvent,GADBannerViewDelegate>

@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, strong) GADBannerView *admobBannerView;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;
@end

NS_ASSUME_NONNULL_END
