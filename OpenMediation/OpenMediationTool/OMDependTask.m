// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMDependTask.h"

#define OM_DEPEND_TASK_WAIT_MAX_TIME 10


static OMDependTask * _instance = nil;


@implementation OMDependTask

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dependTasks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSString *observeValueKey = [NSString stringWithFormat:@"%@%@%@",object,keyPath,change[NSKeyValueChangeNewKey]];
    [self checkObserveValueKeyTask:observeValueKey];
}

- (void)addTaskDependOjbect:(id)object keyPath:(NSString*)keyPath observeValues:(NSArray*)observeValues observeTask:(observeTaskBlock)observeTask realTaskCheckValues:(NSArray*)checkValues realTask:(realTaskBlock)realTask{
    NSString *objecCurrentValue = [[object valueForKeyPath:keyPath] stringValue];
    BOOL runRealTask = NO;
    for (NSString *checkValue in checkValues) {
        if ([objecCurrentValue isEqualToString:checkValue]) {
            runRealTask = YES;
            break;
        }
    }
    if (runRealTask) {
        realTask();
    }
    objecCurrentValue = [[object valueForKeyPath:keyPath] stringValue];
    BOOL runObserveTask = NO;
    for (NSString *observeValue in observeValues) {
        if ([objecCurrentValue isEqualToString:observeValue]) {
            runObserveTask = YES;
            break;
        }
    }
    
    if (runObserveTask) {
        observeTask();
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(checkTimeoutTask) withObject:nil afterDelay:OM_DEPEND_TASK_WAIT_MAX_TIME];
        });
        
        NSString *timStampKey = [NSString stringWithFormat:@"%zd",(NSInteger)([[NSDate date]timeIntervalSince1970] + OM_DEPEND_TASK_WAIT_MAX_TIME)];
        NSString *taskKey = [NSString stringWithFormat:@"%@",timStampKey];
        for (NSString *observeValue in observeValues) {
            NSString *observeValueKey = [NSString stringWithFormat:@"%@%@%@",object,keyPath,observeValue];
            taskKey  = [taskKey stringByAppendingString:[NSString stringWithFormat:@"_%@",observeValueKey]];
        }
        
        NSMutableArray *taskArray = [NSMutableArray array];
        if ([_dependTasks objectForKey:taskKey]) {
            taskArray = [NSMutableArray arrayWithArray:[_dependTasks objectForKey:taskKey]];
        }
        [taskArray addObject:observeTask];
        [_dependTasks setObject:taskArray forKey:taskKey];
        [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
}

- (void)checkTimeoutTask {
    NSInteger now = (NSInteger)[[NSDate date]timeIntervalSince1970];
    for (NSString *key in [_dependTasks allKeys]) {
        NSArray *subKeys = [key componentsSeparatedByString:@"_"];
        if (subKeys.count >0) {
             NSInteger timeoutTime = [[subKeys firstObject]integerValue];
            if (now >= timeoutTime) {
                NSArray *tasks = [_dependTasks objectForKey:key];
                for (observeTaskBlock task in tasks) {
                    task();
                }
                [_dependTasks removeObjectForKey:key];
            }
        }
    }
}

- (void)checkObserveValueKeyTask:(NSString*)valueKey {
    for (NSString *key in [_dependTasks allKeys]) {
        if ([key containsString:valueKey]) {
            NSArray *tasks = [_dependTasks objectForKey:key];
            for (observeTaskBlock task in tasks) {
                task();
            }
            [_dependTasks removeObjectForKey:key];
        }
    }
}
@end
