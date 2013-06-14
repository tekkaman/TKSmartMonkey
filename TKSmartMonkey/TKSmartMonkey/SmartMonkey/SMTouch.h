//
//  SMTouch.h
//
//  Created by tekka on 13-5-6.
//

#import <UIKit/UIKit.h>

@interface SMTouch : UITouch

// return a one-finger tap SMTouch
+ (id)touchWithTarget:(UIView*)target phase:(UITouchPhase)phase;
- (id)initWithTarget:(UIView*)target phase:(UITouchPhase)phase;

// return a one-finger tap with specified point
+ (id)touchWithTarget:(UIView *)target point:(CGPoint)point phase:(UITouchPhase)phase;
- (id)initWithTarget:(UIView*)target point:(CGPoint)point phase:(UITouchPhase)phase;

// return a one-finger tap with specified point and previous point
+ (id)touchWithTarget:(UIView *)target point:(CGPoint)point previous:(CGPoint)privious phase:(UITouchPhase)phase;
- (id)initWithTarget:(UIView*)target point:(CGPoint)point previous:(CGPoint)privious phase:(UITouchPhase)phase;

- (NSTimeInterval)timestamp;
- (UITouchPhase)phase;
- (NSUInteger)tapCount;
- (UIWindow*)window;
- (UIView*)view;

- (CGPoint)locationInView:(UIView *)view;
- (CGPoint)previousLocationInView:(UIView *)view;

@end
