// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrossPromotionDownloader.h"
#import "OMToolUmbrella.h"
#import "OMCrossPromotionCacheFile.h"
#import "OMErrorRequest.h"

@implementation OMCrossPromotionDownloader

+(instancetype)downloader {
    return [[[self class] alloc]init];
}


-(void)downloadUrl:(NSString *)url
            toPath:(NSString *)path
             extra:(NSDictionary*)extraValue
        completion:(downloadCompletionHandler)completion
     delegateQueue:(NSOperationQueue *)delegateQueue {
    if(url && path) {
        _url = url;
        _filePath = path;
        _extraValue = extraValue;
        _dataSize = 0;
        _completion=completion;
        BOOL cacheFresh = [OMCrossPromotionCacheFile cacheFresh:_url];

        if(cacheFresh) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:OMCrossPromotionTaskFinishNotification object:nil userInfo:@{@"url":self.url}];
                self.completion(nil);
            });
        }else{
            NSURL *url=[NSURL URLWithString:_url];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30.0];
            if([NSString omUrlCacheReady:_url]) {
                // add cache header key
                NSDictionary *headers = [OMCrossPromotionCacheFile cacheHeader:_url];
                for (NSString *key in headers) {
                    [request setValue:[headers objectForKey:key] forHTTPHeaderField:key];
                }
            }else{
                // tmpcache
                NSInteger fileCurrentSize = 0;
                NSFileManager *fileManager=[NSFileManager defaultManager];
                NSString *tmpFile = [NSString stringWithFormat:@"%@.tmp",_filePath];
                if([fileManager fileExistsAtPath:tmpFile]) {
                    fileCurrentSize = [[[fileManager attributesOfItemAtPath:tmpFile error:nil] objectForKey:NSFileSize] integerValue];
                    if(fileCurrentSize > 0) {
                        NSString *rangeString=[NSString stringWithFormat:@"bytes=%lld-",(long long)fileCurrentSize];
                        [request setValue:rangeString forHTTPHeaderField:@"Range"];
                        _dataSize = fileCurrentSize;
                    }
                }
                
            }
            _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:delegateQueue];
            NSURLSessionDataTask *downloadTask = [_session dataTaskWithRequest:request];
            [downloadTask resume];
        }
        


    }
}

-(void)cancel {
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark -- NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    completionHandler(nil);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSInteger statusCode = 0;
    if([response respondsToSelector:@selector(statusCode)]) {
        statusCode = [(NSHTTPURLResponse*)response statusCode];
    }
    
    if(statusCode != 206) {
        NSString *tmpFile = [NSString stringWithFormat:@"%@.tmp",_filePath];
        [[NSFileManager defaultManager]removeItemAtPath:tmpFile error:nil];
        _dataSize = 0;
    }
    
    NSString *tmpFile = [NSString stringWithFormat:@"%@.tmp",_filePath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:tmpFile]) {
        [[NSFileManager defaultManager] createFileAtPath:tmpFile contents:nil attributes:nil];
    }
    _writeHandle=[NSFileHandle fileHandleForWritingAtPath:tmpFile];
    NSMutableDictionary *cacheInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *responseHeader = [NSMutableDictionary dictionary];
    if(statusCode == 304) {
        NSString *cacheInfoPath = [NSString omUrlCacheInfoPath:_url];
        if([[NSFileManager defaultManager]fileExistsAtPath:cacheInfoPath]) {
            NSDictionary *cacheDic = [NSDictionary dictionaryWithContentsOfFile:cacheInfoPath];
            if([cacheDic objectForKey:@"responseHeader"]) {
                responseHeader = [cacheDic objectForKey:@"responseHeader"];
            }
        }
    }else{
        if([response respondsToSelector:@selector(allHeaderFields)]) {
            NSDictionary *header = [(NSHTTPURLResponse*)response  allHeaderFields];
            [responseHeader addEntriesFromDictionary:header];
        }
        [cacheInfo setObject:[NSString stringWithFormat:@"%zd",statusCode] forKey:@"code"];
    }


    [cacheInfo setObject:responseHeader forKey:@"responseHeader"];
    [cacheInfo setObject:[NSString stringWithFormat:@"%lf",[[NSDate date]timeIntervalSince1970]] forKey:@"responseDate"];
    [cacheInfo setObject:response.URL.absoluteString forKey:@"baseUrl"];
    [cacheInfo writeToFile:[NSString omUrlCacheInfoPath:_url] atomically:YES];
    
    completionHandler(NSURLSessionResponseAllow);
    

}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    _dataSize += [data length];
    [_writeHandle seekToEndOfFile];
    @try {
        [_writeHandle writeData:data];
    } @catch (NSException *exception) {
        [_session invalidateAndCancel];
    } @finally {
        
    }

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    [_session finishTasksAndInvalidate];
    [_writeHandle closeFile];
    _writeHandle = nil;
    NSInteger statusCode = 0;
    NSString *cacheInfoPath = [NSString omUrlCacheInfoPath:_url];
    if([[NSFileManager defaultManager] fileExistsAtPath:cacheInfoPath]) {
        NSDictionary *cacheInfo = [NSDictionary dictionaryWithContentsOfFile:cacheInfoPath];
        statusCode = [[cacheInfo objectForKey:@"code"]integerValue];
    }
    if(!error && (statusCode == 200 || statusCode == 206 || statusCode == 416) ) {
        NSString *fileSizeKey = [self.url omMd5];
        if(_dataSize == 0) {
            _dataSize =OM_DOWNLOAD_RESPONSE_NO_DATA;
        }
        [[NSUserDefaults standardUserDefaults]setInteger:_dataSize forKey:fileSizeKey];
        NSString *tmpFile = [NSString stringWithFormat:@"%@.tmp",_filePath];
        [[NSFileManager defaultManager]removeItemAtPath:_filePath error:nil];
        [[NSFileManager defaultManager]moveItemAtPath:tmpFile toPath:_filePath error:nil];
    }

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:_url forKey:@"url"];
    if(error) {
        [info setObject:error forKey:@"error"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OMCrossPromotionTaskFinishNotification object:nil userInfo:info];
        self.completion(error);
    });

    if(error || (statusCode != 200 && statusCode != 206)) {
        NSError * responseError = error;
        if(!responseError) {
            responseError = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"response status code: %zd",statusCode]}];
        }
        NSDictionary *extra = self.extraValue;
        if(extra) {
            NSString *pid = OM_SAFE_STRING(extra[@"pid"]);
            NSString *creativeId = OM_SAFE_STRING(extra[@"creativeId"]);
            NSString *campaignId = OM_SAFE_STRING(extra[@"campaignId"]);
            NSInteger startTime = [extra[@"downloadTime"]integerValue];
            NSInteger nowTime = (NSInteger)([[NSDate date]timeIntervalSince1970]*1000.0);
            NSString *error = [NSString stringWithFormat:@"Download %@ error:%@ ,cost time %ld creative id %@,campaign id %@",_url,[responseError description],(nowTime - startTime),creativeId,campaignId];
            
            [OMErrorRequest postWithErrorMsg:@{@"pid":pid,@"tag":@"downlaoder",@"error":error} completionHandler:^(NSObject * _Nullable object, NSError * _Nullable error) {
                if(!error) {
                    OMLogD(@"post download error: %@,%@",self.url,[responseError description]);
                }
            }];
        }
    }

}

@end
