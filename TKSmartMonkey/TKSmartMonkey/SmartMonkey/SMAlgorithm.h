//
//  SMAlgorithm.h
//
//  Created by tekka on 13-4-26.
//

#import <Foundation/Foundation.h>

@interface SMAlgorithm : NSObject

// whether these two view intersect
+ (BOOL)viewIntersected:(UIView*)view1 with:(UIView*)view2;

// whether these two rect intersect
+ (BOOL)rectIntersected:(CGRect)rect1 with:(CGRect)rect2;

// generate a random point within a specified view
+ (CGPoint)randomPointOfView:(UIView*)view;

@end

