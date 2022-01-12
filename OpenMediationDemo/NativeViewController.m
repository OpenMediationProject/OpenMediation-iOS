// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "NativeViewController.h"
#import "OMNativeManager.h"

@interface NativeViewController ()
@property (nonatomic, strong) OMNative *native;
@property (nonatomic, strong) OMNativeView *nativeView;
@property (nonatomic, strong) OMNativeAdView *nativeAdView;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UILabel *action;
@end


@implementation NativeViewController

- (void)viewDidLoad {
    self.title = @"Native";
    self.adFormat = OpenMediationAdFormatNative;
    [super viewDidLoad];
    [self.view addSubview:self.nativeView];
}

- (OMNativeView*)nativeView {
    if (!_nativeView) {
        _nativeView = [[OMNativeView alloc]initWithFrame:CGRectZero];
        _nativeView.frame = CGRectMake(0,300, self.view.frame.size.width, 300);
        _nativeView.mediaView = [[OMNativeMediaView alloc]initWithFrame:CGRectZero];
        _nativeView.mediaView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 250);
        [_nativeView addSubview:_nativeView.mediaView];
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 255, 40, 40)];
        [_nativeView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 255, self.view.frame.size.width-100, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [_nativeView addSubview:_titleLabel];
        
        _bodyLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 270, self.view.frame.size.width-150, 30)];
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.font = [UIFont systemFontOfSize:10];
        [_nativeView addSubview:_bodyLabel];
        
        _action = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 265, 60, 30)];
        _action.layer.cornerRadius = 3;
        _action.layer.masksToBounds = YES;
        _action.layer.borderColor = [UIColor blackColor].CGColor;
        _action.layer.borderWidth = 1;
        _action.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _action.textAlignment = NSTextAlignmentCenter;
        
        [_nativeView addSubview:_action];
        
        
        _nativeView.hidden = YES;
    }
    return _nativeView;
}

- (void)loadAd {
    [[OMNativeManager sharedInstance]addDelegate:self];
    [[OMNativeManager sharedInstance]loadWithPlacementID:self.loadID];
}

-(void)showItemAction {
    [super showItemAction];
    self.showItem.enabled = NO;
    self.nativeView.hidden = NO;
}

-(void)removeItemAction {
    [super removeItemAction];
    self.nativeView.hidden = YES;
    self.nativeAdView.hidden = YES;
}

#pragma mark -- OMNativeDelegate

- (void)omNative:(OMNative*)native didLoad:(OMNativeAd*)nativeAd {
    self.nativeView.nativeAd = nativeAd;
    _iconView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nativeAd.iconUrl]]];
    _titleLabel.text = nativeAd.title;
    _bodyLabel.text = nativeAd.body;
    _action.text = nativeAd.callToAction;
    [_nativeView setClickableViews:@[_iconView,_titleLabel,self.nativeView.mediaView]];
    self.showItem.enabled = YES;
    self.removeItem.enabled = YES;
    [self showLog:@"Native ad did load"];
}

- (void)omNative:(OMNative *)native didLoadAdView:(OMNativeAdView *)nativeAdView {
    self.nativeView.hidden = NO;
    self.nativeView.nativeAdView = nativeAdView;
    self.showItem.enabled = YES;
    self.removeItem.enabled = YES;
    [self showLog:@"Native ad view did load"];
}

- (void)omNative:(OMNative*)native didFailWithError:(NSError*)error {
    [self showLog:@"Native ad load fail"];
}

- (void)omNative:(OMNative*)native nativeAdDidShow:(OMNativeAd*)nativeAd {
    [self showLog:@"Native ad impression"];
}

- (void)omNative:(OMNative*)native nativeAdDidClick:(OMNativeAd*)nativeAd {
    [self showLog:@"Native ad click"];
}


@end
