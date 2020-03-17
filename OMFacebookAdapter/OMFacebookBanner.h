#import <UIKit/UIKit.h>
#import "OMFacebookBannerClass.h"
#import "OMBannerCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMFacebookBanner : UIView <OMBannerCustomEvent,FBAdViewDelegate>
@property (nonatomic, strong) FBAdView *facebookBannerView;
@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;
- (void)loadAdWithBidPayload:(NSString *)bidPayload;
@end

NS_ASSUME_NONNULL_END
