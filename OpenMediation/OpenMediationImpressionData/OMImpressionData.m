// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMImpressionData.h"
#import "OMUnit.h"
#import "OMUserData.h"
#import "OMConfig.h"
#import "OMUserData.h"

@implementation OMImpressionData
- (instancetype)initWithUnit:(OMUnit*)unit  instance:(OMInstance*)instance scene:(OMScene*)scene {
    if (self = [super init]) {
        _impressionId = [NSString stringWithFormat:@"%@_%@",OM_SAFE_STRING(instance.wfReqId),instance.instanceID];
        
        _placementId = unit.unitID;
        
        _placementName = unit.name;
        
        NSArray * adTypeNames = @[@"Banner",@"Native",@"Rewarded Video",@"Interstitial",@"Splash",@"Cross Promotion"];
        NSInteger type = log(unit.adFormat)/log(2);

        _placementAdType = (type >=0 && type < adTypeNames.count)? adTypeNames[type] : @"";
        
        _sceneName = OM_SAFE_STRING(scene.sceneName);
        
        _ruleId = [NSString stringWithFormat:@"%zd",instance.ruleId];
        
        _ruleName = OM_SAFE_STRING(instance.ruleName);
        
        _ruleType = [NSNumber numberWithInteger:instance.ruleType];
        
        _rulePriority = [NSNumber numberWithInteger:instance.rulePriority];
        
        NSArray *abGroupName = @[@"",@"A",@"B"];
        _abGroup = (instance.abGroup >=0 && instance.abGroup< abGroupName.count)?abGroupName[instance.abGroup]:@"";

        _instanceId = instance.instanceID;
        
        _instanceName = instance.name;
        
        _instancePriority = [NSNumber numberWithInteger:instance.instancePriority];
        
        _adNetworkId = [NSString stringWithFormat:@"%zd",instance.adnID];
        
        _adNetworkName = OM_SAFE_STRING([[OMConfig sharedInstance]adnNickName:instance.adnID]);
        
        _adNetworkUnitId = instance.adnPlacementID;
        
        NSArray *precisions = @[@"undisclosed",@"exact",@"estimated",@"defined"];
        
        _precision = (instance.revenuePrecision >=0 && instance.revenuePrecision < precisions.count)? precisions[instance.revenuePrecision] : @"";
        
        _currency = @"USD";
        
        _revenue = [NSNumber numberWithDouble:instance.revenue];
        
        _lifeTimeValue = [NSNumber numberWithDouble:[OMUserData sharedInstance].lifeTimeValue];
        
        _userID = [OMUserData sharedInstance].customUserID;

    }
    return self;
}
@end
