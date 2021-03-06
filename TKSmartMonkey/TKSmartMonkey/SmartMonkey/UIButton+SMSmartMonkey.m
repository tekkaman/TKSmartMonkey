//
//  UIButton+SmartMonkey.m
//
//  Created by tekka on 13-4-27.
//

#import "UIButton+SMSmartMonkey.h"
#import "UIView+SMSmartMonkey.h"
#import "SMTapView.h"

@implementation UIButton (SMSmartMonkey)

- (void)simulateActionWithPoint:(CGPoint)point
{
    UIControlEvents events = [self allControlEvents];
    
    if (events)
    {
        // show tap view
        [SMTapView showTapAtPoint:point fromView:self];
                       
        // delay 100ms loop, let developers see tapView first
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSUInteger maxKeyNum = UIControlEventEditingDidEndOnExit;
            NSUInteger index = random()%maxKeyNum;
            UIControlEvents event;
            while(1)
            {
                if (events & (1<<index))
                {
                    event = (1<<index);
                    [self sendActionsForControlEvents:event];
                    return ;
                }
                
                if (++index == maxKeyNum)
                    index = 0;
            }
        });
    }
    else
    {
        [super simulateActionWithPoint:point];
    }

}

@end
