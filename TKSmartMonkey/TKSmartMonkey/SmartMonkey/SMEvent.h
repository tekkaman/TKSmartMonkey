//
//  SMEvent.h
//
//  Created by tekka on 13-5-6.
//

#import <UIKit/UIKit.h>

@class SMTouch;

@interface SMEvent : UIEvent

// return a touch event
+ (id)eventForTouch;

// init timestamp
- (id)init;

// add a SMTouch obj into the receiver
- (void)addSMTouch:(SMTouch*)touch;

// simulated methods
- (UIEventType)type;
- (UIEventSubtype)subtype;
- (NSTimeInterval)timestamp;
- (NSSet *)allTouches;
- (NSSet *)touchesForWindow:(UIWindow *)window;
- (NSSet *)touchesForView:(UIView *)view;
- (NSInteger)_firstTouchForView:(UIView*)view;

@end
