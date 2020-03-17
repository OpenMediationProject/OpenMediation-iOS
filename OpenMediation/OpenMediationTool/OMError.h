// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OpenMediationConstant.h"
#import "NSError+OMExtension.h"


typedef NS_ENUM(NSInteger, OMErrorModule) {
    OMErrorModuleInit = 0,
    OMErrorModuleLoad = 1,
    OMErrorModuleShow = 2,
};

typedef NS_ENUM(NSInteger, OMErrorCode) {
    OMErrorInitAppKeyEmpty = 10,//init
    OMErrorInitNetworkError,
    OMErrorInitServerError,
    OMErrorInitAppKeyNotFound,
    
    
    OMErrorLoadInitFailed = 20,//placement load
    OMErrorLoadGDPRRefuse,
    OMErrorLoadPlacementEmpty,
    OMErrorLoadPlacementNotFound,
    OMErrorLoadPlacementAdTypeIncorrect,
    OMErrorLoadFrequencry,
    OMErrorLoadNetworkError,
    OMErrorLoadServerError,
    OMErrorLoadEmptyInstance,
    OMErrorLoadWaterfallFail,
    
    OMErrorLoadInstanceNotFound = 30,//instance load
    OMErrorLoadInstanceLoadFrequencry,
    OMErrorLoadInstanceSDKNotFound,
    OMErrorLoadInstanceInitKeyEmpty,
    OMErrorLoadInstanceInitFailed,
    OMErrorLoadInstanceLoadFail,
    
    OMErrorShowPlacementEmpty = 40,//placement load
    OMErrorShowPlacementNotFound,
    OMErrorShowPlacementAdFormatIncorrect,
    OMErrorShowNotInitialized,
    OMErrorShowFailNotReady,
    OMErrorShowFailSceneCapped,
    OMErrorShowAdError,
};

NS_ASSUME_NONNULL_BEGIN

@interface OMError : NSObject

+ (NSError*)omRequestError:(OMErrorModule)module error:(NSError*)requestError;
+ (NSError*)omErrorWithCode:(OMErrorCode)code;
@end

NS_ASSUME_NONNULL_END
