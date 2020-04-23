// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMNativeViewCustomEvent.h"
#import "OMMopubNativeClass.h"
#import "OMMopubNativeAd.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMMopubNativeView : UIView <OMNativeViewCustomEvent,MPNativeAdRendering>
@property (nonatomic, strong) OMMopubNativeAd *nativeAd;
@property (nonatomic, strong) UIImageView *mediaView;
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
