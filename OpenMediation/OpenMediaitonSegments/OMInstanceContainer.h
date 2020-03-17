// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^mInstanceInitBlock)(void);

@interface OMInstanceContainer : NSObject
@property (nonatomic, strong) NSMutableDictionary *instanceMap;
@property (nonatomic, strong) NSMutableDictionary *placementCacheMap;
+ (instancetype)sharedInstance;
- (id)getInstance:(NSString*)instanceID block:(mInstanceInitBlock)mInstanceInitBlock;
- (void)removeImpressionInstance:(NSString*)instanceID;
@end

NS_ASSUME_NONNULL_END
