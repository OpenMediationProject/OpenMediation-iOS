// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationAdFormats.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMImpressionData : NSObject

@property (readonly, copy) NSString *impressionId;

@property (readonly, copy) NSString *placementId;

@property (readonly, copy) NSString *placementName;

@property (readonly, copy) NSString *placementAdType;

@property (readonly, copy) NSString *sceneName;

@property (readonly, copy) NSString *ruleId;

@property (readonly, copy) NSString *ruleName;

@property (readonly, copy) NSNumber *ruleType;

@property (readonly, copy) NSNumber *rulePriority;

@property (readonly, copy) NSString *abGroup;

@property (readonly, copy) NSString *instanceId;

@property (readonly, copy) NSString *instanceName;

@property (readonly, copy) NSNumber *instancePriority;

@property (readonly, copy) NSString *adNetworkId;

@property (readonly, copy) NSString *adNetworkName;

@property (readonly, copy) NSString *adNetworkUnitId;

@property (readonly, copy) NSString *precision;

@property (readonly, copy) NSString *currency;

@property (readonly, copy) NSNumber *revenue;

@property (readonly, copy) NSNumber *lifeTimeValue;

@property (readonly, copy) NSString *userID;

@end

NS_ASSUME_NONNULL_END
