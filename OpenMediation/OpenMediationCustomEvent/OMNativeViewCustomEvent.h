// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMMediatedNativeAd.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMNativeViewCustomEvent<NSObject>

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setNativeAd:(id<OMMediatedNativeAd>)nativeAd;
- (void)setMediaViewWithFrame:(CGRect)frame;
- (UIView*)mediaView;

@end

NS_ASSUME_NONNULL_END
