//
//  SMTimeView.m
//
//  Created by Tekka on 6/12/13.
//

#import "SMTimeView.h"
#import "SMSmartMonkey.h"

static SMTimeView* timeView = nil;
static NSDate* startupDate = nil;
static NSTimeInterval accTimeInterval = 0;

@interface SMTimeView ()

@property (nonatomic, retain) UITapGestureRecognizer* tapGesRecgnizer;

@end

@implementation SMTimeView

+ (void)load
{
    startupDate = [[NSDate date] retain];
    
    // every 1 sec to update timeView
    const NSTimeInterval interval = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateTimeView:) userInfo:nil repeats:YES];
}

+ (void)updateTimeView:(NSTimer *)timer
{    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (window == nil)
    {
        NSLog(@"window is nil");
        return ;
    }
    
    if (timeView == nil)
    {
        CGRect tvFrame = CGRectMake((320-120)/2, 20, 120, 50);
        timeView = [[SMTimeView alloc] initWithFrame:tvFrame];
        [window addSubview:timeView];
    }
    
    if (timeView.superview == nil)
        [window addSubview:timeView];

    timeView.text = [self runningTimeText];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.font = [UIFont fontWithName:@"Courier New" size:20];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        self.tag = SMTimeView_Tag;
        
        _tapGesRecgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(udpateSmartMonkey:)];
        [self addGestureRecognizer:_tapGesRecgnizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    self.tapGesRecgnizer = nil;
    [super dealloc];
}

#pragma mark - notification

- (void)didBecomeActive:(id)sender
{
    startupDate = [[NSDate date] retain];
}

- (void)willResignActive:(id)sender
{
    accTimeInterval += [SMTimeView runningTimeInterval];
}

#pragma mark - tools methods

+ (NSString*)runningTimeText
{
    // 60 = 1m, 60*60 = 1h
    const NSUInteger miniteInterval = 60;
    const NSUInteger hourInterval = miniteInterval*60;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startupDate] + accTimeInterval;
    NSUInteger hour = timeInterval/hourInterval;
    NSUInteger min = (timeInterval - hour*60)/miniteInterval;
    NSUInteger sec = (timeInterval - min*60);
    NSString* text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
    
    return text;
}

+ (NSTimeInterval)runningTimeInterval
{
    return [[NSDate date] timeIntervalSinceDate:startupDate];
}


- (IBAction)udpateSmartMonkey:(id)sender
{
    [SMSmartMonkey switchStatus];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
