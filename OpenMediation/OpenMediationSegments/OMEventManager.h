// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

#define INIT_START                  100

#define INIT_COMPLETE               101

#define LOAD                        102

#define DESTROY                     103

#define INIT_FAILED                 104


#define REFRESH_INTERVAL            110

#define ATTEMPT_TO_BRING_NEW_FEED   111

#define NO_MORE_OFFERS              112

#define AVAILABLE_FROM_CACHE        113

#define LOAD_BLOCKED                114

#define APP_PAUSE                   115

#define APP_RESUME                  116

#define APP_TERMINATE               117

/********************************InstanceLoad********************************/

#define INSTANCE_NOT_FOUND          200

#define INSTANCE_INIT_START         201

#define INSTANCE_INIT_FAILED        202

#define INSTANCE_INIT_SUCCESS       203

#define INSTANCE_DESTROY            204

#define INSTANCE_LOAD               205

#define INSTANCE_LOAD_ERROR         206

#define INSTANCE_LOAD_SUCCESS       208

#define INSTANCE_LOAD_TIMEOUT       211


#define INSTANCE_BID_REQUEST        270

#define INSTANCE_BID_RESPONSE       271

#define INSTANCE_BID_FAILED         272

#define INSTANCE_BID_WIN            273

#define INSTANCE_BID_LOSE           274

#define INSTANCE_PAYLOAD_REQUEST    275

#define INSTANCE_PAYLOAD_SUCCESS    276

#define INSTANCE_PAYLOAD_FAIL       277

/********************************InstanceEvent********************************/

#define INSTANCE_CLOSED             301

#define INSTANCE_SHOW               302

#define INSTANCE_SHOW_FAILED        303

#define INSTANCE_SHOW_SUCCESS       304

#define INSTANCE_CLICKED            306

#define INSTANCE_VIDEO_START        307

#define INSTANCE_VIDEO_COMPLETED    309

#define INSTANCE_VIDEO_REWARDED     310

#define SCENE_NOT_FOUND             315


/********************************Capped********************************/


#define SCENE_CAPPED                400

#define INSTANCE_CAPPED             401

#define PLACEMENT_CAPPED            402

#define SESSION_CAPPED              403


/********************************Api********************************/

#define CALLED_LOAD                 500

#define CALLED_SHOW                 501

#define CALLED_IS_READY_TRUE        502

#define CALLED_IS_READY_FALSE       503

#define CALLED_IS_CAPPED_TRUE       504

#define CALLED_IS_CAPPED_FALSE      505



#define CALLBACK_LOAD_SUCCESS       600

#define CALLBACK_LOAD_ERROR         601

#define CALLBACK_SHOW_FAILED        602

#define CALLBACK_CLICK              603

#define CALLBACK_PRESENT_SCREEN     605

#define CALLBACK_DISMISS_SCREEN     606

#define CALLBACK_REWARDED           608 


NS_ASSUME_NONNULL_BEGIN

@interface OMEventManager : NSObject

@property (nonatomic, strong) NSString *uploadUrl;
@property (nonatomic, assign) NSInteger eventPackageNumber;
@property (nonatomic, assign) NSInteger uploadMaxInterval;
@property (nonatomic, strong) NSArray *uploadEventIds;
@property (nonatomic, strong) NSArray *realTimeEventIds;
@property (nonatomic, strong) NSMutableArray *eventList;
@property (nonatomic, strong) NSMutableDictionary *eventTimeStamp;
@property (nonatomic, strong) NSString *eventDataPath;
@property (nonatomic, assign) BOOL posting;

+ (instancetype)sharedInstance;
- (void)initSuccess;
- (void)loadEventConfig:(NSDictionary*)eventConfig;
- (void)addEvent:(NSInteger)eventID extraData:(NSDictionary*_Nullable)data;

@end

NS_ASSUME_NONNULL_END
