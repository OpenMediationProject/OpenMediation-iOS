// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#ifndef OMAdBasePrivate_h
#define OMAdBasePrivate_h

#import "OMAdBase.h"
#import "OpenMediationConstant.h"
#import "OMToolUmbrella.h"
#import "OMLoadFrequencryControl.h"
#import "OMCustomEventDelegate.h"
#import "OpenMediationAdFormats.h"
#import "OMBid.h"
#import "OMLoad.h"
#import "OMSmartLoad.h"
#import "OMScene.h"

typedef void(^hbRequestCompletionHandler)(NSArray *bidInstances);

@interface OMAdBase()<OMLoadDelegate,OMCustomEventDelegate,OMBidDelegate>
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) OpenMediationAdFormat adFormat;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, strong) NSMutableDictionary<NSString*,id> *instanceAdapters; // key instanceid, value adapter
@property (nonatomic, strong) NSMutableDictionary<NSString*,id> *didLoadAdObjects; //key instance, value ad
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSString*> *didLoadAdnName; //key instance, value adn name
@property (nonatomic, strong) OMLoad *adLoader;
@property (nonatomic, assign) OMLoadAction loadAction;
@property (nonatomic, assign) BOOL loadConfig;
@property (nonatomic, strong) NSString *showSceneID;
@property (nonatomic, assign) BOOL callLoad;//call load
@property (nonatomic, assign) BOOL replenishLoad;//call load
@property (nonatomic, assign) BOOL adAvailable;

@property (nonatomic, copy) NSString *wfReqId;
@property (nonatomic, assign) NSInteger abGroup; //0:"",1:A,2:B
@property (nonatomic, strong) NSDictionary *wfRule; //Waterfall rule data
@property (nonatomic, copy) NSDictionary *wfInsRevenueData; //Waterfall instance revenue data
@property (nonatomic, strong) NSMutableArray *wfInsList;//instance revenue data
@property (nonatomic, strong) NSArray *wfInsPriority;//waterfall instance priority;
//for bid
@property (nonatomic, strong) OMBid *bid;
@property (nonatomic, strong) NSMutableDictionary *wfAllBidResonses; //waterfall all bid responses(c2s && s2s)
@property (nonatomic, strong) NSMutableDictionary *loadedInstanceBidResponses; //loaded instance bid response

@property (nonatomic, strong) OMScene *scene;


- (instancetype)initWithPlacementID:(NSString*)placementID size:(CGSize)size;
- (instancetype)initWithPlacementID:(NSString*)placementID size:(CGSize)size rootViewController:(UIViewController*)rootViewController;
- (void)loadInstance:(NSString*)instanceID;
- (void)loadAd;
- (void)preload;
- (void)loadAd:(OpenMediationAdFormat)adFormat actionType:(OMLoadAction)action;
- (BOOL)isReady;
- (NSString*)checkInstanceIDWithAdapter:(id)adapter;
- (void)omDidChangedAvailable:(BOOL)available;

- (void)showInstance:(id)instanceID;
- (void)adshow:(id)instanceAdapter eventData:(NSDictionary*)eventData;
- (void)adShowFail:(id)instanceAdapter;
- (void)adClick:(id)instanceAdapter eventData:(NSDictionary*)eventData;
- (void)adVideoStart:(id)instanceAdapter;
- (void)adVideoComplete:(id)instanceAdapter;
- (void)adClose:(id)instanceAdapter;
- (void)adReceiveReward:(id)instanceAdapter;

- (void)addEvent:(NSInteger)eventID instance:(NSString*)instanceID extraData:data;
@end
#endif /* OMAdBasePrivate_h */
