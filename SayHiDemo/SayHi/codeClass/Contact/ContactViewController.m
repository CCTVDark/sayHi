//
//  ContactViewController.m
//  SayHi
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "ContactViewController.h"
//好友cell
#import "ContactViewCell.h"
#import "headerFooterView.h"

//引入好友实体
#import "Friend.h"

@interface ContactViewController ()<UITableViewDelegate, UITableViewDataSource,EMContactManagerDelegate,IEMContactManager>
//表视图
@property (nonatomic, strong)UITableView *tableView;
//好友列表请求数据（转化）
@property (nonatomic, strong)NSMutableDictionary *dataDic;
//存放好友分组名
@property (nonatomic, strong)NSMutableArray *listArray;
//分区头三角图标
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, assign)NSInteger isOpen;
@property (nonatomic, assign)NSInteger isSection;
@property (nonatomic, assign)NSInteger isFirst;
@property (nonatomic, strong)NSMutableDictionary *sectionDic;
@end

@implementation ContactViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOpen = 0;
    self.isFirst = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //数组开空间
    self.listArray = [NSMutableArray array];
    self.dataDic = [NSMutableDictionary dictionary];
    self.sectionDic = [NSMutableDictionary dictionary];
    //背景
    self.view.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:232 / 255.0 blue:238 / 255.0 alpha:1];
    //小菊花
    [self showProgressHUD];
    //创建表视图
    [self setTableView];
    //设置代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //获取好友列表
    [self setFriendList];
    
    //appDelegate收到添加好友请求回调方法中的block实现
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app setBlock:^(NSString *name) {
        [self insertIntoDataWithName:name];
    }];
    
    [app setCblock:^(NSString *name) {
       [self insertIntoDataWithName:name];
    }];
}

#pragma mark -- 配置tabBarItem
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:[[UIImage imageNamed:@"contact@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"contact@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(9, 0, -9, 0);
        // 抽屉菜单button
        self.navigationItem.leftBarButtonItem = [self showLeftBarButton];
        self.navigationItem.rightBarButtonItem = [self showRightBarButton];
    }return self;
}
#pragma mark --创建添加好友button

- (UIBarButtonItem *)showRightBarButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Add@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(AddFriend:)];
    return button;
}

//添加好友
- (void)AddFriend:(id)sender {
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加好友"preferredStyle:UIAlertControllerStyleAlert];
    //  设置两个输入框
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入查找的用户名";
        
    }];
    [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入请求信息";
        
    }];
    //  取消事件
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array = control.textFields;
        UITextField *textfield = array[0];
        UITextField *textfield2 = array[1];
        
        
            [textfield resignFirstResponder];
            [textfield2 resignFirstResponder];
  
        
      
        }];
    //  确定事件
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //向服务器发送添加好友的方法
        //1.获取输入框的信息
        NSArray *array = control.textFields;
        UITextField *textfield = array[0];
        UITextField *textfield2 = array[1];
        //发送请求
        [[SereverManager sharedManager] asyncAddContactWithUserName:textfield.text message:textfield2.text complete:^(EMError *error) {
            if (!error) {
                NSLog(@"发送成功");
            }else {
                NSLog(@"发送失败");
            }
        }];
        
            [textfield resignFirstResponder];
            [textfield2 resignFirstResponder];
        
    }];
    [control addAction:cancel];
    [control addAction:confirm];
    //  弹出警示框
    [self presentViewController:control animated:YES completion:nil];
}

#pragma mark -- 创建表视图
- (void)setTableView {
    //创建表视图
    self.tableView = [[UITableView alloc]initWithFrame:kFrame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    __weak ContactViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        //获取好友列表
        [weakSelf setFriendList];
    }];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactViewCell" bundle:nil] forCellReuseIdentifier:@"contactViewCell"];
}
#pragma mark -- 获取好友列表
- (void)setFriendList {
    
    //检索服务器好友
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //声明error
        EMError *error = nil;
        NSArray *array = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        //回主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSString *name in array) {
                [self insertData:name];                
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self hideProgressHUD];
        });
    });
   
}
#pragma mark -- 封装添加好友数据源方法

- (void)insertData:(NSString *)name {
    //判断好友名重复问题
    for (NSString *key in self.listArray) {
        NSMutableArray *tempArray = [self.dataDic objectForKey:key];
        if ([tempArray containsObject:name]) {
            return;
        }
    }
    NSString *firstName = [name substringToIndex:1];
    const char *china = [firstName UTF8String];
    if (strlen(china) == 3) {
        NSString *pinYinName = [ChineseToPinyin pinyinFromChiniseString:firstName];
        firstName = [pinYinName substringToIndex:1];
    }
    firstName = [firstName lowercaseString];
    NSMutableArray *tempArray = [self.dataDic objectForKey:firstName];
    if (tempArray == nil) {
        tempArray = [NSMutableArray array];
        NSNumber *isOpen = @(0);
        [self.dataDic setObject:tempArray forKey:firstName];
        [self.sectionDic setObject:isOpen forKey:firstName];
        [self.listArray addObject:firstName];
        [self.listArray sortUsingSelector:@selector(compare:)];
    }
    [tempArray addObject:name];
}

//封装插入数据源 并且插入单元格的方法
- (void)insertIntoDataWithName:(NSString *)name {
  
    dispatch_async(dispatch_get_main_queue(), ^{
        [self insertData:name];
        //插入cell
        NSString *firstName = [name substringToIndex:1];
        const char *china = [firstName UTF8String];
        if (strlen(china) == 3) {
            NSString *pinYinName = [ChineseToPinyin pinyinFromChiniseString:firstName];
            firstName = [pinYinName substringToIndex:1];
        }
        firstName = [firstName lowercaseString];
        NSMutableArray *tempArray = [self.dataDic objectForKey:firstName];
        NSInteger a = [self.listArray indexOfObject:firstName];
        //如果数组个数为1，证明之前分区不存在，这时就要插入一个分区
        if (tempArray.count == 1) {
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:a];
            [self.tableView insertSections:set withRowAnimation:UITableViewRowAnimationAutomatic];

        }else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tempArray.count - 1 inSection:a];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        });
}




#pragma mark -- 配置cell分区
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.listArray objectAtIndex:section];
    NSMutableArray *tempArray = [self.dataDic objectForKey:key];
    NSNumber *tempOpen = [self.sectionDic objectForKey:key];
    NSInteger open = [tempOpen integerValue];
    NSLog(@"%ld", open);
    if (open == 0) {
        return 0;
    }else {
         return tempArray.count;
    }
    
}


#pragma mark -- 配置cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactViewCell" forIndexPath:indexPath];
    NSMutableArray *tempArray = [self.dataDic objectForKey:[self.listArray objectAtIndex:indexPath.section]];
    //cell.backgroundColor = [UIColor clearColor];
    cell.nickLabel.text = tempArray[indexPath.row];
    return cell;
}


#pragma mark -- 配置cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.listArray[indexPath.section];
    NSMutableArray *tempArray = [self.dataDic objectForKey:key];
    ChatViewController *chatVC = [ChatViewController new];
    chatVC.tempName = tempArray[indexPath.row];
    chatVC.conversation = [[EMClient sharedClient].chatManager getConversation:tempArray[indexPath.row] type:EMConversationTypeChat createIfNotExist:YES];
    BOOL isRead = [chatVC.conversation markAllMessagesAsRead];
    if (!isRead) {
        NSLog(@"清除信息未读失败");
    }
    chatVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:chatVC animated:YES completion:nil];
}
#pragma mark -- 好友列表区头配置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    headerFooterView *view = [[[NSBundle mainBundle ] loadNibNamed:@"headerFooterView" owner:nil options:nil] firstObject];
    NSString *key = [self.listArray objectAtIndex:section];
    NSNumber *tempOpen = [self.sectionDic objectForKey:key];
    NSInteger open = [tempOpen integerValue];
        if (open == 1) {
            view.headerImage.image = [UIImage imageNamed:@"open.png"];
            view.ThreadView.hidden = YES;
        }else if(open == 0) {
            view.headerImage.image = [UIImage imageNamed:@"close.png"];
            view.ThreadView.hidden = NO;
        }
 
    view.listLabel.text = [NSString stringWithFormat:@"  %@", self.listArray[section]];
    view.listLabel.font = [UIFont systemFontOfSize:20];
    view.section = section;
    
    [view setBlock:^(NSInteger sectionO) {
        NSString *key = [self.listArray objectAtIndex:sectionO];
        NSNumber *tempOpen = [self.sectionDic objectForKey:key];
        NSInteger open = [tempOpen integerValue];
        if (open == 1) {
            NSNumber *Open = @(0);
            [self.sectionDic setObject:Open forKey:key];
             [self.tableView reloadData];
        }else if(open == 0) {
            NSNumber *Open = @(1);
            [self.sectionDic setObject:Open forKey:key];
             [self.tableView reloadData];
        }
        }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 45;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = self.listArray[indexPath.section];
        NSMutableArray *tempArray = [self.dataDic objectForKey:key];
        NSString *name = tempArray[indexPath.row];
        // 删除好友
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:name];
        if (!error) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败:%@", error);
        }
        if (tempArray.count == 1) {

            [self.dataDic removeObjectForKey:key];
            

            [self.listArray removeObjectAtIndex:indexPath.section];

            self.isOpen = 0;
            [self.tableView reloadData];
            
        }else {
            [tempArray removeObject:name];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}
//修改删除时实现的删除样式
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除好友";
}

@end
