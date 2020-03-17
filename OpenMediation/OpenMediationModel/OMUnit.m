// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnit.h"
#import "OMEventManager.h"

@implementation OMUnit
- (instancetype)initWithUnitData:(NSDictionary*)unitData {
    if (self = [super init]) {
        _unitModel = unitData;
        _unitID = [NSString stringWithFormat:@"%@",[unitData objectForKey:@"id"]];
        _adFormat = (1<<[[unitData objectForKey:@"t"]integerValue]);
        _main = [[unitData objectForKey:@"main"]integerValue];
        _frequencryCap = [[unitData objectForKey:@"fc"]integerValue];
        _frequencryUnit = [[unitData objectForKey:@"fu"]integerValue];
        _frequencryInterval = [[unitData objectForKey:@"fi"]integerValue];
        _batchSize = [[unitData objectForKey:@"bs"]integerValue];
        _batchTimeout = [[unitData objectForKey:@"pt"]integerValue];
        _fanout = [[unitData objectForKey:@"fo"]boolValue];
        _cacheCount = [[unitData objectForKey:@"cs"]integerValue];
        _cacheReloadTime = [[unitData objectForKey:@"rf"]integerValue];
        _waterfallReloadTime = [[unitData objectForKey:@"rlw"]integerValue];
        _hb = [[unitData objectForKey:@"hb"] integerValue];
        _instanceList = [NSMutableArray array];
        _instanceMap = [NSMutableDictionary dictionary];
        NSArray *instances = [unitData objectForKey:@"ins"];
        if (instances && [instances isKindOfClass:[NSArray class]] && [instances count]>0 ) {
            for (NSDictionary *unitData in instances) {
                OMInstance *instance = [[OMInstance alloc]initWithUnitID:_unitID instanceData:unitData];
                [_instanceList addObject:instance];
                [_instanceMap setObject:instance forKey:instance.instanceID];
            }
        }
        _sceneList = [NSMutableArray array];
        _sceneMapKeyId = [NSMutableDictionary dictionary];
        _sceneMapKeyName = [NSMutableDictionary dictionary];
        NSArray *scenes = [unitData objectForKey:@"scenes"];
        if (scenes && [scenes isKindOfClass:[NSArray class]] && [scenes count] > 0) {
            for (NSDictionary *sceneDic in scenes) {
                OMScene *scene = [[OMScene alloc] initWithUnitID:_unitID sceneData:sceneDic];
                [_sceneList addObject:scene];
                [_sceneMapKeyId setObject:scene forKey:scene.sceneID];
                [_sceneMapKeyName setObject:scene forKey:scene.sceneName];
                if (scene.defaultScene) {
                    self.defaultScene = scene;
                }
            }
        }
    }
    return self;
}

- (OMScene*)getSceneById:(NSString*)sceneID {
    OMScene *scene = nil;
    if (!OM_STR_EMPTY(sceneID) && [_sceneMapKeyId objectForKey:sceneID]) {
        scene = [_sceneMapKeyId objectForKey:sceneID];
    }
    return scene;
}
- (OMScene*)getSceneByName:(NSString*)name {
    OMScene *scene = nil;
    if (!OM_STR_EMPTY(name) && [_sceneMapKeyName objectForKey:name]) {
        scene = [_sceneMapKeyName objectForKey:name];
    } else {
        if (_defaultScene) {
            scene = _defaultScene;
        } else {
            OMLogD(@"ad unit %@ no default scene", _unitID);
        }
        [[OMEventManager sharedInstance]addEvent:SCENE_NOT_FOUND extraData:@{@"pid":_unitID,@"msg":OM_SAFE_STRING(name)}];
    }
    return scene;
}
- (NSDictionary*)modelData {
    NSDictionary *model = [NSDictionary dictionary];
    if (_unitModel && [_unitModel isKindOfClass:[NSDictionary class]]) {
        model = _unitModel;
    }
    return model;
}

@end
