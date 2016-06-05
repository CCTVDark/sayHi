//
//  ImageSelectManager.m
//  SayHi
//
//  Created by lanouhn on 16/5/15.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "ImageSelectManager.h"
#import "AppDelegate.h"
@implementation ImageSelectManager

+ (ImageSelectManager *)sharedManager {
    static ImageSelectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ImageSelectManager alloc]init];
    });return manager;
}

//封装头部视图，头像点击事件
- (void)headerImageTapAction:(BaseViewController *)VC {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *define = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [VC presentViewController:imagePicker animated:YES completion:nil];
    }];
    [alertC addAction:cancel];
    [alertC addAction:define];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertAction *Camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [VC presentViewController:imagePicker animated:YES completion:nil];
        }];
        
        [alertC addAction:Camera];
        
    }
   
    [VC presentViewController:alertC animated:YES completion:nil];
}

#pragma mark -- 相册选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *imagePicker = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@", NSHomeDirectory());
    
    NSData *fData = UIImageJPEGRepresentation(imagePicker, 0.2);
    UIImage *imageF = [UIImage imageWithData:fData];
   
    self.block(fData);
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
@end
