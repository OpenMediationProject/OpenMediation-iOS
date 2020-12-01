// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMCrossPromotionNative.h"
#import "OMCrossPromotionNativeView.h"
#import "OMCrossPromotionNativeMediaView.h"
#import "OMCrossPromotionNativeAd.h"
#import "OMNativeViewCustomEvent.h"
#import "OMCrossPromotionCampaignManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionNativeView : UIView<OMNativeViewCustomEvent>

@property (nonatomic, strong) OMCrossPromotionNativeAd *nativeAd;
@property (nonatomic, strong) OMCrossPromotionNativeMediaView *mediaView;
@property (nonatomic, strong) UIImageView *adChoicesView;
@property (nonatomic, strong) OMCrossPromotionCampaign *campaign;

@end

NS_ASSUME_NONNULL_END
