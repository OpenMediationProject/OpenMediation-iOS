// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMNativeViewCustomEvent.h"
#import "OMGoogleAdNativeAd.h"
#import "OMGoogleAdNativeClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMGoogleAdNativeView : UIView<OMNativeViewCustomEvent>
@property (nonatomic, strong) OMGoogleAdNativeAd *nativeAd;
@property (nonatomic, strong) GADNativeAdView *gadNativeView;
@property (nonatomic, strong) GADMediaView *mediaView;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
- (instancetype)initWithFrame:(CGRect)frame;


@end

NS_ASSUME_NONNULL_END
