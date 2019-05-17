//
//  KKContactSelectTableViewCell.h
//  kk_buluo
//
//  Created by new on 2019/3/17.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGroupMember.h"
NS_ASSUME_NONNULL_BEGIN


typedef void(^tapPortraitImageViewBlock)(void);

@interface KKContactSelectTableViewCell : UITableViewCell
/// 选中图片
@property (nonatomic, strong) UIImageView *selectedImageView;
/// 头像图片
@property (nonatomic, strong) UIImageView *portraitImageView;
/// 昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) KKGroupMember *userInfo;
@property (nonatomic, copy) tapPortraitImageViewBlock tapPortraitImageViewBlock;
@end

NS_ASSUME_NONNULL_END
