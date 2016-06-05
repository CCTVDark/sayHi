//
//  ContactViewCell.h
//  SayHi
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;
@property (strong, nonatomic) IBOutlet UILabel *onLineLabel;
@property (strong, nonatomic) IBOutlet UILabel *SignatureLabel;

@end
