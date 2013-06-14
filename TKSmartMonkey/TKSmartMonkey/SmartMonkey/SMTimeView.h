//
//  SMTimeView.h
//  BaiduBoxApp
//
//  Created by Tekka on 6/12/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

enum{
    SMTimeView_Tag = 66666
};

@interface SMTimeView : UILabel

+ (NSString*)runningTimeText;

@end
