//
//  OMPromotionConfig.m
//  OMPromotionAdapter
//
//  Created by ylm on 2020/11/11.
//  Copyright © 2020 AdTiming. All rights reserved.
//

#import "OMPromotionConfig.h"

static OMPromotionConfig * _instance = nil;

@implementation OMPromotionConfig

+ (instancetype) sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _placementList = [NSMutableArray array];
        _placementMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadConfig:(NSDictionary*)configData {
    
}

@end
