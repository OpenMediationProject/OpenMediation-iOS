// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMEventManager.h"
#import "OMToolUmbrella.h"
#import "OMNetworkUmbrella.h"
#import "OpenMediation.h"

#define OM_EVENT_MAX_COUNT  100

#define OM_EVENT_SAVE_STEP  10

static OMEventManager * _instance = nil;

@implementation OMEventManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _uploadUrl = @"";
        _eventPackageNumber = OM_EVENT_MAX_COUNT;
        _uploadMaxInterval = 0;
        _uploadEventIds = @[];
        _eventList = [NSMutableArray array];
        _eventTimeStamp = [NSMutableDictionary dictionary];
        _eventDataPath = [[NSString omDataPath] stringByAppendingPathComponent:@"es.plist"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:_eventDataPath]) {
            _eventList =[NSMutableArray arrayWithContentsOfFile:_eventDataPath];
        }
        [self addAppActiveObserve];
    }
    return self;
}

- (void)loadEventConfig:(NSDictionary*)eventConfig {
    if (eventConfig && [eventConfig isKindOfClass:[NSDictionary class]]) {
        _uploadUrl = OM_SAFE_STRING(eventConfig[@"url"]);
        _eventPackageNumber = MIN([eventConfig[@"mn"]integerValue],OM_EVENT_MAX_COUNT);
        _uploadMaxInterval  = [eventConfig[@"ci"]integerValue];
        _uploadEventIds = [NSArray array];
        if (eventConfig[@"ids"] && [eventConfig[@"ids"] isKindOfClass:[NSArray class]]) {
            _uploadEventIds = eventConfig[@"ids"];
        }
        if (_uploadMaxInterval > 0) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_uploadMaxInterval target:self selector:@selector(postEvents) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }

}

- (NSString*)eventTimeKey:(NSInteger)eventID extraData:(NSDictionary*_Nullable)data {
    NSString *key = [NSString stringWithFormat:@"%zd",eventID];
    if ([data objectForKey:@"pid"]) {
        key  = [key stringByAppendingFormat:@"_placement%@",[data objectForKey:@"pid"]];
    }
    if ([data objectForKey:@"iid"]) {
        key  = [key stringByAppendingFormat:@"_instance%@",[data objectForKey:@"iid"]];
    }
    if ([data objectForKey:@"scene"]) {
        key  = [key stringByAppendingFormat:@"_scene%@",[data objectForKey:@"scene"]];
    }
    return key;
}

- (void)saveEventTime:(NSInteger)eventID extraData:(NSDictionary*_Nullable)data {
    NSString *key = [self eventTimeKey:eventID extraData:data];
    @synchronized (self) {
        [_eventTimeStamp setObject:[UIDevice omTimeStamp] forKey:key];
    }
}

- (NSInteger)eventTime:(NSInteger)eventID extraData:(NSDictionary*_Nullable)data {
    NSString *key = [self eventTimeKey:eventID extraData:data];
    return [[_eventTimeStamp objectForKey:key] integerValue];
}

- (NSInteger)eventDuration:(NSInteger)eventID extraData:(NSDictionary*_Nullable)data {
    NSInteger duration = 0;
    NSInteger startTime = 0;
    if (eventID == INIT_COMPLETE || eventID == INIT_FAILED) {
        startTime = [self eventTime:INIT_START extraData:data];
    } else if (eventID == AVAILABLE_FROM_CACHE) {
        startTime = [self eventTime:ATTEMPT_TO_BRING_NEW_FEED extraData:data];
    } else if (eventID == LOAD_BLOCKED) {
        startTime = MAX([self eventTime:CALLED_LOAD extraData:data], [self eventTime:ATTEMPT_TO_BRING_NEW_FEED extraData:data]);
    } else if (eventID == NO_MORE_OFFERS) {
        startTime = [self eventTime:LOAD extraData:data];
    } else if (eventID == INSTANCE_INIT_SUCCESS || eventID == INSTANCE_INIT_FAILED) {
        startTime = [self eventTime:INSTANCE_INIT_START extraData:data];
    } else if (eventID == INSTANCE_LOAD_ERROR || eventID == INSTANCE_LOAD_SUCCESS) {
        startTime = [self eventTime:INSTANCE_LOAD extraData:data];
    } else if (eventID == INSTANCE_SHOW_SUCCESS || eventID == INSTANCE_SHOW_FAILED) {
        startTime = [self eventTime:INSTANCE_SHOW extraData:data];
    } else if (eventID == INSTANCE_CLICKED || eventID == INSTANCE_CLOSED) {
        startTime = [self eventTime:INSTANCE_SHOW_SUCCESS extraData:data];
    } else if (eventID == INSTANCE_VIDEO_COMPLETED) {
        startTime = [self eventTime:INSTANCE_VIDEO_START extraData:data];
    } else if (eventID == INSTANCE_BID_RESPONSE || eventID == INSTANCE_BID_FAILED) {
        startTime = [self eventTime:INSTANCE_BID_REQUEST extraData:data];
    }
    if (startTime) {
        duration = [[UIDevice omTimeStamp]integerValue] - startTime;
    }
    return duration;
}

- (void)addEvent:(NSInteger)eventID extraData:(NSDictionary*_Nullable)data {
    NSNumber *eventIDNumber = [NSNumber numberWithInteger:eventID];
    if (![OpenMediation isInitialized] || [_uploadEventIds containsObject:eventIDNumber]) {//未初始化前的event全部加入，在初始化成功后检查后如无需上报remove
        NSMutableDictionary *eventDic = [NSMutableDictionary dictionary];
        [eventDic setValue:[UIDevice omTimeStamp] forKey:@"ts"];
        [eventDic setValue:eventIDNumber forKey:@"eid"];
        if ([self eventDuration:eventID extraData:data] != 0) {
            [eventDic setValue:[NSNumber numberWithInteger:[self eventTime:eventID extraData:data]] forKey:@"duration"];
        }
        if (data) {
            [eventDic addEntriesFromDictionary:data];
        }
        OMLogD(@"add event:%zd",eventID);
        @synchronized (self) {
            [_eventList addObject:[eventDic copy]];
            if ((_eventList.count % OM_EVENT_SAVE_STEP) == 0) {
                [self saveEvents];
            }
        }

        [self checkPackageFull];
    } else {
        OMLogD(@"event ids not contain %@",eventIDNumber);
    }
}


- (void)initSuccess {
    @synchronized (self) {
        NSMutableArray *removeEvents = [NSMutableArray array];
        for (NSDictionary *event in _eventList) {
            NSString *eventID = [event objectForKey:@"eid"];
            if (![_uploadEventIds containsObject:eventID]) {
                [removeEvents addObject:event];
            }
        }
        [_eventList removeObjectsInArray:removeEvents];
    }
    [self saveEvents];
    [self addEvent:INIT_COMPLETE extraData:nil];
}

- (void)checkPackageFull {
    @synchronized (self) {
        if (_eventList.count >= _eventPackageNumber) {
            if ([OpenMediation isInitialized]) {
                [self postEvents];
            } else {
                NSArray *oldEventArray = [_eventList subarrayWithRange:NSMakeRange(0, MIN(_eventList.count, OM_EVENT_SAVE_STEP))];
                [self.eventList removeObjectsInArray:oldEventArray];
                
            }

        }
    }
}

- (void)saveEvents {
    @synchronized (self) {
        [_eventList writeToFile:_eventDataPath atomically:YES];
    }
}

- (void)postEvents {
    @synchronized (self) {
            if (_eventList.count>0 && !_posting) {
            _posting = YES;
            NSInteger batchSize = MIN(_eventList.count, _eventPackageNumber);
            NSArray *postEventArray = [_eventList subarrayWithRange:NSMakeRange(0, batchSize)];
            [self.eventList removeObjectsInArray:postEventArray];
            [self saveEvents];
            [OMEventRequest postEvents:postEventArray url:_uploadUrl completionHandler:^(NSObject * _Nullable object, NSError * _Nullable error) {
                @synchronized (self) {
                    self.posting = NO;
                    if (!error) {
                        [self checkPackageFull];
                    }
                }
            }];
        }
    }
}

- (void)addAppActiveObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    
}

- (void)handleApplicationDidBecomeActive {
    [self addEvent:APP_RESUME extraData:nil];
}

- (void)handleApplicationWillResignActive {
    [self addEvent:APP_PAUSE extraData:nil];
    [self saveEvents];
}

- (void)handleApplicationWillTerminate {
    [self addEvent:APP_TERMINATE extraData:nil];
    [self saveEvents];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillTerminateNotification object:self];
}
@end
