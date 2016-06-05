//
//  DynamicViewController.m
//  SayHi
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "DynamicViewController.h"
#import "GroupViewCell.h"
#import "WBPopMenuSingleton.h"
#import "WBPopMenuModel.h"

@interface DynamicViewController ()<UITableViewDataSource,UITableViewDelegate,EMGroupManagerDelegate,IEMGroupManager>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger isRight;
@property (nonatomic, strong)UITableView *menuView;
//会话对象，用于管理消息
@property (nonatomic, strong)EMConversation *conversation;
@end

@implementation DynamicViewController
#pragma mark -- 配置tabBarItem
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:@"dynamic@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"dynamic@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(9, 0, -9, 0);
        // 抽屉菜单button
        //左
        self.navigationItem.leftBarButtonItem = [self showLeftBarButton];
        //右
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Add@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(showRight:)];
        self.navigationItem.rightBarButtonItem = button;
        self.isRight = 0;
    }return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray = [NSMutableArray array];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:kFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupViewCell" bundle:nil] forCellReuseIdentifier:@"groupViewCell"];
    __weak DynamicViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf setListGroup];
    }];
    [self.view addSubview:self.tableView];
    [self showProgressHUD];
    [self setListGroup];
#pragma mark -- appDelegate收到群组邀请请求回调方法中的block实现

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app setGroupBlock:^(EMGroup *group) {
        [self insertIntoDataWithGroup:group];
    }];
}
#pragma mark -- 获取群组列表
- (void)setListGroup {

     //[[EMClient sharedClient].groupManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //NSArray *groupList = [[EMClient sharedClient].groupManager loadAllMyGroupsFromDB];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *groupList = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:nil];
        self.dataArray = [NSMutableArray arrayWithArray:groupList];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
            [self hideProgressHUD];
            [self.tableView headerEndRefreshing];
        });
        
    });

 
//    //1.创建并行队列
//    dispatch_queue_t queue = dispatch_queue_create("afda", DISPATCH_QUEUE_CONCURRENT);
//    
//    //2.创建分组
//    dispatch_group_t group = dispatch_group_create();
//    //3.往分组中添加异步任务
//        for (EMGroup *Group in groupList) {
//            //EMGroup *tempGroup = [EMGroup groupWithId:Group.groupId];
//            dispatch_group_async(group, queue, ^{
//                EMGroup  *tempGroup = [[EMClient sharedClient].groupManager fetchGroupInfo:Group.groupId includeMembersList:YES error:nil];
//                [self.dataArray addObject:tempGroup];
//                // NSLog(@"---%@",tempGroup.occupants);
//            });
//           
//        }
//    //线程组队列运行完毕后方法
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
//      [self.tableView reloadData];
//    });
//       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//      for (EMGroup *Group in groupList) {
//          EMGroup *tempGroup = [EMGroup groupWithId:Group.groupId];
//        
//        [self.dataArray addObject:tempGroup];
//                           NSLog(@"---%@",tempGroup.occupants);
//      }
//           dispatch_async(dispatch_get_main_queue(), ^{
//               [self.tableView reloadData];
//           });
//           
//           
//       });
}
#pragma mark -- 右导航菜单View
- (void)setMenuView {
    
    NSMutableArray *obj = [NSMutableArray array];
    NSArray *titles = @[@"创建群组", @"加入群组"];
    NSArray *images = @[@"right_menu_facetoface@3x", @"right_menu_addFri@3x"];
    for (NSInteger i = 0; i < titles.count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = images[i];
        info.title = titles[i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:150
                                                             item:obj
                                                           action:^(NSInteger index) {
                                                               NSLog(@"index:%ld",(long)index);
                                                               if (index == 0) {
                                                                   [self createGroup];
                                                                   
                                                               }else {
                                                                   [self searchGroup];
                                                               }
                                                           }];

    

    [self.view addSubview:self.menuView];
}


#pragma mark -- 右导航button点击事件
- (void)showRight:(UIBarButtonItem *)sender {
    [self setMenuView];
    
}
#pragma mark -- 创建群组
- (void)createGroup {
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"创建群"preferredStyle:UIAlertControllerStyleAlert];
    //  设置两个输入框
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入群名";
        
    }];
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入群简介";
        
    }];
    //  取消事件
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //  确定事件
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //向服务器发送添加好友的方法
        //1.获取输入框的信息
        NSArray *array = control.textFields;
        UITextField *textfield = array[0];
        UITextField *textfield2 = array[1];
        //发送请求
        EMError *error = nil;
        EMGroupOptions *setting = [[EMGroupOptions alloc] init];
        setting.maxUsersCount = 500;
        setting.style = EMGroupStylePublicJoinNeedApproval;// 创建不同类型的群组，这里需要才传入不同的类型
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:textfield.text description:textfield2.text invitees:nil message:@"邀请您加入群组" setting:setting error:&error];
        if(!error){
            NSLog(@"创建成功 -- %@",group);
            [self insertIntoDataWithGroup:group];
        }
    }];
    [control addAction:cancel];
    [control addAction:confirm];
    //  弹出警示框
    [self presentViewController:control animated:YES completion:nil];
   
}
#pragma mark -- 加入群组
- (void)searchGroup {
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"加入群组"preferredStyle:UIAlertControllerStyleAlert];
    //  设置两个输入框
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入要加入的群组";
        
    }];
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入请求信息";
        
    }];
    //  取消事件
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //  确定事件
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //向服务器发送添加好友的方法
        //1.获取输入框的信息
        NSArray *array = control.textFields;
        UITextField *textfield = array[0];
        UITextField *textfield2 = array[1];
        //发送请求
        // 申请加入需要审核的公开群组
        EMError *error = nil;
        EMGroup  *tempGroup = [[EMClient sharedClient].groupManager fetchGroupInfo:textfield.text includeMembersList:NO error:nil];
        EMGroupOptions *Options = tempGroup.setting;
        if (Options.style == EMGroupStylePublicJoinNeedApproval) {
            [[EMClient sharedClient].groupManager applyJoinPublicGroup:textfield.text message:textfield2.text error:&error];
            if (error) {
                NSLog(@"%@", error);
            }else {
                NSLog(@"发送成功");
            }
            
        }else if (Options.style == EMGroupStylePublicOpenJoin) {
            [[EMClient sharedClient].groupManager joinPublicGroup:textfield.text error:&error];
            if (error) {
                NSLog(@"%@", error);
            }else {
                NSLog(@"发送成功");
            }
        }
        
        
    }];
    [control addAction:cancel];
    [control addAction:confirm];
    //  弹出警示框
    [self presentViewController:control animated:YES completion:nil];
}
#pragma mark -- 配置Cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupViewCell" forIndexPath:indexPath];
    EMGroup *tempGroup = [self.dataArray objectAtIndex:indexPath.row];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    EMGroup  *tempGroup = [[EMClient sharedClient].groupManager fetchGroupInfo:group.groupId includeMembersList:YES error:nil];
            cell.GroupName.text = tempGroup.subject;
            if (tempGroup.isPublic) {
                cell.GroupType.text = @"公开群";
            }else {
                cell.GroupType.text = @"不公开";
            }
            cell.abountLabel.text = tempGroup.description;
            cell.countLabel.text = [NSString stringWithFormat:@"%ld", tempGroup.occupantsCount];
            cell.group = tempGroup;
   //});
   
  cell.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:232 / 255.0 blue:238 / 255.0 alpha:1];
    return cell;
}
#pragma mark -- Cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EMGroup *tempGroup = [self.dataArray objectAtIndex:indexPath.row];
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    chatVC.group = tempGroup;
    chatVC.conversation = [[EMClient sharedClient].chatManager getConversation:tempGroup.groupId type:EMConversationTypeGroupChat createIfNotExist:YES];
    chatVC.tempName = tempGroup.groupId;
    NSLog(@"%@",tempGroup.groupId);
    chatVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:chatVC animated:YES completion:nil];
}


#pragma mark -- 插入群组
- (void)insertIntoDataWithGroup:(EMGroup *)group {
    for (EMGroup *tempGroup in self.dataArray) {
        if ([tempGroup.groupId isEqualToString:group.groupId]) {
            return;
        }
    }
    [self.dataArray addObject:group];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMGroup *group = [self.dataArray objectAtIndex:indexPath.row];
        EMError *error = nil;
        if ([group.owner isEqualToString:[[EMClient sharedClient] currentUsername]]) {
            EMError *error = nil;
            [[EMClient sharedClient].groupManager destroyGroup:group.groupId error:&error];
            if (!error) {
                NSLog(@"解散成功");
                [self.dataArray removeObject:group];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else {
                NSLog(@"解散失败");
            }
        }else {
            [[EMClient sharedClient].groupManager leaveGroup:group.groupId error:&error];
            if (!error) {
                NSLog(@"退出群组成功");
                [self.dataArray removeObject:group];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else {
                NSLog(@"退出群组失败");
            }
        }
        
    }
}
//修改删除时实现的删除样式
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMGroup *group = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([group.owner isEqualToString:[[EMClient sharedClient] currentUsername]]) {
        return @"解散此群";
    }
    return @"退出此群";
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
