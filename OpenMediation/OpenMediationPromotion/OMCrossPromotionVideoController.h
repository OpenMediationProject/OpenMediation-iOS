// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "OMToolUmbrella.h"
#import "OMCrossPromotionCampaignManager.h"
#import "OMCrossPromotionJSBridge.h"

NS_ASSUME_NONNULL_BEGIN

@protocol promotionVideoDelegate <NSObject>

- (void)promotionVideoOpen;
- (void)promotionVideoPlayStart;
- (void)promotionVideoClick:(BOOL)trackClick;
- (void)promotionVideoPlayEnd;
- (void)promotionVideoClose;
- (void)promotionVideoReward;
- (void)promotionVideoAddEvent:(NSString*)eventBody;

@end

@interface OMCrossPromotionVideoController : UIViewController<OMCrossPromotionJSBridgeDelegate,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) OMCrossPromotionCampaign *campaign;
@property (nonatomic, strong) OMCrossPromotionJSBridge *jsBridge;
@property (nonatomic, strong) WKWebView *wkView;
@property (nonatomic, strong) UIButton *lpCloseItem;
@property (nonatomic, assign) BOOL appSettingStatusBarHidden;
@property (nonatomic, weak) id<promotionVideoDelegate> delegate;

- (instancetype)initWithCampaign:(OMCrossPromotionCampaign*)campaign scene:(NSString*)sceneID;

@end

NS_ASSUME_NONNULL_END
