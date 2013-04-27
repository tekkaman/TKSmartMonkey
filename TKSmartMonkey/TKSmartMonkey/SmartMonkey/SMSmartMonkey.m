//
//  SMSmartMonkey.m
//  BaiduBoxApp
//
//  Created by tekka on 13-4-25.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "SMSmartMonkey.h"
#import "SMAlgorithm.h"
#import "UIView+SMSmartMonkey.h"
#import "SMConfig.h"

@interface SMSmartMonkey ()

// entry point
+ (void)load;

// timer fire selector
+ (void)startSmartMoneky:(NSTimer *)timer;

// find the touchable views
+ (NSMutableArray*)validSubviewsOfView:(UIView*)root coverableViewsArray:(NSArray*)coverableViewsArray;

// simulate actions
+ (void)performActionOnView:(UIView*)view;

// simulate control event
+ (void)sendControlEvent:(UIControlEvents)events withSender:(UIControl*)sender;

// simulate view actions
+ (void)actionOnView:(UIView*)view;

@end

@implementation SMSmartMonkey

+ (void)load
{
    NSLog(@"SmartMoneky has been loaded.");
    
    NSTimeInterval waitForMainVCToComplete = SM_ACTION_INTERVAL;
    [NSTimer scheduledTimerWithTimeInterval:waitForMainVCToComplete target:self selector:@selector(startSmartMoneky:) userInfo:nil repeats:YES];
    
    srand(time(0));
}

+ (void)startSmartMoneky:(NSTimer *)timer
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];

    // get current valid subview
    NSMutableArray *allSubviewsArray = [NSMutableArray arrayWithArray:[self validSubviewsOfView:window coverableViewsArray:nil]];
    
    NSLog(@"Current has %d valid views.", [allSubviewsArray count]);
    NSAssert(allSubviewsArray.count, @"Every scene have at least one view can be operated. It seems that the algorithm get error");
    
    // random select one view to perform action on
    NSUInteger index = rand()%allSubviewsArray.count;
    UIView *selectedView = allSubviewsArray[index];
    NSLog(@"Select view : %@.", selectedView);
    
    [self performActionOnView:selectedView];
}

// return the touchable views array of root
+ (NSMutableArray*)validSubviewsOfView:(UIView*)root coverableViewsArray:(NSArray*)coverableViewsArray
{
    NSEnumerator *enumerator = [root.subviews reverseObjectEnumerator];
    
    // newCoverableViewsArray contains the siblings that may cover the current view
    NSMutableArray *newCoverableViewsArray = [NSMutableArray arrayWithArray:coverableViewsArray];
    NSMutableArray *validSubviewsArray = [NSMutableArray array];
    
    UIView *subview = nil;
    while ( subview = [enumerator nextObject])
    {
        if (subview.userInteractionEnabled == YES && subview.hidden == NO)
        {
            // if subview is not onscreen, jsut abandon it
            if ([subview isOnScreen] == NO)
                continue;
            
            // if subview isn't covered by siblings
            if ([subview notCoveredByViews:newCoverableViewsArray])
            {
                // if subview isn't covered by its subviews
                if ([subview notCoveredBySubviews])
                    [validSubviewsArray addObject:subview];
                
                // find touchable subview
                [validSubviewsArray addObjectsFromArray:[self validSubviewsOfView:subview coverableViewsArray:newCoverableViewsArray]];
            }
            
            // if subview covers full screen
            if ([subview hasCoverFullScreen])
                break;
            
            [newCoverableViewsArray addObject:subview];
        }
    }
    return validSubviewsArray;
}

+ (void)performActionOnView:(UIView*)view
{
    if ([view isKindOfClass:[UIControl class]] == YES)
    {
        // if view is a UIControl
        UIControl *control = (UIControl*)view;
        UIControlEvents events = [control allControlEvents];
        
        if (events)
        {
            [self sendControlEvent:events withSender:control];
            return ;
        }
    }

    // if view is not a UIControl
    [self actionOnView:view];
}

+ (void)sendControlEvent:(UIControlEvents)events withSender:(UIControl*)sender
{
    NSUInteger maxKeyNum = UIControlEventEditingDidEndOnExit;
    NSUInteger index = random()%maxKeyNum;
    UIControlEvents event;
    
    while(1)
    {
        if (events & (1<<index))
        {
            event = (1<<index);
            [sender sendActionsForControlEvents:event];
            return ;
        }
        
        if (++index == maxKeyNum)
            index = 0;
    }
}

+ (void)actionOnView:(UIView*)view
{
    NSUInteger maxKeyNum = 3;
    NSUInteger index = random()%maxKeyNum;
    
    switch(index)
    {
        case 0:
            if ([view respondsToSelector:@selector(accessibilityScroll:)])
            {
                maxKeyNum = UIAccessibilityScrollDirectionPrevious;
                index = random()%maxKeyNum + 1;
                [view accessibilityScroll:index];
                break;
            }
        case 1:
            if ([view respondsToSelector:@selector(accessibilityPerformEscape)])
            {
                [view accessibilityPerformEscape];
                break;
            }
        case 2:
            if ([view respondsToSelector:@selector(accessibilityPerformMagicTap)])
            {
                [self accessibilityPerformMagicTap];
                break;
            }
    }
}

@end
