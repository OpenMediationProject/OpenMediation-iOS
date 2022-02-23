// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationAdFormats.h"
#import "OMBid.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, OMLoadAction) {
    OMLoadActionInit =  1,
    OMLoadActionTimer,
    OMLoadActionCloseEvent,
    OMLoadActionManualLoad,
};


typedef NS_ENUM(NSInteger, OMInstanceLoadState) {
    OMInstanceLoadStateWait = 0,
    OMInstanceLoadStateLoading,
    OMInstanceLoadStateFail,
    OMInstanceLoadStateTimeout,
    OMInstanceLoadStateSuccess,
    OMInstanceLoadStateCallShow,
};

@protocol OMLoadDelegate <NSObject>

- (void)omLoadRequestWithAction:(OMLoadAction)action;
- (void)omLoadInstance:(NSString*)instanceID;
- (void)omLoadInstanceTimeout:(NSString *)instanceID;
- (void)omLoadFill:(NSString*)instanceID;
- (void)omLoadOptimalFill:(NSString*)instanceID;
- (void)omLoadNoFill;
- (void)omLoadEnd;
- (void)omLoadAddEvent:(NSInteger)eventID extraData:data;
- (BOOL)omCheckInstanceReady:(NSString*)instanceID;
@end

@interface OMLoad : NSObject

@property (nonatomic, strong) NSArray *actionName;
@property (nonatomic, strong) NSArray *stateName;

@property (nonatomic, strong) NSString *pid;
@property (nonatomic, assign) OpenMediationAdFormat adFormat;
@property (nonatomic, assign) OMLoadAction loadAction;

@property (nonatomic, assign) NSInteger timeoutSecond;
@property (nonatomic, strong) NSArray *priorityList;
@property (nonatomic, strong) NSMutableDictionary *instanceLoadState;
@property (nonatomic, strong) NSArray *loadGroups;
@property (nonatomic, copy) NSString *optimalFillInstance;
@property (nonatomic, assign) BOOL notifyLoadResult;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL wfLoading;
@property (nonatomic, assign) BOOL adShow;

@property (nonatomic, weak)   id<OMLoadDelegate> delegate;


- (instancetype)initWithPid:(NSString*)pid adFormat:(OpenMediationAdFormat)format;
- (void)loadWithAction:(OMLoadAction)action;
- (void)loadWithPriority:(NSArray *)insPriority;
- (BOOL)isReady;
- (void)resetContext; //for test

- (BOOL)isAdAvailable;

- (void)requestWaterfallWithAction:(OMLoadAction)action;
- (void)groupByBatchSize:(NSInteger)batchSize;
- (void)loadGroupInstane:(NSInteger)groupIndex;
- (void)saveInstanceLoadState:(NSString*)instanceID state:(OMInstanceLoadState)loadState;
- (void)checkOptimalInstance;
- (void)notifyOptimalFill;
- (void)notifyFill:(NSString*)instanceID;
- (void)notifyNoFill;
- (void)notifyLoadEnd;
- (void)addEvent:(NSInteger)eventID extraData:data;

@end

NS_ASSUME_NONNULL_END
