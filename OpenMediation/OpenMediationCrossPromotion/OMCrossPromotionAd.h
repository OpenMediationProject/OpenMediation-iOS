// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMCrossPromotionAdDelegate.h"
#import "OMAdBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionAd : OMAdBase

@property (nonatomic, copy) NSString *wfReqId;
@property (nonatomic, weak)id<OMCrossPromotionAdDelegate> delegate;

- (NSString*)placementID;

- (instancetype)initWithPlacementID:(NSString *)placementID;

- (BOOL)isReady;

- (void)loadAd;

- (void)preload;

- (void)showAdWithScreenPoint:(CGPoint)scaleXY adSize:(CGSize)size angle:(CGFloat) angle scene:(NSString*)sceneName;

- (void)hideAd;

@end

NS_ASSUME_NONNULL_END
