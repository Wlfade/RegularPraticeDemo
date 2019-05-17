//
//  LFButton.m
//  5.UIButton 内部子控件的调整
//
//  Created by jczj on 17/4/5.
//  Copyright © 2017年 jczj. All rights reserved.
//

#import "LFButton.h"

@implementation LFButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //文本居中
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        //图片的内容模式
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return self;
}
- (void)setTheScale:(CGFloat)theScale{
    _theScale = theScale;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
#pragma mark 方式2
- (void)layoutSubviews{
    [super layoutSubviews];
    //设置子控件的位置
    if (_theScale != 0) {
        CGFloat selfHeight = self.bounds.size.height;

        CGFloat imageViewWH = selfHeight * _theScale;
        CGFloat imageViewX = 2;
        CGFloat iamgeViewY = (selfHeight - imageViewWH)/2;

        self.imageView.frame = CGRectMake(imageViewX, iamgeViewY, imageViewWH, imageViewWH);

        CGFloat titleX = CGRectGetMaxX(self.imageView.frame) + 3;
        CGFloat titleW = self.width - titleX;

        self.titleLabel.frame = CGRectMake(titleX, 0, titleW+[ccui getRH:10], selfHeight);
    }else{
        self.imageView.frame = CGRectMake(2, 2, 16, 16);
        self.titleLabel.frame = CGRectMake(20, 0, [ccui getRH:40], 20);
    }
   
}
@end
