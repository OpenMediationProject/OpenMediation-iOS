// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMTencentAdNativeClass.h"
#import "OMTencentAdNativeAd.h"
#import "OMNativeViewCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMTencentAdNativeView : UIView<OMNativeViewCustomEvent,GDTUnifiedNativeAdViewDelegate>

@property (nonatomic, strong) OMTencentAdNativeAd *nativeAd;
@property (nonatomic, strong) GDTUnifiedNativeAdView *gdtNativeView;
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, strong) GDTMediaView *gdtMediaView;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@end

NS_ASSUME_NONNULL_END
