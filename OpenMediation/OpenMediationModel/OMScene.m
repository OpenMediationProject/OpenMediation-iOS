// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMScene.h"
#import "OpenMediationConstant.h"
#import "OMToolUmbrella.h"
@implementation OMScene

- (instancetype)initWithUnitID:(NSString *)unitID sceneData:(NSDictionary *)sceneData {
    if (self = [super init]) {
        _unitID = unitID;
        _sceneID = [NSString stringWithFormat:@"%@",sceneData[@"id"]];
        _sceneName = OM_SAFE_STRING(sceneData[@"n"]);
        _defaultScene = [sceneData[@"isd"]boolValue];
        _frequencryCap = [[sceneData objectForKey:@"fc"]integerValue];
        _frequencryUnit = [[sceneData objectForKey:@"fu"]integerValue];
    }
    return self;
}

@end
