// Copyright 2020 ADTIMING TECHNOLOGY COMPANY LIMITED
// Licensed under the GNU Lesser General Public License Version 3

#import "OMCrashHandle.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "OMBacktrace.h"
#import "OMLogMoudle.h"
#import "NSString+OMExtension.h"
#import "OMErrorRequest.h"

static NSUncaughtExceptionHandler *OMPreviousUncaughtExceptionHandler;

static const int om_monitored_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP
};

static int om_monitored_signals_count = (sizeof(om_monitored_signals) / sizeof(om_monitored_signals[0]));

static struct sigaction* OMPreviousSignalHandlers = NULL;

static stack_t OMSignalStack = {0};


static void OMHandleException(NSException *exception) {
    [[OMCrashHandle sharedInstance]saveException:exception];
}

static void OMHandleSignal(int sigNum, siginfo_t* signalInfo, void* userContext) {
    [[OMCrashHandle sharedInstance]saveSignal:sigNum signalInfo:signalInfo];
}


static OMCrashHandle * _instance = nil;

@implementation OMCrashHandle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _crashLogs = [NSMutableArray array];
        NSString *omDataPath = [NSString omDataPath];
        NSString *crashLogPath = [omDataPath stringByAppendingPathComponent:@"crashLog.plist"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:crashLogPath]) {
            _crashLogs = [NSMutableArray arrayWithContentsOfFile:crashLogPath];
        }
    }
    return self;
}

- (void)installUncaughtExceptionHandler {
    OMPreviousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    if (OMPreviousUncaughtExceptionHandler != OMHandleException) {
        NSSetUncaughtExceptionHandler(&OMHandleException);
    }
}

- (void)uninstallUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(OMPreviousUncaughtExceptionHandler);
    OMPreviousUncaughtExceptionHandler = NULL;
    
}

- (void)installSignalHandler {
    if (OMSignalStack.ss_size == 0)
    {
        OMLogD(@"Allocating signal stack area.");
        OMSignalStack.ss_size = SIGSTKSZ;
        OMSignalStack.ss_sp = malloc(OMSignalStack.ss_size);
    }

    OMLogD(@"Setting signal stack area.");
    if (sigaltstack(&OMSignalStack, NULL) != 0)
    {
        OMLogD(@"signalstack: %s", strerror(errno));
        return;
    }
    
    if (OMPreviousSignalHandlers == NULL)
    {
        OMPreviousSignalHandlers = malloc(sizeof(*OMPreviousSignalHandlers)
                                          * (unsigned)om_monitored_signals_count);
    }
    
    struct sigaction action = {{0}};
    action.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigemptyset(&action.sa_mask);
    action.sa_sigaction = &OMHandleSignal;

    for(int i = 0; i < om_monitored_signals_count; i++)
    {
        OMLogD(@"Assigning handler for signal %d", om_monitored_signals[i]);
        if (sigaction(om_monitored_signals[i], &action, &OMPreviousSignalHandlers[i]) != 0)
        {
            OMLogD(@"sigaction failed %d",i);
            // Try to reverse
            for(i--;i >= 0; i--)
            {
                sigaction(om_monitored_signals[i], &OMPreviousSignalHandlers[i], NULL);
            }
            return;
        }
    }
}

- (void)uninstallSignalHandler {
    for(int i = 0; i < om_monitored_signals_count; i++)
    {
        sigaction(om_monitored_signals[i], &OMPreviousSignalHandlers[i], NULL);
    }
    free(OMPreviousSignalHandlers);
    OMPreviousSignalHandlers = NULL;
}

- (void)install {
    [self installUncaughtExceptionHandler];
    [self installSignalHandler];
}


- (void)uninstall {
    [self uninstallUncaughtExceptionHandler];
    [self uninstallSignalHandler];
}

- (void)saveException:(NSException*)exception {
    NSMutableDictionary *error = [NSMutableDictionary dictionary];
    NSTimeInterval ts = [[NSDate date]timeIntervalSince1970];
    [error setObject:[NSString stringWithFormat:@"%zd",(NSInteger)(ts)] forKey:@"ts"];

    [error setObject:[exception name] forKey:@"name"];
    [error setObject:[exception reason] forKey:@"reason"];
    [error setObject:[NSString stringWithFormat:@"%@",[exception userInfo]] forKey:@"userInfo"];
    [error setObject:[exception callStackSymbols] forKey:@"callStackSymbols"];
    NSArray *callStackReturnAddresses =[exception callStackReturnAddresses];
    NSMutableArray *callStack= [NSMutableArray array];
    for (NSNumber *addr in callStackReturnAddresses) {
        [callStack addObject:[NSString stringWithFormat:@"0x%lx",(unsigned long)[addr intValue]]];
    }
    [error setObject:callStack forKey:@"addr"];
    [error setObject:[OMBacktrace allThreadBacktrace] forKey:@"threads"];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:error options:0 error:&jsonError];
    if (!jsonError && jsonData) {
        NSString *errorStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableDictionary * crashLog = [NSMutableDictionary dictionary];
        [crashLog setObject:@"NSException" forKey:@"tag"];
        [crashLog setObject:errorStr forKey:@"error"];
        
        [self saveCrashLog:crashLog];
    }
    
    if (OMPreviousUncaughtExceptionHandler)
    {
        OMPreviousUncaughtExceptionHandler(exception);
    }
    [self uninstall];
}

- (void) saveSignal:(int)sigNum signalInfo:(siginfo_t*)signalInfo {
    NSMutableDictionary *error = [NSMutableDictionary dictionary];
    
    NSTimeInterval ts = [[NSDate date]timeIntervalSince1970];
    [error setObject:[NSString stringWithFormat:@"%zd",(NSInteger)(ts)] forKey:@"ts"];
    [error setObject:[NSNumber numberWithInt:sigNum] forKey:@"signal"];
    NSString *sigName = [NSString stringWithCString:strsignal(sigNum) encoding:NSUTF8StringEncoding] ?: [NSString stringWithFormat:@"SIGNUM(%i)", sigNum];
    [error setObject:sigName forKey:@"name"];
    [error setObject:[NSNumber numberWithInt:signalInfo->si_code] forKey:@"code"];
    [error setObject:[NSString stringWithFormat:@"0x%lx",(unsigned long)signalInfo->si_addr] forKey:@"addr"];
    [error setObject:[OMBacktrace allThreadBacktrace] forKey:@"threads"];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:error options:0 error:&jsonError];
    if (!jsonError && jsonData) {
        NSString *errorStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableDictionary * crashLog = [NSMutableDictionary dictionary];
        [crashLog setObject:@"signal" forKey:@"tag"];
        [crashLog setObject:errorStr forKey:@"error"];
        
        [self saveCrashLog:crashLog];
    }
    
    [self uninstall];
    raise(sigNum);
}


- (void)saveCrashLog:(NSDictionary*)crashLog {
    @synchronized (self) {
        [_crashLogs addObject:crashLog];
        NSString *omDataPath = [NSString omDataPath];
        NSString *crashLogPath = [omDataPath stringByAppendingPathComponent:@"crashLog.plist"];
        [_crashLogs writeToFile:crashLogPath atomically:YES];
    }
}

- (void)sendCrashLog
{
    @synchronized (self) {
        if (_crashLogs.count>0) {
            NSDictionary *crashLog = [_crashLogs objectAtIndex:0];
            [OMErrorRequest postWithErrorMsg:crashLog completionHandler:^(NSObject * _Nullable object, NSError * _Nullable error) {
                if (!error) {
                    @synchronized (self) {
                        [self.crashLogs removeObject:crashLog];
                        NSString *omDataPath = [NSString omDataPath];
                        NSString *crashLogPath = [omDataPath stringByAppendingPathComponent:@"crashLog.plist"];
                        [self.crashLogs writeToFile:crashLogPath atomically:YES];
                        [self sendCrashLog];
                    }
                }
            }];
        }
    }
}


@end

