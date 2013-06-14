//
//  UIWebView+SMSmartMonkey.m
//  BaiduBoxApp
//
//  Created by Tekka on 6/10/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import "UIWebView+SMSmartMonkey.h"
#import "SMTapView.h"

NSString* const jsClickSimulateFormatter = @"var obj = document.elementFromPoint(%f, %f); obj.click()";

@implementation UIWebView (SMSmartMonkey)

#pragma mark - SMActionProtocol

- (void)simulateActionWithPoint:(CGPoint)point
{
    [SMTapView showTapAtPoint:point fromView:self];
    
    switch(0)//(NSUInteger)random()%[self actionCount])
    {
        case 0:
            [self clickAtPoint:point];
            break;
        case 1:
            [self longPressAtPoint:point];
            break;
        default:
            break;
    }

}

- (NSUInteger)actionCount
{
    return 2;
}

- (void)clickAtPoint:(CGPoint)point
{
    // only simulate single click
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:jsClickSimulateFormatter, point.x, point.y]];
}

- (void)longPressAtPoint:(CGPoint)point
{
    [SMActionDirector actOneFingerLongPressOnView:self point:point];
}

@end
