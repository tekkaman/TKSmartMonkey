//
//  SMAlgorithm.m
//
//  Created by tekka on 13-4-26.
//

#import "SMAlgorithm.h"

@implementation SMAlgorithm

+ (BOOL)viewIntersected:(UIView*)view1 with:(UIView*)view2;
{
    CGRect rect1 = [view1 convertRect:view1.bounds toView:nil];
    CGRect rect2 = [view2 convertRect:view2.bounds toView:nil];
    
    return [self rectIntersected:rect1 with:rect2];
}

+ (BOOL)rectIntersected:(CGRect)rect1 with:(CGRect)rect2;
{
    CGRect result = CGRectIntersection(rect1, rect2);
    
    return !CGRectIsNull(result);
}

+ (CGPoint)randomPointOfView:(UIView*)view
{
    return CGPointMake(random()%(NSInteger)view.bounds.size.width,
                       random()%(NSInteger)view.bounds.size.height);
}

@end
