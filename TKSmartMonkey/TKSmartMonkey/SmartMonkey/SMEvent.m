//
//  SMEvent.m
//
//  Created by tekka on 13-5-6.
//

#import "SMEvent.h"

@interface SMEvent ()

@property (nonatomic, retain) NSMutableSet *smTouchSet;

@end

@implementation SMEvent
{
    NSTimeInterval _smTimestamp;
}

// return a touch event
+ (id)eventForTouch
{
    return [[[SMEvent alloc] init] autorelease];
}

#pragma mark - init & dealloc

- (id)init
{
    if (self = [super init])
    {
        _smTimestamp = [[NSProcessInfo processInfo] systemUptime];
        _smTouchSet = [[NSMutableSet set] retain];
    }
    return self;
}

- (void)dealloc
{
    self.smTouchSet = nil;
    [super dealloc];
}

// add a SMTouch obj into the receiver
- (void)addSMTouch:(SMTouch*)touch
{
    [_smTouchSet addObject:touch];
}

#pragma mark - simulate

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
    return [[_smTouchSet copy] autorelease];
}

// for simplification, just return all touches
- (NSSet *)touchesForView:(UIView *)view
{
    return [[_smTouchSet copy] autorelease];
}

- (NSInteger)_firstTouchForView:(UIView*)view
{
    return 0;
}
@end
