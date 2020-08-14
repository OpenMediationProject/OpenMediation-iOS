// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMNativeViewCustomEvent.h"
#import "OMAdTimingNativeClass.h"
#import "OMAdTimingNativeAd.h"
#import "OMAdTimingNativeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMAdTimingNativeView : UIView<OMNativeViewCustomEvent>

@property (nonatomic, strong) OMAdTimingNativeAd *nativeAd;
@property (nonatomic, strong) AdTimingAdsNativeView *adtNativeView;
@property (nonatomic, strong) AdTimingAdsNativeMediaView *mediaView;

/// This is a method to initialize an AdTimingNativeView.
/// Parameter frame: the AdTimingNativeView frame.
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
