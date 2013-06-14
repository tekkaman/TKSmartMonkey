//
//  SMCrashController.m
//  BaiduBoxApp
//
//  Created by Tekka on 6/11/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import "SMCrashController.h"
#import "SMTimeView.h"

static const NSInteger UncaughtExceptionHandlerSkipAddressCount = 3;
static const NSInteger UncaughtExceptionHandlerReportAddressCount = 15;

static void smCustomHandleException(NSException *exception);
static void smCustomSignalHandler(int signal);
static NSString* smDetailedBacktrace(NSException *exception);

static NSString* currentDate()
{
    NSString* date = nil;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
    date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    return date;
}

static void saveCallStackInfo(NSString* callStack)
{
    if (callStack == nil || callStack.length == 0)
        return;
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *smPath = [docPath stringByAppendingString:@"/smartmonkey"];
    BOOL exists = ([[NSFileManager defaultManager] fileExistsAtPath:smPath isDirectory:nil]);
    if (!exists)
    {
        NSError * error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:smPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString *text = [@"RunningTime : " stringByAppendingString:[[SMTimeView runningTimeText] stringByAppendingFormat:@"\n%@", callStack]];
    NSString *filePath = [smPath stringByAppendingFormat:@"/%@", currentDate()];
    
    [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

// 处理未捕获的异常
static void smCustomHandleException(NSException *exception)
{
    [SMCrashController unregisterUncaughtExceptionHandler];
    
	NSString *callStack = smDetailedBacktrace(exception);
    saveCallStackInfo(callStack);
}

// 处理系统信号
static void smCustomSignalHandler(int signal)
{
    // 进入异常处理时应第一时间恢复默认默认异常处理
    [SMCrashController unregisterUncaughtExceptionHandler];
    
    // 获取调用栈信息
    NSException *exception = nil;
	NSString *callStack = smDetailedBacktrace(exception);
    
    saveCallStackInfo(callStack);
    
    // 重新发出信号, 保持系统默认处理
    raise(signal);
}

// format callstack info
static NSString* smDetailedBacktrace(NSException *exception)
{
    NSMutableString *backTrace = [NSMutableString string];
    NSMutableString *exceptionReason = [NSMutableString string];
    if (exception != nil)
    {
        // iOS >= 4.0
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_4_0))
        {
            NSArray *callStackSyms = [exception callStackSymbols]; // NS_AVAILABLE(4_0);
            if ([callStackSyms count] > 0)
            {
                int index = 0;
                for (; index < [callStackSyms count]; index++)
                {
                    [backTrace appendString:[callStackSyms objectAtIndex:index]];
                    [backTrace appendString:@"\n"];
                }
            }
        }
        // 异常产生的原因
        [exceptionReason appendString:[exception reason]];
    }
    
    if (backTrace.length == 0)
    {
        // 捕获信号
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_4_0))
        {
            NSMutableArray *callStackSyms = [NSMutableArray arrayWithArray:[NSThread callStackSymbols]]; // NS_AVAILABLE(4_0);
            if ([callStackSyms count] > 3)
            {
                int index = 3; // 屏蔽移动统计SDK内部函数调用序列
                for (; index < [callStackSyms count]; index++)
                {
                    [backTrace appendString:[callStackSyms objectAtIndex:index]];
                    [backTrace appendString:@"\n"];
                }
            }
        }
    }
    if (backTrace.length == 0) return nil;
    NSMutableString *detailInfo = [NSMutableString string];
    [detailInfo appendString:exceptionReason];
    [detailInfo appendString:@"\n"];
    [detailInfo appendString:@"( \n"];
    [detailInfo appendString:backTrace];
    [detailInfo appendString:@") \n"];
    return detailInfo;
}

@implementation SMCrashController

+ (void)load
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SMCrashController registerUncaughtExceptionHandler];
    });
}

+ (void) registerUncaughtExceptionHandler
{
    NSSetUncaughtExceptionHandler(&smCustomHandleException);
	signal(SIGABRT, smCustomSignalHandler);
	signal(SIGILL, smCustomSignalHandler);
	signal(SIGSEGV, smCustomSignalHandler);
	signal(SIGFPE, smCustomSignalHandler);
	signal(SIGBUS, smCustomSignalHandler);
	signal(SIGPIPE, smCustomSignalHandler);
}

+ (void) unregisterUncaughtExceptionHandler
{
    NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
}
@end
