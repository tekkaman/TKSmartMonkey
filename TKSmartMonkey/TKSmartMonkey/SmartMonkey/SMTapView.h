//
//  SMTapView.h
//
//  Created by tekka on 13-6-9.
//

#import <UIKit/UIKit.h>

@interface SMTapView : UIView

// show tap-view on wnd with specified point
+ (void)showTapAtPoint:(CGPoint)point;

// show tap-view on wnd with specified point, first convert point into wnd system
+ (void)showTapAtPoint:(CGPoint)point fromView:(UIView*)view;

// show long-press-view on wnd with specified point
+ (void)showLongPressAtPoint:(CGPoint)point;

// show long-press-view on wnd with specified point, first convert point into wnd system
+ (void)showLongPressAtPoint:(CGPoint)point fromeView:(UIView*)view;

@end
