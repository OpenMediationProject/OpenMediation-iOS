// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionVideoController.h"
#import "OMToolUmbrella.h"
#import <pthread.h>
#import "OMEventManager.h"

#define CLOSE_ICON_WIDTH         (([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height)?([UIScreen mainScreen].bounds.size.width/320.0*16.0):([UIScreen mainScreen].bounds.size.height/320*16.0))

static NSString *const  close_image_string = @"iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3NpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxYzVlZDUwOS1kZjFjLTQ2MWQtYmM5OS05Njk2OGVmYTk4MzUiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RTg0NjYxODU2QjM3MTFFNjlGMDFENzQwNjQzNkQ5RkQiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RTg0NjYxODQ2QjM3MTFFNjlGMDFENzQwNjQzNkQ5RkQiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6YjI3NDZmMjItYmNjNC00N2RhLTg2ZDItMjkxYmJlMzdjNzU4IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjFjNWVkNTA5LWRmMWMtNDYxZC1iYzk5LTk2OTY4ZWZhOTgzNSIvPiA8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";

@implementation WKPreferences (promotionKVC)
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end


@implementation OMCrossPromotionVideoController

- (instancetype)initWithCampaign:(OMCrossPromotionCampaign*)campaign scene:(NSString*)sceneID {
    if ([super init]) {
        _campaign = campaign;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.wkView loadHTMLString:[_campaign webHtmlStr] baseURL:[NSURL fileURLWithPath:[NSString omUrlCachePath:[_campaign webUrl]]]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wkView];
    [self.view addSubview:self.lpCloseItem];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    self.wkView.frame = self.view.bounds;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showLpCloseItem {
    [UIView animateWithDuration:2 animations:^{
        self.lpCloseItem.alpha = 1.0;
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    _wkView.frame = CGRectMake(0, 0, size.width, size.height);
    _lpCloseItem.frame = CGRectMake((_lpCloseItem.frame.origin.x<size.height/2.0)?10 :size.width - 30, 10, _lpCloseItem.frame.size.width, _lpCloseItem.frame.size.height);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _appSettingStatusBarHidden = [[UIApplication sharedApplication]isStatusBarHidden];
    [UIApplication sharedApplication].statusBarHidden = YES;
    if (!self.presentedViewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [self.campaign skStartImpression];
        });
        if(_delegate && [_delegate respondsToSelector:@selector(promotionVideoOpen)]) {
            [_delegate promotionVideoOpen];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.wkView stopLoading];
    [UIApplication sharedApplication].statusBarHidden = _appSettingStatusBarHidden;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!self.presentedViewController) {
        [self.campaign skEndImpression];
        if (self.delegate && [self.delegate respondsToSelector:@selector(promotionVideoClose)]) {
            [self.delegate promotionVideoClose];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    if (self.presentingViewController) {
        return  [self.presentingViewController supportedInterfaceOrientations];
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.presentingViewController) {
        return  [self.presentingViewController preferredInterfaceOrientationForPresentation];
    } else {
        return UIInterfaceOrientationPortrait;
    }
}

- (BOOL)shouldAutorotate {
    if (self.presentingViewController) {
        return  [self.presentingViewController shouldAutorotate];
    } else {
        return YES;
    }
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

- (WKWebView*)wkView {
    if(!_wkView) {
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
        
        _wkView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:config];
        _wkView.backgroundColor = [UIColor whiteColor];
        _wkView.opaque = NO;
        _wkView.UIDelegate = self;
        _wkView.navigationDelegate = self;
        _jsBridge = [[OMCrossPromotionJSBridge alloc]initWithBindWebView:_wkView placementID:self.campaign.pid];
        _jsBridge.campaign = self.campaign;
        _jsBridge.jsMessageHandler = self;
    }
    return _wkView;
}

- (UIButton*)lpCloseItem {
    if(!_lpCloseItem) {
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:close_image_string options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *closeImage = [UIImage imageWithData:imageData];
        _lpCloseItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lpCloseItem setImage:closeImage forState:UIControlStateNormal];
        [_lpCloseItem addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _lpCloseItem.layer.cornerRadius = CLOSE_ICON_WIDTH/2.0;
        _lpCloseItem.clipsToBounds = YES;
        int  randomCount = arc4random_uniform(2);
        if (randomCount > 0) {
            _lpCloseItem.frame = CGRectMake(10, 10, CLOSE_ICON_WIDTH, CLOSE_ICON_WIDTH);
        } else {
            _lpCloseItem.frame = CGRectMake(self.view.frame.size.width - 30, 10, CLOSE_ICON_WIDTH, CLOSE_ICON_WIDTH);
        }
    }
    return _lpCloseItem;
}

- (void)dealloc{
    [self.view removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark -- OMCrossPromotionJSBridgeDelegate

- (void)jsBridgeSetCloseVisible:(BOOL)visible {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if (weakSelf) {
            if (visible) {
                [self showLpCloseItem];
            } else {
                weakSelf.lpCloseItem.alpha = 0;
            }
        }
    });
}


- (void)jsBridgeClick:(BOOL)trackClick {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if (weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(promotionVideoClick:)]) {
            [weakSelf.delegate promotionVideoClick:trackClick];
        }
    });
}

- (void)jsBridgeVideoPlayProgress:(NSInteger)percentage {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if(percentage == 0) {
            if(weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(promotionVideoPlayStart)]) {
                [weakSelf.delegate promotionVideoPlayStart];
            }
        }else if(percentage == 100) {
            if(weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(promotionVideoPlayEnd)]) {
                [weakSelf.delegate promotionVideoPlayEnd];
            }
        }
    });
}

- (void)jsBridgeAddRewarded {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if (weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(promotionVideoReward)]) {
            [weakSelf.delegate promotionVideoReward];
        }
    });
}

- (void)jsBridgeClose {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if (weakSelf) {
            [weakSelf close];
        }
    });
}


- (void)jsBridgePushEvent:(NSString*)eventBody {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync_on_main_queue(^{
        if (weakSelf && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(promotionVideoAddEvent:)]) {
            [weakSelf.delegate promotionVideoAddEvent:eventBody];
        }
    });
}

@end
