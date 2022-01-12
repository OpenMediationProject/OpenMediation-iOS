// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInstance.h"

@implementation OMInstance

-(instancetype)initWithUnitID:(NSString *)unitID instanceData:(NSDictionary *)instanceData {
    if (self = [super init]) {
        _unitID = unitID;
        _instanceID = [NSString stringWithFormat:@"%@",[instanceData objectForKey:@"id"]];
        _wfReqId = @"";
        _ruleName = @"";
        [self updateWithInstanceData:instanceData];
    }
    return self;
}

- (void)updateWithInstanceData:(NSDictionary*)instanceData {
    _name = OM_SAFE_STRING([instanceData objectForKey:@"n"]);
    _adnID = [[instanceData objectForKey:@"m"] integerValue];
    _adnPlacementID = OM_SAFE_STRING([instanceData objectForKey:@"k"]);
    _frequencryCap = [[instanceData objectForKey:@"fc"] integerValue];
    _frequencryUnit = [[instanceData objectForKey:@"fu"] integerValue];
    _frequencryIntercal = [[instanceData objectForKey:@"fi"] integerValue];
    _hb = [[instanceData objectForKey:@"hb"]boolValue];
    _hbt = [[instanceData objectForKey:@"hbt"]integerValue];
}
@end
