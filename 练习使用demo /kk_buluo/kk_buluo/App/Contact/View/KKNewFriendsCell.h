//
//  KKNewFriendsCell.h
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKNewFriendsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKNewFriendsCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headPicImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) KKNewFriendsModel *friendsModel;
@end

NS_ASSUME_NONNULL_END
