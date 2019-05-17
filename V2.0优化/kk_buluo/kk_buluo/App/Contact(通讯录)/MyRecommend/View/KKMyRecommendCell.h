//
//  KKMyRecommendCell.h
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMyRecommend.h"
#import "CC_Time.h"
NS_ASSUME_NONNULL_BEGIN
@class KKMyRecommendCell;
typedef void(^attentionButtonActionBlock)(KKMyRecommend *recommend, KKMyRecommendCell *cell);
@interface KKMyRecommendCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headPicImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) KKMyRecommend *myRecommend;
@property (nonatomic, copy) attentionButtonActionBlock attentionButtonActionBlock;
@end

NS_ASSUME_NONNULL_END
