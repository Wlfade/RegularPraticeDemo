//
//  PhotoListTableViewCell.m
//  LQPhotoAlbun
//
//  Created by liang lee on 2018/5/9.
//  Copyright © 2018年 liang lee. All rights reserved.
//

#import "PhotoListTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation PhotoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
    
}

-(void)setUIWithArray:(NSArray *)images{
    
    CGFloat space = 20;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 20*2 - 15*2)/3;
    CGFloat height = width;
    
    UIView *view_background = [[UIView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, height)];
    [self.contentView addSubview:view_background];
    
    for (int i = 0; i<images.count; i++) {
        UIImageView *imageView_photo = [[UIImageView alloc]initWithFrame:CGRectMake(15 + (space + width)*(i%3), 0, width, height)];
        [imageView_photo sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:[UIImage imageNamed:@""]];
        [view_background addSubview:imageView_photo];
        imageView_photo.userInteractionEnabled = YES;
        imageView_photo.tag =10086 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [imageView_photo addGestureRecognizer:tap];
        
        [imageView_photo setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageView_photo.contentMode =  UIViewContentModeScaleAspectFill;
        imageView_photo.clipsToBounds  = YES;
    }
    
}

-(void)tap:(UITapGestureRecognizer *)tap{
    
    UIImageView *imageView = (UIImageView *)tap.view;
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedImageViewOnCell:withImageView:)]) {
        [_delegate didSelectedImageViewOnCell:self withImageView:imageView];
    }
}

@end
