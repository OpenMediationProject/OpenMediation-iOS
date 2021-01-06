// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMAdSingletonInterface.h"
#import "OMScene.h"
NS_ASSUME_NONNULL_BEGIN

@interface OMAdSingletonInterface()
@property (nonatomic, strong) NSMutableDictionary *loadAdInstanceDic;
@property (nonatomic, strong) NSHashTable *delegates;
@property (nonatomic, strong) NSHashTable *mediationDelegates;
@property (nonatomic, strong) NSMapTable *placementDelegateMap;
@property (nonatomic, strong) NSString *adClassName;
- (instancetype)initWithAdClassName:(NSString*)adClassName adFormat:(OpenMediationAdFormat)adFormat;
- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)addMediationDelegate:(id)delegate;
- (void)removeMediationDelegate:(id)delegate;
- (void)registerDelegate:(NSString*)placementID delegate:(id)delegate;
- (void)preload;
- (void)preloadPlacementID:(NSString*)pid;
- (void)loadAd;
- (void)loadWithPlacementID:(NSString*)placementID;
- (BOOL)isReady;
- (BOOL)placementIsReady:(NSString*)placementID;
- (BOOL)isCappedForScene:(NSString *)sceneName;
- (void)addAdEvent:(NSInteger)eventID placementID:(NSString*)placementID scene:(OMScene*_Nullable)scene extraMsg:(NSString*_Nullable)message;
@end

NS_ASSUME_NONNULL_END
