// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMCrossPromotionAdDelegate.h"
#import "OMAdBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionAd : OMAdBase

@property (nonatomic, weak)id<OMCrossPromotionAdDelegate> delegate;

- (NSString*)placementID;

- (instancetype)initWithPlacementID:(NSString *)placementID;

- (BOOL)isReady;

- (void)loadAd;

- (void)preload;

- (void)showAdWithSize:(CGSize)adSize screenPoint:(CGPoint)scaleXY xAngle:(CGFloat) xAngle zAngle:(CGFloat)zAngle scene:(NSString*)sceneName;

- (void)hideAd;

@end

NS_ASSUME_NONNULL_END
