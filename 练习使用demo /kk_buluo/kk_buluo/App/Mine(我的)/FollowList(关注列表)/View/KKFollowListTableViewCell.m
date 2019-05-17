//
//  KKFollowListTableViewCell.m
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKFollowListTableViewCell.h"

@interface KKFollowListTableViewCell ()
@property (nonatomic, weak) UIImageView *headIconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *descLabel;
@end


@implementation KKFollowListTableViewCell

#pragma mark - life circle
- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)createSubViews {
    
    //1.headIcon
    CGFloat imgW = [ccui getRH:50];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.backgroundColor = UIColor.grayColor;
    imageV.layer.cornerRadius = imgW/2.0;
    imageV.layer.masksToBounds = YES;
    self.headIconImageView = imageV;
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:15]);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(imgW);
    }];
    
    //2.nameL
    DGLabel *nameL = [DGLabel labelWithText:@"" fontSize:[ccui getRH:14] color:COLOR_BLACK_TEXT];
    self.nameLabel = nameL;
    [self.contentView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_top).mas_offset(5);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10);
    }];
    
    //3.descL
    DGLabel *descL = [DGLabel labelWithText:@"" fontSize:[ccui getRH:14] color:COLOR_GRAY_TEXT];
    self.descLabel = descL;
    [self.contentView addSubview:descL];
    [descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(imageV.mas_bottom).mas_offset(-6);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10);
    }];
    
    //4.addBtn
    DGButton *addBtn = [DGButton btnWithFontSize:[ccui getRH:11] title:@"+ 关注" titleColor:COLOR_BLUE];
    self.addFollowButton = addBtn;
    addBtn.hidden = YES;
    addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.contentView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:10]);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
    
    //5.grayLine
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = COLOR_BG;
    [self.contentView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(-[ccui getRH:10]);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
