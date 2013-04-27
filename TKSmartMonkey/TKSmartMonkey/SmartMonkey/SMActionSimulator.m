//
//  SMActionSimulator.m
//
//  Created by tekka on 13-4-27.
//

#import "SMActionSimulator.h"

@implementation SMActionSimulator

+ (void)randomSimulateActionOnView:(UIView*)view
{
    NSUInteger index = random()%1;
    
    switch (index) {
        case 0:
            [self simualteTapOnView:view];
            break;
            break;
        default:
            break;
    }
}

+ (void)simualteTapOnView:(UIView*)view
{
    //UITouch *touchBegan = [UITouch touch]
    //[view touchesBegan:<#(NSSet *)#> withEvent:<#(UIEvent *)#>]
}

@end
