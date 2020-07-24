// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMBaseRequest.h"
#import "OMToolUmbrella.h"

@implementation OMBaseRequest

+ (void)getWithUrl:(NSString *)url
              type:(OMRequestType)requestType
              body:(NSData*)body
 completionHandler:(requestCompletionHandler)completionHandler {
    [self requestWithUrl:[NSURL URLWithString:url] method:@"GET" type:requestType body:body completionHandler:completionHandler];
}

+ (void)postWithUrl:(NSString *)url
               type:(OMRequestType)requestType
               body:(NSData*)body
  completionHandler:(requestCompletionHandler)completionHandler {
    [self requestWithUrl:[NSURL URLWithString:url] method:@"POST" type:requestType body:body completionHandler:completionHandler];
}

+ (void)requestWithUrl:(NSURL *)url
                method:(NSString *)httpMethod
                  type:(OMRequestType)requestType
                  body:(NSData *)body
     completionHandler:(requestCompletionHandler)completionHandler {
    if ([OMNetMonitor sharedInstance].netStatus == OMNotReachable) {
        completionHandler(nil,[NSError omNetworkError:OMRequestErrorNetworkNotReachable]);
        return;
    }
    if (!url) {
        completionHandler(nil,[NSError omNetworkError:OMRequestErrorInvalidRequest]);
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:httpMethod];
    [request setHTTPBody:body];
    
    if (requestType == OMRequestTypeNormal) {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    } else {
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    }
    //[request setValue:@"1" forHTTPHeaderField:@"debug"];
    
    dispatch_queue_t requestQueue = dispatch_queue_create("com.om.request", DISPATCH_QUEUE_SERIAL);
    dispatch_async(requestQueue, ^{
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (error) {
                    completionHandler(nil, [NSError omNetworkError:OMRequestErrorNetworkError]);
                }
                if (!httpResponse) {
                    completionHandler(nil, [NSError omNetworkError:OMRequestErrorInvalidResponse]);
                }
                NSInteger responseStatusCode = [httpResponse statusCode];
                if (responseStatusCode != 200) {
                    completionHandler(nil, [NSError omNetworkError:responseStatusCode]);
                    return ;
                }
                if (OM_IS_NULL(data)) {
                    completionHandler(nil, [NSError omNetworkError:OMRequestErrorEmptyResponseData]);
                    return;
                }
                NSData *jsonData = data;
                
                if (jsonData.omIsGzippedData) {
                    jsonData = [jsonData omUnzipData];
                }
                
                if (jsonData) {
                    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    if (object) {
                        completionHandler(object, nil);
                    } else {
                        completionHandler(jsonData, nil);
                    }
                } else {
                    completionHandler(data, nil);
                }
                
            });
            
        }];
        [task resume];
    });
}

@end
