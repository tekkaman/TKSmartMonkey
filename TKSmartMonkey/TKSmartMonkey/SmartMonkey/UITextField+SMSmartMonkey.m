//
//  UITextField+SMSmartMonkey.m
//
//  Created by tekka on 13-4-27.
//

#import "UITextField+SMSmartMonkey.h"
#import "SMTapView.h"

@implementation UITextField (SMSmartMonkey)

- (void)simulateActionWithPoint:(CGPoint)point;
{
    [SMTapView showTapAtPoint:point fromView:self];
    
    if (self.isFirstResponder)
        [self resignFirstResponder];
    else
        [self becomeFirstResponder];
}

@end
