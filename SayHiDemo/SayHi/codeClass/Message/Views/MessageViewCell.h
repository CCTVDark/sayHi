//
//  MessageViewCell.h
//  SayHi
//
//  Created by lanouhn on 16/5/19.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nickLabel;
@property (strong, nonatomic) IBOutlet UILabel *onLineLabel;
@property (strong, nonatomic) IBOutlet UILabel *SignatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageCount;

@end
