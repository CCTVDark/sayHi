//
//  ContactViewCell.m
//  SayHi
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "ContactViewCell.h"

@implementation ContactViewCell

- (void)awakeFromNib {
    self.headerImageView.layer.cornerRadius = 25;
    self.headerImageView.layer.masksToBounds = YES;
}
- (IBAction)callAction:(UIButton *)sender {
    ChatCallController *callVC = [[ChatCallController alloc]init];
    callVC.tempName = self.nickLabel.text;
    ContactViewController *contactVC = nil;
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[ContactViewController class]]) {
         contactVC = (ContactViewController *)nextResponder;
            
        }
    }
    [contactVC presentViewController:callVC animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
