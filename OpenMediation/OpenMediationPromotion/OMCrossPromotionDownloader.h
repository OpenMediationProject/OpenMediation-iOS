// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import <Foundation/Foundation.h>

#define OM_DOWNLOAD_RESPONSE_NO_DATA   -200

typedef void (^downloadCompletionHandler)(NSError  *_Nullable error);
NS_ASSUME_NONNULL_BEGIN

static NSString *const OMCrossPromotionTaskFinishNotification=@"OMCrossPromotionTaskFinishNotification";

@interface OMCrossPromotionDownloader : NSObject<NSURLSessionDelegate>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, copy) NSDictionary *extraValue;
@property (nonatomic, assign) NSInteger dataSize;
@property (nonatomic, strong) NSFileHandle *writeHandle;
@property (nonatomic,strong, nullable) NSURLSession *session;
@property (nonatomic,copy) downloadCompletionHandler completion;

+ (instancetype)downloader;
-(void)downloadUrl:(NSString *)url
            toPath:(NSString *)path
             extra:(NSDictionary*)extraValue
        completion:(downloadCompletionHandler)completion
     delegateQueue:(NSOperationQueue *)delegateQueue;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
