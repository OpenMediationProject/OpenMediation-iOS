// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import "OMToolUmbrella.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMInstance : NSObject

@property(nonatomic, copy)NSString *unitID;
@property(nonatomic, copy)NSString *instanceID;
@property(nonatomic, assign)OMAdNetwork adnID;
@property(nonatomic, copy)NSString *adnPlacementID;
@property(nonatomic, assign)NSInteger frequencryCap;
@property(nonatomic, assign)NSInteger frequencryUnit;
@property(nonatomic, assign)NSInteger frequencryIntercal;
@property (nonatomic, assign) BOOL hb;//headbidding
@property (nonatomic, assign) NSInteger hbt;//headbidding maxtimeoutms
- (instancetype)initWithUnitID:(NSString *)unitID instanceData:(NSDictionary *)instanceData;


@end

NS_ASSUME_NONNULL_END
