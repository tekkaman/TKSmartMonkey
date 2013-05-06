//
//  SMActionDirector.h
//  BaiduBoxApp
//
//  Created by tekka on 13-5-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMActionDirector : NSObject

// return the number of actions
+ (NSInteger)actionCount;

// perform one-finger tap on view
+ (void)actOneFingerTapOnView:(UIView*)view;

// perform one-finger scroll on view
+ (void)actOneFingerScrollOnView:(UIView*)view;

@end
