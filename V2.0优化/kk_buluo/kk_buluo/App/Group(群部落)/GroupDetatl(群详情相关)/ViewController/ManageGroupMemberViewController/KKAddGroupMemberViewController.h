//
//  KKAddGroupMemberViewController.h
//  kk_buluo
//
//  Created by new on 2019/3/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "KKMyGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKAddGroupMemberViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) KKMyGroup *groupModel;

@end

NS_ASSUME_NONNULL_END
