// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

typedef void(^configureCompletionHandler)(NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface OMInitRequest : NSObject

+(void)configureWithAppKey:(NSString *)appKey baseHost:(NSString*)host completionHandler:(configureCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
