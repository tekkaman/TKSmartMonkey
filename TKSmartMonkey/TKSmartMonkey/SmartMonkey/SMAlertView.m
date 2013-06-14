//
//  SMAlertView.m
//  BaiduBoxApp
//
//  Created by Tekka on 6/12/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import "SMAlertView.h"

@implementation SMAlertView

+ (void)showAlert:(NSString*)text
{
    CGRect wndFrame = [UIApplication sharedApplication].keyWindow.bounds;
    
    SMAlertView *alertView = [[SMAlertView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    alertView.bounds = CGRectMake(0, 0, 200, 40);
    alertView.center = CGPointMake(wndFrame.size.width/2, wndFrame.size.height/2);
    alertView.text = text;
    alertView.font = [UIFont fontWithName:@"Courier New" size:20];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.3
                         animations:^()
         {
             alertView.alpha = 0.0;
         }
                         completion:^(BOOL completed)
         {
             [alertView removeFromSuperview];
         }
         ];
    });
    
    [alertView release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.textColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
