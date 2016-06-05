//
//  NetworkingManager.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "NetworkingManager.h"
#import "AFNetworking.h"
@implementation NetworkingManager
+ (void)requestGETWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id))finish error:(void (^)(NSError *))conError {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //数据格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
    NSURLSessionDataTask *task = [manager GET:urlStr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        //调用block 将此类传到控制器
        finish(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //调用error block 将错误信息传递出去
        conError(error);
    }];
    [task resume];
}

+ (void)requestPOSTWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id))finish error:(void (^)(NSError *))conError {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript", nil];
    NSURLSessionDataTask *task =  [manager POST:urlStr parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        conError(error);
    }];
    [task resume];
}

@end
