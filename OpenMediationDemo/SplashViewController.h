// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "BaseViewController.h"
@import OpenMediation;

NS_ASSUME_NONNULL_BEGIN

@interface SplashViewController : BaseViewController<OMSplashDelegate>

@property (nonatomic, strong) OMSplash *splash;

@end

NS_ASSUME_NONNULL_END
