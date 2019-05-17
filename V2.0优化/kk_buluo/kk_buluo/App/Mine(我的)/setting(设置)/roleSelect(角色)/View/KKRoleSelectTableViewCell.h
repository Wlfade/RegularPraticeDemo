//
//  KKRoleSelectTableViewCell.h
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRoleSelectTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, assign) BOOL isDefaultRole;

@end

NS_ASSUME_NONNULL_END
