//
//  BBDynamicBlowUpCell.m
//  BananaBall
//
//  Created by 单车 on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BBDynamicBlowUpCell.h"

@interface BBDynamicBlowUpCell()

@end

@implementation BBDynamicBlowUpCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _creatSubView];
    }
    return self;
}
- (void)_creatSubView{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor blackColor];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];

    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
    [imageView addGestureRecognizer:tap];
}
- (void)Tapped:(UIGestureRecognizer *) gesture
{
    if ([self.delegate respondsToSelector:@selector(BBDynamicBlowUpCellTap:)])
    {
        [self.delegate BBDynamicBlowUpCellTap:self];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}
@end
