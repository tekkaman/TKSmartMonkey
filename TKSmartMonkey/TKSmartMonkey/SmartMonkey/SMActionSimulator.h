//
//  SMActionSimulator.h
//
//  Created by tekka on 13-4-27.
//

#import <Foundation/Foundation.h>

@interface SMActionSimulator : NSObject

// 对view随机模拟一种行为
+ (void)randomSimulateActionOnView:(UIView*)view;

// 对view模拟单击
+ (void)simualteTapOnView:(UIView*)view;

@end
