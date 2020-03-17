// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OMLoadFrequencryControl : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSString*,NSArray*> *placementImprMap;
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSArray*> *instanceImprMap;
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSArray*> *sceneImprMap;

+ (instancetype)sharedInstance;
- (void)checkOldImprRecord;
- (void)recordImprOnPlacement:(NSString*)placementID;
- (void)recordImprOnInstance:(NSString*)instanceID;
- (BOOL)allowLoadOnPlacement:(NSString*)placementID;
- (BOOL)allowLoadOnInstance:(NSString*)instanceID;
- (NSInteger)todayimprCountOnPlacment:(NSString*)placmentID;
- (void)recordImprOnPlacement:(NSString*)placementID sceneID:(NSString*)sceneName;
- (BOOL)overCapOnPlacement:(NSString*)placementID scene:(NSString*)sceneName;
@end

NS_ASSUME_NONNULL_END
