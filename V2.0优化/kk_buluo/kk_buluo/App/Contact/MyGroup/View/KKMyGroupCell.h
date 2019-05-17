//
//  KKMyGroupCell.h
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMyGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKMyGroupCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headPicImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) KKMyGroup *myGroup;

@end

NS_ASSUME_NONNULL_END
