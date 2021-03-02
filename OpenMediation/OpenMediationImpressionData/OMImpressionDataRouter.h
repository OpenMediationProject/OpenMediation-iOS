// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMImpressionDataDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMImpressionDataRouter : NSObject

/// Returns the singleton instance.
+ (instancetype)sharedInstance;


/// Add delegate
- (void)addDelegate:(id<OMImpressionDataDelegate>)delegate;

/// Remove delegate
- (void)removeDelegate:(id<OMImpressionDataDelegate>)delegate;


- (void)postImpressionData:(OMImpressionData*)impressionData;
@end

NS_ASSUME_NONNULL_END
