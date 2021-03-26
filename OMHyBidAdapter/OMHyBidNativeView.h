// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMNativeViewCustomEvent.h"
#import "OMHyBidNativeClass.h"
#import "OMHyBidNativeAd.h"
#import "OMHyBidNative.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMHyBidNativeView : UIView<OMNativeViewCustomEvent>

@property (nonatomic, strong) OMHyBidNativeAd *nativeAd;
@property (nonatomic, strong) HyBidNativeAdRenderer *renderer; // native view
@property (nonatomic, strong) UIImageView *mediaView;
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
