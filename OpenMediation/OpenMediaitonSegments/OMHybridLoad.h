// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMLoad.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMHybridLoad : OMLoad
@property (nonatomic, assign) NSInteger batchSize;
@property (nonatomic, assign) BOOL fanoutType;
@end

NS_ASSUME_NONNULL_END
