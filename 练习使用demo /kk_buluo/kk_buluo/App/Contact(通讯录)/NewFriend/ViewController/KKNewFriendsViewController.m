//
//  KKNewFriendsViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKNewFriendsViewController.h"
#import "KKNewFriendsCell.h"
#import "KKNewFriendsModel.h"
#import "KKPersonalPageController.h"

@interface KKNewFriendsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *nearlyThreeDaysApplies; /// threeDaysAgoApplies
@property (nonatomic, strong) NSMutableArray *threeDaysAgoApplies;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) HHPaginator *paginator;
@property (nonatomic, strong) UIView *friendsNoContentFootView;
@end

@implementation KKNewFriendsViewController

- (UIView *)friendsNoContentFootView{
    if (_friendsNoContentFootView == nil) {
        _friendsNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"关注获取更多内容哦" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_friendsNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_recommend"] remindWords:attribute];
        _friendsNoContentFootView.hidden = YES;
    }
    return _friendsNoContentFootView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[KKNewFriendsCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.tableFooterView = self.friendsNoContentFootView;
    }
    return _tableView;
}

- (NSMutableArray *)nearlyThreeDaysApplies {
    if (!_nearlyThreeDaysApplies) {
        _nearlyThreeDaysApplies = [NSMutableArray array];
    }
    return _nearlyThreeDaysApplies;
}

- (NSMutableArray *)threeDaysAgoApplies {
    if (!_threeDaysAgoApplies) {
        _threeDaysAgoApplies = [NSMutableArray array];
    }
    return _threeDaysAgoApplies;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count == 0) {
        return 0;
    }else if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
        return 1;
    }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count == 0) {
        return 0;
    }else if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
        return self.nearlyThreeDaysApplies.count;
    }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
        return self.threeDaysAgoApplies.count;
    }else {
        if (section == 0) {
            return self.nearlyThreeDaysApplies.count;
        }else {
            return self.threeDaysAgoApplies.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:56];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ccui getRH:33];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKNewFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count == 0) {
        
    }else if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
        cell.friendsModel = self.nearlyThreeDaysApplies[indexPath.row];
    }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
        cell.friendsModel = self.threeDaysAgoApplies[indexPath.row];
    }else {
        if (indexPath.section == 0) {
            cell.friendsModel = self.nearlyThreeDaysApplies[indexPath.row];
        }else {
            cell.friendsModel = self.threeDaysAgoApplies[indexPath.row];
        }
    }
    /// 同意添加朋友
    WS(weakSelf)
    cell.agreeAddFriendBlock = ^(KKNewFriendsModel *model) {
        [weakSelf toRequestAgreeAddFriend:model];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        sectionHeader.backgroundColor =  RGB(247, 248, 249);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake([ccui getRH:15], [ccui getRH:10], [ccui getRH:43], [ccui getRH:13]);
        label.adjustsFontSizeToFitWidth = YES;
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:[ccui getRH:17]];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
            label.text = self.sectionArray[0];
        }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
            label.text = self.sectionArray[1];
        }else {
            label.text = self.sectionArray[section];
        }
        return sectionHeader;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKNewFriendsModel *friendsModel;
    if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count == 0) {
    }else if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
        friendsModel = self.nearlyThreeDaysApplies[indexPath.row];
    }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
        friendsModel = self.threeDaysAgoApplies[indexPath.row];
    }else {
        if (indexPath.section == 0) {
            friendsModel = self.nearlyThreeDaysApplies[indexPath.row];
        }else {
            friendsModel = self.threeDaysAgoApplies[indexPath.row];
        }
    }
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    personVC.userId = friendsModel.userId;
    personVC.personalPageType = PERSONAL_PAGE_OTHER;
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"新朋友"];
    
    [self.view addSubview:self.tableView];
    self.sectionArray = @[@"近三天", @"三天前"];

    self.pages = 1;
    [self loadNewData];
}

- (void)loadNewData {
    WS(weakSelf)
    /// 下拉清空原数组
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages = 1;
        [weakSelf.threeDaysAgoApplies removeAllObjects];
        [weakSelf.nearlyThreeDaysApplies removeAllObjects];
        [weakSelf requestNewFriendData:weakSelf.pages];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    /// 上拉
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages ++;
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [weakSelf requestNewFriendData:weakSelf.pages];
        }else{
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/**
 requestNewFriendData : 请求新朋友列表数据

 @param currentPage 页码
 */
- (void)requestNewFriendData:(NSInteger)currentPage {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_APPLY_FRIEND_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:[NSString stringWithFormat:@"%lu", currentPage] forKey:@"currentPage"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
       
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        weakSelf.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
        NSNumber *success = responseDic[@"success"];
        if (success.integerValue == 1) {        
            [weakSelf.threeDaysAgoApplies addObjectsFromArray:[KKNewFriendsModel mj_objectArrayWithKeyValuesArray:responseDic[@"threeDaysAgoApplies"]]];
            [weakSelf.nearlyThreeDaysApplies addObjectsFromArray:[KKNewFriendsModel mj_objectArrayWithKeyValuesArray:responseDic[@"nearlyThreeDaysApplies"]]];
            
            if (weakSelf.threeDaysAgoApplies.count != 0 || weakSelf.nearlyThreeDaysApplies.count != 0) {
                weakSelf.tableView.tableFooterView = [[UIView alloc] init];
                [weakSelf.tableView reloadData];
            }
        }
        weakSelf.friendsNoContentFootView.hidden = NO;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 同意好友添加
- (void)toRequestAgreeAddFriend:(KKNewFriendsModel *)model {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"AUIT_FRIEND" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:model.ID forKey:@"id"];
    [params setValue:@"AGREED" forKey:@"status"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_CONTACT_DATA object:nil];
            [weakSelf loadNewData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
@end
