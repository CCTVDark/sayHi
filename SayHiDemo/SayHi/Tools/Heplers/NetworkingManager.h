//
//  NetworkingManager.h
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingManager : NSObject
/*GET请求方式
 *
 *@param urlStr 请求地址
 *@param dic 请求连接的参数
 *@param finish 请求成功后的回调
 *@param error 请求失败后的回调
*/
+ (void)requestGETWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id responseObject))finish error:(void (^)(NSError *error))conError;
+ (void)requestPOSTWithUrlString:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void (^)(id))finish error:(void (^)(NSError *))conError;


@end
