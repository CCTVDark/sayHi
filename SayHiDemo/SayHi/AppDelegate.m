//
//  AppDelegate.m
//  SayHi
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
@interface AppDelegate ()<EMContactManagerDelegate,EMGroupManagerDelegate,IEMGroupManager,IEMChatManager,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSHomeDirectory());
 //环信SDK配置
    EMOptions *options = [EMOptions optionsWithAppkey:@"yj19910405#sayhi"];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
   //登录界面
   [self setLogin];
    //添加联系人回调方法代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //群组代理
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //好友消息回调
    
   self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}
#pragma mark -- 封装,已登录时配置根视图控制器
- (DDMenuController *)setRootViewController {
    //1.先获取可视化中的根视图控制器（消息界面）
    MessageViewController *messageVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    //添加导航控制器
    UINavigationController *messageNC = [[UINavigationController alloc]initWithRootViewController:messageVC];
    
    //2.创建联系人控制器
    ContactViewController *contact = [[ContactViewController alloc]init];
    UINavigationController *contactNC = [[UINavigationController alloc]initWithRootViewController:contact];
    //3.创建动态控制器
    DynamicViewController *dynamicVC = [[DynamicViewController alloc]init];
    UINavigationController *dynamicNC = [[UINavigationController alloc]initWithRootViewController:dynamicVC];
    //将控制器关联到tabBar
    UITabBarController *tabBarVC = [[UITabBarController alloc]init];
    tabBarVC.viewControllers = @[messageNC,contactNC,dynamicNC];
    //4.创建抽屉控制器
    self.ddMenuController = [[DDMenuController alloc]initWithRootViewController:tabBarVC];
   
    //5.创建MenuViewController(我们自己创建的)
    MenuViewController *menuVC = [[MenuViewController alloc]init];
    //6.将menuVC指定为DDMenu的左控制器
    //self.mmDrawerController = [[MMDrawerController alloc]initWithCenterViewController:tabBarVC leftDrawerViewController:menuVC];
    self.ddMenuController.leftViewController = menuVC;
    //7.最后 把DDMenu设置为根视图控制器
    // self.mmDrawerController.maximumLeftDrawerWidth = 200;
    //[self.mmDrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    return self.ddMenuController;
}


#pragma mark -- 封装第一次登录事件
- (void)setLogin {
    LoginViewController *firstVC = [[LoginViewController alloc]init];
    self.window.rootViewController = firstVC;
}
#pragma mark -- 对方同意添加好友的回调方法
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername {
    //调用插入数据的方法
    if (self.Cblock) {
          self.Cblock(aUsername);
    }
  
    
}


#pragma mark -- 收到添加好友回调的方法
//收到好友的添加请求
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage {
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"好友添加" message:[NSString stringWithFormat:@"%@想添加您为好友", aUsername] preferredStyle:UIAlertControllerStyleAlert];
    //  拒绝事件
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不鸟你" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //告诉服务器, 拒绝了添加好友
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSLog(@"拒绝成功");
                }else {
                    NSLog(@"拒绝失败");
                }
            });
        });
    }];
    //  同意事件
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //告诉服务器, 是好友关系
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSLog(@"同意成功");
                    if (self.block) {
                        self.block(aUsername);
                    }
                    
                }else {
                    NSLog(@"同意失败");
                }
            });
        });
        
    }];
    [control addAction:cancel];
    [control addAction:confirm];
   
    [self.window.rootViewController presentViewController:control animated:YES completion:nil];
}
#pragma mark -- 收到入群邀请
- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage {
    
   // EMGroup *group = [EMGroup groupWithId:aGroupId];
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"好友添加" message:[NSString stringWithFormat:@"%@想添加您进群", aInviter] preferredStyle:UIAlertControllerStyleAlert];
    //  拒绝事件
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不鸟你" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //告诉服务器, 拒绝了进群
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].groupManager declineInvitationFromGroup:aGroupId inviter:aInviter reason:@"不想进"];
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSLog(@"拒绝成功");
                }else {
                    NSLog(@"拒绝失败");
                }
            });
        });
    }];
    //  同意事件
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //告诉服务器, 同意进群
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = nil;
           EMGroup *group = [[EMClient sharedClient].groupManager acceptInvitationFromGroup:aGroupId inviter:aInviter error:&error];

            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    NSLog(@"同意成功");
                    if (self.block) {
                        self.GroupBlock(group);
                    }
                    
                }else {
                    NSLog(@"同意失败");
                }
            });
        });
        
    }];
    [control addAction:cancel];
    [control addAction:confirm];
    
    [self.window.rootViewController presentViewController:control animated:YES completion:nil];

    
}
#pragma mark -- 对方同意加入本群
- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee {
    NSString *agree = [NSString stringWithFormat:@"%@同意入群:%@",aInvitee,aGroup.subject];
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:agree preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [control addAction:cancel];
    [self.window.rootViewController presentViewController:control animated:YES completion:nil];
}
#pragma mark -- 群主收到入群申请
- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason {
    NSString *agree = [NSString stringWithFormat:@"%@申请加入群:%@",aApplicant, aGroup.subject];
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:agree preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].groupManager declineJoinApplication:aGroup.groupId applicant:aApplicant reason:@"不鸟你"];
        if (error) {
            NSLog(@"拒绝失败%@", error);
        }else {
            NSLog(@"拒绝成功");
        }
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].groupManager acceptJoinApplication:aGroup.groupId applicant:aApplicant];
        NSLog(@"%@", aGroup.groupId);
        if (error) {
            NSLog(@"接受失败%@", [error errorDescription]);
        }else {
            NSLog(@"接受成功");
        }
    }];
    [control addAction:cancel];
    [control addAction:confirm];
    [self.window.rootViewController presentViewController:control animated:YES completion:nil];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.baidu.www.SayHi" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SayHi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SayHi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
