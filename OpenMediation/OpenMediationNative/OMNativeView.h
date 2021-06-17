// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
@class OMNativeAd;
#import "OMNativeAdView.h"
#import "OMNativeMediaView.h"


NS_ASSUME_NONNULL_BEGIN

/// A customized UIView to represent a ad (native ad).
@interface OMNativeView : UIView

@property (nonatomic, strong) OMNativeAd *nativeAd;
@property (nonatomic, strong) OMNativeMediaView *mediaView;
@property (nonatomic, strong) OMNativeAdView *nativeAdView;

/// This is a method to initialize an OMNativeView.
/// Parameter frame: the OMNativeView frame.
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setClickableViews:(NSArray<UIView *> *)clickableViews; //for Facebook TencentAd

@end

NS_ASSUME_NONNULL_END
