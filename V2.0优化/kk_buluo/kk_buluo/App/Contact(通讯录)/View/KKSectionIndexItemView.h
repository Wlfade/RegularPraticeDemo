
//
//  Created by summerxx on 2018/3/16.
//  Copyright © 2019年 summerxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSectionIndexItemView : UIView
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;//方便在子类里重写该方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end
