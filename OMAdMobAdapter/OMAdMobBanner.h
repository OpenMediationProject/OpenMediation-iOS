#import <UIKit/UIKit.h>
#import "OMAdMobBannerClass.h"
#import "OMBannerCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdMobBanner : UIView <OMBannerCustomEvent,GADBannerViewDelegate>

@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, strong) GADBannerView *admobBannerView;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;
@end

NS_ASSUME_NONNULL_END
