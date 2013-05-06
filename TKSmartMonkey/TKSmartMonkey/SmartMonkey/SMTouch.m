//
//  SMTouch.m
//  BaiduBoxApp
//
//  Created by tekka on 13-5-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
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
}

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
        _smPoint = CGPointMake(target.bounds.size.width/2, target.bounds.size.height/2);
    }
    
    return self;
}

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
    return CGPointZero;
}

@end
