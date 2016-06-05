//
//  GroupViewCell.h
//  SayHi
//
//  Created by lanouhn on 16/5/21.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMGroup.h"
@interface GroupViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *GroupName;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *abountLabel;
@property (strong, nonatomic) IBOutlet UILabel *GroupType;
@property (nonatomic, strong) EMGroup *group;
@end
