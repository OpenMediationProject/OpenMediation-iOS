// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "InitSettingViewController.h"

@interface AppDelegate:UIResponder
- (NSString *)getAppKey;
- (NSString*)getBaseHost;
@end

@interface InitSettingViewController ()
@property (nonatomic, strong) UILabel *appKeyLabel;
@property (nonatomic, strong) UITextField *appKeyTextField;
@property (nonatomic, strong) UILabel *hostLabel;
@property (nonatomic, strong) UITextField *hostTextField;

@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation InitSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.appKeyLabel];
    [self.view addSubview:self.appKeyTextField];
    [self.view addSubview:self.hostLabel];
    [self.view addSubview:self.hostTextField];
    [self.view addSubview:self.saveBtn];
    
    NSString *input = [[UIPasteboard generalPasteboard] string];
    self.appKeyTextField.text = input;
}

- (void)save:(id)sender {
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults] setValue:([self.appKeyTextField.text length]?self.appKeyTextField.text:self.appKeyTextField.placeholder) forKey:@"OpenMediationAppKey"];
    [[NSUserDefaults standardUserDefaults] setValue:([self.hostTextField.text length]?self.hostTextField.text:self.hostTextField.placeholder) forKey:@"OpenMediationBaseHost"];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save" message:@"Save success！\nPlease restart！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UILabel*)appKeyLabel {
    if(!_appKeyLabel){
        _appKeyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 ,90,self.view.frame.size.width,30)];
        _appKeyLabel.textAlignment = NSTextAlignmentLeft;
        _appKeyLabel.font = [UIFont systemFontOfSize:15];
        _appKeyLabel.textColor = [UIColor blackColor];
        _appKeyLabel.text = @"AppKey";
    }
    return _appKeyLabel;
}

- (UITextField*)appKeyTextField {
    if(!_appKeyTextField) {
        _appKeyTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 120, self.view.frame.size.width-30, 30)];
        _appKeyTextField.font = [UIFont systemFontOfSize:13];
        _appKeyTextField.textAlignment = NSTextAlignmentCenter;
        _appKeyTextField.textColor = [UIColor blackColor];
        _appKeyTextField.borderStyle = UITextBorderStyleRoundedRect;
        _appKeyTextField.placeholder = [((AppDelegate*)([UIApplication sharedApplication].delegate))getAppKey];
    }
    return _appKeyTextField;

}

- (UILabel*)hostLabel {
    if(!_hostLabel){
        _hostLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 ,180,self.view.frame.size.width,30)];
        _hostLabel.textAlignment = NSTextAlignmentLeft;
        _hostLabel.font = [UIFont systemFontOfSize:15];
        _hostLabel.textColor = [UIColor blackColor];
        _hostLabel.text = @"Host";
    }
    return _hostLabel;
}

- (UITextField*)hostTextField {
    if(!_hostTextField) {
        _hostTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 210, self.view.frame.size.width-30, 30)];
        _hostTextField.font = [UIFont systemFontOfSize:13];
        _hostTextField.textAlignment = NSTextAlignmentCenter;
        _hostTextField.textColor = [UIColor blackColor];
        _hostTextField.borderStyle = UITextBorderStyleRoundedRect;
        _hostTextField.placeholder = [((AppDelegate*)([UIApplication sharedApplication].delegate))getBaseHost];
    }
    return _hostTextField;

}

- (UIButton*)saveBtn {
    if(!_saveBtn){
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2.0,self.view.frame.size.width, 50)];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_saveBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}


@end
