// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMCrossPromotionCustomEvent.h"
#import "OMCrossPromotionCampaign.h"
#import "OMCrossPromotionJSBridge.h"


NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionCP : UIView <OMCrossPromotionCustomEvent,OMCrossPromotionCampaignClickHandlerDelegate,OMCrossPromotionJSBridgeDelegate,WKUIDelegate,WKNavigationDelegate>

@property(nonatomic, weak, nullable) id<crossPromotionCustomEventDelegate> delegate;

- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)showAdWithScreenPoint:(CGPoint)scaleXY adSize:(CGSize)size angle:(CGFloat) angle scene:(NSString*)sceneName;
- (void)hideAd;

@end

NS_ASSUME_NONNULL_END
