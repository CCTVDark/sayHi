//
//  SereverManager.h
//  LessonHuanXin_20
//
//  Created by lanouhn on 16/4/15.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSDK.h"
//在这封装登录、注册、添加好友事件
@interface SereverManager : NSObject
//单例方法
+ (SereverManager *)sharedManager;
//封装注册方法
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password complete:(void(^)(EMError *error))complete;
//封装登录方法
- (void)asyncLoginWithUserName:(NSString *)userName password:(NSString *)password complete:(void(^)(EMError *error))complete;
//封装异步添加好友的方法
- (void)asyncAddContactWithUserName:(NSString *)userName message:(NSString *)message complete:(void(^)(EMError *error))complete;
//封装异步删除好友的方法
- (void)asyncDeleteContactWithContact:(NSString *)contact complete:(void(^)(EMError *error))complete;

@end
