//
//  UIButton+Action.h
//  LessonNavigation_07
//
//  Created by lanouhn on 16/3/2.
//  Copyright © 2016年 LiuGuoDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Action)

+ (UIButton *)setButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;



@end
