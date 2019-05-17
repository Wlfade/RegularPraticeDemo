//
//  KKDyLikeViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKDyLikeViewController : BaseTableViewController
@property (nonatomic,strong)NSString *sourceId;

@property (nonatomic,strong)void(^refreshBlock)(void);

- (void)refreshLikeInfor;
@end

NS_ASSUME_NONNULL_END
