// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFacebookNativeView.h"
#import "OMFacebookNative.h"

@implementation OMFacebookNativeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setNativeAd:(OMFacebookNativeAd *)nativeAd {
    _nativeAd = nativeAd;
    FBNativeAd *fbNativeAd = _nativeAd.adObject;
    Class fbAdChoicesViewClass = NSClassFromString(@"FBAdChoicesView");
    if (fbAdChoicesViewClass) {
        self.adChoicesView = [[fbAdChoicesViewClass alloc]initWithNativeAd:fbNativeAd];
        _adChoicesView.corner = UIRectCornerTopRight;
        [self addSubview:_adChoicesView];
    }
    if (self.mediaView) {
        self.mediaView.delegate = self;
    }
    UIViewController *rootVC = [self rootViewController];
    OMFacebookNative *native = (OMFacebookNative*)fbNativeAd.delegate;
    if ([native isKindOfClass:NSClassFromString(@"OMFacebookNative")]) {
        rootVC = native.rootVC;
    }
    if (fbNativeAd && [fbNativeAd respondsToSelector:@selector(registerViewForInteraction:mediaView:iconView:viewController:clickableViews:)]) {
        NSArray<UIView *> *clickableViews = @[];
        [fbNativeAd registerViewForInteraction:self mediaView:self.mediaView iconView:nil viewController:rootVC clickableViews:clickableViews];
    }

}

- (void)setMediaViewWithFrame:(CGRect)frame {
    Class FBMediaViewClass = NSClassFromString(@"FBMediaView");
    if (FBMediaViewClass) {
        _mediaView = [[FBMediaViewClass alloc]initWithFrame:frame];
    }
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    if (_adChoicesView.superview == self) {
        [self bringSubviewToFront:_adChoicesView];
    }
}

- (UIWindow *)currentWindow {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

- (UIViewController *)rootViewController {
    UIWindow *window = [self currentWindow];
    UIViewController *topVC = [self topViewController:window.rootViewController];
    return topVC;
    
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self topViewController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self topViewController:rootViewController.presentedViewController];
    }
    return rootViewController;
}

- (void)setClickableViews:(NSArray*)clickableViews {
    UIViewController *rootVC = [self rootViewController];
    
    if (_nativeAd.adObject && [_nativeAd.adObject respondsToSelector:@selector(registerViewForInteraction:mediaView:iconView:viewController:clickableViews:)]) {
        [_nativeAd.adObject registerViewForInteraction:self mediaView:self.mediaView iconView:nil viewController:rootVC clickableViews:clickableViews];
    }
}


#pragma mark -- FBMediaViewDelegate

- (void)mediaViewDidLoad:(FBMediaView *)mediaView {
    
}

- (void)mediaViewWillEnterFullscreen:(FBMediaView *)mediaView {
    
}

- (void)mediaViewDidExitFullscreen:(FBMediaView *)mediaView {
    
}

- (void)mediaView:(FBMediaView *)mediaView videoVolumeDidChange:(float)volume {
    
}

- (void)mediaViewVideoDidPause:(FBMediaView *)mediaView {
    
}

- (void)mediaViewVideoDidPlay:(FBMediaView *)mediaView {
    
}

- (void)mediaViewVideoDidComplete:(FBMediaView *)mediaView {
    
}

@end
