//
//  Friend+CoreDataProperties.h
//  SayHi
//
//  Created by lanouhn on 16/5/13.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface Friend (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *friendName;
@property (nullable, nonatomic, retain) NSString *listName;

@end

NS_ASSUME_NONNULL_END
