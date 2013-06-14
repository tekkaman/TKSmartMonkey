//
//  SMCrashController.h
//
//  Created by Tekka on 6/11/13.
//

#import <Foundation/Foundation.h>

@interface SMCrashController : NSObject

// monit exception & signal that will leads to crash
+ (void) registerUncaughtExceptionHandler;

// unmonit exception & signal that will leads to crash
+ (void) unregisterUncaughtExceptionHandler;

@end
