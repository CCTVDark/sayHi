//
//  MessageViewController.m
//  SayHi
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageViewCell.h"
#import "ChatViewController.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation MessageViewController

#pragma mark -- 配置tabBarItem
- (void)awakeFromNib {
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:@"message@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"message@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(9, 0, -9, 0);
    // 抽屉菜单button
    self.navigationItem.leftBarButtonItem = [self showLeftBarButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置视图
    [self setRootViews];
    //这步必须，因为要去数据库加载group
    //NSArray *groupList = [[EMClient sharedClient].groupManager loadAllMyGroupsFromDB];
   
}
//视图将要出现加载消息列表
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    //NSLog(@"%@",conversations);
    self.dataArray = [NSMutableArray arrayWithArray:conversations];
    [self.tableView reloadData];
}
- (void)setRootViews {
    [self showProgressHUD];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //表视图
    self.tableView = [[UITableView alloc]initWithFrame:kFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak MessageViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
             weakSelf.dataArray = [NSMutableArray arrayWithArray:conversations];
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.tableView reloadData];
                [weakSelf.tableView headerEndRefreshing];
                [weakSelf hideProgressHUD];
            });
            
        });
    }];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"messageViewCell"];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70;
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMConversation *conver = self.dataArray[indexPath.row];
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageViewCell" forIndexPath:indexPath];
    cell.messageCount.text = [NSString stringWithFormat:@"%d", [conver unreadMessagesCount]];
    if (conver.unreadMessagesCount == 0) {
        cell.messageCount.textColor = [UIColor blackColor];
        cell.messageCount.alpha = 0.5;
    }
    if (conver.type == EMChatTypeGroupChat) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:conver.conversationId includeMembersList:YES error:nil];
//            EMGroup *group = [EMGroup groupWithId:conver.conversationId];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.nickLabel.text = group.subject;
                cell.onLineLabel.text = @"群组";
            });
        });
    }else {
         cell.nickLabel.text = conver.conversationId;
        cell.onLineLabel.text = @"好友";
    }
   
    EMMessage *message = [conver latestMessage];
    EMMessageBody *msgBody = message.body;
  if (msgBody.type == EMMessageBodyTypeText) {
      cell.SignatureLabel.text = [self getInfoFromMessage:message];
  }else if(msgBody.type == EMMessageBodyTypeVoice){
      EMVoiceMessageBody *body = ((EMVoiceMessageBody *)msgBody);
      
      cell.SignatureLabel.text = body.displayName;
  }else {
      EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
      cell.SignatureLabel.text = body.displayName;
  }
    cell.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:232 / 255.0 blue:238 / 255.0 alpha:1];
    return cell;
}
#pragma mark -- 封装从Message 中获取聊天信息的方法
- (NSString *)getInfoFromMessage:(EMMessage *)message {
    EMMessageBody *messageBody = message.body;
    //获取文字信息
    EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
    //获取聊天信息
    NSString *text = textBody.text;
    return text;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *chatVC = [ChatViewController new];
    EMConversation *conver = self.dataArray[indexPath.row];
    BOOL isRead = [conver markAllMessagesAsRead];
    if (!isRead) {
        NSLog(@"清除信息未读失败");
    }
    chatVC.conversation = conver;
    chatVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    chatVC.tempName = conver.conversationId;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    chatVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [app.window.rootViewController presentViewController:chatVC animated:YES completion:nil];
}

@end
