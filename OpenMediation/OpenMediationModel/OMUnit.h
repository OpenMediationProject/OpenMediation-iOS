// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationAdFormats.h"
#import "OMInstance.h"
#import "OMScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMUnit : NSObject

@property (nonatomic, strong) NSDictionary *unitModel;
@property (nonatomic, copy) NSString *unitID;
@property (nonatomic, assign) OpenMediationAdFormat adFormat;
@property (nonatomic, assign) NSInteger main;
@property (nonatomic, assign) NSInteger frequencryCap;
@property (nonatomic, assign) NSInteger frequencryUnit;
@property (nonatomic, assign) NSInteger frequencryInterval;
@property (nonatomic, assign) NSInteger batchSize;
@property (nonatomic, assign) NSInteger batchTimeout;
@property (nonatomic, assign) NSInteger fanout;
@property (nonatomic, assign) NSInteger cacheCount;
@property (nonatomic, assign) NSInteger cacheReloadTime;
@property (nonatomic, assign) NSInteger waterfallReloadTime;
@property (nonatomic, strong) NSMutableArray *instanceList;
@property (nonatomic, strong) NSMutableDictionary *instanceMap;
@property (nonatomic, strong) NSMutableArray *sceneList;
@property (nonatomic, strong) NSMutableDictionary *sceneMapKeyId;
@property (nonatomic, strong) NSMutableDictionary *sceneMapKeyName;
@property (nonatomic, strong) OMScene *defaultScene;
@property (nonatomic, assign) NSInteger hb;

- (instancetype)initWithUnitData:(NSDictionary*)unitData;
- (OMScene*)getSceneById:(NSString*)sceneID;
- (OMScene*)getSceneByName:(NSString*)name;
- (NSDictionary*)modelData;

@end

NS_ASSUME_NONNULL_END
