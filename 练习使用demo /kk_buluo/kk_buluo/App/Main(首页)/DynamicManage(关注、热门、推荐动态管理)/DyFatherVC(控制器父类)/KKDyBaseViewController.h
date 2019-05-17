//
//  KKDyBaseViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKDynamicWholeItem;
@interface KKDyBaseViewController : UIViewController
/** 表视图的frame */
@property(nonatomic,assign)CGRect tableFrame;

/* 动态表数据数组 */
@property(nonatomic,strong)NSMutableArray <KKDynamicWholeItem *> *dynamicMutArr;

/** 动态表视图 */
@property (nonatomic,strong)UITableView *dynamicTableView;
/** 请求数据的 */
@property(nonatomic,strong)NSString *nowDate;

@property(nonatomic,strong)HHPaginator *paginator;


- (void)refresh;

//- (void)loadMore;

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
