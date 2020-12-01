// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMCustomEventDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@protocol OMCrossPromotionCustomEvent;

@protocol crossPromotionCustomEventDelegate<OMCustomEventDelegate>

- (void)promotionCustomEventWillAppear:(id<OMCrossPromotionCustomEvent>)adapter;
- (void)promotionCustomEventDidClick:(id<OMCrossPromotionCustomEvent>)adapter;
- (void)promotionCustomEventDidDisAppear:(id<OMCrossPromotionCustomEvent>)adapter;

@end

@protocol OMCrossPromotionCustomEvent<NSObject>
@property(nonatomic, weak, nullable) id<crossPromotionCustomEventDelegate> delegate;
- (instancetype)initWithParameter:(NSDictionary*)adParameter;
- (void)loadAd;
- (BOOL)isReady;
- (void)showAdWithSize:(CGSize)adSize screenPoint:(CGPoint)scaleXY xAngle:(CGFloat) xAngle zAngle:(CGFloat)zAngle scene:(NSString*)sceneName;
- (void)hideAd;
@end

NS_ASSUME_NONNULL_END
