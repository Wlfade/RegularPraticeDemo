//
//  KKMyCommentTableViewCell.m
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMyCommentTableViewCell.h"

@interface KKMyCommentTableViewCell ()
//headerView
@property (nonatomic, weak) UIImageView *headIconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIButton *moreButton;
//comment
@property (nonatomic, weak) UILabel *commentLabel;
//content
@property (nonatomic, weak) UIImageView *dynamicImageView;
@property (nonatomic, weak) UILabel *formLabel;
@property (nonatomic, weak) UILabel *descLabel;


@end

@implementation KKMyCommentTableViewCell

#pragma mark - life circle
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
    
    CGFloat leftSpace = [ccui getRH:15];
    CGFloat headerViewH = [ccui getRH:55];
    CGFloat commentLabelH = [ccui getRH:30];
    CGFloat dynamicViewH = [ccui getRH:60];
    
    //1.headerV
    UIView *headerV = [[UIView alloc]init];
    [self.contentView addSubview:headerV];
    [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(headerViewH);
    }];
    [self setupHeaderView:headerV];
    
    //2.commentL
    DGLabel *commentL = [DGLabel labelWithText:@"***" fontSize:[ccui getRH:16] color:COLOR_BLACK_TEXT];
    self.commentLabel = commentL;
    [self.contentView addSubview:commentL];
    [commentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.top.mas_equalTo(headerV.mas_bottom);
        make.height.mas_equalTo(commentLabelH);
    }];
    
    //3.dynamicContent
    UIView *dynamicV = [[UIView alloc]init];
    dynamicV.backgroundColor = rgba(242, 242, 242, 1);
    [self.contentView addSubview:dynamicV];
    [dynamicV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentL.mas_bottom);
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo(dynamicViewH);
    }];
    [self setupDynamicView:dynamicV];
    
    //4.grayLine
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = rgba(242, 242, 242, 1);
    [self.contentView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}

/** 设置headerView */
-(void)setupHeaderView:(UIView *)view {
    WS(weakSelf);
    
    //1.headIcon
    CGFloat imgW = [ccui getRH:35];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.backgroundColor = UIColor.grayColor;
    imageV.layer.cornerRadius = imgW/2.0;
    imageV.layer.masksToBounds = YES;
    self.headIconImageView = imageV;
    [view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:15]);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(imgW);
    }];
    
    //2.nameL
    DGLabel *nameL = [DGLabel labelWithText:@"***" fontSize:[ccui getRH:15] color:COLOR_BLACK_TEXT bold:YES];
    self.nameLabel = nameL;
    [view addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_top).mas_offset(1);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10);
    }];
    
    //3.msgCountL
    DGLabel *timeL = [DGLabel labelWithText:@"**" fontSize:[ccui getRH:11] color:COLOR_GRAY_TEXT];
    self.timeLabel = timeL;
    [view addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(imageV.mas_bottom).mas_offset(-1);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10);
    }];
    
    //4.moreBtn
    DGButton *moreBtn = [DGButton btnWithImg:Img(@"dynamic_more_icon")];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    moreBtn.clickTimeInterval = 1.0;
    [moreBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickMoreButton:btn];
    }];
    [view addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(-[ccui getRH:2]);
        make.height.mas_equalTo([ccui getRH:40]);
        make.width.mas_equalTo([ccui getRH:40]);
    }];
}


/** 设置DynamicView */
-(void)setupDynamicView:(UIView *)view {
    //1.headIcon
    CGFloat imgW = [ccui getRH:60];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.backgroundColor = UIColor.grayColor;
    self.dynamicImageView = imageV;
    [view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo([ccui getRH:0]);
        make.width.height.mas_equalTo(imgW);
    }];
    
    //2.nameL
    DGLabel *nameL = [DGLabel labelWithText:@"***" fontSize:[ccui getRH:13] color:COLOR_BLACK_TEXT];
    self.formLabel = nameL;
    [view addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_top).mas_offset(5);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10);
    }];
    
    //3.msgCountL
    DGLabel *timeL = [DGLabel labelWithText:@"***********" fontSize:[ccui getRH:13] color:COLOR_GRAY_TEXT];
    self.descLabel = timeL;
    timeL.numberOfLines = 2;
    [view addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameL.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10);
        make.right.mas_equalTo(-6);
    }];
}

#pragma mark - interaction
-(void)clickMoreButton:(UIButton *)btn {
    if ([self.commentDelegate respondsToSelector:@selector(commentCell:withHeadViewPoint:)]) {
        CGPoint p = [btn.superview convertPoint:btn.frame.origin toView:self.window];
        p.x += btn.frame.size.width / 2;
        p.y += btn.frame.size.height / 2;
        [self.commentDelegate commentCell:self withHeadViewPoint:p];
    }
}

#pragma mark - setter
-(void)setModel:(KKMyCommentSimpleModel *)model {
    _model = model;
    
    //1.headerV
    [self.headIconImageView sd_setImageWithURL:Url(model.commonObjectLogoUrl)];
    self.nameLabel.text = model.commonObjectName;
    self.timeLabel.text = model.gmtCreate;
    
    //2.commentL
    self.commentLabel.attributedText = model.attributedContent;
    
    //3.dynamicV
    KKMyCommentTopicObjectModel *topicModel = model.topicSimple.topicObject;
    NSString *imgStr = topicModel.properties.smallImageList.firstObject.url;
    if (!imgStr) {
        imgStr = topicModel.properties.middleImageList.firstObject.url;
    }
    if (!imgStr) {
        imgStr = topicModel.properties.largerImageList.firstObject.url;
    }
    [self.dynamicImageView sd_setImageWithURL:Url(imgStr) placeholderImage:Img(@"default_trasmit_icon")];
    
    NSString *subjectId = model.topicSimple.topicObject.subjectId;
    if (subjectId.length < 1) {
        self.formLabel.text = @"";
        self.descLabel.text = @"该动态已被删除";
    }else{
        self.formLabel.text = [NSString stringWithFormat:@"%@%@",@"@",topicModel.commonObjectName];
        self.descLabel.attributedText = topicModel.attributedSummary;
    }
    
}

@end
