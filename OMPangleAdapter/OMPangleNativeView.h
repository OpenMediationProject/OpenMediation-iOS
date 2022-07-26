// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMNativeViewCustomEvent.h"
#import "OMPangleNativeClass.h"
#import "OMPangleNativeAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPangleNativeView : UIView <OMNativeViewCustomEvent>

@property (nonatomic, strong) OMPangleNativeAd *nativeAd;
@property (nonatomic, strong) PAGLNativeAdRelatedView *nativeView;
@property (nonatomic, strong) PAGMediaView *mediaView;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
