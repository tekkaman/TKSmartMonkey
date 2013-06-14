//
//  SMActionDirector.h
//  BaiduBoxApp
//
//  Created by tekka on 13-5-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMActionProtocol <NSObject>
// simulate action on self with point
- (void)simulateActionWithPoint:(CGPoint)point;
@end

@interface SMActionDirector : NSObject

// return the number of actions
+ (NSInteger)actionCount;

// perform one-finger tap on view (with specified point)
+ (void)actOneFingerTapOnView:(UIView*)view;
+ (void)actOneFingerTapOnView:(UIView*)view point:(CGPoint)point;

// perform one-finger long press on view (with specified point)
+ (void)actOneFingerLongPressOnView:(UIView*)view;
+ (void)actOneFingerLongPressOnView:(UIView*)view point:(CGPoint)point;

// perform one-finger scroll on view (with start point)
+ (void)actOneFingerScrollOnView:(UIView*)view;
+ (void)actOneFingerScrollOnView:(UIView*)view startPoint:(CGPoint)point;

// perform one-finger twist on view (with statr point)
+ (void)actOneFingerTwistOnView:(UIView*)view;
+ (void)actOneFingerTwistOnView:(UIView*)view startPoint:(CGPoint)point;

@end
