//
//  SMEvent.m
//  BaiduBoxApp
//
//  Created by tekka on 13-5-6.
//  Copyright (c) 2013年 Baidu. All rights reserved.
//

#import "SMEvent.h"

@implementation SMEvent
{
    NSTimeInterval _smTimestamp;
    NSMutableSet* _smTouchSet;
}

// return a touch event
+ (id)eventForTouch
{
    SMEvent *event = [[SMEvent alloc] init];
    return [event autorelease];
}

// init timestamp
- (id)init
{
    if (self = [super init])
    {
        _smTimestamp = [[NSProcessInfo processInfo] systemUptime];
        _smTouchSet = [NSMutableSet set];
    }
    return self;
}

- (void)dealloc
{
    [NSMutableSet release];
    [super dealloc];
}

// add a SMTouch obj into the receiver
- (void)addSMTouch:(SMTouch*)touch
{
    [_smTouchSet addObject:touch];
}

- (UIEventType)type
{
    return UIEventTypeTouches;
}

- (UIEventSubtype)subtype
{
    return UIEventSubtypeNone;
}

- (NSTimeInterval)timestamp
{
    return _smTimestamp;
}

- (NSSet *)allTouches
{
    return _smTouchSet;
}

- (NSSet *)touchesForWindow:(UIWindow *)window
{
    return [_smTouchSet copy];
}

// for simplification, just return all touches
- (NSSet *)touchesForView:(UIView *)view
{
    return [_smTouchSet copy];
}

- (NSInteger)_firstTouchForView:(UIView*)view
{
    return 0;
}
@end
