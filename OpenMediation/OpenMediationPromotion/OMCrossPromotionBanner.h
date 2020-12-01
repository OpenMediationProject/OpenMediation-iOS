// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMBannerCustomEvent.h"
#import "OMCrossPromotionCampaign.h"
#import "OMCrossPromotionJSBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionBanner : UIView <OMBannerCustomEvent,OMCrossPromotionCampaignClickHandlerDelegate,OMCrossPromotionJSBridgeDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, assign) CGSize bannerSize;
@property(nonatomic, weak, nullable) id<bannerCustomEventDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController;

- (void)loadAdWithBidPayload:(NSString*)bidPayload;

@end

NS_ASSUME_NONNULL_END
