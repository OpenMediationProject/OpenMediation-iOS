// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMCrossPromotionCampaign.h"

typedef void(^loadCompletionHandler)( OMCrossPromotionCampaign * _Nullable campaign,NSError * _Nullable error);


NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionCampaignManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *placmentAdsMap;

+ (instancetype)sharedInstance;

- (void)loadPid:(NSString*)pid
             size:(CGSize)size
          reqId:(NSString*)reqId
           action:(NSInteger)action
completionHandler:(loadCompletionHandler)completionHandler;

- (void)loadAdWithPid:(NSString*)pid
             size:(CGSize)size
            reqId:(NSString*)reqId
           action:(NSInteger)action
            payload:(nullable NSString*)payload
completionHandler:(loadCompletionHandler)completionHandler;

- (void)addCampaignsWithData:(NSArray*)campaignsData pid:(NSString*)pid;

- (OMCrossPromotionCampaign*)getCampaignWithPid:(NSString*)pid;


@end

NS_ASSUME_NONNULL_END
