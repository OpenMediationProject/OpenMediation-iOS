// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionDownloadManager.h"
#import "OMToolUmbrella.h"

#define kFGDwonloadMaxTaskCount 3

static OMCrossPromotionDownloadManager * _instance = nil;

@implementation OMCrossPromotionDownloadManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


-(instancetype)init {
    if(self=[super init]) {
        _activeTasks = [NSMutableDictionary dictionary];
        _queuedTasks = [NSMutableArray array];
        _duplicateTasks = [NSMutableArray array];
        self.operationQueue = [[NSOperationQueue alloc]init];
        self.operationQueue.maxConcurrentOperationCount = 1;
        self.downloadQueue = dispatch_queue_create("com.om.download", DISPATCH_QUEUE_SERIAL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskDidFinishDownload:) name:OMCrossPromotionTaskFinishNotification object:nil];
        
    }
    return self;
}

-(void)downloadUrl:(NSString *)url extra:(NSDictionary*)extraValue completion:(downloadCompletionHandler)completion {
    NSString *urlCachePath = [NSString omUrlCachePath:url];
    [self downloadUrl:url extra:extraValue toPath:urlCachePath completion:completion];
}

-(void)downloadUrl:(NSString *)url extra:(NSDictionary*)extraValue toPath:(NSString *)filePath completion:(downloadCompletionHandler)completion {
    if(!OM_STR_EMPTY(url) && !OM_STR_EMPTY(filePath) && completion) {
        @synchronized (_queuedTasks) {
                NSDictionary *dict=@{@"url":url,
                                     @"filePath":filePath,
                                     @"extra":extraValue,
                                     @"completion":completion};
                [_queuedTasks addObject:dict];
            }
        [self runQueuedTask];
    }

}

-(void)cancelDownloadTask:(NSString *)url {
    if(!OM_STR_EMPTY(url)) {
        OMCrossPromotionDownloader *downloader=[_activeTasks objectForKey:[url omMd5]];
        if(downloader) {
            [downloader cancel];
        }
        @synchronized (_activeTasks) {
            [_activeTasks removeObjectForKey:[url omMd5]];
        }
        [self runQueuedTask];
    }
}

-(void)cancelAllTasks {
    @synchronized(_activeTasks) {
        NSMutableArray *keys = [NSMutableArray array];
        [_activeTasks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            OMCrossPromotionDownloader *downloader=obj;
            [downloader cancel];
            [keys addObject:key];
        }];
        [_activeTasks removeObjectsForKeys:keys];
    }
}

- (void)runQueuedTask {
    if(_activeTasks.count < kFGDwonloadMaxTaskCount) {
        @synchronized(_queuedTasks) {
            if(_queuedTasks.count > 0) {
                NSDictionary *task=[_queuedTasks objectAtIndex:0];
                NSString *url = task[@"url"];
                NSString *filePath = task[@"filePath"];
                downloadCompletionHandler completion = task[@"completion"];
                if([self activeTasksContainUrl:url]) {
                    @synchronized (_duplicateTasks) {
                        [_duplicateTasks addObject:task];
                    }
                }else{
                    OMCrossPromotionDownloader *downloader=[OMCrossPromotionDownloader downloader];
                    @synchronized (_activeTasks) {
                        [_activeTasks setObject:downloader forKey:[url omMd5]];
                    }
                    __weak __typeof(self) weakSelf = self;
                    dispatch_async(_downloadQueue, ^{
                        NSMutableDictionary *extra = [NSMutableDictionary dictionaryWithDictionary:task[@"extra"]];
                        NSInteger nowTime = (NSInteger)([[NSDate date]timeIntervalSince1970]*1000.0);
                        [extra setObject:[NSNumber numberWithInteger:nowTime] forKey:@"startTime"];
                        [downloader downloadUrl:url toPath:filePath extra:extra completion:completion delegateQueue:weakSelf.operationQueue];
                    });
                }
                [_queuedTasks removeObjectAtIndex:0];
            }
        }
    }
}

- (BOOL)activeTasksContainUrl:(NSString*)url {
    BOOL contain = NO;
    @synchronized (_activeTasks) {
        for (NSString *urlKey in _activeTasks) {
            if([[url omMd5] isEqualToString:urlKey]) {
                contain = YES;
            }
        }
    }
    return contain;
}

-(void)downloadTaskDidFinishDownload:(NSNotification *)sender {
    NSString *url=[sender.userInfo objectForKey:@"url"];
    NSError *error =[sender.userInfo objectForKey:@"error"];
    [self finishDownloadTask:url error:error];
}

- (void)finishDownloadTask:(NSString*)url error:(NSError*)error {
    @synchronized (_activeTasks) {
        NSString *urlKey = [url omMd5];
        OMCrossPromotionDownloader *finishTask = [_activeTasks objectForKey:urlKey];
        if(finishTask) {
            NSString *finishTaskFilePath = finishTask.filePath;
            @synchronized (_duplicateTasks) {
                NSMutableArray *removeDuplicateTasks = [NSMutableArray array];
                for (NSDictionary *duplicateTask in _duplicateTasks) {
                    if([duplicateTask[@"url"] isEqualToString:url]) {
                        NSString *duplicateTaskFilePath = duplicateTask[@"filePath"];
                        if(![duplicateTaskFilePath isEqualToString:finishTaskFilePath]) {
                            [[NSFileManager defaultManager]copyItemAtPath:finishTaskFilePath toPath:duplicateTaskFilePath error:nil];
                        }
                        downloadCompletionHandler completion = duplicateTask[@"completion"];
                        if(completion) {
                            completion(error);
                        }
                        [removeDuplicateTasks addObject:duplicateTask];
                    }
                }
                [_duplicateTasks removeObjectsInArray:removeDuplicateTasks];
            }
            [_activeTasks removeObjectForKey:urlKey];
        }
    }

    [self runQueuedTask];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
