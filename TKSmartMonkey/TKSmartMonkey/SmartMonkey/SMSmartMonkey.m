//
//  SMSmartMonkey.m
//
//  Created by tekka on 13-4-25.
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
    if ([view respondsToSelector:@selector(simulateAction)])
    {
        [view simulateAction];
    }
    else
        NSAssert(0, @"This can't happen. If you down here, You may not include UIView+SMSmartMonkey files.");
}

@end
