// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMRequestType) {
    OMRequestTypeNormal,
    OMRequestTypeJsonGzipToJson,
};

typedef void(^requestCompletionHandler)(NSObject *_Nullable object,  NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface OMBaseRequest : NSObject

+ (void)getWithUrl:(NSString *)url type:(OMRequestType)requestType body:(NSData*)body completionHandler:(requestCompletionHandler)completionHandler;
+ (void)postWithUrl:(NSString *)url type:(OMRequestType)requestType body:(NSData*)body completionHandler:(requestCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
