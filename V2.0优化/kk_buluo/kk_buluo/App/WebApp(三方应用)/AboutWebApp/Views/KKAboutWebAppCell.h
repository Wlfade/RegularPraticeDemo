//
//  KKAboutWebAppCell.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKApplicationInfo.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectedToSendFriendBlock)(void);
typedef void(^didSelectedDeleteOrAddWebAppBlock)(UIButton *button);

@interface KKAboutWebAppCell : UITableViewCell
@property (nonatomic, copy) didSelectedToSendFriendBlock didSelectedToSendFriendBlock;
@property (nonatomic, copy) didSelectedDeleteOrAddWebAppBlock didSelectedDeleteOrAddWebAppBlock;
@property (nonatomic, strong) KKApplicationInfo *appInfo;
@property (nonatomic, assign) CGFloat desHeight;


@end

NS_ASSUME_NONNULL_END
