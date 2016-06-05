//
//  AppDelegate.h
//  SayHi
//
//  Created by lanouhn on 16/5/11.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DDMenuController.h"//即将作为根视图控制器
#import "EMGroup.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong)DDMenuController *ddMenuController;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, copy)void(^block)(NSString *name);//收到添加好友的回调
@property (nonatomic, copy)void(^Cblock)(NSString *name);
@property (nonatomic, copy)void(^GroupBlock)(EMGroup *group);//收到群组邀请的回调

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (DDMenuController *)setRootViewController;
- (void)setLogin;

@end

