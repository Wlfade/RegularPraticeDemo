//
//  KKGuildGroupListViewController.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKWepAppGuildListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKGuildGroupListViewController : BaseViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *guildId;

@end

NS_ASSUME_NONNULL_END
