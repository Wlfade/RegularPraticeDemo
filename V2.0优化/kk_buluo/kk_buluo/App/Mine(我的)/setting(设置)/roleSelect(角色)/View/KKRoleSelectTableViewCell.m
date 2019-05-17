//
//  KKRoleSelectTableViewCell.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRoleSelectTableViewCell.h"

@interface KKRoleSelectTableViewCell()
@property (nonatomic, weak)UILabel *nameLabel;
@property (nonatomic, weak) UILabel *defaultTagLabel;
@property (nonatomic, weak)UIImageView *indicatorImageView;
@property (nonatomic, weak)UIView *grayLine;

@end


@implementation KKRoleSelectTableViewCell

#pragma mark - life circle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

#pragma mark -
-(void)setupUI {
    
    CGFloat leftSpace = [ccui getRH:20];
    CGFloat indicatorW = [ccui getRH:18];
    CGFloat tagW = [ccui getRH:24];
    CGFloat tagH = [ccui getRH:13];
    
    //1.nameL
    UILabel *nameL = [[UILabel alloc]init];
    self.nameLabel = nameL;
    nameL.textColor = COLOR_HEX(0x333333);
    nameL.font = [UIFont systemFontOfSize:[ccui getRH:15]];
    [self.contentView addSubview: nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.top.bottom.mas_equalTo(0);
    }];
    
    //2.tagL
    UILabel *defaultTagL = [[UILabel alloc]init];
    self.defaultTagLabel = defaultTagL;
    defaultTagL.hidden = YES;
    defaultTagL.backgroundColor = rgba(233, 187, 87, 1);
    defaultTagL.text = @"默认";
    defaultTagL.textColor = UIColor.whiteColor;
    defaultTagL.textAlignment = NSTextAlignmentCenter;
    defaultTagL.font = [UIFont systemFontOfSize:[ccui getRH:8]];
    [self.contentView addSubview: defaultTagL];
    [defaultTagL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameL.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(tagW);
        make.height.mas_equalTo(tagH);
    }];
    
    //3.indicator
    UIImageView *indicatorImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark_round_blueBg"]];
    self.indicatorImageView = indicatorImgV;
    indicatorImgV.hidden = YES;
    [self.contentView addSubview:indicatorImgV];
    [indicatorImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-leftSpace);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(indicatorW);
    }];
    
    //4.grayLine
    UIView *grayLine = [[UIView alloc]init];
    self.grayLine = grayLine;
    grayLine.backgroundColor = COLOR_BG;
    [self.contentView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark - setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.indicatorImageView.hidden = !selected;
}

-(void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    if ([nameStr containsString:@"(停用)"]) {
        self.nameLabel.textColor = COLOR_GRAY_TEXT;
    }else{
        self.nameLabel.textColor = COLOR_BLACK_TEXT;
    }
    self.nameLabel.text = nameStr;
}

-(void)setIsDefaultRole:(BOOL)isDefaultRole {
    _isDefaultRole = isDefaultRole;
    self.defaultTagLabel.hidden = !isDefaultRole;
}

@end
