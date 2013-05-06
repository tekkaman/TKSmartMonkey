//
//  SMTouch.h
//  BaiduBoxApp
//
//  Created by tekka on 13-5-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTouch : UITouch

// return a one-finger tap SMTouch
+ (id)touchWithTarget:(UIView*)target phase:(UITouchPhase)phase;

- (id)initWithTarget:(UIView*)target phase:(UITouchPhase)phase;

- (NSTimeInterval)timestamp;
- (UITouchPhase)phase;
- (NSUInteger)tapCount;
- (UIWindow*)window;
- (UIView*)view;

- (CGPoint)locationInView:(UIView *)view;
- (CGPoint)previousLocationInView:(UIView *)view;

@end
