//
//  KKContactCell.h
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKContactUserInfo.h"
#import "KKGroupMember.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKContactCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headPicImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) id userInfo;

@end

NS_ASSUME_NONNULL_END
