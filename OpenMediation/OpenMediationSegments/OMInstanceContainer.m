// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMInstanceContainer.h"
static OMInstanceContainer * _instance = nil;

@implementation OMInstanceContainer
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if ([super init]) {
        _instanceMap = [NSMutableDictionary dictionary];
        _placementCacheMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)getInstance:(NSString*)instanceID block:(mInstanceInitBlock)mInstanceInitBlock {
    id instance = [_instanceMap objectForKey:instanceID];
    if (!instance) {
        instance = mInstanceInitBlock();
        [_instanceMap setObject:instance forKey:instanceID];
    }
    return instance;
}

- (void)removeImpressionInstance:(NSString*)instanceID {
    if (instanceID) {
        [_instanceMap removeObjectForKey:instanceID];
    }
}

@end
