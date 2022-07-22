#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OMBannerCustomEvent.h"
#import "OMGoogleAdBannerClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OMGoogleAdBanner : UIView <OMBannerCustomEvent,GADBannerViewDelegate>

@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
@property (nonatomic, strong) GAMBannerView *admobBannerView;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;
- (void)loadAd;
@end

NS_ASSUME_NONNULL_END
