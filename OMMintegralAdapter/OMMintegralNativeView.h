// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMMintegralNativeClass.h"
#import "OMMintegralNativeAd.h"
#import "OMNativeViewCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMMintegralNativeView : UIView<OMNativeViewCustomEvent,MTGMediaViewDelegate>

@property (nonatomic, strong) OMMintegralNativeAd *nativeAd;
@property (nonatomic, strong) MTGAdChoicesView *adChoicesView;
@property (nonatomic, strong) MTGMediaView *mediaView;

@end

NS_ASSUME_NONNULL_END
