//
//  UIButton+Action.m
//  LessonNavigation_07
//
//  Created by lanouhn on 16/3/2.
//  Copyright © 2016年 LiuGuoDong. All rights reserved.
//

#import "UIButton+Action.h"

@implementation UIButton (Action)
+ (UIButton *)setButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    //button.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
    //添加事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}



@end
