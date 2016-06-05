
//  Copyright © 2015年 刘国栋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WBPopMenuModel,WBTableViewCell;

/**
 * 由model 设置cell 的回调
 */
typedef void(^TableViewCellConfigureBlock) (WBTableViewCell * cell,WBPopMenuModel * model);

/**
 * 数据源管理类的封装
 */
@interface WBTableViewDataSource : NSObject <UITableViewDataSource>

/**
 *  创建数据源管理
 *
 *  @param anItems             数据源
 *  @param cellClass           cell 类
 *  @param aConfigureCellBlock 设置cell的回调
 */
- (instancetype) initWithItems:(NSArray *)anItems
                     cellClass:(Class)cellClass
            configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

@end
