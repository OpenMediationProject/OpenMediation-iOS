//
//  OMPromotionUnit.h
//  OpenMediation
//
//  Created by ylm on 2020/11/11.
//  Copyright © 2020 AdTiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenMediationAdFormats.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMPromotionUnit : NSObject

@property (nonatomic, copy) NSString *unitID;
@property (nonatomic, assign) OpenMediationAdFormat adFormat;

- (instancetype)initWithUnitData:(NSDictionary*)unitData;

@end

NS_ASSUME_NONNULL_END
