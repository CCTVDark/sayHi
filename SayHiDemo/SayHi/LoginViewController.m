//
//  LoginViewController.m
//  SayHi
//
//  Created by lanouhn on 16/5/12.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "LoginViewController.h"
#import "SereverManager.h"
#import "AppDelegate.h"
@interface LoginViewController ()<EMClientDelegate,UITextFieldDelegate>
@property (nonatomic, strong)AppDelegate *myApp;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:232 / 255.0 blue:238 / 255.0 alpha:1];
    
    //添加代理方法，因为要监听是否自动登录成功
    [[EMClient sharedClient]addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //NSLog(@"%@",NSHomeDirectory());
    self.myApp = [UIApplication sharedApplication].delegate;
    [self setHeaderImage];
}
//头像视图
- (void)setHeaderImage {
    self.headerViewImage.layer.cornerRadius = 40;
    self.headerViewImage.layer.masksToBounds = YES;
    NSLog(@"%@", NSHomeDirectory());
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSString *imagePath = [cache stringByAppendingPathComponent:@"images"];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    NSKeyedUnarchiver *keyedUn = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    UIImage *image = [keyedUn decodeObjectForKey:@"image"];
    [keyedUn finishDecoding];
    if (image) {
        self.headerViewImage.image = image;
    }else {
        self.headerViewImage.image = [UIImage imageNamed:@"header.png"];
    }
}

//登录
- (IBAction)LoginButtonAction:(UIButton *)sender {
    //判断是否设置了自动登录
    BOOL isAutoLogin = [[EMClient sharedClient].options isAutoLogin];
    if (isAutoLogin == NO) {
        [[SereverManager sharedManager] asyncLoginWithUserName:self.userNameTF.text password:self.passwordTF.text complete:^(EMError *error) {
            if (error == nil) {
                NSLog(@"登录成功");
                //设置自动登录
                [EMClient sharedClient].options.isAutoLogin = YES;
                self.myApp.window.rootViewController = [self.myApp setRootViewController];
            }else {
                NSLog(@"登录失败,%@", [error errorDescription]);
            }
        }];
    }
}
//注册
- (IBAction)registerButtonAction:(UIButton *)sender {
    [[SereverManager sharedManager] registerWithUserName:self.userNameTF.text password:self.passwordTF.text complete:^(EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
        }else {
            NSLog(@"注册失败");
        }
    }];
}

//关于我们
- (IBAction)aboutButtonAction:(UIButton *)sender {
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"说哈是一款简便的超轻量级聊天软件，只面对少数人群，后续也不会进行软件推广" preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [control addAction:cancel];
    [self presentViewController:control animated:YES completion:nil];
    
}

#pragma mark -- 代理方法
- (void)didAutoLoginWithError:(EMError *)aError {
    //跳转界面
    if (!aError) {
        NSLog(@"登录成功");
       self.myApp.window.rootViewController = [self.myApp setRootViewController];
    
        
    }else {
        NSLog(@"自动登录失败");
    }
}

#pragma mark -- 点击view收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.passwordTF resignFirstResponder];
    [self.userNameTF resignFirstResponder];
}
#pragma mark -- textField点击改变frame方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //键盘即将消失的监测方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘即将出现的监测方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardShow:(NSNotification *)notifi {
    CGRect keyboardRect = [notifi.userInfo [UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    float time = [[notifi.userInfo objectForKey:UIKeyboardWillShowNotification] floatValue];
    [UIView animateWithDuration:time animations:^{
        self.headerViewImage.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
        self.userNameTF.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
        self.passwordTF.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
    }];
}
- (void)keyBoardHide:(NSNotification *)notifi {
    float time = [[notifi.userInfo objectForKey:UIKeyboardWillHideNotification] floatValue];
    //现在使用动画改变keyboardView的位置
    [UIView animateWithDuration:time animations:^{
        self.headerViewImage.transform = CGAffineTransformMakeTranslation(0, 0);
        self.userNameTF.transform = CGAffineTransformMakeTranslation(0, 0);
        self.passwordTF.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
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
