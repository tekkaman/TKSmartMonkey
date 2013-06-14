//
//  SMTouch.m
//
//  Created by tekka on 13-5-6.
//

#import "SMTouch.h"

@implementation SMTouch
{
    NSTimeInterval _smTimestamp;
    UITouchPhase _smPhase;
    NSUInteger _smTapCount;
    UIWindow* _smWindow;
    UIView* _smView;
    CGPoint _smPoint;
    CGPoint _smPrivious;
}

#pragma mark - init methods

+ (id)touchWithTarget:(UIView*)target phase:(UITouchPhase)phase
{
    SMTouch *smTouch = [[SMTouch alloc] initWithTarget:target phase:phase];
    return [smTouch autorelease];
}

- (id)initWithTarget:(UIView*)target phase:(UITouchPhase)phase
{
    if (self = [super init])
    {
        _smTimestamp = [[NSProcessInfo processInfo] systemUptime];
        _smPhase = phase;
        _smTapCount = 1;
        _smWindow = [UIApplication sharedApplication].delegate.window;
        _smView = target;
        _smPoint = CGPointMake(target.bounds.size.width, target.bounds.size.height);
        _smPrivious = _smPoint;
    }
    
    return self;
}

+ (id)touchWithTarget:(UIView *)target point:(CGPoint)point phase:(UITouchPhase)phase
{
    SMTouch *smTouch = [[SMTouch alloc] initWithTarget:target point:point phase:phase];
    return [smTouch autorelease];
}

- (id)initWithTarget:(UIView*)target point:(CGPoint)point phase:(UITouchPhase)phase;
{
    if (self = [self initWithTarget:target phase:phase])
    {
        _smPoint = point;
    }
    return self;
}

+ (id)touchWithTarget:(UIView *)target point:(CGPoint)point previous:(CGPoint)privious phase:(UITouchPhase)phase
{
    SMTouch *smTouch = [[SMTouch alloc] initWithTarget:target point:point previous:privious phase:phase];
    return [smTouch autorelease];
}

- (id)initWithTarget:(UIView*)target point:(CGPoint)point previous:(CGPoint)privious phase:(UITouchPhase)phase
{
    if (self = [self initWithTarget:target point:point phase:phase])
    {
        _smPrivious = privious;
    }
    return self;
}

#pragma mark - public methods

- (NSTimeInterval)timestamp
{
    return _smTimestamp;
}

- (UITouchPhase)phase
{
    return _smPhase;
}

- (NSUInteger)tapCount
{
    return _smTapCount;
}

- (UIWindow*)window
{
    return _smWindow;
}

- (UIView*)view
{
    return _smView;
}

- (CGPoint)locationInView:(UIView *)view
{
    if (view == _smView)
        return _smPoint;
    
    return [_smView convertPoint:_smPoint toView:view];;
}

// 只有UITouchPhaseMoved才提供此函数实现
- (CGPoint)previousLocationInView:(UIView *)view
{
    return _smPrivious;
}

@end
