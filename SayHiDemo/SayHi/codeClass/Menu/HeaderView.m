//
//  HeaderView.m
//  SayHi
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (void)awakeFromNib {
    self.frame = CGRectMake(0, 0, kDeviceWidth, 150);
    [self setHeaderImage];
    self.signature.text = @"专为测试环信开发";
    self.nickName.text = [[EMClient sharedClient] currentUsername];
}
#pragma mark -- 封装头像图片
- (void)setHeaderImage {
    self.headerImageView.userInteractionEnabled = YES;
    self.headerImageView.layer.cornerRadius = 40;
    self.headerImageView.layer.masksToBounds = YES;
    
    //去沙盒读取头像图片
    [self headerImageWithData];
    
    //为头像添加轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlephotos:)];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView addGestureRecognizer:tap];
}

//封装沙盒获取头像的方法
- (void)headerImageWithData {
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *imagePath = [cache stringByAppendingPathComponent:@"images"];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    NSKeyedUnarchiver *keyedUn = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    UIImage *image = [keyedUn decodeObjectForKey:@"image"];
    [keyedUn finishDecoding];
    if (image) {
        self.headerImageView.image = image;
    }

}

#pragma mark -- 轻拍手势的实现
- (void)handlephotos:(UITapGestureRecognizer *)sender {
    //从MenuViewController回调照册方法
    self.block();
}

#pragma mark -- 相册选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *imagePicker = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@", NSHomeDirectory());
    
    NSData *fData = UIImageJPEGRepresentation(imagePicker, 0.5);
    UIImage *imageF = [UIImage imageWithData:fData];
    self.headerImageView.image = imageF;
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *imagePath = [cache stringByAppendingPathComponent:@"images"];
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:imageF forKey:@"image"];
    [archiver finishEncoding];
    BOOL isSuccess = [data writeToFile:imagePath atomically:YES];
    NSLog(isSuccess ? @"yes" : @"no");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)barcode2DAction:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //这里是子线程区域
        //向服务器发送退出登陆的方法
        EMError *error = [[EMClient sharedClient] logout:YES];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                NSLog(@"退出成功");
                //返回登陆界面
                AppDelegate *APP = [UIApplication sharedApplication].delegate;
                [APP setLogin];
                
            } else {
                NSLog(@"退出失败");
            }
        });
    });
}



@end
