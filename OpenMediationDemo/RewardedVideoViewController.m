// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "RewardedVideoViewController.h"

@implementation RewardedVideoViewController

- (void)viewDidLoad {
    self.title = @"RewardedVideo";
    self.adFormat = OpenMediationAdFormatRewardedVideo;
    [super viewDidLoad];
}

- (void)loadAd {
    [[OMRewardedVideo sharedInstance] addDelegate:self];
    if ([[OMRewardedVideo sharedInstance]isReady]) {
        self.showItem.enabled = YES;
    }
}


-(void)showItemAction {
    NSLog(@"isCappedForScene:%@,%d",self.loadID,[[OMRewardedVideo sharedInstance]isCappedForScene:self.loadID]);
    [[OMRewardedVideo sharedInstance]showWithViewController:self scene:self.loadID];
}

#pragma mark -- OMRewardedVideoDelegate

/// Invoked when a rewarded video is available.
- (void)omRewardedVideoChangedAvailability:(BOOL)available {
    self.showItem.enabled = available;
    if (available) {
         [self showLog:@"RewardedVideo ad did load"];
    }
}

/// Sent immediately when a rewarded video is opened.
- (void)omRewardedVideoDidOpen:(OMScene*)scene {
    [self showLog:@"RewardedVideo ad open"];
}

/// Sent immediately when a rewarded video starts to play.
- (void)omRewardedVideoPlayStart:(OMScene*)scene {
    [self showLog:@"RewardedVideo video start"];
}

/// Send after a rewarded video has been completed.
- (void)omRewardedVideoPlayEnd:(OMScene*)scene {
     [self showLog:@"RewardedVideo video end"];
}

/// Sent after a rewarded video has been clicked.
- (void)omRewardedVideoDidClick:(OMScene*)scene {
    [self showLog:@"RewardedVideo ad click"];
}

/// Sent after a user has been granted a reward.
- (void)omRewardedVideoDidReceiveReward:(OMScene*)scene {
    [self showLog:@"RewardedVideo receive reward"];
}

/// Sent after a rewarded video has been closed.
- (void)omRewardedVideoDidClose:(OMScene*)scene {
    [self showLog:@"RewardedVideo close"];
}

/// Sent after a rewarded video has failed to play.
- (void)omRewardedVideoDidFailToShow:(OMScene*)scene withError:(NSError *)error {
    [self showLog:@"RewardedVideo fail show"];
}

@end
