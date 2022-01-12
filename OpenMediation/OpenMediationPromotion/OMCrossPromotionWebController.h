// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <Webkit/Webkit.h>

@protocol OMWebViewControllerDelegate<NSObject>

@optional

- (void)webViewControllerDismiss;
@end

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionWebController : UIViewController<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *closeItem;
@property (nonatomic, assign) BOOL appSettingStatusBarHidden;
@property (nonatomic, weak) id<OMWebViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
