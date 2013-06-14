//
//  SMSmartMonkey.h
//
//  Created by tekka on 13-4-25.
//

#import <Foundation/Foundation.h>

// With SMSmartMonkey, you just include these code into your project, and you do not need to modify any code.
// An SmartMonkey will just work for you.
@interface SMSmartMonkey : NSObject

// start running smartmonkey
+ (void)startSmartMonkey:(BOOL)alert;

// stop running smartmonkey
+ (void)stopSmartMonkey;

// whether smartmonkey is running
+ (BOOL)isSmartMonkeyRunning;

// switch between start & stop
+ (void)switchStatus;

@end
