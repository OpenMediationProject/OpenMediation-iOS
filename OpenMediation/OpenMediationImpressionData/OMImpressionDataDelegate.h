// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMImpressionData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OMImpressionDataDelegate<NSObject>

- (void)omImpressionData:(OMImpressionData * _Nullable)impressionData error:(NSError* _Nullable)error;

@end

NS_ASSUME_NONNULL_END
