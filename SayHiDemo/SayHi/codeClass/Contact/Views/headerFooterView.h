//
//  headerFooterView.h
//  SayHi
//
//  Created by lanouhn on 16/5/24.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headerFooterView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UILabel *listLabel;
@property (nonatomic, copy)void(^block)(NSInteger section);
@property (strong, nonatomic) IBOutlet UIView *ThreadView;
@property (nonatomic, assign)NSInteger section;
@end
