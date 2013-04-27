//
//  UIButton+SmartMonkey.m
//  BaiduBoxApp
//
//  Created by tekka on 13-4-27.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "UIButton+SmartMonkey.h"
#import "UIView+SMSmartMonkey.h"

@implementation UIButton (SmartMonkey)

- (void)simulateAction
{
    UIControlEvents events = [self allControlEvents];
    
    if (events)
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
    }
    else
    {
        [super simulateAction];
    }

}

@end
