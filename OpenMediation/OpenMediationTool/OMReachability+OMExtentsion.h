// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMReachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMReachability (OMExtentsion)

+ (BOOL)omIsHttpAgentOpen;
+ (BOOL)omIsVPNConnected;

@end

NS_ASSUME_NONNULL_END
