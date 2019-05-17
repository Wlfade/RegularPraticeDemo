//
//  KKMyRecommendViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyRecommendViewController.h"
#import "DGItemView.h"
#import "KKMyRecommendCell.h"
#import "KKMyRecommendSonModel.h"
#import "KKPersonalPageController.h"

@interface KKMyRecommendViewController ()<DGItemViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) DGItemView *itemView;
/// 推荐成功表视图
@property (nonatomic, strong) UITableView *didJoinInTableView;
/// 待加入
@property (nonatomic, strong) UITableView *willJoinInTableView;
/// 滑动视图
@property (nonatomic, strong) UIScrollView *scrollView;
/// 推荐成功数组
@property (nonatomic, strong) NSMutableArray *successArray;
/// 待加入
@property (nonatomic, strong) NSMutableArray *willJoinInArray;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pages2;
@property (nonatomic, strong) HHPaginator *paginator;
@property (nonatomic, strong) HHPaginator *paginator2;

@property (nonatomic, strong) UIView *successNoContentFootView;
@property (nonatomic, strong) UIView *willNoContentFootView;

@end

@implementation KKMyRecommendViewController

- (UIView *)successNoContentFootView{
    if (_successNoContentFootView == nil) {
        _successNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"可以把部落推荐给好友哦" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_successNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_contact"] remindWords:attribute];
        _successNoContentFootView.hidden = YES;
    }
    return _successNoContentFootView;
}

- (UIView *)willNoContentFootView{
    if (_willNoContentFootView == nil) {
        _willNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"可以把部落推荐给好友哦" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_willNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_contact"] remindWords:attribute];
        _willNoContentFootView.hidden = YES;
    }
    return _willNoContentFootView;
}

- (NSMutableArray *)successArray {
    if (!_successArray) {
        _successArray = [NSMutableArray array];
    }
    return _successArray;
}

- (NSMutableArray *)willJoinInArray {
    if (!_willJoinInArray) {
        _willJoinInArray = [NSMutableArray array];
    }
    return _willJoinInArray;
}

- (DGItemView *)itemView {
    if (!_itemView) {
        _itemView = [[DGItemView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, 39)];
        _itemView.titleArr = @[@"推荐成功", @"待加入"];
        _itemView.normalFont = [UIFont systemFontOfSize:14];
        _itemView.selectedFont = [UIFont systemFontOfSize:14];
        _itemView.indicatorScale = 0.4;
        _itemView.backgroundColor = [UIColor whiteColor];
        _itemView.indicatorImage = Img(@"item_scrollLine");
        _itemView.indicatorColor = RGB(50, 50, 50);
        _itemView.selectedColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _itemView.delegate = self;
    }
    return _itemView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 5, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8))];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UITableView *)didJoinInTableView {
    
    if (!_didJoinInTableView) {
        
        _didJoinInTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8))];
        _didJoinInTableView.delegate = self;
        _didJoinInTableView.dataSource = self;
        _didJoinInTableView.tableFooterView = self.successNoContentFootView;
        [_didJoinInTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _didJoinInTableView;
}

- (UITableView *)willJoinInTableView {
    
    if (!_willJoinInTableView) {
        
        _willJoinInTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8))];
        _willJoinInTableView.delegate = self;
        _willJoinInTableView.dataSource = self;
        _willJoinInTableView.tableFooterView = self.willNoContentFootView;
        [_willJoinInTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellIDWill"];
    }
    return _willJoinInTableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.didJoinInTableView) {
        return self.successArray.count;
    }else {
        return self.willJoinInArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.didJoinInTableView) {
        
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        KKMyRecommendSonModel *recommend = self.successArray[indexPath.row];
        cell.timeLabel.hidden = NO;
        cell.nameLabel.text = recommend.loginName;
        cell.phoneNumLabel.text= recommend.cell;
        [cell.headPicImageView sd_setImageWithURL:[NSURL URLWithString:recommend.userLogoUrl]];
        cell.timeLabel.text = [CC_Time getTimeStringWithNowDate:[self getCurrentTimeStr] OldDate:recommend.gmtInvite];
        return cell;
    }else if (tableView == self.willJoinInTableView) {
        
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDWill"];
        KKMyRecommendSonModel *recommend = self.willJoinInArray[indexPath.row];
        cell.timeLabel.hidden = NO;
        cell.headPicImageView.backgroundColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:255/255.0 alpha:1.0];
        cell.phoneNumLabel.text= recommend.cell;
        cell.timeLabel.text = [CC_Time getTimeStringWithNowDate:[self getCurrentTimeStr] OldDate:recommend.gmtInvite];
        return cell;
    }
    return nil;
}

/**
 getCurrentTimeStr 获取字符串类型的当前时间

 @return value
 */
- (NSString *)getCurrentTimeStr {
    NSDate *data = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *timeStr = [dateFormatter stringFromDate:data];
    return timeStr;
}

/// 调整tableView分割线的宽度
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
}

#pragma mark - 跳转个人主页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKMyRecommendSonModel *recommend;
    /// 成功邀请的才能跳转个人主页
    if (tableView == self.didJoinInTableView) {
        recommend = self.successArray[indexPath.row];
        KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
        personVC.userId = recommend.userId;
        personVC.personalPageType = PERSONAL_PAGE_OTHER;
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

#pragma mark - DGItemViewDelegate
- (BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    /// RECOMMEND_REGISTER_QUERY 状态，我的推荐 取SUCCESS，待加入的取WAIT
    if (index == 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }else {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        self.itemView.selectedIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"我的推荐"];
    
    self.pages = 1;
    self.pages2 = 1;
    [self.view addSubview:self.itemView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.didJoinInTableView];
    [self.scrollView addSubview:self.willJoinInTableView];
    [self loadNewData];

}
#pragma mark - 网络
- (void)loadNewData {
    WS(weakSelf)
    /// 下拉清空原数组
    self.didJoinInTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages = 1;
        [weakSelf.successArray removeAllObjects];
        [weakSelf requestMyRecommendData:@"SUCCESS" currentPage:weakSelf.pages];
    }];
    [self.didJoinInTableView.mj_header beginRefreshing];

    self.willJoinInTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages2 = 1;
        [weakSelf.willJoinInArray removeAllObjects];
        [weakSelf requestMyRecommendData:@"WAIT" currentPage:weakSelf.pages];
    }];
    [self.willJoinInTableView.mj_header beginRefreshing];
    
    self.didJoinInTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages ++;
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [weakSelf requestMyRecommendData:@"SUCCESS" currentPage:weakSelf.pages];
        }else{
            [strongSelf.didJoinInTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    self.willJoinInTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages2 ++;
        SS(strongSelf)
        if (strongSelf->_paginator2.page < strongSelf->_paginator2.pages) {
            strongSelf->_paginator2.page++;
            [weakSelf requestMyRecommendData:@"WAIT" currentPage:weakSelf.pages2];
        }else{
            [strongSelf.willJoinInTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}

/**
 requestMyRecommendData : 获取我关注的数据

 @param status 成功还是待加入
 @param currentPage 当前页码
 */
- (void)requestMyRecommendData:(NSString *)status currentPage:(NSInteger)currentPage {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"RECOMMEND_REGISTER_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:status forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%lu", currentPage] forKey:@"currentPage"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];;
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            /// 成功放到成功的数组
            if ([status isEqualToString:@"SUCCESS"]) {
                weakSelf.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];

                [weakSelf.successArray addObjectsFromArray:[KKMyRecommendSonModel mj_objectArrayWithKeyValuesArray:responseDic[@"list"]]];
                [weakSelf.didJoinInTableView reloadData];
                if (weakSelf.successArray.count > 0) {
                    weakSelf.didJoinInTableView.tableFooterView = [[UIView alloc] init];
                }
            }else {
                weakSelf.paginator2 = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];

                [weakSelf.willJoinInArray addObjectsFromArray:[KKMyRecommendSonModel mj_objectArrayWithKeyValuesArray:responseDic[@"list"]]];
                [weakSelf.willJoinInTableView reloadData];
                if (weakSelf.willJoinInArray.count > 0) {
                    weakSelf.willJoinInTableView.tableFooterView = [[UIView alloc] init];
                }
            }
        }
        weakSelf.successNoContentFootView.hidden = NO;
        weakSelf.willNoContentFootView.hidden = NO;
        [weakSelf.didJoinInTableView.mj_header endRefreshing];
        [weakSelf.didJoinInTableView.mj_footer endRefreshing];
        [weakSelf.willJoinInTableView.mj_header endRefreshing];
        [weakSelf.willJoinInTableView.mj_footer endRefreshing];
    }];
}
@end
