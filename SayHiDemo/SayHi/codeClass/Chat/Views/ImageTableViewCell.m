//
//  ImageTableViewCell.m
//  SayHi
//
//  Created by lanouhn on 16/5/15.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "ImageTableViewCell.h"

@implementation ImageTableViewCell

- (void)awakeFromNib {
    self.ChatimageView.layer.cornerRadius = 10.f;
    self.ChatimageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
