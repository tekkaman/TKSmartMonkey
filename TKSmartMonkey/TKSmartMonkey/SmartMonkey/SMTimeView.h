//
//  SMTimeView.h
//
//  Created by Tekka on 6/12/13.
//

#import <UIKit/UIKit.h>

enum{
    SMTimeView_Tag = 66666
};

@interface SMTimeView : UILabel

+ (NSString*)runningTimeText;

@end
