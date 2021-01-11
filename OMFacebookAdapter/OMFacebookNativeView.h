// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <UIKit/UIKit.h>
#import "OMFacebookNativeClass.h"
#import "OMFacebookNativeAd.h"
#import "OMNativeViewCustomEvent.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMFacebookNativeView : UIView<FBMediaViewDelegate,OMNativeViewCustomEvent>

@property (nonatomic, strong) OMFacebookNativeAd *nativeAd;
@property (nonatomic, strong) FBAdChoicesView *adChoicesView;
@property (nonatomic, strong) FBMediaView *mediaView;

- (instancetype)initWithFrame:(CGRect)frame;



@end

NS_ASSUME_NONNULL_END
