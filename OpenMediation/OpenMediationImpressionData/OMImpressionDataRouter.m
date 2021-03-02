// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMImpressionDataRouter.h"
#import "OMConfig.h"

static OMImpressionDataRouter * _instance = nil;


@interface OMImpressionDataRouter ()

@property (nonatomic, strong) NSHashTable *delegates;

@end

@implementation OMImpressionDataRouter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}


- (void)addDelegate:(id)delegate {
    if (![_delegates containsObject:delegate]) {
        [_delegates addObject:delegate];
        OMLogD(@"ImpressionData %@ add delegate %@",NSStringFromClass([self class]),delegate);
    }
}

- (void)removeDelegate:(id)delegate {
    [_delegates removeObject:delegate];
    OMLogD(@"ImpressionData %@ remove delegate %@",NSStringFromClass([self class]),delegate);
}


- (void)postImpressionData:(OMImpressionData*)impressionData {
    if ([OMConfig sharedInstance].impressionDataCallBack) {
        for (id <OMImpressionDataDelegate> delegate in self.delegates ) {
            if (delegate && [delegate respondsToSelector:@selector(omImpressionData:error:)]) {
                [delegate omImpressionData:impressionData error:nil];
            }
        }
    } else {
         NSError* error =  [NSError errorWithDomain:@"com.openmediation.ads" code:401 userInfo:@{NSLocalizedDescriptionKey:@"Ad revenue measurement is not enabled"}];
        for (id <OMImpressionDataDelegate> delegate in self.delegates ) {
            if (delegate && [delegate respondsToSelector:@selector(omImpressionData:error:)]) {
                [delegate omImpressionData:nil error:error];
            }
        }
    }

}

@end
