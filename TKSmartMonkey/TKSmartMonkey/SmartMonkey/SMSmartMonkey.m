//
//  SMSmartMonkey.m
//
//  Created by tekka on 13-4-25.
//

#import "SMSmartMonkey.h"
#import "SMAlgorithm.h"
#import "UIView+SMSmartMonkey.h"
#import "SMConfig.h"
#import "SMTimeView.h"
#import "SMAlertView.h"

static NSTimer* smTimer = nil;

@interface SMSmartMonkey ()

// entry point
+ (void)load;

// timer fire selector
+ (void)onTimerFired:(NSTimer *)timer;

// find the touchable views
+ (NSMutableArray*)validSubviewsOfView:(UIView*)root coverableViewsArray:(NSArray*)coverableViewsArray;

// hit-test simulate
+ (void)performActionWithValidViewArray:(NSArray*)validViewArray;

// simulate actions
+ (void)performActionOnView:(UIView*)view point:(CGPoint)point;

@end

@implementation SMSmartMonkey

+ (void)load
{
    NSLog(@"SmartMoneky has been loaded.");
    
    if (SM_ACTION_AT_STARTUP)
        [self startSmartMonkey:NO];
    
    srand(time(0));
}

#pragma mark - public methods

+ (void)startSmartMonkey:(BOOL)alert
{
    if (alert)
        [SMAlertView showAlert:@"start running"];
    
    NSTimeInterval waitForMainVCToComplete = SM_ACTION_INTERVAL;
    smTimer = [NSTimer scheduledTimerWithTimeInterval:waitForMainVCToComplete target:self selector:@selector(onTimerFired:) userInfo:nil repeats:YES];
}

+ (void)stopSmartMonkey
{
    [SMAlertView showAlert:@"stop running"];
    
    if (smTimer)
    {
        [smTimer invalidate];
        smTimer = nil;
    }
}

+ (BOOL)isSmartMonkeyRunning
{
    return smTimer != nil;
}

+ (void)switchStatus
{
    if ([self isSmartMonkeyRunning])
        [self stopSmartMonkey];
    else
        [self startSmartMonkey:YES];
}

#pragma mark - internal methods

+ (void)onTimerFired:(NSTimer *)timer
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    // get current valid subview
    NSMutableArray *validViewsArray = [NSMutableArray arrayWithArray:[self validSubviewsOfView:window coverableViewsArray:nil]];
    
    NSLog(@"Current has %d valid views.", [validViewsArray count]);
    if (validViewsArray.count == 0)
        return ;
    
//    [self printfViewArray:allSubviewsArray];
//    return ;
    
    [self performActionWithValidViewArray:validViewsArray];
}

+ (void)printfViewArray:(NSArray*)array
{
    NSUInteger i = 0;
    for (UIView* view in array)
    {
        NSLog(@"%dth view : %@", i, view);
        i++;
    }
}

// return the touchable views array of root, obj[0] > obj[1] > obj[2] …… and so on
+ (NSMutableArray*)validSubviewsOfView:(UIView*)root coverableViewsArray:(NSArray*)coverableViewsArray
{
    NSEnumerator *enumerator = [root.subviews reverseObjectEnumerator];
    
    // newCoverableViewsArray contains the siblings that may cover the current view
    NSMutableArray *newCoverableViewsArray = [NSMutableArray arrayWithArray:coverableViewsArray];
    NSMutableArray *validSubviewsArray = [NSMutableArray array];
    
    UIView *subview = nil;
    while ( subview = [enumerator nextObject])
    {
        if (subview.tag == SMTimeView_Tag)
            continue;
        
        if (subview.userInteractionEnabled == YES && subview.hidden == NO && subview.alpha > 0)
        {
            // if a control is not enabled, just abondon it
            if ([subview isKindOfClass:NSClassFromString(@"UIControl")] && [(UIControl*)subview isEnabled] == NO)
                continue;
                
            // if subview is not onscreen, just abandon it
            if ([subview isOnScreen] == NO)
                continue;
            
            // if subview isn't covered by siblings
            if ([subview notCoveredByViews:newCoverableViewsArray])
            {
                // find touchable subview
                [validSubviewsArray addObjectsFromArray:[self validSubviewsOfView:subview coverableViewsArray:newCoverableViewsArray]];
                
                // if subview isn't covered by its subviews
                if ([subview notCoveredBySubviews] && [self shouldNotExclude:subview])
                    [validSubviewsArray addObject:subview];
            }
            
            // if subview covers full screen
            if ([subview hasCoverFullScreen])
                break;
            
            [newCoverableViewsArray addObject:subview];
        }
    }
    return validSubviewsArray;
}

+ (void)performActionWithValidViewArray:(NSArray*)validViewArray
{
    if (validViewArray.count == 0)
        return ;
    
    NSEnumerator *enumerator = nil;
    while(1)
    {
        // random select a view
        NSUInteger index = (NSUInteger)random()%validViewArray.count;
        UIView *target = (UIView*)validViewArray[index];
        
        // generate a random point within the view
        CGPoint point = [SMAlgorithm randomPointOfView:target];
        
        // figure out who will handle this point
        enumerator = validViewArray.objectEnumerator;
        UIView *view = nil;
        while (view = [enumerator nextObject])
        {
            CGPoint localPoint = [view convertPoint:point fromView:target];
            if (CGRectContainsPoint(view.bounds, localPoint))
            {
                [self performActionOnView:view point:localPoint];
                return ;
            }
        }
    }
}

+ (BOOL)shouldNotExclude:(UIView*)view
{
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")])
        return NO;
    if ([view isKindOfClass:NSClassFromString(@"_UISwitchInternalView")])
        return NO;
    if ([view isKindOfClass:NSClassFromString(@"UIGroupTableViewCellBackground")])
        return NO;
    if ([view isKindOfClass:NSClassFromString(@"UITextFieldBorderView")])
        return NO;
    if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")])
        return NO;
    if ([view isKindOfClass:NSClassFromString(@"_UIWebViewScrollView")])
        return NO;
    
    return YES;
}

+ (void)performActionOnView:(UIView*)view point:(CGPoint)point
{
    NSLog(@"Select view : %@.", view);
    if ([view respondsToSelector:@selector(simulateActionWithPoint:)])
    {
        [view simulateActionWithPoint:point];
    }
    else
        NSAssert(0, @"This can't happen. If you down here, You may not include UIView+SMSmartMonkey files.");
}

@end
