// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMExposureMonitor.h"

@interface OMViewObserver : NSObject
- (void)observeView:(UIView*)view visible:(BOOL)visible;
@end

@interface OMExposureMonitor() {
    CFRunLoopObserverRef _observer;
}
@end

static OMExposureMonitor * _instance = nil;

@implementation OMExposureMonitor

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


-(instancetype)init {
    if (self=[super init]) {
        _monitoredViewMap = [NSMapTable weakToWeakObjectsMapTable];
        [self addObserverForMainRunloop];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObserverForMainRunloop) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObserverForMainRunloop) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)addObserverForMainRunloop {
    if (_observer || [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    _observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (weakSelf && activity == kCFRunLoopBeforeWaiting) {
             [weakSelf checkMonitoredViews];
        }
    });
    CFRunLoopAddObserver([NSRunLoop mainRunLoop].getCFRunLoop, _observer, kCFRunLoopCommonModes);
}

- (void)removeObserverForMainRunloop {
    if (_observer) {
        CFRunLoopRemoveObserver([NSRunLoop mainRunLoop].getCFRunLoop, _observer, kCFRunLoopCommonModes);
    }
    _observer = nil;
}

- (void)checkMonitoredViews {
    
    NSEnumerator *enumerator = [_monitoredViewMap keyEnumerator];
    OMViewObserver *observer;

    while ((observer = [enumerator nextObject])) {
        if (observer && [observer respondsToSelector:@selector(observeView:visible:)] && [_monitoredViewMap objectForKey:observer]) {
            UIView *monitorView = [_monitoredViewMap objectForKey:observer];
            [observer observeView:monitorView visible:[self visible:monitorView]];
        }
    }
}

- (BOOL)visible:(UIView*)view {
    UIWindow *window = view.window;
    BOOL isHidden = view.isHidden;
    UIView*superView =view.superview;
    BOOL superViewHidden = NO;
    while(!superViewHidden && superView) {
        superViewHidden = superView.isHidden;
        superView = superView.superview;
    }
    if (superViewHidden) {
        isHidden = YES;
    }
    CGFloat alpha = view.alpha;
    superView =view.superview;
    while(superView) {
        if (superView.alpha < alpha) {
            alpha = superView.alpha;
        }
        superView = superView.superview;
    }
    if (!window || isHidden || alpha < 0.05) {
        return NO;
    }
    CGRect frame = view.frame;
    CGRect rectInWindow = CGRectIntegral([view.superview convertRect:frame toView:window]);
    CGRect intersectionRect = CGRectIntersection(rectInWindow, window.frame);
    if (CGRectIsNull(intersectionRect) || CGRectIsEmpty(intersectionRect)|| (intersectionRect.size.width*intersectionRect.size.height < 10)) {
        return NO;
    }
    return YES;
}

- (void)addObserver:(NSObject*)observer forView:(UIView*)view {
    @synchronized (_monitoredViewMap) {
        [_monitoredViewMap setObject:view forKey:observer];
    }
}

- (void)removeObserver:(NSObject*)observer {
    @synchronized (_monitoredViewMap) {
        [_monitoredViewMap removeObjectForKey:observer];
    }
}

@end
