//
//  KKPersonalPageController.h
//  kk_buluo
//
//  Created by 樊星 on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "KKPersonalPageTableHeadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKPersonalPageController : BaseViewController
@property (nonatomic, assign) KKPersonPageType personalPageType;
@property (nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
