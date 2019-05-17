//
//  KKChatListSearchTableViewCell.m
//  kk_buluo
//
//  Created by david on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatListSearchTableViewCell.h"

@interface KKChatListSearchTableViewCell ()

@end

@implementation KKChatListSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    CGFloat imgW = [ccui getRH:40];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.backgroundColor = UIColor.grayColor;
    imageV.layer.cornerRadius = imgW/2.0;
    imageV.layer.masksToBounds = YES;
    self.headIconImageView = imageV;
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:8]);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(imgW);
    }];
    
    //2.nameL
    DGLabel *nameL = [DGLabel labelWithText:@"" fontSize:[ccui getRH:16] color:COLOR_BLACK_TEXT];
    self.nameLabel = nameL;
    [self.contentView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_top).mas_offset(1);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(7);
    }];
    
    //3.msgCountL
    DGLabel *msgCountL = [DGLabel labelWithText:@"" fontSize:[ccui getRH:14] color:COLOR_GRAY_TEXT];
    self.msgLabel = msgCountL;
    [self.contentView addSubview:msgCountL];
    [msgCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(imageV.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(7);
    }];
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
