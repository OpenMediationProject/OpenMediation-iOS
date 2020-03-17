// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "WelcomeViewController.h"
#import "MainViewController.h"

@import OpenMediation;

@interface WelcomeViewController ()
@property (strong, nonatomic) UILabel *welcomLabel;
@property (strong, nonatomic) UIButton *appKeyBtn;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *showBar = [[UIBarButtonItem alloc]initWithTitle:@"Ad" style:UIBarButtonItemStylePlain target:self action:@selector(showItemAction)];
    self.navigationItem.rightBarButtonItem = showBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSuccess) name:@"kOpenMediatonInitSuccessNotification" object:nil];
    [self.view addSubview:self.welcomLabel];
    
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

@end
