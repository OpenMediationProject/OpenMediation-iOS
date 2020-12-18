// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "CrossPromotionViewController.h"

@interface CrossPromotionViewController ()

@end

@implementation CrossPromotionViewController

- (void)viewDidLoad {
    self.title = @"CrossPromotion";
    self.adFormat = OpenMediationAdFormatCrossPromotion;
    [super viewDidLoad];
    
}

- (void)loadAd {
    [[OMCrossPromotion sharedInstance] addDelegate:self];
    if ([[OMCrossPromotion sharedInstance]isReady]) {
        self.showItem.enabled = YES;
    }
}


-(void)showItemAction {
    self.showItem.enabled = NO;
    [[OMCrossPromotion sharedInstance]showAdWithScreenPoint:CGPointMake(0.6, 0.3) angle:20 scene:self.loadID];
}

-(void)removeItemAction {
    self.removeItem.enabled = NO;
    [[OMCrossPromotion sharedInstance]hideAd];
}

- (void)omCrossPromotionChangedAvailability:(BOOL)available {
    self.showItem.enabled = available;
    if (available) {
         [self showLog:@"CrossPromotion ad did load"];
    }
}

/// Sent immediately when promotion ad will appear.
- (void)omCrossPromotionWillAppear:(OMScene*)scene {
    [self showLog:@"CrossPromotion ad will appear"];
    self.removeItem.enabled = YES;
}

/// Sent after a promotion ad has been clicked.
- (void)omCrossPromotionDidClick:(OMScene*)scene {
    [self showLog:@"CrossPromotion ad click"];
}

/// Sent after a promotion ad did sdisappear.
- (void)omCrossPromotionDidDisappear:(OMScene*)scene {
    [self showLog:@"CrossPromotion ad did disappear"];
}

/// Sent after a promotion video has failed to play.
- (void)omCrossPromotionDidFailToShow:(OMScene*)scene withError:(NSError *)error {
    [self showLog:@"CrossPromotion fail show"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[OMCrossPromotion sharedInstance]hideAd];
}

@end
