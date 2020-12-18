// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionCP.h"
#import <WebKit/WebKit.h>
#import "OMNetworkUmbrella.h"
#import "OMModelUmbrella.h"
#import "OMCrossPromotionCampaignManager.h"
#import "OMToolUmbrella.h"
#import "OMModelUmbrella.h"
#import "OMCrossPromotionClRequest.h"
#import "OMCrossPromotionExposureMonitor.h"
#import "OMCrossPromotionJSBridge.h"

@protocol PromotionEventDelegate <crossPromotionCustomEventDelegate>

@optional

- (void)customEventAddEvent:(NSObject*)adapter event:(NSDictionary*)eventBody;

@end

@interface OMCrossPromotionCP ()

@property (nonatomic, strong) OMCrossPromotionJSBridge *jsBridge;
@property (nonatomic, strong) WKWebView *adWebView;
@property (nonatomic, strong) OMCrossPromotionCampaign *campaign;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, strong) NSString *placementID;
@property (nonatomic, assign) BOOL impr;
@property (nonatomic, copy) NSString *showSceneID;
@property (nonatomic, assign) CGPoint scaleXY;
@property (nonatomic, assign) CGSize adSize;

@end

@implementation OMCrossPromotionCP

- (instancetype)initWithParameter:(NSDictionary*)adParameter {
    if (self = [super initWithFrame:CGRectMake(0, 0, 1, 1)]) {
        self.hidden = YES;
        self.layer. shouldRasterize = YES;
        self.layer.allowsEdgeAntialiasing = YES;
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _placementID = [adParameter objectForKey:@"pid"];
        }
        _rootViewController = [UIViewController omCurrentWindow].rootViewController;
        [_rootViewController.view addSubview:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
         ];
    }
    return self;
}

- (void)loadAd {
    if (OM_STR_EMPTY(self.placementID)) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [[OMCrossPromotionCampaignManager sharedInstance] loadPid:self.placementID size:[UIScreen mainScreen].bounds.size action:4 completionHandler:^(OMCrossPromotionCampaign *campaign, NSError *error) {
        if (error) {
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                [weakSelf.delegate customEvent:weakSelf didFailToLoadWithError:error];
            }
        } else {
            weakSelf.campaign = campaign;
            weakSelf.campaign.clickHanlerDelegate = weakSelf;
            [campaign cacheMaterielCompletion:^{
                if(weakSelf) {
                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didLoadAd:)]) {
                        [weakSelf.delegate customEvent:self didLoadAd:nil];
                    }
                    weakSelf.impr = NO;
                    [self addSubview:self.adWebView];
                    self.jsBridge.campaign = campaign;
                    [self.adWebView loadHTMLString:[weakSelf.campaign webHtmlStr] baseURL:[NSURL fileURLWithPath:[NSString omUrlCachePath:[weakSelf.campaign webUrl]]]];
                }
            }];
        }
    }];
    
    
}

- (void)checkCampgian {
    [[OMCrossPromotionCampaignManager sharedInstance] loadPid:self.placementID size:[UIScreen mainScreen].bounds.size action:4 completionHandler:^(OMCrossPromotionCampaign *campaign, NSError *error) {
        
    }];
}

- (BOOL)isReady {
    if(self.campaign && [self.campaign isReady]) {
        [self checkCampgian];
        return YES;
    }
    return NO;
}

- (void)showAdWithScreenPoint:(CGPoint)scaleXY adSize:(CGSize)size angle:(CGFloat) angle scene:(NSString*)sceneName {
    self.scaleXY = scaleXY;
    self.adSize = size;
    self.frame = CGRectMake(self.scaleXY.x *_rootViewController.view.frame.size.width, self.scaleXY.y *_rootViewController.view.frame.size.height, self.adSize.width, self.adSize.height);
    _adWebView.frame = CGRectMake(0,0, size.width, size.height);
    self.transform = CGAffineTransformMakeRotation(angle/180.0*M_PI);
    self.hidden = NO;
    [_rootViewController.view addSubview:self];
    if (_delegate && [_delegate respondsToSelector:@selector(promotionCustomEventWillAppear:)]) {
        [_delegate promotionCustomEventWillAppear:self];
    }
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    self.frame = CGRectMake(self.scaleXY.x *_rootViewController.view.frame.size.width, self.scaleXY.y *_rootViewController.view.frame.size.height, self.adSize.width, self.adSize.height);
}


- (void)hideAd {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(promotionCustomEventDidDisAppear:)]) {
        [_delegate promotionCustomEventDidDisAppear:self];
    }
}

- (void)drawRect:(CGRect)rect {
    [[OMCrossPromotionExposureMonitor sharedInstance]addObserver:self forView:self];
    [super drawRect:rect];
}

- (void)observeView:(UIView*)view visible:(BOOL)visible {
    if(visible) {
        if(!_impr) {
            _impr  =YES;
            [self impression];
            [_jsBridge sendEvent:OMCrossPromotionJSEventShow];
        }
    }

}

- (void)impression {
    [self.campaign impression:OM_SAFE_STRING(self.showSceneID)];
}


- (WKWebView*)adWebView {
    if(!_adWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        if (@available(iOS 13.0, *)) {
            config.defaultWebpagePreferences.preferredContentMode = WKContentModeMobile;
        }
        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.javaScriptEnabled = YES;
        [preference setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        config.preferences = preference;
        config.allowsInlineMediaPlayback = YES;
        config.requiresUserActionForMediaPlayback = NO;
        
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        config.userContentController = wkUController;
        
        _adWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
        _adWebView.backgroundColor = [UIColor whiteColor];
        _adWebView.opaque = NO;
        _adWebView.UIDelegate = self;
        _adWebView.navigationDelegate = self;
        _jsBridge = [[OMCrossPromotionJSBridge alloc]initWithBindWebView:_adWebView placementID:self.placementID];
        _jsBridge.jsMessageHandler = self;
        
    }
    return _adWebView;
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme containsString:@"itms-apps"] ) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -- AdTimingJSDelegate

- (void)jsBridgeRefreshAd:(NSInteger)millisecond {
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(millisecond * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [OMCrossPromotionClRequest requestCampaignWithPid:weakSelf.placementID size:[UIScreen mainScreen].bounds.size actionType:2 payload:nil completionHandler:^(NSDictionary *insAndCampaigns, NSError *error) {
            if(!error) {
                NSArray *campaigns = [insAndCampaigns objectForKey:@"campaigns"];
                if(campaigns && [campaigns isKindOfClass:[NSArray class]]) {
                    [[OMCrossPromotionCampaignManager sharedInstance]addCampaignsWithData:campaigns pid:weakSelf.placementID];
                }
                [weakSelf loadAd];
            }
        }];
    });

}

- (void)jsBridgeClick:(BOOL)clickTrack {
    //click
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(promotionCustomEventDidClick:)]) {
            [weakSelf.delegate promotionCustomEventDidClick:self];
        }
        if (weakSelf.rootViewController && clickTrack) {
            [weakSelf.campaign clickAndShowAd:weakSelf.rootViewController sceneID:self.showSceneID];
        }
    });
}

- (void)jsBridgePushEvent:(NSString*)eventBody {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if(!OM_STR_EMPTY(eventBody)) {
            NSData *data = [eventBody dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonErr = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
            if(!jsonErr) {
                id<PromotionEventDelegate> delegate = (id<PromotionEventDelegate>)(weakSelf.delegate);
                NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:dict];
                [body setObject:OM_SAFE_STRING(self.showSceneID) forKey:@"scene"];
                if(delegate && [delegate respondsToSelector:@selector(customEventAddEvent:event:)]) {
                    [delegate customEventAddEvent:weakSelf event:body];
                }
            }
        }
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
