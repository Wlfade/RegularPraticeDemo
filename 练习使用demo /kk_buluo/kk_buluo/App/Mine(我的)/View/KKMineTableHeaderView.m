//
//  KKMineTableHeaderView.m
//  kk_buluo
//
//  Created by david on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMineTableHeaderView.h"
#import "KKIconTitleView.h"
#import "KKTwoLineTitleView.h"

//controller
#import "KKMyRelativeDynamicVC.h"
#import "KKMyCommentListVC.h"
#import "KKPersonalPageController.h"
//#import "ScanViewController.h"
#import "KKScaneViewController.h"

@interface KKMineTableHeaderView ()
{
    CGFloat _topViewHeight;
    CGFloat _centerViewHeight;
    CGFloat _grayBarHeight;
}
//topView
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) DGButton *headIconButton;
@property (nonatomic, weak) DGLabel *nameLabel;
@property (nonatomic, strong) NSMutableArray <KKTwoLineTitleView *>*twoLineViewArr;
@property (nonatomic, strong) NSArray *twoLineTitleArr;

//centerView
@property (nonatomic, weak) UIView *centerView;
@property (nonatomic, strong) NSMutableArray <KKIconTitleView *>*iconTitleViewArr;
@property (nonatomic, strong) NSArray *iconTitleArr;
@property (nonatomic, strong) NSArray *iconNameArr;

@end

@implementation KKMineTableHeaderView

#pragma mark - lazy load
-(NSMutableArray <KKTwoLineTitleView *>*)twoLineViewArr {
    if (!_twoLineViewArr) {
        _twoLineViewArr = [NSMutableArray array];
    }
    return _twoLineViewArr;
}

-(NSArray *)twoLineTitleArr {
    if (!_twoLineTitleArr) {
        _twoLineTitleArr = @[@"关注",@"粉丝",@"获赞",@"获评论",@"获转发"];
    }
    return _twoLineTitleArr;
}

-(NSMutableArray <KKIconTitleView *>*)iconTitleViewArr {
    if (!_iconTitleViewArr) {
        _iconTitleViewArr = [NSMutableArray array];
    }
    return _iconTitleViewArr;
}

-(NSArray *)iconTitleArr {
    if (!_iconTitleArr) {
        _iconTitleArr = @[@"我的发布",@"我的转发",@"我的评论",@"我的点赞",@"我的收藏"];
    }
    return _iconTitleArr;
}

-(NSArray *)iconNameArr {
    if (!_iconNameArr) {
        _iconNameArr = @[@"mine_icon_publish",@"mine_icon_forward",@"mine_icon_comment",@"mine_icon_good",@"mine_icon_collection",];
    }
    return _iconNameArr;
}

#pragma mark - setter
-(void)setModel:(KKUserHomeModel *)model {
    _model = model;
    
    //1.个人信息
    [self.headIconButton sd_setImageWithURL:Url(model.userLogoUrl) forState:UIControlStateNormal];
    self.nameLabel.text = model.userName;
    
    //2.topView的item信息
    for (KKTwoLineTitleView *view in self.twoLineViewArr) {
        NSString *detailTitle = view.detailLabel.text;
        NSInteger count = 0;
        if ([detailTitle isEqualToString:@"关注"]) {
            count = model.myFollowers;
        }else if ([detailTitle isEqualToString:@"粉丝"]){
            count = model.followMyUsers;
        }else if ([detailTitle isEqualToString:@"获赞"]){
            count = model.likeMyUsers;
        }else if ([detailTitle isEqualToString:@"获评论"]){
            count = model.commentMyUsers;
        }else if ([detailTitle isEqualToString:@"获转发"]){
            count = model.transmitMyUsers;
        }

        NSString *title = [NSString stringWithFormat:@"%ld",(long)count];
        if(count > 10000) {
            float f = count/10000.0;
            title = [NSString stringWithFormat:@"%.2fW",floor(f*100)/100];
        }else if(count > 1000) {
            float f = count/1000.0;
            title = [NSString stringWithFormat:@"%.2fK",floor(f*100)/100];
        }
         view.titleLabel.text = title;
    }
}


#pragma mark - life circle

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDimension];
        [self setupSubViews];
    }
    return self;
}


#pragma mark - UI
-(void)setDimension {
    _topViewHeight = iPhoneX ? [ccui getRH:181+24] : [ccui getRH:181];
    _centerViewHeight = [ccui getRH:100];
    _grayBarHeight = [ccui getRH:3];
}

-(void)setupSubViews {
    self.backgroundColor = UIColor.whiteColor;
    CGFloat topViewH = _topViewHeight;
    CGFloat centerViewH = _centerViewHeight;
    CGFloat grayBarH = _grayBarHeight;
    
    //1.topV
    UIView *topV = [[UIView alloc]init];
    self.topView = topV;
    topV.backgroundColor = UIColor.whiteColor;
    [self addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(topViewH);
    }];
    //subviews
    [self setupTopView];
    
    //2.grayBar
    UIView *grayBar1 = [[UIView alloc]init];
    grayBar1.backgroundColor = UIColor.whiteColor;
    [self addSubview:grayBar1];
    [grayBar1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topV.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(grayBarH);
    }];
    
    //3.centerV
    UIView *centerV = [[UIView alloc]init];
    self.centerView = centerV;
    centerV.backgroundColor = UIColor.whiteColor;
    [self addSubview:centerV];
    [centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(grayBar1.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(centerViewH);
    }];
    //subviews
    [self setupCenterView];
    
    //4.grayBar2
//    UIView *grayBar2 = [[UIView alloc]init];
//    grayBar2.backgroundColor = UIColor.whiteColor;
//    [self addSubview:grayBar2];
//    [grayBar2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(centerV.mas_bottom);
//        make.left.right.bottom.mas_equalTo(0);
//    }];
}

-(void)setupTopView {
    WS(weakSelf);
    CGFloat leftSpace = [ccui getRH:15];
    
    //扫描
    DGButton *scanBtn = [DGButton btnWithBgImg:Img(@"mine_icon_scan")];
    [self.topView addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:iPhoneX? 60 : 36]);
        make.right.mas_equalTo(-[ccui getRH:15]);
        make.width.height.mas_equalTo(22);
    }];
    [scanBtn addClickBlock:^(DGButton *btn) {
        [weakSelf pushToScanVC];
    }];
    
    //1.头像
    CGFloat headIconW = [ccui getRH:63];
    CGFloat headIconTopSpace = iPhoneX ? [ccui getRH:81] : [ccui getRH:57];
    
    DGButton *headIconBtn = [[DGButton alloc]init];
    self.headIconButton = headIconBtn;
    headIconBtn.backgroundColor = UIColor.grayColor;
    headIconBtn.layer.cornerRadius = headIconW/2.0;
    headIconBtn.layer.masksToBounds = YES;
    [self.topView addSubview:headIconBtn];
    [headIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.top.mas_equalTo(headIconTopSpace);
        make.width.height.mas_equalTo(headIconW);
    }];
    
    //2.nameL
    DGLabel *nameL = [DGLabel labelWithText:@"xxx" fontSize:[ccui getRH:18] color:COLOR_BLACK_TEXT bold:YES];
    self.nameLabel = nameL;
    [self.topView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headIconBtn.mas_right).mas_offset(leftSpace);
        make.centerY.mas_equalTo(headIconBtn);
    }];
    
    //3.箭头
    DGButton *arrowBtn = [DGButton btnWithImg:Img(@"arrow_right_gray")];
    arrowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.topView addSubview:arrowBtn];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-leftSpace);
        make.centerY.mas_equalTo(headIconBtn);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    arrowBtn.clickTimeInterval = 1.0;
    [arrowBtn addClickBlock:^(DGButton *btn) {
        [weakSelf pushToMyPersonalPageVC];
    }];
    
    //4.items
    CGFloat itemsCount = self.twoLineTitleArr.count;
    CGFloat spaceX = [ccui getRH:10];
    CGFloat itemW = (SCREEN_WIDTH - 2*leftSpace - (itemsCount-1)*spaceX)/itemsCount;
    CGFloat itemH = [ccui getRH:36];
    
    KKTwoLineTitleView *leftItemV = nil;
    for (NSInteger i=0; i<itemsCount; i++) {
        KKTwoLineTitleView *view = [[KKTwoLineTitleView alloc]init];
        view.titleLabel.text = @"";
        view.detailLabel.text = self.twoLineTitleArr[i];
        view.tag = i;
        WS(weakSelf);
        [view addTapWithTimeInterval:1.0 tapBlock:^(NSInteger tag) {
            [weakSelf tapTwoLineTitleView:tag];
        }];
        //add
        [self.twoLineViewArr addObject:view];
        [self.topView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-[ccui getRH:10]);
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
    
}

-(void)setupCenterView {
    
    //过滤
    if (self.iconTitleArr.count != self.iconNameArr.count) {
        [CC_NoticeView showError:@"icon图片和标题个数不一致"];
        return;
    }
    
    //1.bg
    UIImageView *bgImgV = [[UIImageView alloc]initWithImage:Img(@"min_bg_dynamic")];
    [self.centerView addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    //2.itemsV
    UIView *itemsV = [[UIView alloc]init];
    [self.centerView addSubview:itemsV];
    [itemsV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-[ccui getRH:8]);
    }];
    
    //2.items
    CGFloat itemsCount = self.iconTitleArr.count;
    CGFloat leftSpace = [ccui getRH:15];
    CGFloat spaceX = [ccui getRH:10];
    CGFloat itemW = (SCREEN_WIDTH - 2*leftSpace - (itemsCount-1)*spaceX)/itemsCount;
    CGFloat itemH = [ccui getRH:48];
    CGFloat iconH = [ccui getRH:22];
    
    KKIconTitleView *leftItemV = nil;
    for (NSInteger i=0; i<itemsCount; i++) {
        UIImage *img = Img(self.iconNameArr[i]);
        KKIconTitleView *view = [[KKIconTitleView alloc]initWithImg:img title:self.iconTitleArr[i]];
        view.iconHeight = iconH;
        view.tag = i;
        WS(weakSelf);
        [view addTapWithTimeInterval:1.0 tapBlock:^(NSInteger tag) {
            [weakSelf tapIconTitleView:tag];
        }];
        //add
        [self.iconTitleViewArr addObject:view];
        [itemsV addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-[ccui getRH:17]);
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

-(void)tapIconTitleView:(NSInteger)tag {
    //1.过滤越界
    if (tag >= self.iconTitleViewArr.count || tag < 0) {
        return ;
    }
    
    //2.获取title
    KKIconTitleView *view = self.iconTitleViewArr[tag];
    NSString *title = view.titleLabel.text;
    
    if ([title isEqualToString:@"我的发布"]) {
        [self pushToMyRelativeDynamicVC:KKMyDynamicTypeCreate];
    }else if ([title isEqualToString:@"我的转发"]){
         [self pushToMyRelativeDynamicVC:KKMyDynamicTypeTransmit];
    }else if ([title isEqualToString:@"我的点赞"]){
         [self pushToMyRelativeDynamicVC:KKMyDynamicTypeLike];
    }else if ([title isEqualToString:@"我的收藏"]){
         [self pushToMyRelativeDynamicVC:KKMyDynamicTypeCollect];
    }else if ([title isEqualToString:@"我的评论"]){
        [self pushToMyCommentListVC];
    }
}

#pragma mark - jump
-(void)pushToAttentionVC {
    
}

-(void)pushToFansVC {
    
}

-(void)pushToMyPersonalPageVC {
    KKPersonalPageController *vc = [[KKPersonalPageController alloc]init];
    vc.personalPageType = PERSONAL_PAGE_OWNER;
    vc.userId = self.model.userId;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)pushToMyRelativeDynamicVC:(KKMyDynamicType)type {
    KKMyRelativeDynamicVC *vc = [[KKMyRelativeDynamicVC alloc]initWithType:type];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)pushToMyCommentListVC {
    KKMyCommentListVC *vc = [[KKMyCommentListVC alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)pushToScanVC {
    KKScaneViewController *scanVC = [[KKScaneViewController alloc]init];
    [self.viewController.navigationController pushViewController:scanVC animated:YES];
}

@end
