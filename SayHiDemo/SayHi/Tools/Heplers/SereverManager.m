//
//  SereverManager.m
//  LessonHuanXin_20
//
//  Created by lanouhn on 16/4/15.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "SereverManager.h"


@implementation SereverManager
+ (SereverManager *)sharedManager {
    static SereverManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SereverManager alloc]init];
    });return manager;
}


#pragma mark -- 实现注册方法
- (void)registerWithUserName:(NSString *)userName password:(NSString *)password complete:(void (^)(EMError *))complete {
    //DISPATCH_QUEUE_PRIORITY_DEFAULT是优先级选择，PRIORITY：优先。 0 是系统保留参数
    //将来这个block中的代码在子线程中执行，因为我们要在block中写向环信服务器发送注册用户的请求，并且以后还需要向自己公司做网络请求注册信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient]registerWithUsername:userName password:password];
        //回到主线程中执行block
        //规则性
        dispatch_async(dispatch_get_main_queue(), ^{
           //这个block中的代码在主线程执行
            //调用传递信息的block
            complete(error);//将错误信息返回给控制器
        });
    });
    
    
}

#pragma mark -- 登录
- (void)asyncLoginWithUserName:(NSString *)userName password:(NSString *)password complete:(void (^)(EMError *))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient]loginWithUsername:userName password:password];
        //回到主线程中执行block
        //规则性
        dispatch_async(dispatch_get_main_queue(), ^{
            //这个block中的代码在主线程执行
            //调用传递信息的block
            complete(error);//将错误信息返回给控制器
        });
    });

}
#pragma mark -- 添加好友
- (void)asyncAddContactWithUserName:(NSString *)userName message:(NSString *)message complete:(void (^)(EMError *))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].contactManager addContact:userName message:message];
        //回到主线程中执行block
        //规则性
        dispatch_async(dispatch_get_main_queue(), ^{
            //这个block中的代码在主线程执行
            //调用传递信息的block
            complete(error);//将错误信息返回给控制器
        });
    });


}

- (void)asyncDeleteContactWithContact:(NSString *)contact complete:(void (^)(EMError *))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:contact];
        //回到主线程中执行block
        //规则性
        dispatch_async(dispatch_get_main_queue(), ^{
            //这个block中的代码在主线程执行
            //调用传递信息的block
            complete(error);//将错误信息返回给控制器
        });
    });
}


@end
