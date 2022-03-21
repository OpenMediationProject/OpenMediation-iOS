// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMUnityAdapter.h"
#import "OMUnityRouter.h"

static OMUnityAdapter * _instance = nil;

@implementation OMUnityAdapter

+ (NSString*)adapterVerison {
    return UnityAdapterVersion;
}

+ (void)setConsent:(BOOL)consent {
    
    Class metaDataClass = NSClassFromString(@"UADSMetaData");
    if (metaDataClass && [metaDataClass instancesRespondToSelector:@selector(set:value:)] && [metaDataClass instancesRespondToSelector:@selector(commit)]) {
        UADSMetaData *gdprConsentMetaData = [[metaDataClass alloc] init];
        [gdprConsentMetaData set:@"gdpr.consent" value:[NSNumber numberWithBool:consent]];
        [gdprConsentMetaData commit];
    }
}

+ (void)setUSPrivacyLimit:(BOOL)privacyLimit {
    Class metaDataClass = NSClassFromString(@"UADSMetaData");
    if (metaDataClass && [metaDataClass instancesRespondToSelector:@selector(set:value:)] && [metaDataClass instancesRespondToSelector:@selector(commit)]) {
        UADSMetaData *privacyConsentMetaData = [[metaDataClass alloc] init];
        [privacyConsentMetaData set:@"privacy.consent" value:[NSNumber numberWithBool:!privacyLimit]];
        [privacyConsentMetaData commit];
    }
}

+ (void)setUserAgeRestricted:(BOOL)restricted {
    Class metaDataClass = NSClassFromString(@"UADSMetaData");
    if (metaDataClass && [metaDataClass instancesRespondToSelector:@selector(set:value:)] && [metaDataClass instancesRespondToSelector:@selector(commit)]) {
        UADSMetaData *privacyConsentMetaData = [[metaDataClass alloc] init];
        [privacyConsentMetaData set:@"user.nonbehavioral" value:[NSNumber numberWithBool:!restricted]];
        [privacyConsentMetaData commit];
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {

    Class unityClass = NSClassFromString(@"UnityAds");
    if (!unityClass) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.unityadapter"
                                                    code:404
                                                userInfo:@{NSLocalizedDescriptionKey:@"Unity SDK not found"}];
        completionHandler(error);
        return;
    }
    
    NSString *key = [configuration objectForKey:@"appKey"];
    if (unityClass && [unityClass respondsToSelector:@selector(initialize:initializationDelegate:)] && [key length]>0) {
        [OMUnityAdapter sharedInstance].initBlock = completionHandler;
        [unityClass initialize:key initializationDelegate:[OMUnityAdapter sharedInstance]];
        completionHandler(nil);
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"com.mediation.unityadapter"
                                                    code:400
                                                userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key."}];
        completionHandler(error);
    }

}

- (void)initializationComplete {
    if (self.initBlock) {
        self.initBlock(nil);
        self.initBlock = nil;
    }
}

- (void)initializationFailed:(UnityAdsInitializationError)error withMessage:(NSString *)message {
    if (self.initBlock) {
        self.initBlock(error?[NSError errorWithDomain:@"om.mediation.heliumadapter" code:error userInfo:@{NSLocalizedDescriptionKey:message}]:nil);
        self.initBlock = nil;
    }
}

+ (void)setLogEnable:(BOOL)logEnable {
    Class unityClass = NSClassFromString(@"UnityAds");
    if (unityClass && [unityClass respondsToSelector:@selector(setDebugMode:)]) {
        [unityClass setDebugMode:logEnable];
    }
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
