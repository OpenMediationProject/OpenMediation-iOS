// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "MainViewController.h"
#import "BannerViewController.h"
#import "NativeViewController.h"
#import "InterstitialViewController.h"
#import "RewardedVideoViewController.h"
#import "SplashViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//类iPhone5机型
#define KIs320x568_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//类iPhone6机型
#define KIs375x667_6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//类iPhone6+机型
#define KIs414x736_6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//类iPhoneX机型
#define KIs375x812_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//类iPhoneXR机型
#define KIs414x896_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//类iPhoneX Max机型
#define KIs414x896_XMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark ------ 类iPhoneX异性屏适配 ------

#define SafeAreaBottomHeight (KIs375x812_X || KIs414x896_XR || KIs414x896_XMax ? 34 : 22)
#define SafeAreaTopHeight (KIs375x812_X || KIs414x896_XR || KIs414x896_XMax ? 44 : 22)
#define KNavHeight (KIs375x812_X || KIs414x896_XR || KIs414x896_XMax ? 88 : 64)
#define KTabbarHeight (KIs375x812_X || KIs414x896_XR || KIs414x896_XMax ? 83 : 49)

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createViews];
}

-(void)createViews {
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavHeight, kScreenWidth, kScreenHeight - KNavHeight) style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.rowHeight = 50;
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else { self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Banner";
            break;
        case 1:
            cell.textLabel.text = @"Native";
            break;
        case 2:
            cell.textLabel.text = @"Interstitial";
            break;
        case 3:
            cell.textLabel.text = @"RewardedVideo";
            break;
        case 4:
            cell.textLabel.text = @"Splash";
            break;
        case 5:
            cell.textLabel.text = @"Iap test";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *vcGroup = @[@"BannerViewController",@"NativeViewController",@"InterstitialViewController",@"RewardedVideoViewController",@"SplashViewController"];
    if (indexPath.row < vcGroup.count) {
        Class vcClass = NSClassFromString(vcGroup[indexPath.row]);
        UIViewController *vc = [[vcClass alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
