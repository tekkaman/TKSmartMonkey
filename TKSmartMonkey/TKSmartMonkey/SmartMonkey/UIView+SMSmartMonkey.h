//
//  UIView+SMSmartMonkey.h
//
//  Created by tekka on 13-4-27.
//

#import <UIKit/UIKit.h>

@interface UIView (SMSmartMonkey)

// whether receiver is within the screen boundary
- (BOOL)isOnScreen;

// whether receiver's frame has covered all screen
- (BOOL)hasCoverFullScreen;

// the frame that has converted to the screen coordinate
- (CGRect)screenFrame;

// whether receiver will be covered by viewsArray
- (BOOL)notCoveredByViews:(NSArray*)viewsArray;

// whetehr receiver will be covered by its subviews
- (BOOL)notCoveredBySubviews;

// simualte user behavior
- (void)simulateAction;

@end
