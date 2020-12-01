// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMCrossPromotionCampaignManager.h"
#import "OMNativeCustomEvent.h"
#import "OMMediatedNativeAd.h"
@class OMCrossPromotionNativeAd;

NS_ASSUME_NONNULL_BEGIN


@protocol OMCrossPromotionNativeAdDelegate <NSObject>

- (void)OMCrossPromotionNativeAdWillShow:(OMCrossPromotionNativeAd*)nativeAd;
- (void)OMCrossPromotionNativeAdDidClick:(OMCrossPromotionNativeAd*)nativeAd;

@end

@interface OMCrossPromotionNativeAd : NSObject<OMMediatedNativeAd>

@property (nonatomic, strong) OMCrossPromotionCampaign *campaign;
@property (nonatomic, strong) id <OMCrossPromotionNativeAdDelegate> adDelegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *callToAction;
@property (nonatomic, assign) double rating;
@property (nonatomic, copy) NSString *nativeViewClass;
@property (nonatomic, assign) BOOL impr;
- (instancetype)initWithCampaign:(OMCrossPromotionCampaign *)campaign;
- (void)showAd:(UIViewController*)rootViewController;
@end

NS_ASSUME_NONNULL_END
