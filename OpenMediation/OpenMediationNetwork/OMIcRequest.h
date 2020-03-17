// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMIcRequest : NSObject

+ (void)postWithPid:(NSString *)pid
 instanceID:(NSString *)instanceID
   adnID:(OMAdNetwork)adnID
    sceneID:(NSString *)sceneID
extraParams:(NSString*)extraParams;

@end

NS_ASSUME_NONNULL_END
