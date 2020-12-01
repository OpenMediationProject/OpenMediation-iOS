// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^clCompletionHandler)(NSDictionary *_Nullable campaigns,  NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionClRequest : NSObject

+ (void)requestCampaignWithPid:(NSString *)pid size:(CGSize)size actionType:(NSInteger)actionType payload:(nullable NSString*)payload completionHandler:(clCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
