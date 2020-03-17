// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>

@import OpenMediation;

#define kIsIphoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *loadItem;
@property (nonatomic, strong) UIBarButtonItem *showItem;
@property (nonatomic, strong) UIBarButtonItem *removeItem;
@property (nonatomic, strong) UIBarButtonItem *clearItem;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIScrollView *logScrollView;// Log
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) NSString *loadID;
@property (nonatomic, assign) OpenMediationAdFormat adFormat;


- (void)showLog:(NSString*)log;
-(void)showItemAction;
-(void)clearItemAction;
-(void)removeItemAction;

@end

NS_ASSUME_NONNULL_END
