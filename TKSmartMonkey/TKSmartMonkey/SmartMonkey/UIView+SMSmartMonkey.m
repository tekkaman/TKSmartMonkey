//
//  UIView+SMSmartMonkey.m
//  BaiduBoxApp
//
//  Created by tekka on 13-4-27.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "UIView+SMSmartMonkey.h"
#import "SMAlgorithm.h"

@implementation UIView (SMSmartMonkey)

#pragma mark - public methods

- (BOOL)isOnScreen
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect frame = [self convertRect:self.bounds toView:nil];
    
    NSInteger x0 = frame.origin.x;
    NSInteger x1 = x0 + frame.size.width;
    NSInteger y0 = frame.origin.y;
    NSInteger y1 = y0 + frame.size.height;
    
    if (x0 > window.bounds.size.width || x1 < 0)
        return NO;
    
    if (y0 > window.bounds.size.height || y1 < 0)
        return NO;
    
    return YES;
}

- (BOOL)hasCoverFullScreen
{
    CGRect myFrame = [self screenFrame];
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    
    return CGRectContainsRect(myFrame, screenFrame);
}

- (CGRect)screenFrame
{
    CGPoint center = [self convertPoint:self.center toView:nil];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    return CGRectMake(center.x - width/2, center.y - height/2, width, height);;
}

- (BOOL)notCoveredByViews:(NSArray*)viewsArray
{
    // 1.filter uninteracted views
    NSArray *filteredArray = [self filterUnintersectedViews:viewsArray];
    if (filteredArray.count == 0)
        return YES;
    
    // 2.statistics sorted x coordinate
    NSArray *sortedXArray = [self sortedXCoordinatesArray:filteredArray];
    
    // 3.divide rect using xArray and sort
    NSArray *sortedDividedRectsArray = [self divideSubviews:filteredArray by:sortedXArray];
    
    // 4.check not covered
    return ![self checkCoveredByRects:sortedDividedRectsArray];
}

- (BOOL)notCoveredBySubviews
{
    // UIButton will be covered by its pic, so just return YES
    if ([self isKindOfClass:[UIButton class]])
        return YES;
    
    return [self notCoveredByViews:self.subviews];
}

- (void)simulateAction
{
    NSUInteger maxKeyNum = 3;
    NSUInteger index = random()%maxKeyNum;
    
    index = 2;
    
    switch(index)
    {
        case 0:
            if ([self respondsToSelector:@selector(accessibilityScroll:)])
            {
                maxKeyNum = UIAccessibilityScrollDirectionPrevious;
                index = random()%maxKeyNum + 1;
                [self accessibilityScroll:index];
                break;
            }
        case 1:
            if ([self respondsToSelector:@selector(accessibilityPerformEscape)])
            {
                [self accessibilityPerformEscape];
                break;
            }
        case 2:
            if ([self respondsToSelector:@selector(accessibilityPerformMagicTap)])
            {
                [self accessibilityPerformMagicTap];
                break;
            }
    }

}

#pragma mark - internal methods

- (NSArray*)filterUnintersectedViews:(NSArray*)coverbilityViews
{
    NSMutableArray *filterArray = [NSMutableArray array];
    
    for (UIView *view in coverbilityViews)
    {
        if ([SMAlgorithm viewIntersected:self with:view])
            [filterArray addObject:view];
    }
    
    return filterArray;
}

// statistics sorted x coordinate
- (NSArray*)sortedXCoordinatesArray:(NSArray*)coverbilityViews
{
    NSMutableArray *sortedArray = [NSMutableArray array];
    
    for (UIView *coverView in coverbilityViews)
    {
        CGRect frame = [coverView convertRect:coverView.bounds toView:nil];
        
        NSInteger x0 = frame.origin.x;
        NSInteger x1 = x0 + frame.size.width;
        [sortedArray addObject:[NSNumber numberWithInteger:x0]];
        [sortedArray addObject:[NSNumber numberWithInteger:x1]];
    }
    
    [sortedArray sortUsingComparator:^(id obj0, id obj1){
        NSNumber* x0 = (NSNumber*)obj0;
        NSNumber* x1 = (NSNumber*)obj1;
        return [x0 compare:x1];
    }];
    
    return sortedArray;
}

// divide rect using xArray, return sorted array
- (NSArray*)divideSubviews:(NSArray*)coverbilityViews by:(NSArray*)sortedXArray
{
    NSInteger *sortedXNavArray = (NSInteger*)malloc(sortedXArray.count * sizeof(NSInteger));
    NSInteger index = 0;
    
    for (NSNumber *x in sortedXArray)
    {
        sortedXNavArray[index++] = [x integerValue];
    }
    
    // generate divied rects
    NSMutableArray *sortedDividedRects = [NSMutableArray array];
    for (UIView *subview in coverbilityViews)
    {
        CGRect frame = [subview convertRect:subview.bounds toView:nil];
        NSInteger x0 = frame.origin.x;
        NSInteger x1 = x0 + frame.size.width;
        NSInteger y0 = frame.origin.y;
        NSInteger y1 = y0 + frame.size.height;
        
        for (index = 0; index < sortedXArray.count; index++)
        {
            //NSLog(@"%f", sortedXNavArray[index]);
            if (sortedXNavArray[index] > x0 && sortedXNavArray[index] <= x1)
            {
                CGRect rect = CGRectMake(x0, y0, sortedXNavArray[index]-x0, y1-y0);
                [sortedDividedRects addObject:[NSValue valueWithCGRect:rect]];
                x0 = sortedXNavArray[index];
            }
            else if (sortedXNavArray[index] >= x1)
                break;
        }
    }
    
    free(sortedXNavArray);
    
    // sort rects
    [sortedDividedRects sortUsingComparator:^(id obj0, id obj1){
        CGRect rect0 = [(NSValue*)obj0 CGRectValue];
        CGRect rect1 = [(NSValue*)obj1 CGRectValue];
        
        if (rect0.origin.x < rect1.origin.x)
            return NSOrderedAscending;
        if (rect0.origin.x > rect1.origin.x)
            return NSOrderedDescending;
        if (rect0.origin.y < rect1.origin.y)
            return NSOrderedAscending;
        if (rect0.origin.y > rect1.origin.y)
            return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    
    return sortedDividedRects;
}

- (BOOL)checkCoveredByRects:(NSArray*)rectsArray
{
    CGRect frame = [self convertRect:self.bounds toView:nil];
    NSInteger x0 = frame.origin.x;
    NSInteger x1 = x0 + frame.size.width;
    NSInteger y0 = frame.origin.y;
    NSInteger y1 = y0 + frame.size.height;
    
    NSUInteger rectsNum = rectsArray.count;
    NSUInteger index = 0;
    NSInteger x, y, width, heigth;
    NSInteger coveredX, coveredY;
    
    while (index < rectsNum)
    {
        CGRect rect = [(NSValue*)rectsArray[index++] CGRectValue];
        x = rect.origin.x;
        y = rect.origin.y;
        width = rect.size.width;
        heigth = rect.size.height;
        
        if ([SMAlgorithm rectIntersected:frame with:rect] == NO)
            continue;
        
        // the first y does not cover the start point, so not covered
        if (y > frame.origin.y)
            return NO;
        
        y = y + rect.size.height;
        
        coveredY = y;
        coveredX = x + width;
        
        CGRect nextRect;
        while(1)
        {
            if (index >= rectsNum)
                break;
            
            nextRect = [(NSValue*)rectsArray[index] CGRectValue];
            if (nextRect.origin.x != x)
                break;
            
            // y does not successive, we confirm that coveration does not happen
            if (nextRect.origin.y > y && nextRect.origin.y > y0 && nextRect.origin.y + 1 < y1 )
                return NO;
            
            y = nextRect.origin.y + nextRect.size.height;
            index++;
        }
        
        // x does not succesive, we confirm that coveration does not happen
        if (nextRect.origin.x > x + width)
            return NO;
        
        // all the successive y can not cover the region
        if (y + 1 < y1)
            return NO;
        
        coveredY = y;
        coveredX = x + width;
    }
    
    if (coveredY >= y1 && coveredX >= x1)
        return YES;
    
    return NO;
}

@end
