//
//  UITableView+SmartMonkey.m
//
//  Created by Tekka on 6/11/13.
//

#import "UITableView+SmartMonkey.h"
#import "SMTapView.h"
#import "SMAlgorithm.h"

@implementation UITableView (SmartMonkey)

#pragma mark - SMActionProtocol

- (void)simulateActionWithPoint:(CGPoint)point
{
    [SMTapView showTapAtPoint:point fromView:self];

    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        NSIndexPath* path = [self indexPathForRowAtPoint:point];
        
        if (path == nil)
            return ;
        
        id<UITableViewDelegate> delegate = self.delegate;
        
        if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
            [delegate tableView:self didSelectRowAtIndexPath:path];
    });
}

@end
