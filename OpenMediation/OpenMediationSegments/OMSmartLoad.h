// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMLoad.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMSmartLoad : OMLoad

@property (nonatomic, assign) NSInteger unitCacheCount;
@property (nonatomic, assign) NSInteger configCacheCount;
@property (nonatomic, strong) NSMutableArray *fillInstances;
@property (nonatomic, assign) NSInteger maxParallelLoadCount;
@property (nonatomic, assign) NSInteger replenishCacheNofillCount;
@property (nonatomic, strong, nullable) NSTimer *checkCacheTimer;

@property (nonatomic, assign) NSInteger loadingCount;
@property (nonatomic, assign) NSInteger cacheCount;


@end

NS_ASSUME_NONNULL_END
