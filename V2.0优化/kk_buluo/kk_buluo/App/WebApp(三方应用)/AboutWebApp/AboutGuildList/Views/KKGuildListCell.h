//
//  KKGuildListCell.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWepAppAboutDetailInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKGuildListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headPicImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) KKWepAppAboutDetailInfo *info;

@end

NS_ASSUME_NONNULL_END
