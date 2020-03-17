// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"

typedef void(^OMMediationInitCompletionBlock)(NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OMAdnSDKInitState) {
    OMAdnSDKInitStateDefault = 0,
    OMAdnSDKInitStateInitializing = 1,
    OMAdnSDKInitStateInitialized = 2,
};

@interface OMMediations : NSObject

@property(nonatomic, strong)NSDictionary *adnNameMap;
@property(nonatomic, strong)NSDictionary *adnSdkClassMap;
@property (nonatomic, strong) NSMutableDictionary *adnSDKInitState;
@property(nonatomic, strong)NSDictionary *adNetworkInfo;

+ (BOOL)importAdnSDK:(OMAdNetwork)adnID;
+ (NSString*)adnName:(OMAdNetwork)adnID;
+ (void)validateIntegration;

+ (instancetype)sharedInstance;
- (void)initAdNetworkSDKWithId:(OMAdNetwork)adnID completionHandler:(OMMediationInitCompletionBlock)completionHandler;

- (BOOL)adnSDKInitialized:(OMAdNetwork)adnID;

@end

NS_ASSUME_NONNULL_END
