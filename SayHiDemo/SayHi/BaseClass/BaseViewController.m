//
//  BaseViewController.m
//  OneProject
//
//  Created by lanouhn on 16/4/22.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
//使用懒加载创建对象
- (MBProgressHUD *)HUD {
    if (_HUD == nil) {
        self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_HUD];
    }return _HUD;
}


#pragma mark -- 显示loading
- (void)showProgressHUD {
    [self showProgressHUDWithString:nil];
    //[self.HUD show:YES];
}
#pragma mark -- 
- (void)showProgressHUDWithString:(NSString *)title {
    if (title.length == 0) {
        self.HUD.labelText = nil;
    }else {
        self.HUD.labelText = title;
    }
    [self.HUD show:YES];
}

//隐藏
- (void)hideProgressHUD {
    if (self.HUD != nil) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
}

#pragma mark --  抽屉菜单button
//创建抽屉button
- (UIBarButtonItem *)showLeftBarButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_menu_icon@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(showLeft:)];
    return button;
}
//button点击事件
- (void)showLeft:(UIBarButtonItem *)sender {
    AppDelegate *myApp = [UIApplication sharedApplication].delegate;
    [myApp.ddMenuController showLeftController:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //不能写在这里，因为要继承，此方法只在加载视图时才走
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
