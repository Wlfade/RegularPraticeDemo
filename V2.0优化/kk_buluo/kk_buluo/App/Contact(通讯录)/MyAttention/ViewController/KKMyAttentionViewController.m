//
//  KKMyAttentionViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/18.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyAttentionViewController.h"
#import "DGItemView.h"
#import "KKMyRecommendCell.h"
#import "KKPersonalPageController.h"

@interface KKMyAttentionViewController ()<DGItemViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) DGItemView *itemView;

@property (nonatomic, strong) UITableView *lTableView;

@property (nonatomic, strong) UITableView *rTableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) NSMutableArray *userArray;

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pages2;

@property (nonatomic, strong) HHPaginator *paginator;
@property (nonatomic, strong) HHPaginator *paginator2;

@property (nonatomic, strong) UIView *attentionNewsNoContentFootView;

@property (nonatomic, strong) UIView *attentionPersonNoContentFootView;
@end

@implementation KKMyAttentionViewController

- (UIView *)attentionNewsNoContentFootView{
    if (_attentionNewsNoContentFootView == nil) {
        _attentionNewsNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"关注获取更多内容哦 (关注更多)" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_attentionNewsNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_recommend"] remindWords:attribute];
        _attentionNewsNoContentFootView.hidden = YES;
    }
    return _attentionNewsNoContentFootView;
}

- (UIView *)attentionPersonNoContentFootView{
    if (_attentionPersonNoContentFootView == nil) {
        _attentionPersonNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"关注获取更多内容哦 (关注更多)" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_attentionPersonNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_recommend"] remindWords:attribute];
        _attentionPersonNoContentFootView.hidden = YES;
    }
    return _attentionPersonNoContentFootView;
}


- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (DGItemView *)itemView {
    if (!_itemView) {
        _itemView = [[DGItemView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, 39)];
        _itemView.titleArr = @[@"公会号", @"达人"];
        _itemView.normalFont = [UIFont systemFontOfSize:14];
        _itemView.selectedFont = [UIFont systemFontOfSize:14];
        _itemView.indicatorScale = 0.4;
        _itemView.backgroundColor = [UIColor whiteColor];
        _itemView.indicatorImage = Img(@"item_scrollLine");
        _itemView.indicatorColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _itemView.selectedColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _itemView.delegate = self;
    }
    return _itemView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8))];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UITableView *)lTableView {
    if (!_lTableView) {
        _lTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8))];
        _lTableView.delegate = self;
        _lTableView.dataSource = self;
        _lTableView.tableFooterView = self.attentionNewsNoContentFootView;
        [_lTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _lTableView;
}

- (UITableView *)rTableView {
    if (!_rTableView) {
        _rTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8))];
        _rTableView.delegate = self;
        _rTableView.dataSource = self;
        _rTableView.tableFooterView = self.attentionPersonNoContentFootView;
        [_rTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellIDWill"];
    }
    return _rTableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.lTableView) {
        return self.messageArray.count;
    }else {
        return self.userArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.lTableView) {
        KKMyRecommend *recommend = self.messageArray[indexPath.row];
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//        recommend.isHasFocus = NO;
        /// commonObjectMemoType,commonObjectCertType,cellType, 区分label显示, 简介还是认真信息
        recommend.type = commonObjectCertType;
        cell.myRecommend = recommend;
        return cell;
    }else {
        KKMyRecommend *recommend = self.userArray[indexPath.row];
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDWill"];
        cell.myRecommend = recommend;
        return cell;
    }
}

#pragma mark - 跳转主页的逻辑
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.lTableView) {
        /// 这里跳转到公会号主页
        KKMyRecommend *recommend = self.messageArray[indexPath.row];
        KKPersonalPageController *vc = [[KKPersonalPageController alloc] init];
        vc.userId = recommend.userId;
        vc.personalPageType = PERSONAL_PAGE_GUILD;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        /// 这里跳转到角色主页
        KKMyRecommend *recommend = self.userArray[indexPath.row];
        KKPersonalPageController *vc = [[KKPersonalPageController alloc] init];
        vc.userId = recommend.userId;
        vc.personalPageType = PERSONAL_PAGE_OTHER;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
}

#pragma mark - DGItemViewDelegate
- (BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
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
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"我的关注"];
    
    self.pages = 1;
    self.pages = 1;
    [self.view addSubview:self.itemView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.lTableView];
    [self.scrollView addSubview:self.rTableView];
    [self loadNewData];
}
#pragma mark - 网络
- (void)loadNewData {
    WS(weakSelf)
    /// 下拉清空原数组
    self.lTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pages = 1;
        [weakSelf.messageArray removeAllObjects];
        [weakSelf requestMyAttenttionType:@"GUILD_INDEX" currentPage:weakSelf.pages];
    }];
    [self.lTableView.mj_header beginRefreshing];
    
    self.rTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pages2 = 1;
        [weakSelf.userArray removeAllObjects];
        [weakSelf requestMyAttenttionType:@"USER" currentPage:weakSelf.pages2];
    }];
    [self.rTableView.mj_header beginRefreshing];
    
    /// 上拉
    self.lTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pages ++;
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            
            strongSelf->_paginator.page++;
            [weakSelf requestMyAttenttionType:@"GUILD_INDEX" currentPage:weakSelf.pages];

        }else{
            
            [strongSelf.lTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    self.rTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages2 ++;
        SS(strongSelf)
        if (strongSelf->_paginator2.page < strongSelf->_paginator2.pages) {
            
            strongSelf->_paginator2.page++;
            [weakSelf requestMyAttenttionType:@"USER" currentPage:weakSelf.pages2];
            
        }else{
            
            [strongSelf.rTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}
#pragma mark - 网络
- (void)requestMyAttenttionType:(NSString *)type currentPage:(NSInteger)currentPage {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"MY_FOLLOW_OBJECT_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:type forKey:@"types"];
    [params setValue:[NSString stringWithFormat:@"%lu", currentPage]forKey:@"currentPage"];
    [params setValue:@"10" forKey:@"pageSize"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            if ([type isEqualToString:@"GUILD_INDEX"]) {
                /// 公会号
                weakSelf.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
                [weakSelf.messageArray addObjectsFromArray:[KKMyRecommend mj_objectArrayWithKeyValuesArray:responseDic[@"myFollowObjects"]]];
                if (weakSelf.messageArray.count > 0) {
                    
                    weakSelf.lTableView.tableFooterView = [[UIView alloc] init];
                    [weakSelf.lTableView reloadData];
                }
            }else {
                /// 达人
                weakSelf.paginator2 = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
                [weakSelf.userArray addObjectsFromArray:[KKMyRecommend mj_objectArrayWithKeyValuesArray:responseDic[@"myFollowObjects"]]];
                if (weakSelf.userArray.count > 0) {
                    
                    weakSelf.rTableView.tableFooterView = [[UIView alloc] init];
                    [weakSelf.rTableView reloadData];
                }
            }
        }
        weakSelf.attentionNewsNoContentFootView.hidden = NO;
        weakSelf.attentionPersonNoContentFootView.hidden = NO;
        [weakSelf.lTableView.mj_header endRefreshing];
        [weakSelf.lTableView.mj_footer endRefreshing];
        [weakSelf.rTableView.mj_header endRefreshing];
        [weakSelf.rTableView.mj_footer endRefreshing];
    }];
}

@end
