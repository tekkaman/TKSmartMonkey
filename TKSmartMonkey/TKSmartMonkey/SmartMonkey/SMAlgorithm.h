//
//  SMAlgorithm.h
//  BaiduBoxApp
//
//  Created by tekka on 13-4-26.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAlgorithm : NSObject

// whether these two view intersect
+ (BOOL)viewIntersected:(UIView*)view1 with:(UIView*)view2;

// whether these two rect intersect
+ (BOOL)rectIntersected:(CGRect)rect1 with:(CGRect)rect2;

@end

