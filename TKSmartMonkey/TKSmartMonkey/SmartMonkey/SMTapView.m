//
//  SMTapView.m
//  BaiduBoxApp
//
//  Created by tekka on 13-6-9.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "SMTapView.h"

@implementation SMTapView

+ (void)showTapAtPoint:(CGPoint)point;
{
    [self _showViewAtPoint:point WithInterval:0.3];
}

+ (void)showTapAtPoint:(CGPoint)point fromView:(UIView*)view;
{
    UIWindow *wnd = [UIApplication sharedApplication].keyWindow;
    CGPoint wndPoint = [wnd convertPoint:point fromView:view];
    
    [self showTapAtPoint:wndPoint];
}

+ (void)showLongPressAtPoint:(CGPoint)point
{
    [self _showViewAtPoint:point WithInterval:2.0];
}

+ (void)showLongPressAtPoint:(CGPoint)point fromeView:(UIView*)view
{
    UIWindow *wnd = [UIApplication sharedApplication].keyWindow;
    CGPoint wndPoint = [wnd convertPoint:point fromView:view];
    
    [self showLongPressAtPoint:wndPoint];
}

+ (void)_showViewAtPoint:(CGPoint)point WithInterval:(NSTimeInterval)interval
{
    SMTapView *tapView = [[SMTapView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    tapView.center = point;
    
    [[UIApplication sharedApplication].keyWindow addSubview:tapView];
    
    double delayInSeconds = interval;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.3
                         animations:^()
         {
             tapView.alpha = 0.0;
         }
                         completion:^(BOOL completed)
         {
             [tapView removeFromSuperview];
         }
         ];
    });
    
    [tapView release];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width/2;
        self.backgroundColor = [UIColor redColor];
        self.clipsToBounds = YES;
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}


@end
