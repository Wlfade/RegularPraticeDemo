//
//  KKAttentionMoreViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/3/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKAttentionMoreViewController.h"
#import "KKMyRecommendCell.h"
#import "KKAttentionSearchViewController.h"
#import "KKPersonalPageController.h"
#import "MiSearchBar.h"
#define NAVBAR_CHANGE_POINT 50

@interface KKAttentionMoreViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) MiSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *naviImageView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pages;
@property(nonatomic,strong) HHPaginator *paginator;

@end

@implementation KKAttentionMoreViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, 50) placeholder:@"  搜索"];
        _searchBar.placeholder = @"  搜索";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _searchBar.bottom) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"KKMyRecommendCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKMyRecommendCell"];
    if (self.dataArray.count == 0) {
        return nil;
    }
    KKMyRecommend *myRecommend = self.dataArray[indexPath.row];
    /// 是否需要显示关注按钮
    myRecommend.isHasFocus = YES;
    myRecommend.type = commonObjectCertType;
    cell.myRecommend = myRecommend;
    cell.attentionButtonActionBlock = ^(KKMyRecommend * _Nonnull recommend , KKMyRecommendCell *cell) {
        [weakSelf requstToAttentionuserId:recommend withComplete:^{
            if ([[KKUserInfoMgr shareInstance].userId isEqualToString:recommend.userId]) {
                return ;
            }
            recommend.focus = YES;
            cell.myRecommend = recommend;
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKMyRecommend *recommend = self.dataArray[indexPath.row];
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    //// 公会号
    if ([recommend.objectType.name isEqualToString:@"GUILD_INDEX"]) {
        personVC.personalPageType = PERSONAL_PAGE_GUILD;
    }else {
        personVC.personalPageType = PERSONAL_PAGE_OTHER;
    }
    personVC.userId = recommend.userId;
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    KKAttentionSearchViewController *attentionSearchVC = [[KKAttentionSearchViewController alloc] init];
    [self.navigationController pushViewController:attentionSearchVC animated:YES];
    return YES;
}

#pragma mark - 上拉, 下拉 网络请求
- (void)loadData {
    WS(weakSelf)
    /// 下拉清空原数组
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf requstAttentionMoreCurrentPage:weakSelf.pages];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages ++;
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [strongSelf requstAttentionMoreCurrentPage:weakSelf.pages] ;
        }else{
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/**
 requstAttentionMoreCurrentPage 请求关注更多

 @param currentPage 页码
 */
- (void)requstAttentionMoreCurrentPage:(NSInteger)currentPage {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"RECOMMEND_FOLLOW_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:[NSString stringWithFormat:@"%lu", currentPage] forKey:@"currentPage"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];;
        if (str) {
            
            [CC_NoticeView showError:str];
        }else {
            
            weakSelf.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            [weakSelf.dataArray addObjectsFromArray:[KKMyRecommend mj_objectArrayWithKeyValuesArray:responseDic[@"canFollowObjects"]]];
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.tableView reloadData];
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

/**
 requstToAttentionuserId

 @param recommend 需要关注的model
 @param complete 是否关注成功
 */
- (void)requstToAttentionuserId:(KKMyRecommend *)recommend withComplete:(void(^)(void))complete{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
    /// GUILD_INDEX | USER : 公会或者用户
    if ([recommend.objectType.name isEqualToString:@"GUILD_INDEX"]) {
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }else {
        [params setValue:@"USER" forKey:@"subscribeType"];
    }
    [params setValue:recommend.userId forKey:@"objectId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        recommend.isHasFocus = YES;
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            complete();
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WHITE;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"关注感兴趣的人"];
    [self.naviBar.backButton setImage:[UIImage imageNamed:@"navi_back_gray"] forState:UIControlStateNormal];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.dataArray.count > 10) {
//        UIColor *color = [UIColor whiteColor];
//        CGFloat offset_y = scrollView.contentOffset.y;
//
//        if (offset_y > NAVBAR_CHANGE_POINT) {
//
//            self.naviBar.titleLabel.text = @"关注感兴趣的人";
//            self.searchBar.hidden = YES;
//            self.naviImageView.hidden = YES;
//            [self.naviBar.backButton setImage:[UIImage imageNamed:@"navi_back_gray"] forState:UIControlStateNormal];
//            [self.navigationController.navigationBar xtSetBackgroundColor:color];
//            if (self.searchBar.hidden == YES) {
//                self.tableView.frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT);
//            }
//        }else{
//
//            self.naviBar.titleLabel.text = @"";
//            self.searchBar.hidden = NO;
//            self.naviImageView.hidden = NO;
//            [self.naviBar.backButton setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
//            [self.navigationController.navigationBar xtSetBackgroundColor:[color colorWithAlphaComponent:0]];
//            if (self.searchBar.hidden == NO) {
//                self.tableView.frame = CGRectMake(0, self.searchBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchBar.bottom);
//            }
//        }
//    }
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self scrollViewDidScroll:self.tableView];
//    self.tableView.delegate = self;
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar xtReset];
}

@end
