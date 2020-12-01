// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>
#import "OMCrossPromotionDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface OMCrossPromotionDownloadManager : NSObject

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) dispatch_queue_t downloadQueue;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray *queuedTasks;
@property (nonatomic, strong) NSMutableArray *duplicateTasks;
@property (nonatomic, strong) NSMutableDictionary *activeTasks;

+ (instancetype)sharedInstance;
-(void)downloadUrl:(NSString *)url extra:(NSDictionary*)extraValue completion:(downloadCompletionHandler)completion;
-(void)downloadUrl:(NSString *)url extra:(NSDictionary*)extraValue toPath:(NSString *)filePath completion:(downloadCompletionHandler)completion;
-(void)cancelDownloadTask:(NSString *)url;
-(void)cancelAllTasks;

@end

NS_ASSUME_NONNULL_END
