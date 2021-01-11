// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionClickHandler.h"
#import "OMToolUmbrella.h"
#import "OMConfig.h"
#import "OMEventManager.h"

@implementation OMCrossPromotionClickHandler

- (instancetype)initWithAppID:(NSString*)appID ska:(NSDictionary*)skaParameter adURL:(NSString*)url {
    if (self = [super init]) {
        _appID = appID;
        _ska = skaParameter;
        _adUrl = url;
        if(!OM_STR_EMPTY(_appID)) {
            NSMutableDictionary *productParameter = [NSMutableDictionary dictionary];
            productParameter[SKStoreProductParameterITunesItemIdentifier] = [NSNumber numberWithInteger:[_appID integerValue]];
            if (@available(iOS 14.0, *)) {
                if(_ska) {
                    [productParameter addEntriesFromDictionary:_ska];
                }
            }
            [self.storeVC loadProductWithParameters:productParameter completionBlock:^(BOOL result, NSError * _Nullable error) {
                if(result && !error) {
                    self.storeLoadComplete = YES;
                }
            }];
        }
        
    }
    return self;
}



- (void)clickAppAd:(UIViewController*)rootVC scene:(NSString*)sceneID {
    
    if(!(OM_STR_EMPTY(_adUrl))) {
        if([_adUrl containsString:@"{scene}"]) {
            _adUrl = [_adUrl stringByReplacingOccurrencesOfString:@"{scene}" withString:OM_SAFE_STRING(sceneID)];
        }
        [rootVC.view addSubview:self.webView];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_adUrl]]];
    }
    
    [rootVC presentViewController:self.storeVC animated:YES
                       completion:^{
                           self.storeLoadComplete = NO;
                       }];
    if(_delegate && [_delegate respondsToSelector:@selector(clickHandlerWillPresentScreen)]) {
        [_delegate clickHandlerWillPresentScreen];
    }
}

- (void)clickWebAd:(UIViewController*)rootVC scene:(NSString*)sceneID {
    if(!OM_STR_EMPTY(_adUrl)) {
        OMCrossPromotionWebController *webVC = [[OMCrossPromotionWebController alloc]init];
        webVC.delegate = self;
        if([_adUrl containsString:@"{scene}"]) {
            _adUrl = [_adUrl stringByReplacingOccurrencesOfString:@"{scene}" withString:sceneID];
        }
        webVC.url = _adUrl;
        [rootVC presentViewController:[[UINavigationController alloc]initWithRootViewController:webVC] animated:YES completion:^{
            
        }];
        if(_delegate && [_delegate respondsToSelector:@selector(clickHandlerWillPresentScreen)]) {
            [_delegate clickHandlerWillPresentScreen];
        }
    }
}

- (WKWebView*)webView {
    if(!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        if (@available(iOS 13.0, *)) {
           configuration.defaultWebpagePreferences.preferredContentMode = WKContentModeMobile;
        }
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (SKStoreProductViewController*)storeVC {
    if(!_storeVC) {
        _storeVC = [[SKStoreProductViewController alloc]init];
        _storeVC.view.frame = [UIScreen mainScreen].bounds;
        _storeVC.delegate = self;
    }
    return _storeVC;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    if([url containsString:@"itunes.apple.com"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling ,nil);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    // 重定向时调用
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [_webView removeFromSuperview];
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if(!_webView.isLoading) {
        [_webView removeFromSuperview];
    }
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}


- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
}


- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    __weak __typeof(self) weakSelf = self;
    [_storeVC dismissViewControllerAnimated:YES completion:^{
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(clickHandlerDisDismissScrren)]) {
            [weakSelf.delegate clickHandlerDisDismissScrren];
        }
        weakSelf.storeVC = nil;
        if(weakSelf.appID) {
            NSMutableDictionary *productParameter = [NSMutableDictionary dictionary];
            productParameter[SKStoreProductParameterITunesItemIdentifier] = [NSNumber numberWithInteger:[weakSelf.appID integerValue]];
            if (@available(iOS 14.0, *)) {
                if(weakSelf.ska) {
                    [productParameter addEntriesFromDictionary:weakSelf.ska];
                }
            }
            [weakSelf.storeVC loadProductWithParameters:productParameter completionBlock:^(BOOL result, NSError * _Nullable error) {
                if(result && !error) {
                    weakSelf.storeLoadComplete = YES;
                }
            }];
        }
    }];
}

- (void)webViewControllerDismiss {
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickHandlerDisDismissScrren)]) {
        [self.delegate clickHandlerDisDismissScrren];
    }
}

@end
