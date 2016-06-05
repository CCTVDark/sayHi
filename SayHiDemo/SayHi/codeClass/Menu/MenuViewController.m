//
//  MenuViewController.m
//  SayHi
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "MenuViewController.h"
//
#import "MenuViewCell.h"
//头部视图
#import "HeaderView.h"
@interface MenuViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
//菜单列表
@property (nonatomic, strong)NSArray *listArray;
//头部视图
@property (nonatomic, strong)HeaderView *headerView;
@property(nonatomic,strong)UITableView  *tableView;
@end
static NSString *identifier = @"menuViewCell";
@implementation MenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     self.listArray = @[@"个性装扮", @"我的收藏", @"我的相册", @"我的文件"];
    [self setTableview];
}
#pragma mark -- tableView表视图配置
- (void)setTableview {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.scrollEnabled = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = (kDeviceHeight - 150) / self.listArray.count;
    [self addHeaderView];
}



#pragma mark -- 封装头部视图
- (void)addHeaderView {
    self.headerView = [[[NSBundle mainBundle ] loadNibNamed:@"HeaderView" owner:nil options:nil] firstObject];
    self.headerView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:232 / 255.0 blue:238 / 255.0 alpha:1];
    __weak MenuViewController *weakSelf = self;
    [self.headerView setBlock:^{
        [weakSelf headerImageTapAction];
    }];
    self.tableView.tableHeaderView = self.headerView;
}
//封装头部视图，头像点击事件
- (void)headerImageTapAction {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak HeaderView *weakSelf = self.headerView;
        UIAlertAction *define = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = weakSelf;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *Camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            
            imagePicker.delegate = weakSelf;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        }];
        [alertC addAction:cancel];
        [alertC addAction:define];
        [alertC addAction:Camera];
        [self presentViewController:alertC animated:YES completion:nil];
    }
   
}


#pragma mark -- Cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Table view 配置

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.menuLabel.text = self.listArray[indexPath.row];
    return cell;
}



@end
