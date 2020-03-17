// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMUnit.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMInitState) {
    OMInitStateDefault = 0,
    OMInitStateInitializing = 1,
    OMInitStateInitialized = 2,
};

@interface OMConfig : NSObject

@property(nonatomic, strong) NSDictionary *adFormats;
@property(nonatomic, assign) OMInitState initState;
@property(nonatomic, assign) BOOL initSuccess;

@property(nonatomic, copy) NSString *appKey;

@property(nonatomic, assign) BOOL openDebug;
@property(nonatomic, copy) NSString *clUrl;
@property(nonatomic, copy) NSString *lrUrl;
@property(nonatomic, copy) NSString *icUrl;
@property(nonatomic, copy) NSString *iapUrl;
@property(nonatomic, copy) NSString *erUrl;
@property(nonatomic, copy) NSString *hbUrl;

@property(nonatomic, strong) NSMutableDictionary *adnNameMap;
@property(nonatomic, strong) NSMutableDictionary *adnAppkeyMap;
@property(nonatomic, strong) NSMutableArray *adUnitList;
@property(nonatomic, strong) NSMutableDictionary *adUnitMap;
@property(nonatomic, strong) NSMutableDictionary *instanceMap;
@property(nonatomic, strong) NSMutableDictionary *adnPlacementMap;
@property(nonatomic, strong)NSDictionary *configData;
@property(nonatomic, assign)BOOL clickOpenAppStore;

@property(nonatomic, assign)BOOL consent;//gdpr



+ (instancetype)sharedInstance;

- (void)loadCongifData:(NSDictionary *)configData;

- (void)loadApi:(NSDictionary*)apiDic;

- (void)loadMediation:(NSArray *)mediationData;

- (void)loadAdUnits:(NSArray *)adUnits;

- (NSString *)adnName:(OMAdNetwork)adnID;

- (NSString *)adnAppKey:(OMAdNetwork)adnID;

- (NSArray *)allInstanceInAdUnit:(NSString*)unitID;

- (OMInstance *)getInstanceByinstanceID:(NSString*)instanceID;

- (NSString *)getInstanceAdnPlacementID:(NSString*)instanceID;

- (OMAdNetwork)getInstanceAdNetwork:(NSString*)instanceID;

- (OMScene *)getSceneWithSceneID:(NSString*)sceneID inAdUnit:(NSString*)unitID;

- (OMScene *)getSceneWithSceneName:(NSString*)sceneName inAdUnit:(NSString*)unitID;

- (NSString *)getSceneIDWithSceneName:(NSString*)sceneName inAdUnit:(NSString*)unitID;

- (BOOL)configContainAdUnit:(NSString*)unitID;

- (BOOL)isValidAdUnitId:(NSString*)unitID forAdFormat:(OpenMediationAdFormat)adFormat;

- (NSArray*)adFormatUnits:(OpenMediationAdFormat)adFormat;

- (NSString*)defaultUnitIDForAdFormat:(OpenMediationAdFormat)adFormat;

- (OpenMediationAdFormat)adUnitFormat:(NSString*)unitID;

- (NSArray *)adnPlacements:(OMAdNetwork)adnID;

- (NSString *)checkinstanceIDWithAdNetwork:(OMAdNetwork)adnID adnPlacementID:(NSString *)placementID;

- (NSString *)checkAdUnitIdWithAdNetwork:(OMAdNetwork)adnID adnPlacementID:(NSString *)placementID;

- (NSString *)adFormatName:(OpenMediationAdFormat)adFormat;

@end

NS_ASSUME_NONNULL_END
