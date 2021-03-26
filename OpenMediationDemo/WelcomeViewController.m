// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "WelcomeViewController.h"
#import "MainViewController.h"
#import "InitSettingViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@import OpenMediation;

@interface WelcomeViewController ()
@property (strong, nonatomic) UILabel *welcomLabel;
@property (strong, nonatomic) UIButton *settingBtn;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *showBar = [[UIBarButtonItem alloc]initWithTitle:@"Ad" style:UIBarButtonItemStylePlain target:self action:@selector(showItemAction)];
    self.navigationItem.rightBarButtonItem = showBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSuccess) name:@"kOpenMediatonInitSuccessNotification" object: nil];
    [self.view addSubview:self.welcomLabel];
    [self.view addSubview:self.settingBtn];
    
    UIButton *idfaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    idfaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3.0*2.0 - 100,self.view.frame.size.width, 50)];
    idfaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [idfaBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [idfaBtn setTitle:@"RequestIDFAAuthorization" forState:UIControlStateNormal];
    [idfaBtn addTarget:self action:@selector(requestIDFAAuthorization) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:idfaBtn];
}

- (void)requestIDFAAuthorization {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"IDFA: %@",idfa);
            } else {
                NSLog(@"The authorization status %ud",(unsigned int)status);
            }
        }];
    }
}

- (void)initSuccess {
    self.welcomLabel.text = [self.welcomLabel.text stringByAppendingString:@"\n\nOpenMediation init success!!!"];
}

- (UILabel*)welcomLabel {
    if (!_welcomLabel) {
        _welcomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,150,self.view.frame.size.width,200)];
        _welcomLabel.textAlignment = NSTextAlignmentCenter;
        _welcomLabel.numberOfLines = 0;
        NSString *buildDate = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateFormatter.dateFormat = @"MMM dd yyyy HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:buildDate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        NSString* dateStr = [dateFormatter stringFromDate:date];
        _welcomLabel.text = [NSString stringWithFormat:@"V%@\n\nBuild: %@",[OpenMediation SDKVersion],dateStr];
    }
    return _welcomLabel;
}

- (void)showItemAction {
    MainViewController *listVC = [[MainViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (UIButton*)settingBtn {
    if(!_settingBtn){
        _settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3.0*2.0,self.view.frame.size.width, 50)];
        _settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_settingBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_settingBtn setTitle:@"Init Settings" forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (void)setting {
    InitSettingViewController *settingVC = [[InitSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
@end
