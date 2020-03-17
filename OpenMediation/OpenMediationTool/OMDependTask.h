// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^observeTaskBlock)(void);

typedef void (^realTaskBlock)(void);

@interface OMDependTask : NSObject
@property (nonatomic, strong) NSMutableDictionary *dependTasks;

+ (instancetype)sharedInstance;
//- (void)runTask:(taskBlock)task dependOjbect:(id)object keyPath:(NSString*)keyPath value:(NSString*)value;
- (void)addTaskDependOjbect:(id)object keyPath:(NSString*)keyPath observeValues:(NSArray*)observeValues observeTask:(observeTaskBlock)observeTask realTaskCheckValues:(NSArray*)checkValues realTask:(realTaskBlock)realTask;
@end

NS_ASSUME_NONNULL_END
