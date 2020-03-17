// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OMCrashHandle : NSObject
@property(strong, nonatomic) NSMutableArray *crashLogs;

+ (instancetype)sharedInstance;
- (void)install;
- (void)sendCrashLog;
- (void)saveException:(NSException*)exception;
- (void)saveSignal:(int)sigNum signalInfo:(siginfo_t*)signalInfo;
@end

NS_ASSUME_NONNULL_END
