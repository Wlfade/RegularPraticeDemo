//
//  KKLookAtGroupMemberViewController.h
//  kk_buluo
//
//  Created by new on 2019/3/19.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "KKPersonalPageModel.h"
#import "KKMyGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKLookAtGroupMemberViewController : BaseViewController
@property (nonatomic, strong) KKMyGroup *groupModel;
@property (nonatomic, strong) KKPersonalPageModel *personModel;
@property (nonatomic, assign) BOOL selectFriend;
@end

NS_ASSUME_NONNULL_END
