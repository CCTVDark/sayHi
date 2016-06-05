
//  Copyright © 2016年 刘国栋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPopMenuView : UIView

@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, copy) void(^action)(NSInteger index);
@property (nonatomic, copy) NSArray * menuItem;
@property (nonatomic, strong) UITableView * tableView;


- (instancetype) initWithFrame:(CGRect)frame
                     menuWidth:(CGFloat)menuWidth
                         items:(NSArray *)items
                        action:(void(^)(NSInteger index))action;
@end
