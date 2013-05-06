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

@implementation SMActionDirector

+ (NSInteger)actionCount
{
    return 0;
}

+ (void)actOneFingerTapOnView:(UIView*)view;
{
    NSLog(@"actOneFingerTapOnView");
    
    SMEvent* beganEvent = [SMEvent eventForTouch];
    SMTouch* beganTouch = [SMTouch touchWithTarget:view phase:UITouchPhaseBegan];
    [beganEvent addSMTouch:beganTouch];
    [view touchesBegan:[beganEvent touchesForView:view] withEvent:beganEvent];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        SMEvent* endEvent = [SMEvent eventForTouch];
        SMTouch* endTouch = [SMTouch touchWithTarget:view phase:UITouchPhaseEnded];
        [endEvent addSMTouch:endTouch];
        [view touchesEnded:[endEvent touchesForView:view] withEvent:endEvent];
    });
}

+ (void)actOneFingerScrollOnView:(UIView*)view
{
    NSLog(@"actOneFingerScrollOnView");
    
    NSArray *ptArray = [self randomPointArrayOfView:view];
    
    // touches began
    SMEvent* beganEvent = [SMEvent eventForTouch];
    SMTouch* beganTouch = [SMTouch touchWithTarget:view point:[(NSValue*)ptArray[0] CGPointValue] phase:UITouchPhaseBegan];
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

#pragma mark - private methods
+ (NSArray*)randomPointArrayOfView:(UIView*)view
{
    NSMutableArray *array = [NSMutableArray array];
    
    CGPoint beganPoint = CGPointMake(random()%(NSInteger)view.bounds.size.width,
                                     random()%(NSInteger)view.bounds.size.height);
    CGPoint endPoint = CGPointMake(random()%(NSInteger)view.bounds.size.width,
                                   random()%(NSInteger)view.bounds.size.height);
    
    CGFloat xDiff = endPoint.x - beganPoint.x;
    CGFloat yDiff = endPoint.y - beganPoint.y;
    
    CGFloat appendX = (xDiff == 0)?beganPoint.x:(random()%(NSInteger)xDiff);
    CGFloat appendY = (yDiff == 0)?beganPoint.y:(random()%(NSInteger)yDiff);
    
    CGPoint interPoint = CGPointMake(beganPoint.x + (appendX*((xDiff<0)?-1:1)), beganPoint.y + (appendY*((yDiff<0)?-1:1)));
    
    [array addObject:[NSValue valueWithCGPoint:beganPoint]];
    [array addObject:[NSValue valueWithCGPoint:interPoint]];
    [array addObject:[NSValue valueWithCGPoint:endPoint]];
    
    return array;
}

@end
