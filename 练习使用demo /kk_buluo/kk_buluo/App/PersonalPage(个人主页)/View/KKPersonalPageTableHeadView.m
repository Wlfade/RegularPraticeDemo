//
//  KKPersonalPageTableHeadView.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKPersonalPageTableHeadView.h"
#import "KKTwoLineTitleView.h"

@interface KKPersonalPageTableHeadView()
@property (nonatomic, strong) NSArray *twoLineTitleArr;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSMutableArray *twoLineViewArr;
@end

@implementation KKPersonalPageTableHeadView{
    UILabel *nameLabel;
    UILabel *infolabel;
    UILabel *infolabel2;
    UIImageView *headImage;
    UIImageView *addFriendImage;
    UIImageView *addAttentionImage;
    UILabel *applyInLabel;
    UIView *myGroupView;
    UILabel *addAttention;
    UIView *itemView;
    UIView *functionView;
    UILabel *bottomLineLabel;
}

#pragma mark - lazy load
-(NSArray *)twoLineTitleArr {
    if (!_twoLineTitleArr) {
        if(self.personalPageType == PERSONAL_PAGE_OWNER || self.personalPageType == PERSONAL_PAGE_OTHER){
            _twoLineTitleArr = @[@"关注", @"粉丝", @"获评论", @"获转发", @"获赞"];
        }else if(self.personalPageType == PERSONAL_PAGE_GUILD){
            _twoLineTitleArr = @[@"粉丝", @"获赞"];
        }
    }
    return _twoLineTitleArr;
}

#pragma mark - life circle
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        [self configSubView];
        
    }
    return self;
}

-(void)setModel:(KKPersonalPageModel *)model{
    if(model){
        [self layoutDataWith:model];
        _model = model;
    }
}

-(void)layoutDataWith:(KKPersonalPageModel *)model{
    
    if(self.personalPageType == PERSONAL_PAGE_OTHER){//他人个人主页
        
        if(!_model){
            UIView *functionView = [self getFunctionViewWith:model];
            [self.contentView addSubview:functionView];
            
            UIView *nameAndInfoView = [self getNameAndInfoView];
            [self.contentView addSubview:nameAndInfoView];
            
            itemView = [self getItemViewWith:model];
            [self.contentView addSubview:itemView];
            
            UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [ccui getRH:300], SCREEN_WIDTH, 10)];
            bottomLineLabel.backgroundColor = RGB(244, 244, 244);
            [self.contentView addSubview:bottomLineLabel];
        }
        
        if(model.focus){//如果已关注
            addAttention.text = @"已关注";
            addAttention.backgroundColor = rgba(255, 255, 255, 0.2);
            addAttention.textColor = RGB(134, 135, 158);
        }else{
            addAttention.text = @"+ 关注";
            addAttention.backgroundColor = RGB(43, 63, 255);
            addAttention.textColor = [UIColor whiteColor];
        }
        [headImage sd_setImageWithURL:[NSURL URLWithString:model.userLogoUrl]];
        nameLabel.text = model.userName;
        if(model.memo.length>0)infolabel.text = [@"简介:" stringByAppendingString:model.memo?:@""];
        
        if(itemView)[itemView removeFromSuperview];
        itemView = [self getItemViewWith:model];
        [self.contentView addSubview:itemView];
        
    }else if(self.personalPageType == PERSONAL_PAGE_OWNER){//自己个人主页
        
        if(!_model){
            UIView *nameAndInfoView = [self getNameAndInfoView];
            
            [self.contentView addSubview:nameAndInfoView];
            
            itemView = [self getItemViewWith:model];
            [self.contentView addSubview:itemView];
            
            UIImageView *editImage = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:296], [ccui getRH:188], [ccui getRH:65], [ccui getRH:22])];
            editImage.image = [UIImage imageNamed:@"personal_page_edit_info"];
            editImage.userInteractionEnabled = YES;
            [self.contentView addSubview:editImage];
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editUserInfo)];
            [editImage addGestureRecognizer:ges];
            
            UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [ccui getRH:298], SCREEN_WIDTH, 10)];
            bottomLineLabel.backgroundColor = RGB(244, 244, 244);
            [self.contentView addSubview:bottomLineLabel];
            
            myGroupView = [self getMyGroupViewWith:model];
            [self.contentView addSubview:myGroupView];
        }
        
        [headImage sd_setImageWithURL:[NSURL URLWithString:model.userLogoUrl]];
        nameLabel.text = model.userName;
        if(model.memo.length>0){
            infolabel.text = [@"简介:" stringByAppendingString:model.memo];
        }else {
            infolabel.text = @"简介: ";
        }
        
        if(model.myGroups.count>0){
            if(myGroupView)[myGroupView removeFromSuperview];
            myGroupView = [self getMyGroupViewWith:model];
            [self.contentView addSubview:myGroupView];
        }else{
            if(myGroupView)[myGroupView removeFromSuperview];
        }
        
        if(itemView)[itemView removeFromSuperview];
        itemView = [self getItemViewWith:model];
        [self.contentView addSubview:itemView];
        
    }else if(self.personalPageType == PERSONAL_PAGE_GROUP){//群主页
        headImage.hidden = YES;
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.userLogoUrl]];
        if(!_model){
            if(model.joined == 0){
                applyInLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:277], [ccui getRH:121], [ccui getRH:83], [ccui getRH:30])];
                applyInLabel.backgroundColor = RGB(43, 63, 255);
                applyInLabel.text = @"申请加入";
                applyInLabel.textAlignment = NSTextAlignmentCenter;
                applyInLabel.userInteractionEnabled = YES;
                applyInLabel.textColor = [UIColor whiteColor];
                applyInLabel.font = [ccui getRFS:13];
                applyInLabel.layer.cornerRadius = [ccui getRH:3];
                applyInLabel.layer.masksToBounds = YES;
                [self.contentView addSubview:applyInLabel];
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyInGroup)];
                [applyInLabel addGestureRecognizer:ges];
            }else {
                applyInLabel.hidden = YES;
            }
            
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:17], [ccui getRH:129], [ccui getRH:200], [ccui getRH:17])];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [ccui getRFS:18];
            nameLabel.text = _model.userName;
            [self.contentView addSubview:nameLabel];
            
            infolabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:177], [ccui getRH:300], [ccui getRH:11])];
            infolabel.textColor = RGB(102, 102, 102);
            infolabel.font = [ccui getRFS:11];
            if(_model.memo.length>0) infolabel.text = [@"简介:" stringByAppendingString:_model.memo?:@""];
            [self.contentView addSubview:infolabel];
            
            bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [ccui getRH:202], SCREEN_WIDTH, 10)];
            bottomLineLabel.backgroundColor = RGB(244, 244, 244);
            [self.contentView addSubview:bottomLineLabel];
        }
        
        if(_model.joined == 1 && applyInLabel){
            applyInLabel.hidden = YES;
        }
        
        if(_model.joined == 1){
            if(functionView)[functionView removeFromSuperview];
            functionView = [self getFunctionViewWith:model];
            [self.contentView addSubview:functionView];
        }
        
        nameLabel.text = model.userName;
        if(model.memo.length>0)infolabel.text = [@"简介:" stringByAppendingString:model.memo?:@""];
        bottomLineLabel.top = [KKPersonalPageTableHeadView getHeadViewHeightWithPersonalPageType:self.personalPageType andUserModel:model]-9;
        
    }else if(self.personalPageType == PERSONAL_PAGE_GUILD){//公会号主页
        
        if(!_model){
            /// 私聊, 关注, 取消关注, 加好友
            UIView *functionView = [self getFunctionViewWith:model];
            [self.contentView addSubview:functionView];
            /// 公会名字, 简介
            UIView *nameAndInfoView = [self getNoticeNameAndInfoView];
            [self.contentView addSubview:nameAndInfoView];
            /// 关注 分数, 获赞
            itemView = [self getItemViewWith:model];
            itemView.top = [ccui getRH:257];
            [self.contentView addSubview:itemView];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, itemView.bottom, SCREEN_WIDTH, 97)];
            bgView.backgroundColor = RGB(241, 241, 241);
            
            ///
            UIImageView *blackView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 15, SCREEN_WIDTH - 28, 67)];
            blackView.image = [UIImage imageNamed:@"wepApp_bg_black"];
            [bgView addSubview:blackView];
            blackView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openWepAppAction)];
            [blackView addGestureRecognizer:tap];
            
            ///
            UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 36, 36)];
            logo.clipsToBounds = YES;
            logo.layer.cornerRadius = 5;
            [logo sd_setImageWithURL:[NSURL URLWithString:model.applicationSimple.logoUrl]];
            [blackView addSubview:logo];
            
            ///
            UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(57, 17, blackView.width - 57 - 20, 15)];
            appName.text = model.applicationSimple.name;
            appName.textColor = [UIColor whiteColor];
            appName.font = [ccui getRFS:15];
            [blackView addSubview:appName];
            
            ///
            UILabel *appDes = [[UILabel alloc] initWithFrame:CGRectMake(57, 39, blackView.width - 57 - 20, 10)];
            appDes.font = [UIFont systemFontOfSize:10];
            appDes.text = model.applicationSimple.descs;
            
            /// 群
            myGroupView = [self getMyGroupViewWith:model];
            /// 只有应用
            if (model.applicationSimple && model.myGroups.count == 0) {
                [self.contentView addSubview:bgView];

            }else if (!model.applicationSimple && model.myGroups.count > 0) {
                /// 删掉应用视图
                [bgView removeFromSuperview];
                /// 只有群
                myGroupView.top = itemView.bottom;
                [self.contentView addSubview:myGroupView];
                
            }else if (model.applicationSimple && model.myGroups.count > 0) {
                /// 有群有应用
                [self.contentView addSubview:bgView];
                myGroupView.top = bgView.bottom;
                [self.contentView addSubview:myGroupView];
            }
            /// 应用
            if (model.applicationSimple) {

            }else {
//                UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,itemView.bottom, SCREEN_WIDTH, 10)];
//                bottomLineLabel.backgroundColor = RGB(244, 244, 244);
//                [self.contentView addSubview:bottomLineLabel];
            }
            
        }
        if(model.focus){//如果已关注
            addAttention.text = @"已关注";
            addAttention.backgroundColor = rgba(255, 255, 255, 0.2);
            addAttention.textColor = RGB(134, 135, 158);
        }else{
            addAttention.text = @"+ 关注";
            addAttention.backgroundColor = RGB(43, 63, 255);
            addAttention.textColor = [UIColor whiteColor];
        }
        [headImage sd_setImageWithURL:[NSURL URLWithString:model.userLogoUrl]];
        nameLabel.text = model.userName;
        infolabel.text =  model.guildCert;
        [infolabel sizeToFit];
        infolabel.width = infolabel.width+[ccui getRH:20];
        if(model.memo.length>0)infolabel2.text = [@"简介:" stringByAppendingString:model.memo?:@""];
        
        if(itemView)[itemView removeFromSuperview];
        itemView = [self getItemViewWith:model];
        itemView.top = [ccui getRH:257];
        [self.contentView addSubview:itemView];
    }
}

#pragma mark - UI
-(void)configSubView{
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:160])];
    self.bgImageView.image = [UIImage imageNamed:@"personal_page_bgimage"];
    [self.contentView addSubview:self.bgImageView];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.layer.masksToBounds = YES;
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:160])];
    alphaView.backgroundColor = rgba(0, 0, 0, 0.1);
    [self.contentView addSubview:alphaView];
    
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:19], [ccui getRH:88], [ccui getRH:90], [ccui getRH:90])];
    headImage.backgroundColor = RGB(242, 242, 242);
    headImage.layer.cornerRadius = [ccui getRH:45];
    headImage.layer.masksToBounds = YES;
    [self.contentView addSubview:headImage];
}

-(UIView *)getMyGroupViewWith:(KKPersonalPageModel *)model{
    
    UIView *myGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, [ccui getRH:307], SCREEN_WIDTH, [ccui getRH:113])];
    /// 相关群图标
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:10], [ccui getRH:12], [ccui getRH:17], [ccui getRH:15])];
    imageView.image = [UIImage imageNamed:@"guild_about_group"];
    [myGroupView addSubview:imageView];
    

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:5] + imageView.right, [ccui getRH:13], [ccui getRH:80], [ccui getRH:13])];
    if (self.personalPageType == PERSONAL_PAGE_GUILD) {
        titleLabel.text = @"相关群聊";
    }else {
        titleLabel.text = @"我的群";
    }
    titleLabel.font = [ccui getRFS:14];
    titleLabel.textColor = COLOR_BLACK_TEXT;
    [myGroupView addSubview:titleLabel];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake([ccui getRH:302], [ccui getRH:14], [ccui getRH:59], [ccui getRH:11])];
    if (model.myGroups.count < 6) {
        moreBtn.hidden = YES;
    }else {
        moreBtn.hidden = NO;
    }
    [moreBtn setTitle:@"查看全部 >" forState:UIControlStateNormal];
    [moreBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [ccui getRFS:11];
    [myGroupView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(clickAllGroup) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *groupItem;
    for (int i = 0; i < (model.myGroups.count>5?5:model.myGroups.count); i++) {
        
        groupItem = [self getMyGroupItemViewWith:model.myGroups[i]];
        CGFloat x = [ccui getRH:15]+i*([ccui getRH:11]+[ccui getRH:49]);
        groupItem.frame = CGRectMake(x, [ccui getRH:34], [ccui getRH:49], [ccui getRH:70]);
        [myGroupView addSubview:groupItem];
        groupItem.tag = i;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupItemClick:)];
        [groupItem addGestureRecognizer:ges];
    }
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:9], groupItem.bottom+[ccui getRH:10], [ccui getRH:346], 0.5)];
    [myGroupView addSubview:lineLabel];
    return myGroupView;
}

-(void)groupItemClick:(UITapGestureRecognizer *)ges{
    
    self.clickGroup(_model.myGroups[ges.view.tag]);
}

-(UIView *)getMyGroupItemViewWith:(KKPersonalPageGroupModel *)groupModel{
    
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:49], [ccui getRH:70])];
    
    UIImageView *groupImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:49], [ccui getRH:49])];
    groupImage.backgroundColor = RGB(242, 242, 242);
    groupImage.layer.cornerRadius = [ccui getRH:24.5];
    groupImage.layer.masksToBounds = YES;
    [itemView addSubview:groupImage];
    [groupImage sd_setImageWithURL:[NSURL URLWithString:groupModel.groupLogoUrl]];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, groupImage.bottom + [ccui getRH:9], [ccui getRH:49], [ccui getRH:11])];
    nameLabel.font = [ccui getRFS:11];
    nameLabel.textColor = RGB(51, 51, 51);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:nameLabel];
    nameLabel.text = groupModel.groupName;
    
    return itemView;
}

-(UIView *)getNoticeNameAndInfoView{
    
    UIView *nameInfoView = [[UIView alloc] initWithFrame:CGRectMake([ccui getRH:17], [ccui getRH:189], [ccui getRH:341], [ccui getRH:68])];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:200], [ccui getRH:18])];
    nameLabel.font = [ccui getRFS:18];
    nameLabel.textColor = RGB(51, 51, 51);
    [nameInfoView addSubview:nameLabel];
    
    infolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.bottom+[ccui getRH:15], [ccui getRH:35], [ccui getRH:13])];
    infolabel.font = [ccui getRFS:11];
    infolabel.textAlignment = NSTextAlignmentCenter;
    infolabel.textColor = RGB(61, 99, 138);
    infolabel.layer.cornerRadius = [ccui getRH:6.5];
    infolabel.layer.masksToBounds = YES;
    infolabel.backgroundColor = RGB(174, 218, 255);
    [nameInfoView addSubview:infolabel];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_page_identify"]];
    [nameInfoView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->infolabel.left - 5);
        make.width.mas_equalTo([ccui getRH:14]);
        make.height.mas_equalTo([ccui getRH:16]);
        make.top.mas_equalTo(self->infolabel.top - 2);
    }];
    
    infolabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, infolabel.bottom+[ccui getRH:9], [ccui getRH:300], [ccui getRH:11])];
    infolabel2.font = [ccui getRFS:11];
    infolabel2.textColor = RGB(102, 102, 102);
    [nameInfoView addSubview:infolabel2];
    
    return nameInfoView;
}

-(UIView *)getNameAndInfoView{
    
    UIView *nameInfoView = [[UIView alloc] initWithFrame:CGRectMake([ccui getRH:17], [ccui getRH:189], [ccui getRH:341], [ccui getRH:45])];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:200], [ccui getRH:18])];
    nameLabel.font = [ccui getRFS:18];
    nameLabel.textColor = RGB(51, 51, 51);
    [nameInfoView addSubview:nameLabel];
    
    infolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.bottom, [ccui getRH:341], [ccui getRH:41])];
    infolabel.numberOfLines = 0;
    infolabel.lineBreakMode = NSLineBreakByCharWrapping;
    infolabel.font = [ccui getRFS:11];
    infolabel.textColor = RGB(102, 102, 102);
    [nameInfoView addSubview:infolabel];
    
    return nameInfoView;
}

-(UIView *)getItemViewWith:(KKPersonalPageModel *)model{
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [ccui getRH:234], SCREEN_WIDTH, [ccui getRH:63])];
    CGFloat leftSpace = [ccui getRH:15];
    //4.items
    CGFloat itemsCount = self.twoLineTitleArr.count;
    CGFloat spaceX = [ccui getRH:10];
    CGFloat itemW = (SCREEN_WIDTH - 2*leftSpace - (itemsCount-1)*spaceX)/itemsCount;
    CGFloat itemH = [ccui getRH:40];
    
    KKTwoLineTitleView *leftItemV = nil;
    for (NSInteger i=0; i<itemsCount; i++) {
        KKTwoLineTitleView *view = [[KKTwoLineTitleView alloc]init];
        view.detailLabel.text = self.twoLineTitleArr[i];
        NSString *titleStr;
        if([self.twoLineTitleArr[i] isEqualToString:@"关注"]){
            titleStr = [NSString stringWithFormat:@"%ld", model.myFollowers];
        }else if([self.twoLineTitleArr[i] isEqualToString:@"粉丝"]){
            titleStr = [NSString stringWithFormat:@"%ld", model.followMyUsers];
        }else if([self.twoLineTitleArr[i] isEqualToString:@"获评论"]){
            titleStr = [NSString stringWithFormat:@"%ld", model.commentMyUsers];
        }else if([self.twoLineTitleArr[i] isEqualToString:@"获转发"]){
            titleStr = [NSString stringWithFormat:@"%ld", model.transmitMyUsers];
        }else if([self.twoLineTitleArr[i] isEqualToString:@"获赞"]){
            titleStr = [NSString stringWithFormat:@"%ld", model.likeMyUsers];
        }
        NSInteger count = [titleStr integerValue];
        if(count > 10000) {
            float f = count/10000.0;
            titleStr = [NSString stringWithFormat:@"%.2fW",floor(f*100)/100];
        }else if(count > 1000) {
            float f = count/1000.0;
            titleStr = [NSString stringWithFormat:@"%.2fK",floor(f*100)/100];
        }
        view.titleLabel.text = titleStr;
        view.tag = i;
        WS(weakSelf);
        [view addTapWithTimeInterval:1.0 tapBlock:^(NSInteger tag) {
            [weakSelf tapTwoLineTitleView:tag];
        }];
        //add
        [self.twoLineViewArr addObject:view];
        [contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-[ccui getRH:12]);
            make.width.mas_equalTo(itemW);
            make.height.mas_equalTo(itemH);
            if (leftItemV) {
                make.left.mas_equalTo(leftItemV.mas_right).mas_offset(spaceX);
            }else{
                make.left.mas_equalTo(leftSpace);
            }
        }];
        
        leftItemV = view;
    }
    return contentView;
}

-(UIView *)getFunctionViewWith:(KKPersonalPageModel *)model{
    
    UIView *functioView = [[UIView alloc] initWithFrame:CGRectMake([ccui getRH:245], [ccui getRH:121], [ccui getRH:115], [ccui getRH:30])];
    
    if(self.personalPageType == PERSONAL_PAGE_OTHER
       || self.personalPageType == PERSONAL_PAGE_GUILD
       || self.personalPageType == PERSONAL_PAGE_GROUP){
        
        UIImageView *addFriendImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:39], [ccui getRH:30])];
        addFriendImage.backgroundColor = [UIColor redColor];
        if(self.personalPageType == PERSONAL_PAGE_OTHER){
            if(model.friend){
                addFriendImage.image = [UIImage imageNamed:@"personal_page_send_message"];
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupMessage)];
                [addFriendImage addGestureRecognizer:ges];
            }else{
                addFriendImage.image = [UIImage imageNamed:@"personal_page_addfriend"];
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriendClick)];
                [addFriendImage addGestureRecognizer:ges];
            }
        }else if(self.personalPageType == PERSONAL_PAGE_GUILD){
            addFriendImage.image = [UIImage imageNamed:@"personal_page_send_message"];
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupMessage)];
            [addFriendImage addGestureRecognizer:ges];
        }else if(self.personalPageType == PERSONAL_PAGE_GROUP){
            addFriendImage.image = [UIImage imageNamed:@"personal_page_send_message"];
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupMessage)];
            [addFriendImage addGestureRecognizer:ges];
        }
        addFriendImage.backgroundColor = RGB(43, 63, 255);
        addFriendImage.layer.cornerRadius = [ccui getRH:3];
        addFriendImage.layer.masksToBounds = YES;
        addFriendImage.userInteractionEnabled = YES;
        addFriendImage.contentMode =  UIViewContentModeCenter;
        [functioView addSubview:addFriendImage];
     
        if(self.personalPageType == PERSONAL_PAGE_GROUP){
            addAttention = [[UILabel alloc] initWithFrame:CGRectMake(addFriendImage.right+[ccui getRH:14], 0, [ccui getRH:68], [ccui getRH:30])];
            addAttention.layer.cornerRadius = [ccui getRH:3];
            addAttention.layer.masksToBounds = YES;
            addAttention.backgroundColor = RGBA(214, 214, 214, 0.6);
            addAttention.font = [ccui getRFS:13];
            addAttention.userInteractionEnabled = YES;
            addAttention.textAlignment = NSTextAlignmentCenter;
            addAttention.text = @"已加入";
            addAttention.textColor = [UIColor whiteColor];
            [functioView addSubview:addAttention];
        }else{
            addAttention = [[UILabel alloc] initWithFrame:CGRectMake(addFriendImage.right+[ccui getRH:14], 0, [ccui getRH:68], [ccui getRH:30])];
            addAttention.layer.cornerRadius = [ccui getRH:3];
            addAttention.layer.masksToBounds = YES;
            addAttention.backgroundColor = RGB(43, 63, 255);
            addAttention.font = [ccui getRFS:13];
            addAttention.textColor = [UIColor whiteColor];
            addAttention.userInteractionEnabled = YES;
            addAttention.textAlignment = NSTextAlignmentCenter;
            if(self.model.focus){//如果已关注
                addAttention.text = @"已关注";
            }else{
                addAttention.text = @"+ 关注";
            }
            [functioView addSubview:addAttention];
            UITapGestureRecognizer *ges1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAttenTion)];
            [addAttention addGestureRecognizer:ges1];
        }
    }
    
    return functioView;
}


#pragma mark - clickTitle
-(void)addFriendClick{
    
    if(self.model.friend){
        self.clickTitle(@"发送消息");
    }else{
        self.clickTitle(@"添加好友");
    }
}

-(void)groupMessage{
    self.clickTitle(@"发送消息");
}

-(void)clickAllGroup{
    
    self.clickTitle(@"查看全部");
}

-(void)addAttenTion{
    self.clickTitle(@"加关注");
}

-(void)applyInGroup{
    self.clickTitle(@"申请加群");
}

-(void)editUserInfo{
    self.clickTitle(@"编辑资料");
}

#pragma mark - interaction
-(void)tapTwoLineTitleView:(NSInteger)tag {
    //1.过滤越界
    if (tag >= self.twoLineViewArr.count || tag < 0) {
        return ;
    }
    
    //2.获取title
    KKTwoLineTitleView *twoLineTitleV = self.twoLineViewArr[tag];
    NSString *title = twoLineTitleV.detailLabel.text;
    
    if ([title isEqualToString:@"关注"]) {
        [self pushToAttentionVC];
        return ;
    }
    
    if ([title isEqualToString:@"粉丝"]) {
        [self pushToFansVC];
        return;
    }
}

#pragma mark - jump
-(void)pushToAttentionVC {
    
}

-(void)pushToFansVC {
    
}

- (void)openWepAppAction {
    self.openWepAppActionBlock(self.model);
}
+(CGFloat)getHeadViewHeightWithPersonalPageType:(KKPersonPageType)type andUserModel:(KKPersonalPageModel *)model{
    
    if(type == PERSONAL_PAGE_OTHER){//他人个人主页
        return [ccui getRH:307];
    }else if(type == PERSONAL_PAGE_OWNER){//自己个人主页
        if(model.myGroups.count>0){
            return [ccui getRH:420];
        }else{
            return [ccui getRH:307];
        }
    }else if(type == PERSONAL_PAGE_GROUP){//群主页
        
        if(model.memo.length>0){
            return [ccui getRH:210];
        }else{
            return [ccui getRH:168];
        }
    }else if(type == PERSONAL_PAGE_GUILD){//公会号主页
        
        CGFloat height = [ccui getRH:317];
        if (model.applicationSimple) {
            height += [ccui getRH:90];
        }
        
        if (model.myGroups.count > 0){
            height += [ccui getRH:125];
        }
        
        return height;
        
    }
    return [ccui getRH:307];
}
@end
