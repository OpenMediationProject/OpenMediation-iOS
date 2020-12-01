//
//  OMPromotionUnit.m
//  OpenMediation
//
//  Created by ylm on 2020/11/11.
//  Copyright © 2020 AdTiming. All rights reserved.
//

#import "OMPromotionUnit.h"

@implementation OMPromotionUnit

- (instancetype)initWithUnitData:(NSDictionary*)unitData {
    if (self = [super init]) {
        _unitID = [NSString stringWithFormat:@"%@",[unitData objectForKey:@"id"]];
        _adFormat = (1<<[[unitData objectForKey:@"t"]integerValue]);
    }
    return self;
}

@end
