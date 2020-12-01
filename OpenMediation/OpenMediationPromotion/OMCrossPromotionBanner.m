// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionBanner.h"
#import <WebKit/WebKit.h>
#import "OMToolUmbrella.h"
#import "OMCrossPromotionJSBridge.h"
#import "OMCrossPromotionCampaignManager.h"
#import "OMCrossPromotionExposureMonitor.h"
#import "OMCrossPromotionClRequest.h"


@protocol PromotionEventDelegate <bannerCustomEventDelegate>

@optional

- (void)customEventAddEvent:(NSObject*)adapter event:(NSDictionary*)eventBody;

@end

@interface OMCrossPromotionBanner ()

@property (nonatomic, strong) OMCrossPromotionJSBridge *jsBridge;
@property (nonatomic, strong) WKWebView *adWebView;
@property (nonatomic, strong) OMCrossPromotionCampaign *campaign;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, strong) NSString *placementID;
@property (nonatomic, assign) BOOL impr;

@end

@implementation OMCrossPromotionBanner


- (instancetype)initWithFrame:(CGRect)frame adParameter:(NSDictionary *)adParameter rootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithFrame:frame]) {
        if(adParameter && [adParameter isKindOfClass:[NSDictionary class]]) {
            _placementID = [adParameter objectForKey:@"pid"];
            _rootViewController = rootViewController;
            _bannerSize = frame.size;
        }
    }
    return self;
}

- (void)bannerRefresh {
    if (OM_STR_EMPTY(self.placementID)) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [[OMCrossPromotionCampaignManager sharedInstance] loadPid:self.placementID size:_bannerSize action:4 completionHandler:^(OMCrossPromotionCampaign *campaign, NSError *error) {
        if (error) {
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                [weakSelf.delegate customEvent:self didFailToLoadWithError:error];
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
                    [weakSelf addSubview:self.adWebView];
                    weakSelf.jsBridge.campaign = campaign;
                    [weakSelf.adWebView loadHTMLString:[weakSelf.campaign webHtmlStr] baseURL:[NSURL fileURLWithPath:[NSString omUrlCachePath:[weakSelf.campaign webUrl]]]];
                }
            }];
        }
    }];
}

- (void)loadAdWithBidPayload:(NSString*)bidPayload {
    NSString *payload = @"";
    if ([bidPayload length]>0) {
        NSData *data = [bidPayload dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonErr = nil;
        NSDictionary *admBody = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
        if([admBody isKindOfClass:[NSDictionary class]]) {
            payload = admBody[@"payload"];
        }
    }
    if (![payload length]) {
        if(_delegate && [_delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
            NSError *error = [[NSError alloc]initWithDomain:@"com.crosspromotion.ads" code:501 userInfo: @{NSLocalizedDescriptionKey:@"Invalid bid payload"}];
            [_delegate customEvent:self didFailToLoadWithError:error];
        }
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [[OMCrossPromotionCampaignManager sharedInstance] loadAdWithPid:self.placementID size:_bannerSize action:4 payload:payload completionHandler:^(OMCrossPromotionCampaign *campaign, NSError *error) {
        if (error) {
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customEvent:didFailToLoadWithError:)]) {
                [weakSelf.delegate customEvent:self didFailToLoadWithError:error];
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
    [self.campaign impression:@""];
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

#pragma mark -- OMCrossPromotionJSBridgeDelegate

- (void)jsBridgePushEvent:(NSString*)eventBody {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if(!OM_STR_EMPTY(eventBody)) {
            NSData *data = [eventBody dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonErr = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
            if(!jsonErr) {
                id<PromotionEventDelegate> delegate = (id<PromotionEventDelegate>)weakSelf.delegate;
                NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:dict];
                if(delegate && [delegate respondsToSelector:@selector(customEventAddEvent:event:)]) {
                    [delegate customEventAddEvent:weakSelf event:body];
                }
            }
        }
    });
}

- (void)jsBridgeClick:(BOOL)trackClick {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bannerCustomEventDidClick:)]) {
            [weakSelf.delegate bannerCustomEventDidClick:self];
        }
        if (weakSelf.rootViewController && trackClick) {
            [weakSelf.campaign clickAndShowAd:weakSelf.rootViewController sceneID:@""];
        }
    });
}

- (void)jsBridgWillOpenBrowser {
    [self campaignClickHandlerLeaveApplication];
}

- (void)jsBridgeRefreshAd:(NSInteger)millisecond {
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(millisecond * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [OMCrossPromotionClRequest requestCampaignWithPid:weakSelf.placementID size:weakSelf.bannerSize actionType:2 payload:nil completionHandler:^(NSDictionary *insAndCampaigns, NSError *error) {
            if(!error) {
                NSArray *campaigns = [insAndCampaigns objectForKey:@"campaigns"];
                if(campaigns && [campaigns isKindOfClass:[NSArray class]]) {
                    [[OMCrossPromotionCampaignManager sharedInstance]addCampaignsWithData:campaigns pid:weakSelf.placementID];
                }
                [weakSelf bannerRefresh];
            }
        }];
    });

}

#pragma mark -- AdTimingCampaignClickHandlerDelegate

- (void)campaignClickHandlerWillPresentScreen {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillPresentScreen:)]) {
        [_delegate bannerCustomEventWillPresentScreen:self];
    }
}

- (void)campaignClickHandlerDisDismissScrren {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventDismissScreen:)]) {
        [_delegate bannerCustomEventDismissScreen:self];
    }
}

- (void)campaignClickHandlerLeaveApplication {
    if(_delegate && [_delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [_delegate bannerCustomEventWillLeaveApplication:self];
    }
}


@end
