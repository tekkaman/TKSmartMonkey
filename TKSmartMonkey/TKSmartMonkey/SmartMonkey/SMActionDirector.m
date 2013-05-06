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

+ (void)actionOneFingerTapOnView:(UIView*)view;
{
    NSLog(@"actionOneFingerTapOnView");
    
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

@end
