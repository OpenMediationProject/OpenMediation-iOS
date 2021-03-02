// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import "OMToolUmbrella.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMInstance : NSObject

@property (nonatomic, copy) NSString *unitID;
@property (nonatomic, copy) NSString *instanceID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) OMAdNetwork adnID;
@property (nonatomic, copy) NSString *adnPlacementID;
@property (nonatomic, assign) NSInteger frequencryCap;
@property (nonatomic, assign) NSInteger frequencryUnit;
@property (nonatomic, assign) NSInteger frequencryIntercal;
@property (nonatomic, assign) BOOL hb;  //headbidding
@property (nonatomic, assign) NSInteger hbt;    //headbidding maxtimeoutms
@property (nonatomic, copy) NSString *wfReqId;  //requestId;
@property (nonatomic, assign) NSInteger ruleId;  //ruleId;
@property (nonatomic,copy) NSString *ruleName;
@property (nonatomic, assign) NSInteger ruleType;  //ruleId;
@property (nonatomic,assign) NSInteger rulePriority;
@property (nonatomic, assign) NSInteger abGroup; //0:none,1:A,2:B
@property (nonatomic, assign) float revenue;
@property (nonatomic, assign) NSInteger revenuePrecision; //0:undisclosed,1:exact,2:estimated,3:defined
@property (nonatomic, assign) NSInteger instancePriority;
@property (nonatomic, assign) NSInteger realInstancePriority;


- (instancetype)initWithUnitID:(NSString *)unitID instanceData:(NSDictionary *)instanceData;


@end

NS_ASSUME_NONNULL_END
