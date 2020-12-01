// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

@class OMCrossPromotionAd;

NS_ASSUME_NONNULL_BEGIN

@protocol OMCrossPromotionAdDelegate<NSObject>

@optional


- (void)promotionChangedAvailability:(OMCrossPromotionAd *)Promotion newValue:(BOOL)available;

- (void)promotionDidLoad:(OMCrossPromotionAd*)Promotion;

- (void)promotionDidFailToLoad:(OMCrossPromotionAd*)Promotion withError:(NSError*)error;

- (void)promotionWillAppear:(OMCrossPromotionAd *)Promotion;

- (void)promotionDidClick:(OMCrossPromotionAd *)Promotion;

- (void)promotionDidDisappear:(OMCrossPromotionAd *)Promotion;

@end

NS_ASSUME_NONNULL_END

