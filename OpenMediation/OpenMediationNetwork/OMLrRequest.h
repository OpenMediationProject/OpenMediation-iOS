// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, OMLRType) {
    OMLRTypeSDKInit = 1,
    OMLRTypeWaterfallLoad = 2,
    OMLRTypeWaterfallReady = 3,
    OMLRTypeInstanceLoad = 4,
    OMLRTypeInstanceReady = 5,
    OMLRTypeInstanceImpression = 6,
    OMLRTypeInstanceClick = 7,
    OMLRTypeVideoStart = 8,
    OMLRTypeVideoComplete = 9,
    OMLRTypeWaterfallFill = 14,
};

NS_ASSUME_NONNULL_BEGIN

@interface OMLrRequest : NSObject

+ (void)postWithType:(OMLRType)type
                 pid:(NSString *)pid
               adnID:(OMAdNetwork)adnID
          instanceID:(NSString *)instanceID
              action:(NSInteger)action
               scene:(NSString *)sceneID
                 abt:(NSInteger)abTest
                 abtId:(NSInteger)abtId
                 bid:(BOOL)bid
               reqId:(NSString *)reqId
              ruleId:(NSInteger)ruleId
             revenue:(double)revenue
                  rp:(NSInteger)rp
                  ii:(NSInteger)ii
                 adn:(NSString*)adnName;

@end

NS_ASSUME_NONNULL_END
