//
//  headerFooterView.m
//  SayHi
//
//  Created by lanouhn on 16/5/24.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "headerFooterView.h"

@implementation headerFooterView


- (void)awakeFromNib {

    self.headerImage.image = [UIImage imageNamed:@"close.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    self.block(self.section);
}

@end
