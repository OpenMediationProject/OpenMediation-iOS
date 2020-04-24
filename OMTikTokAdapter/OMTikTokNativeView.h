// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMNativeViewCustomEvent.h"
#import "OMTikTokNativeClass.h"
#import "OMTikTokNativeAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMTikTokNativeView : UIView <OMNativeViewCustomEvent>

@property (nonatomic, strong) OMTikTokNativeAd *nativeAd;
@property (nonatomic, strong) BUNativeAdRelatedView *relatedView;
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIImageView *mainImageView;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
