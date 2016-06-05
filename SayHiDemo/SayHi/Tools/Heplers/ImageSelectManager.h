//
//  ImageSelectManager.h
//  SayHi
//
//  Created by lanouhn on 16/5/15.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
@interface ImageSelectManager : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
+ (ImageSelectManager *)sharedManager;
@property (nonatomic, strong)void(^block)(NSData *data);
- (void)headerImageTapAction:(BaseViewController *)VC;
@end
