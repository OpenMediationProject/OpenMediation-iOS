// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "BaseViewController.h"
@import OpenMediation;

NS_ASSUME_NONNULL_BEGIN

@interface BannerViewController : BaseViewController <OMBannerDelegate>
@property (nonatomic,strong) OMBanner *banner;
@end

NS_ASSUME_NONNULL_END
