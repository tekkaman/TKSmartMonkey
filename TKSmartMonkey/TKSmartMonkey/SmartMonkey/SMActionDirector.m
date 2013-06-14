//
//  SMActionDirector.m
//  BaiduBoxApp
//
//  Created by tekka on 13-5-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "SMActionDirector.h"
#import "SMTouch.h"
#import "SMEvent.h"
#import "SMTapView.h"
#import "SMAlgorithm.h"

@implementation SMActionDirector

+ (NSInteger)actionCount
{
    return 3;
}

#pragma mark - one-finger tap

+ (void)actOneFingerTapOnView:(UIView*)view;
{
    CGPoint point = [SMAlgorithm randomPointOfView:view];
    return [self actOneFingerTapOnView:view point:point];
}

+ (void)actOneFingerTapOnView:(UIView*)view point:(CGPoint)point
{
    NSLog(@"actOneFingerTapOnView");
    
    [SMTapView showTapAtPoint:point fromView:view];
    [self _oneFingerTapOnView:view point:point interval:0];
}

#pragma mark - one-finger long-press

+ (void)actOneFingerLongPressOnView:(UIView*)view
{
    CGPoint point = [SMAlgorithm randomPointOfView:view];
    return [self actOneFingerLongPressOnView:view point:point];
}

+ (void)actOneFingerLongPressOnView:(UIView*)view point:(CGPoint)point
{
    NSLog(@"actOneFingerLongPressOnView");
    
    [SMTapView showLongPressAtPoint:point fromeView:view];
    [self _oneFingerTapOnView:view point:point interval:2.0];
}

+ (void)_oneFingerTapOnView:(UIView*)view point:(CGPoint)point interval:(NSTimeInterval)interval
{
    SMEvent* beganEvent = [SMEvent eventForTouch];
    SMTouch* beganTouch = [SMTouch touchWithTarget:view point:point  phase:UITouchPhaseBegan];
    [beganEvent addSMTouch:beganTouch];
    
    [view touchesBegan:[beganEvent touchesForView:view] withEvent:beganEvent];
    
    double delayInSeconds = interval;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       SMEvent* endEvent = [SMEvent eventForTouch];
                       SMTouch* endTouch = [SMTouch touchWithTarget:view point:point phase:UITouchPhaseEnded];
                       [endEvent addSMTouch:endTouch];
                       
                       [view touchesEnded:[endEvent touchesForView:view] withEvent:endEvent];
                   });
}

#pragma mark - one-finger scroll

+ (void)actOneFingerScrollOnView:(UIView*)view
{
    NSLog(@"actOneFingerScrollOnView");
    
    NSArray *ptArray = [self _randomScrollPointArrayOfView:view];
    [self _actOneFingerScrollOnView:view withPointArray:ptArray];
}

+ (void)actOneFingerScrollOnView:(UIView*)view startPoint:(CGPoint)point
{
    NSArray *ptArray = [self _randomScrollPointArrayOfView:view startPoint:point];
    [self _actOneFingerScrollOnView:view withPointArray:ptArray];
}

+ (void)_actOneFingerScrollOnView:(UIView*)view withPointArray:(NSArray*)ptArray
{
    // touches began
    SMEvent* beganEvent = [SMEvent eventForTouch];
    SMTouch* beganTouch = [SMTouch touchWithTarget:view
                                             point:[(NSValue*)ptArray[0] CGPointValue]
                                          previous:[(NSValue*)ptArray[0] CGPointValue]
                                             phase:UITouchPhaseBegan];
    [beganEvent addSMTouch:beganTouch];
    [view touchesBegan:[beganEvent touchesForView:view] withEvent:beganEvent];
    
    // touches move
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        SMEvent* interEvent = [SMEvent eventForTouch];
        SMTouch* interTouch = [SMTouch touchWithTarget:view
                                                 point:[(NSValue*)ptArray[1] CGPointValue]
                                              previous:[(NSValue*)ptArray[0] CGPointValue]
                                                 phase:UITouchPhaseMoved];
        [interEvent addSMTouch:interTouch];
        [view touchesMoved:[interEvent touchesForView:view] withEvent:interEvent];
    });
    
    // touch end
    delayInSeconds = 1.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        SMEvent* endEvent = [SMEvent eventForTouch];
        SMTouch* endTouch = [SMTouch touchWithTarget:view
                                               point:[(NSValue*)ptArray[2] CGPointValue]
                                            previous:[(NSValue*)ptArray[1] CGPointValue]
                                               phase:UITouchPhaseEnded];
        [endEvent addSMTouch:endTouch];
        [view touchesEnded:[endEvent touchesForView:view] withEvent:endEvent];
    });
}

#pragma mark - one-finger twist

+ (void)actOneFingerTwistOnView:(UIView*)view
{
    CGPoint point = [SMAlgorithm randomPointOfView:view];
    [self actOneFingerTwistOnView:view startPoint:point];
}

+ (void)actOneFingerTwistOnView:(UIView*)view startPoint:(CGPoint)point
{
    NSLog(@"actOneFingerTwistOnView");
    const NSUInteger maxTwistPoint = 10;
    NSArray* ptArray = [self _twistPointArrayOfView:view startPoint:point count:maxTwistPoint];
    
    // touches began
    SMEvent* beganEvent = [SMEvent eventForTouch];
    SMTouch* beganTouch = [SMTouch touchWithTarget:view
                                             point:[(NSValue*)ptArray[0] CGPointValue]
                                          previous:[(NSValue*)ptArray[0] CGPointValue]
                                             phase:UITouchPhaseBegan];
    [beganEvent addSMTouch:beganTouch];
    [view touchesBegan:[beganEvent touchesForView:view] withEvent:beganEvent];
    
    double delayInSeconds = 0;
    dispatch_time_t popTime;
    
    for (NSUInteger i = 1; i < ptArray.count; i++)
    {
        delayInSeconds += 0.2;
        
        // touch end
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            SMEvent* event = [SMEvent eventForTouch];
            if ( i+1 == ptArray.count)
            {
                SMTouch* touch = [SMTouch touchWithTarget:view
                                                    point:[(NSValue*)ptArray[i] CGPointValue]
                                                 previous:[(NSValue*)ptArray[i-1] CGPointValue]
                                                    phase:UITouchPhaseEnded];
                [event addSMTouch:touch];
                [view touchesEnded:[event touchesForView:view] withEvent:event];
            }
            else
            {
                SMTouch* touch = [SMTouch touchWithTarget:view
                                                    point:[(NSValue*)ptArray[i] CGPointValue]
                                                 previous:[(NSValue*)ptArray[i-1] CGPointValue]
                                                    phase:UITouchPhaseMoved];
                [event addSMTouch:touch];
                [view touchesMoved:[event touchesForView:view] withEvent:event];
            }
        });
    }

}

+ (NSArray*)_twistPointArrayOfView:(UIView*)view startPoint:(CGPoint)point  count:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSValue valueWithCGPoint:point]];
    
    CGPoint lastPoint = point;
    for (NSUInteger i = 1; i < count; i++)
    {
        CGPoint newPoint = [self _fixPoint:[SMAlgorithm randomPointOfView:view] from:lastPoint];
        
        [array addObject:[NSValue valueWithCGPoint:newPoint]];
        
        lastPoint = newPoint;
    }
    
    return array;
}

+ (CGPoint)_fixPoint:(CGPoint)point1 from:(CGPoint)point2
{
    const NSUInteger maxDiff = 30;
    if (abs(point1.x - point2.x) > maxDiff)
    {
        if (point1.x > point2.x) point1.x = point2.x + maxDiff;
        else point1.x = point2.x - maxDiff;
    }
    
    if (abs(point1.y - point2.y) > maxDiff)
    {
        if (point1.y > point2.y) point1.y = point2.y + maxDiff;
        else point1.y = point2.y - maxDiff;
    }
    
    return point1;
}

#pragma mark - private methods

+ (NSArray*)_randomScrollPointArrayOfView:(UIView*)view
{
    CGPoint beganPoint = [SMAlgorithm randomPointOfView:view];
    CGPoint endPoint = [SMAlgorithm randomPointOfView:view];
    
    return [self _scrollPointArrayOfStartPoint:beganPoint endPoint:endPoint];
}

+ (NSArray*)_randomScrollPointArrayOfView:(UIView*)view startPoint:(CGPoint)point
{
    CGPoint beganPoint = point;
    CGPoint endPoint = [SMAlgorithm randomPointOfView:view];
    return [self _scrollPointArrayOfStartPoint:beganPoint endPoint:endPoint];
}

+ (NSArray*)_scrollPointArrayOfStartPoint:(CGPoint)beganPoint endPoint:(CGPoint)endPoint
{
    CGFloat xDiff = endPoint.x - beganPoint.x;
    CGFloat yDiff = endPoint.y - beganPoint.y;
    
    CGFloat appendX = (xDiff == 0)?beganPoint.x:(random()%(NSInteger)xDiff);
    CGFloat appendY = (yDiff == 0)?beganPoint.y:(random()%(NSInteger)yDiff);
    
    CGPoint interPoint = CGPointMake(beganPoint.x + (appendX*((xDiff<0)?-1:1)), beganPoint.y + (appendY*((yDiff<0)?-1:1)));
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSValue valueWithCGPoint:beganPoint]];
    [array addObject:[NSValue valueWithCGPoint:interPoint]];
    [array addObject:[NSValue valueWithCGPoint:endPoint]];
    
    return array;
}

@end
