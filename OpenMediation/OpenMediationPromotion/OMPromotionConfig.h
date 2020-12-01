//
//  OMPromotionConfig.h
//  OMPromotionAdapter
//
//  Created by ylm on 2020/11/11.
//  Copyright © 2020 AdTiming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OMPromotionConfig : NSObject

@property (nonatomic, strong)   NSMutableArray *placementList;
@property (nonatomic, strong)   NSMutableDictionary *placementMap;

+ (instancetype) sharedInstance;

- (void)loadConfig:(NSDictionary*)configData;

@end

NS_ASSUME_NONNULL_END
