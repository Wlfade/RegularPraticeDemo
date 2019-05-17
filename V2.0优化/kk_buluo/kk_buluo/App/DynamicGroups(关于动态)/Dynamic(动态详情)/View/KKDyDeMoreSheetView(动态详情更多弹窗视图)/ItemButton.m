//
//  ItemButton.m
//  01-微博动画（启动动画）
//
//  Created by 王玲峰 on 2017/11/16.
//  Copyright © 2017年 王玲峰. All rights reserved.
//

#import "ItemButton.h"
static const CGFloat kImageRatio = 0.75;
@implementation ItemButton


-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * kImageRatio;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat labelY = imageH;
    CGFloat labelH = self.bounds.size.height - labelY;
    self.titleLabel.frame = CGRectMake(imageX, labelY, imageW, labelH);
    
}
- (void)setHighlighted:(BOOL)highlighted{
    
}
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.transform = CGAffineTransformIdentity;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.transform = CGAffineTransformIdentity;
//    }];
//}
@end
