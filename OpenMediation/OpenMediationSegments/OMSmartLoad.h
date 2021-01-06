// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMLoad.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMSmartLoad : OMLoad

@property (nonatomic, assign) NSInteger maxParallelLoadCount;
@property (nonatomic, assign) NSInteger replenishCacheNofillCount;
@property (nonatomic, strong, nullable) NSTimer *checkCacheTimer;

@property (nonatomic, assign) NSInteger loadingCount;
@property (nonatomic, assign) NSInteger loadSuccessCount;
@property (nonatomic, assign) NSInteger cacheReadyCount;


@end

NS_ASSUME_NONNULL_END
