// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMReachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMNetMonitor : NSObject

@property (nonatomic, strong) OMReachability *reachability;
@property (nonatomic , assign) OMNetworkStatus netStatus;

+ (instancetype)sharedInstance;
- (void)startMonitor;
- (NSString *)getNetWorkType;
- (NSNumber*)omNetworkType;

@end

NS_ASSUME_NONNULL_END
