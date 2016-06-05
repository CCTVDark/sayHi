//
//  ChatViewController.h
//  SayHi
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "BaseViewController.h"
#import "EMSDK.h"
typedef NS_ENUM(NSInteger, ChatType) {
    ChatTypeText,//文字
    ChatTypeImage,//图片
    ChatTypeVoice//音频
};
@interface ChatViewController : BaseViewController
@property (nonatomic, strong)NSString *tempName;
//消息类型
@property (nonatomic, assign)ChatType chatType;
//会话对象，用于管理消息
@property (nonatomic, strong)EMConversation *conversation;
//群组对象
@property (nonatomic, strong)EMGroup *group;
@end
