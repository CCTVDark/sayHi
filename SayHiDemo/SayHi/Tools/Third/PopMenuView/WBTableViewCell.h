
//  Copyright © 2015年 刘国栋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTableViewCell : UITableViewCell

/**
 *  使用 alloc 创建cell
 *
 *  @param tableView 表格控件
 *
 *  @return 创建的 cell
 *
 *  内已做复用处理
 *  如果有特殊要求 可以重写此方法
 */
+ (instancetype)cellAllocWithTableView:(UITableView *)tableView;


@end
