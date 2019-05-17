//
//  KKDyDetailCommentViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKDyDetailCommentViewController : BaseTableViewController
@property (nonatomic,strong)NSString *objectId;

@property (nonatomic,strong)void(^refreshBlock)(void);

- (void)refreshCommentInfor;
@end

NS_ASSUME_NONNULL_END
