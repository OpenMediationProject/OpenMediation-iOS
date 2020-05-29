// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Splash";
    self.adFormat = OpenMediationAdFormatSplash;
    [super viewDidLoad];
}

- (void)loadAd{
    _splash = [[OMSplash alloc] initWithPlacementId:self.loadID adSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    _splash.delegate = self;
    [_splash loadAd];
}

- (void)showItemAction{
    [_splash showWithWindow:[UIApplication sharedApplication].keyWindow customView:nil];
    self.showItem.enabled = NO;
}

- (void)omSplashDidLoad:(OMSplash *)splash{
    self.showItem.enabled = YES;
    [self showLog:@"Splash did load"];
}

- (void)omSplashFailToLoad:(OMSplash *)splash withError:(NSError *)error{
    [self showLog:@"Splash load failed"];
}

- (void)omSplashDidShow:(OMSplash *)splash{
    [self showLog:@"Splash ad show"];
}

- (void)omSplashDidClick:(OMSplash *)splash{
    [self showLog:@"Splash click"];
}

- (void)omSplashDidClose:(OMSplash *)splash{
    [self showLog:@"Splash ad close"];
}

- (void)omSplashDidFailToShow:(OMSplash *)splash withError:(NSError *)error{
    [self showLog:@"Splash fail to show"];
}

@end
