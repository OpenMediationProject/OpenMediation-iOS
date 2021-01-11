// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMLoadFrequencryControl.h"
#import "OMConfig.h"
#import "OMToolUmbrella.h"
#import "OMScene.h"
#import "OMEventManager.h"

static OMLoadFrequencryControl * _instance = nil;

@implementation OMLoadFrequencryControl

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self =[super init]) {
        [self loadPlacementImprData];
        [self loadInstanceImprData];
        [self loadScenenImprData];
    }
    return self;
}

- (void)loadPlacementImprData {
    _placementImprMap = [NSMutableDictionary dictionary];
    NSString *omDataPath = [NSString omDataPath];
    NSString *placementImprPath = [omDataPath stringByAppendingPathComponent:@"api.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:placementImprPath]) {
        _placementImprMap =[NSMutableDictionary dictionaryWithContentsOfFile:placementImprPath];
    }
}

- (void)savePlacementImprData {
    NSString *omDataPath = [NSString omDataPath];
    NSString *placementImprPath = [omDataPath stringByAppendingPathComponent:@"api.plist"];
    [_placementImprMap writeToFile:placementImprPath atomically:YES];
}

- (void)loadInstanceImprData {
    _instanceImprMap = [NSMutableDictionary dictionary];
    NSString *omDataPath = [NSString omDataPath];
    NSString *instanceImprPath = [omDataPath stringByAppendingPathComponent:@"aii.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:instanceImprPath]) {
        _instanceImprMap =[NSMutableDictionary dictionaryWithContentsOfFile:instanceImprPath];
    }
}

- (void)saveInstanceImprData {
    NSString *omDataPath = [NSString omDataPath];
    NSString *instanceImprPath = [omDataPath stringByAppendingPathComponent:@"aii.plist"];
    [_instanceImprMap writeToFile:instanceImprPath atomically:YES];
}

- (void)loadScenenImprData {
    _sceneImprMap = [NSMutableDictionary dictionary];
    NSString *omDataPath = [NSString omDataPath];
    NSString *instanceImprPath = [omDataPath stringByAppendingPathComponent:@"aci.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:instanceImprPath]) {
        _sceneImprMap =[NSMutableDictionary dictionaryWithContentsOfFile:instanceImprPath];
    }
}

- (void)saveSceneImprData {
    NSString *omDataPath = [NSString omDataPath];
    NSString *instanceImprPath = [omDataPath stringByAppendingPathComponent:@"aci.plist"];
    [_sceneImprMap writeToFile:instanceImprPath atomically:YES];
}


- (void)checkOldImprRecord {
    NSTimeInterval nowTimeStamp = [[NSDate date]timeIntervalSince1970];
    NSTimeInterval oldDataTimeStamp  = nowTimeStamp - 60*60*24*2;

    NSArray *allPlacment = [_placementImprMap allKeys];
    
    for (NSString* placement in allPlacment) {
        NSMutableArray *filterRecords = [NSMutableArray array];
        NSArray *records = [_placementImprMap objectForKey:placement];
        for (int i=0; i<[records count]; i++) {
            NSString *recordTime = records[i];
            if ([recordTime integerValue] > oldDataTimeStamp) {
                [filterRecords addObject:recordTime];
            }
        }
        [_placementImprMap setObject:filterRecords forKey:placement];
    }
    [self savePlacementImprData];
    
    
    NSArray *allInstance = [_instanceImprMap allKeys];
    for (NSString* instance in allInstance) {
        NSMutableArray *filterRecords = [NSMutableArray array];
        NSArray *records = [_instanceImprMap objectForKey:instance];
        for (int i=0; i<[records count]; i++) {
            NSString *recordTime = records[i];
            if ([recordTime integerValue] > oldDataTimeStamp) {
                [filterRecords addObject:recordTime];
            }
        }
        [_instanceImprMap setObject:filterRecords forKey:instance];
    }
    [self saveInstanceImprData];
    
    NSArray *allScenes = [_sceneImprMap allKeys];
    for (NSString* scene in allScenes) {
        NSMutableArray *filterRecords = [NSMutableArray array];
        NSArray *records = [_sceneImprMap objectForKey:scene];
        for (int i=0; i<[records count]; i++) {
            NSString *recordTime = records[i];
            if ([recordTime integerValue] > oldDataTimeStamp) {
                [filterRecords addObject:recordTime];
            }
        }
        [_sceneImprMap setObject:filterRecords forKey:scene];
    }
    [self saveSceneImprData];
}


- (void)recordImprOnPlacement:(NSString*)placementID {
    NSMutableArray *records = [NSMutableArray array];
    if ([_placementImprMap objectForKey:placementID]) {
        records = [NSMutableArray arrayWithArray:[_placementImprMap objectForKey:placementID]];
    }
    NSTimeInterval timeStamp = [[NSDate date]timeIntervalSince1970];
    [records addObject:[NSString stringWithFormat:@"%zd",(NSInteger)(timeStamp)]];
    [_placementImprMap setObject:records forKey:placementID];
    [self savePlacementImprData];
    OMLogD(@"placementID %@ save impression count = %zd",placementID,[records count]);
}


- (void)recordImprOnInstance:(NSString*)instanceID {
    NSMutableArray *records = [NSMutableArray array];
    if ([_instanceImprMap objectForKey:instanceID]) {
        records = [NSMutableArray arrayWithArray:[_instanceImprMap objectForKey:instanceID]];
    }
    NSTimeInterval timeStamp = [[NSDate date]timeIntervalSince1970];
    [records addObject:[NSString stringWithFormat:@"%zd",(NSInteger)(timeStamp)]];
    [_instanceImprMap setObject:records forKey:instanceID];
    [self saveInstanceImprData];
    OMLogD(@"instanceID %@ save impression count = %zd",instanceID,[records count]);
}

- (BOOL)overCapOnPlacement:(NSString*)placementID {
    BOOL overCap = NO;
    OMUnit *adUnit = [[OMConfig sharedInstance].adUnitMap objectForKey:placementID];
    
    if (adUnit && adUnit.frequencryCap > 0) {
        NSInteger imprCount = [self imprCountOnPlacment:placementID inHours:adUnit.frequencryUnit];
        if (imprCount >= adUnit.frequencryCap ) {
            overCap = YES;
            [[OMEventManager sharedInstance]addEvent:PLACEMENT_CAPPED extraData:@{@"pid":placementID}];
            OMLogD(@"placement =%@ over cap %zd,%zd",placementID,imprCount,adUnit.frequencryCap);
        }
    }
    return overCap;
}

- (void)recordImprOnPlacement:(NSString*)placementID sceneID:(NSString*)sceneID {
    [self recordImprOnPlacement:placementID];
    OMScene *scene = [[OMConfig sharedInstance]getSceneWithSceneID:sceneID inAdUnit:placementID];
    if (scene) {
        NSMutableArray *records = [NSMutableArray array];
        if ([_sceneImprMap objectForKey:scene.sceneID]) {
            records = [NSMutableArray arrayWithArray:[_sceneImprMap objectForKey:scene.sceneID]];
        }
        NSTimeInterval timeStamp = [[NSDate date]timeIntervalSince1970];
        [records addObject:[NSString stringWithFormat:@"%zd",(NSInteger)(timeStamp)]];
        [_sceneImprMap setObject:records forKey:scene.sceneID];
        [self saveSceneImprData];
        OMLogD(@"scene %@ save impression count = %zd",scene.sceneName,[records count]);
    }

}

- (BOOL)loadTimeLessThanIntervalOnPlacement:(NSString*)placementID {
    BOOL lessThanInterval = NO;
    OMUnit *adUnit = [[OMConfig sharedInstance].adUnitMap objectForKey:placementID];
    if (adUnit && adUnit.frequencryInterval >0) {
        NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
        NSInteger lastLoadTime = [self placmentLastImprTime:placementID];
        if ((now - lastLoadTime) < adUnit.frequencryInterval) {
            lessThanInterval = YES;
            OMLogD(@" placement =%@ less than load interval %zd,%zd",placementID,(NSInteger)(now - lastLoadTime),adUnit.frequencryInterval);
        }
    }
    return lessThanInterval;
}


- (BOOL)allowLoadOnPlacement:(NSString*)placementID {
    BOOL allow = YES;
    if ([self overCapOnPlacement:placementID] || [self loadTimeLessThanIntervalOnPlacement:placementID]) {
        allow = NO;
    }
    return allow;
}



- (BOOL)overCapOnInstance:(NSString*)instanceID {
    BOOL overCap = NO;
    OMInstance *adInstance = [[OMConfig sharedInstance].instanceMap objectForKey:instanceID];
    if (adInstance && adInstance.frequencryCap > 0) {
        NSInteger imprCount = [self imprCountOnInstance:instanceID inHours:adInstance.frequencryUnit];
        if (imprCount >= adInstance.frequencryCap) {
            overCap = YES;
            [[OMEventManager sharedInstance]addEvent:INSTANCE_CAPPED extraData:@{@"iid":adInstance.instanceID}];
            OMLogD(@"instance =%@ over cap %zd,%zd",instanceID,imprCount,adInstance.frequencryCap);
        }
    }
    return overCap;
}

- (BOOL)loadTimeLessThanIntervalOnInstance:(NSString*)instanceID {
    BOOL lessThanInterval = NO;
    OMInstance *adInstance = [[OMConfig sharedInstance].instanceMap objectForKey:instanceID];
    if (adInstance.frequencryIntercal >0) {
        NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
        NSInteger lastLoadTime = [self instanceLastImprTime:instanceID];
        if ((now - lastLoadTime) < adInstance.frequencryIntercal) {
            lessThanInterval = YES;
            OMLogD(@"instance =%@ less than load interval %zd,%zd",instanceID,(NSInteger)(now - lastLoadTime),adInstance.frequencryIntercal);
        }
    }
    return lessThanInterval;
}

- (BOOL)allowLoadOnInstance:(NSString*)instanceID {
    BOOL allow = YES;
    if ([self overCapOnInstance:instanceID] || [self loadTimeLessThanIntervalOnInstance:instanceID]) {
        allow = NO;
    }
    return allow;
}

- (BOOL)overCapOnPlacement:(NSString*)placementID scene:(NSString*)sceneName {
    BOOL overCap = YES;//取不到广告位scene时YES
    OMScene *scene = [[OMConfig sharedInstance]getSceneWithSceneName:sceneName inAdUnit:placementID];
    if (scene) {
        overCap = NO;//取到广告位scene默认NO，再判断是否overcap
        if (scene && scene.frequencryCap > 0) {
            NSInteger imprCount = [self imprCountOnSceneID:scene.sceneID inHours:scene.frequencryUnit];
            if (imprCount >= scene.frequencryCap ) {
                overCap = YES;
                [[OMEventManager sharedInstance]addEvent:SCENE_CAPPED extraData:@{@"pid":placementID,@"scene":scene.sceneID}];
                OMLogD(@"scene =%@ over cap %zd,%zd",scene.sceneName,imprCount,scene.frequencryCap);
            }
        }

    }
    
    return overCap;
}

- (NSInteger)imprCountOnPlacment:(NSString*)placmentID inHours:(NSInteger)hourCount {
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSInteger start = now - hourCount *3600;
    NSInteger imprCount = 0;
    NSArray *records = [_placementImprMap objectForKey:placmentID];
    for (NSString *recordTime in records) {
        if ([recordTime integerValue] > start) {
            imprCount++;
        }
    }
    return imprCount;
}

- (NSInteger)todayimprCountOnPlacment:(NSString*)placmentID {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSInteger start = [[NSDate date]timeIntervalSinceDate:startDate];
    NSInteger imprCount = 0;
    NSArray *records = [_placementImprMap objectForKey:placmentID];
    for (NSString *recordTime in records) {
        if ([recordTime integerValue] > start) {
            imprCount++;
        }
    }
    return imprCount;
}

- (NSInteger)placmentLastImprTime:(NSString*)placmentID {
    NSInteger lastImprTime = 0;
    if ([_placementImprMap objectForKey:placmentID]) {
        NSArray *records = [_placementImprMap objectForKey:placmentID];
        if ([records count] > 0) {
            lastImprTime = [[records lastObject]integerValue];
        }
    }
    return lastImprTime;
}


- (NSInteger)imprCountOnInstance:(NSString*)instanceID inHours:(NSInteger)hourCount {
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSInteger start = now - hourCount *3600;
    NSInteger imprCount = 0;
    NSArray *records = [_instanceImprMap objectForKey:instanceID];
    for (NSString *recordTime in records) {
        if ([recordTime integerValue] > start) {
            imprCount++;
        }
    }
    return imprCount;
}


- (NSInteger)instanceLastImprTime:(NSString*)instanceID {
    NSInteger lastImprTime = 0;
    if ([_instanceImprMap objectForKey:instanceID]) {
        NSArray *records = [_instanceImprMap objectForKey:instanceID];
        if ([records count] > 0) {
            lastImprTime = [[records lastObject]integerValue];
        }
    }
    return lastImprTime;
}

- (NSInteger)imprCountOnSceneID:(NSString*)sceneID inHours:(NSInteger)hourCount {
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSInteger start = now - hourCount *3600;
    NSInteger imprCount = 0;
    NSArray *records = [_sceneImprMap objectForKey:sceneID];
    for (NSString *recordTime in records) {
        if ([recordTime integerValue] > start) {
            imprCount++;
        }
    }
    return imprCount;
}

@end
