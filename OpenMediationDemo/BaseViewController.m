// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "BaseViewController.h"



@interface OMConfig : NSObject
+ (instancetype) sharedInstance;
- (NSString*)defaultUnitIDForAdFormat:(OpenMediationAdFormat)adFormat;
@end

@interface BaseViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction)];
    _loadItem = [[UIBarButtonItem alloc]initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemAction)];
    _showItem = [[UIBarButtonItem alloc]initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(showItemAction)];
    _showItem.enabled = NO;
    self.navigationItem.leftBarButtonItems = @[_backItem,_loadItem,_showItem];
    
    _clearItem = [[UIBarButtonItem alloc]initWithTitle:@"Clean" style:UIBarButtonItemStylePlain target:self action:@selector(clearItemAction)];
    _removeItem = [[UIBarButtonItem alloc]initWithTitle:@"Rmove" style:UIBarButtonItemStylePlain target:self action:@selector(removeItemAction)];
    _removeItem.enabled = NO;
    self.navigationItem.rightBarButtonItems = @[_clearItem,_removeItem];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, (kIsIphoneX ? 98 : 74), self.view.frame.size.width-30, 30)];
    self.textField.font = [UIFont systemFontOfSize:13];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.textColor = [UIColor blackColor];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textField];
    
    self.logScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textField.frame), self.view.frame.size.width, (self.view.frame.size.height - 45 - ((kIsIphoneX ? 88 : 64)))/2)];
    self.logScrollView.delegate = self;
    [self.view addSubview:self.logScrollView];
    
    self.logLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 0)];
    self.logLabel.numberOfLines = 0;
    self.logLabel.text = @"Log";
    self.logLabel.font = [UIFont systemFontOfSize:17];
    self.logLabel.textAlignment = NSTextAlignmentCenter;
    [self.logScrollView addSubview:self.logLabel];
    
    if (@available(iOS 11.0, *)) {
        self.logScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    
    
    self.loadID = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"AdFormat%zdUnitId",self.adFormat]];

    if (self.adFormat <= OpenMediationAdFormatNative || self.adFormat == OpenMediationAdFormatSplash ) {
        if (!self.loadID || self.loadID.length == 0) {
            self.loadID = [[OMConfig sharedInstance]defaultUnitIDForAdFormat:self.adFormat];
        }
        self.textField.placeholder = [NSString stringWithFormat:@"Please input unit id, defalut%@",self.loadID];
    } else {
        
        self.textField.placeholder = @"Please input scene name";
    }
    
    self.textField.text = self.loadID;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];


}

-(void)backItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadItemAction {
    [self.textField resignFirstResponder];
    [self.showItem setEnabled:NO];
    [self showLog:@"loading..."];
    [self loadAd];
}

- (void)loadAd {
    
}

-(void)showItemAction {
    self.showItem.enabled = NO;
    [self.view endEditing:YES];
}

-(void)clearItemAction {
    self.logLabel.text = @"";
    [self.view endEditing:YES];
}

-(void)removeItemAction {
    self.removeItem.enabled = NO;
    [self.view endEditing:YES];
    
}

- (void)showLog:(NSString*)log {
    self.logLabel.text = [self.logLabel.text stringByAppendingString:[NSString stringWithFormat:@"\n%@",log]];
    CGRect rect = [self.logLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    CGRect y = self.logLabel.frame;
    y.size.height = rect.size.height;
    self.logLabel.frame = y;
    self.logScrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(self.logLabel.frame)+60);
}

-(void)changedTextField:(UITextField *)textField {
    NSString *inputText;
    if (self.textField.text.length > 0) {
        inputText = self.textField.text;
        self.loadID = self.textField.text;
        [[NSUserDefaults standardUserDefaults] setValue:inputText forKey:[NSString stringWithFormat:@"AdFormat%zdUnitId",self.adFormat]];
        self.logLabel.text = @"";
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1 {
    [self.view endEditing:YES]; 
}
@end
