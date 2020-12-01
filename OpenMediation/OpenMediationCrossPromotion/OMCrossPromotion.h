// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OMAdSingletonInterface.h"
#import "OMCrossPromotionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotion : OMAdSingletonInterface
/// Returns the singleton instance.
+ (instancetype)sharedInstance;

/// Add delegate
- (void)addDelegate:(id<OMCrossPromotionDelegate>)delegate;

/// Remove delegate
- (void)removeDelegate:(id<OMCrossPromotionDelegate>)delegate;

/// Indicates whether the promotion ad is ready to show ad.
- (BOOL)isReady;

/// Indicates whether the scene has reached the display frequency.
- (BOOL)isCappedForScene:(NSString *)sceneName;

/// Show promotion ad on top view
/// Parameter scaleXY: the value is a CGPonit, x is width percentage, y is height percentage. eg screen center CGPointMake(0.5,0.5)
/// Parameter scene: the value is an NSString, ad scene name in OpenMediation dashboard setting.
- (void)showAdWithScreenPoint:(CGPoint)scaleXY scene:(NSString *)sceneName;


/// Show promotion ad on top view.
/// @param adSize  ad size
/// @param scaleXY  The value is a CGPonit, x is width percentage, y is height percentage. eg screen center CGPointMake(0.5,0.5)
/// @param xAngle  Rotated angle in clockwise.
/// @param zAngle  Rotated angle in clockwise.
/// @param sceneName  The value is an NSString, ad scene name in OpenMediation dashboard setting.
- (void)showAdWithSize:(CGSize)adSize screenPoint:(CGPoint)scaleXY xAngle:(CGFloat) xAngle zAngle:(CGFloat)zAngle scene:(NSString *)sceneName;

/// Hide promotion ad.
- (void)hideAd;

@end

NS_ASSUME_NONNULL_END
