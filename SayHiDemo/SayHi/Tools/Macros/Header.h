//
//  Header.h
//  SayHi
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#ifndef Header_h
#define Header_h
//header.h 文件 一般用于添加宏定义 以及一些常用的数据
//屏幕的宽度
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
//屏幕的高度
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
//frame适应导航栏64
#define kFrame CGRectMake(0, 64, kDeviceWidth, kDeviceHeight - 64 - 49)
#define kFrameTwo CGRectMake(0, 64, kDeviceWidth, kDeviceHeight  - 64 - 30 - 30)
#endif /* Header_h */
