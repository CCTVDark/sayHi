//
//  HeaderView.h
//  SayHi
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UIButton *barcode2D;
@property (strong, nonatomic) IBOutlet UILabel *signature;
@property (nonatomic, copy)void(^block)();



@end
