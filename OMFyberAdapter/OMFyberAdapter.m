// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMFyberAdapter.h"

static OMFyberAdapter *_instance = nil;
static dispatch_queue_t sIASDKInitSyncQueue = nil;

#pragma mark - consts
NSString * const kIASDKOMAdapterAppIDKey = @"appKey";
NSString * const kIASDKOMAdapterErrorDomain = @"com.om.IASDKAdapter";

@implementation OMFyberAdapter

+ (NSString*)adapterVerison {
    return FyberAdapterVersion;
}

+ (void)initialize {
    static BOOL initialised = NO;

    if ((self == OMFyberAdapter.self) && !initialised) { // invoke only once per application runtime (and not in subclasses);
        initialised = YES;

        sIASDKInitSyncQueue = dispatch_queue_create("com.Inneractive.mediation.openmediation.init.syncQueue", DISPATCH_QUEUE_SERIAL);
    }
}

+ (void)initSDKWithConfiguration:(NSDictionary *)configuration completionHandler:(OMMediationAdapterInitCompletionBlock)completionHandler {
    NSError *errorIfHas = nil;
    NSString *appID = configuration[kIASDKOMAdapterAppIDKey];
    Class InnerActiveClass = NSClassFromString(@"IASDKCore");
    if (appID.length) {
        if (InnerActiveClass && [InnerActiveClass respondsToSelector:@selector(sharedInstance)] && [[InnerActiveClass sharedInstance] respondsToSelector:@selector(appID)]) {
            dispatch_async(sIASDKInitSyncQueue, ^{
                NSString *currentAppId = (NSString *)[[InnerActiveClass sharedInstance] performSelector:@selector(appID)];
                if (![currentAppId isEqualToString:appID]) {
                    [[InnerActiveClass sharedInstance] initWithAppID:appID];
                }
            });

//            [self.class setCachedInitializationParameters:configuration];
        }
        else {
            //TODO: check the error code representation
            errorIfHas = [NSError errorWithDomain:kIASDKOMAdapterErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey:@"Failed,check init method and key"}];
        }
    }
    else {
        errorIfHas = [NSError errorWithDomain:kIASDKOMAdapterErrorDomain code:400 userInfo:@{NSLocalizedDescriptionKey:@"The VAMP SDK mandatory param appID is missing"}];
    }

    if (completionHandler) {
        completionHandler(errorIfHas);
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
