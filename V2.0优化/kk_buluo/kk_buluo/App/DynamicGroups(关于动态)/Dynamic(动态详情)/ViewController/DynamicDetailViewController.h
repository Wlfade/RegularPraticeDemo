//
//  DynamicDetailViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class KKDynamicWholeItem;



@interface DynamicDetailViewController : BaseViewController
//subjectId
@property (nonatomic,strong)NSString *subjectId;

/** 刷新动态详情里面的数据 */
@property(nonatomic,strong) void(^dynamicBlock)(KKDynamicWholeItem *);

- (void)doCommentAction;
@end

NS_ASSUME_NONNULL_END
