// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (OMExtension)
+ (UIViewController *)omRootViewController;
+ (UIWindow *)omCurrentWindow;
@end

NS_ASSUME_NONNULL_END
