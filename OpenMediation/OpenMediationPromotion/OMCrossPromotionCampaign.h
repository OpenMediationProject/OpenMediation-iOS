// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import "OpenMediationAdFormats.h"
#import "OMCrossPromotionCampaignModel.h"
#import "OMNetworkUmbrella.h"
#import "OMCrossPromotionClickHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMCrossPromotionCampaignState) {
    OMCrossPromotionCampaignStateDefault = 0,
    OMCrossPromotionCampaignStateDataReady,
    OMCrossPromotionCampaignStateImpression,
    OMCrossPromotionCampaignStateClick,
};

@protocol OMCrossPromotionCampaignClickHandlerDelegate<NSObject>

@optional

- (void)campaignClickHandlerWillPresentScreen;
- (void)campaignClickHandlerDisDismissScrren;
- (void)campaignClickHandlerLeaveApplication;
@end

typedef void(^cacheCompletionHandler)(void);

@interface OMCrossPromotionCampaign : NSObject <OMClickHandlerDelegate>

@property (nonatomic, strong) OMCrossPromotionCampaignModel *model;
@property (nonatomic, assign) NSTimeInterval expireTime;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, assign) OpenMediationAdFormat adFormat;
@property (nonatomic, assign) OMCrossPromotionCampaignState state;
@property (nonatomic, strong) OMCrossPromotionClickHandler *clickHandler;
@property (nonatomic, copy, nullable) cacheCompletionHandler cacheReadyCompletion;
@property (nonatomic, weak) id<OMCrossPromotionCampaignClickHandlerDelegate> clickHanlerDelegate;
- (instancetype)initWithCampaignData:(NSDictionary*)cData pid:(NSString*)pid;
- (BOOL)isReady;
- (void)cacheMaterielCompletion:(cacheCompletionHandler)completionHandler;
- (BOOL)iconReady;
- (NSString*)iconCachePath;
- (BOOL)mainImgReady;
- (BOOL)videoReady;
- (NSString*)mainImgCachePath;
- (NSString*)videoCachePath;
- (BOOL)resourceReady;
- (NSString*)webUrl;
- (NSString*)webHtmlStr;
- (void)impression;
- (void)impression:(nullable NSString*)sceneID;
- (void)clickAndShowAd:(UIViewController*)rootVC;
- (void)clickAndShowAd:(UIViewController*)rootVC sceneID:(nullable NSString*)sceneID;
- (BOOL)expire;
- (NSDictionary*)originData;
- (UIImage*)logoImage;
- (void)iconClick;

@end

NS_ASSUME_NONNULL_END
