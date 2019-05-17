//
//  KKContactSelectedCollectionViewCell.h
//  kk_buluo
//
//  Created by new on 2019/3/17.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKContactUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKContactSelectedCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *ivAva;
@property (nonatomic, strong) KKContactUserInfo *userInfo;
@end

NS_ASSUME_NONNULL_END
