//
// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "InterstitialViewController.h"

@implementation InterstitialViewController

- (void)viewDidLoad {
    self.title = @"Interstitial";
    self.adFormat = OpenMediationAdFormatInterstitial;
    [super viewDidLoad];
}

- (void)loadAd {
    [[OMInterstitial sharedInstance] addDelegate:self];
    if ([[OMInterstitial sharedInstance]isReady]) {
        self.showItem.enabled = YES;
    }
}


-(void)showItemAction {
    [self.view endEditing:YES];
    NSLog(@"isCappedForScene:%@,%d",self.loadID,[[OMInterstitial sharedInstance]isCappedForScene:self.loadID]);
    [[OMInterstitial sharedInstance]showWithViewController:self scene:self.loadID];
}

#pragma mark -- InterstitialDelegate

/// Invoked when a interstitial video is available.
- (void)omInterstitialChangedAvailability:(BOOL)available {
    self.showItem.enabled = available;
    if (available) {
         [self showLog:@"Interstitial ad did load"];
    }
}

/// Sent immediately when a interstitial video is opened.
- (void)omInterstitialDidOpen:(OMScene*)scene {
        [self showLog:@"Interstitial ad open"];
}

/// Sent immediately when a interstitial video starts to play.
- (void)omInterstitialDidShow:(OMScene*)scene {
        [self showLog:@"Interstitial ad show"];
}

/// Sent after a interstitial video has been clicked.
- (void)omInterstitialDidClick:(OMScene*)scene {
        [self showLog:@"Interstitial ad click"];
}

/// Sent after a interstitial video has been closed.
- (void)omInterstitialDidClose:(OMScene*)scene {
        [self showLog:@"Interstitial ad close"];
}

/// Sent after a interstitial video has failed to play.
- (void)omInterstitialDidFailToShow:(OMScene*)scene withError:(NSError *)error {
        [self showLog:@"Interstitial fail to show"];
}

@end
