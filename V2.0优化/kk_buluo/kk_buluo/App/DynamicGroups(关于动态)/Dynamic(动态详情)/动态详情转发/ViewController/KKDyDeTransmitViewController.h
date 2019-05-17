//
//  KKDyDeTransmitViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKDyDeTransmitViewController : BaseTableViewController
@property (nonatomic,strong)NSString *sourceId;

@property (nonatomic,strong)void(^refreshBlock)(void);

- (void)refreshTransmitInfor;
@end

NS_ASSUME_NONNULL_END
