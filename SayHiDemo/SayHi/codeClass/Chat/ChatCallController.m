//
//  ChatCallController.m
//  SayHi
//
//  Created by lanouhn on 16/5/18.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "ChatCallController.h"

@interface ChatCallController ()

@end

@implementation ChatCallController

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 25, 60, 30);
    [backButton setTitle:@"<返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backDisMiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

}



//返回上一界面
- (void)backDisMiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
