//
//  KKLookAtGroupMemberViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/19.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKLookAtGroupMemberViewController.h"
#import "KKContactCell.h"
#import "KKContactUserInfo.h"
#import "KKGroupMember.h"
#import "KKChatVC.h"
#import "KKDeleteGroupMemberViewController.h"
#import "KKAddGroupMemberViewController.h"
#import "KKPersonalPageController.h"
//自定义消息
#import "KKChatContactMsgContent.h"

@interface KKLookAtGroupMemberViewController ()<UITableViewDelegate, UITableViewDataSource, DSectionIndexViewDataSource, DSectionIndexViewDelegate>
@property (nonatomic,strong) UITableView *contactTableView;
/// 通过字母排序的好友
@property (nonatomic, strong) NSMutableDictionary *allFriends;
/// A, B, C
@property (nonatomic, strong) NSMutableArray *allKeys;
@property (nonatomic, strong) KKSectionIndexView *sectionIndexView;

@end

@implementation KKLookAtGroupMemberViewController

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}

- (UITableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        _contactTableView.backgroundColor = COLOR_HEADER_BG;
        [_contactTableView registerClass:[KKContactCell class] forCellReuseIdentifier:@"cellIdentifier"];
        [_contactTableView setSectionIndexColor:[UIColor darkGrayColor]];
        _contactTableView.tableFooterView = [[UIView alloc] init];
    }
    return _contactTableView;
}

- (KKSectionIndexView *)sectionIndexView {
    if (!_sectionIndexView) {
        _sectionIndexView = [[KKSectionIndexView alloc] init];
        _sectionIndexView.backgroundColor = [UIColor clearColor];
        _sectionIndexView.dataSource = self;
        _sectionIndexView.delegate = self;
        _sectionIndexView.isShowCallout = YES;
        _sectionIndexView.calloutViewType = CalloutViewTypeForUserDefined;
        _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
        _sectionIndexView.calloutMargin = 100.f;
    }
    return _sectionIndexView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _allKeys[section];
    NSArray *array = [_allFriends objectForKey:key];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:56];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (self.allKeys.count == 0) {
        return nil;
    }
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    KKGroupMember *userInfo = arrayForKey[indexPath.row];
    cell.userInfo = userInfo;
    WS(weakSelf)
    /// 点击了头像
    cell.tapHeaderBlock = ^{
        KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
        if ([userInfo.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
            personVC.personalPageType = PERSONAL_PAGE_OWNER;
        }else {
            personVC.personalPageType = PERSONAL_PAGE_OTHER;
        }
        personVC.userId = userInfo.userId;
        [weakSelf.navigationController pushViewController:personVC animated:YES];
    };
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        return [ccui getRH:30];
    }else {
        return 0.0001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

/// 自定有索引处理
- (NSInteger)numberOfItemViewForSectionIndexView:(KKSectionIndexView *)sectionIndexView {
    return _allKeys.count;
}

- (KKSectionIndexItemView *)sectionIndexView:(KKSectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section {
    KKSectionIndexItemView *itemView = [[KKSectionIndexItemView alloc] init];
    itemView.titleLabel.text = [_allKeys objectAtIndex:section];
    itemView.titleLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:13];
    itemView.titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    itemView.titleLabel.highlightedTextColor = COLOR_HEADER_BG;
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    return itemView;
}

- (UIView *)sectionIndexView:(KKSectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 80, 80);
    label.backgroundColor = [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1/1.0];
    label.textColor =  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.layer.cornerRadius = 40;
    label.clipsToBounds = YES;
    label.text = [_allKeys objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSString *)sectionIndexView:(KKSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section {
    return [_allKeys objectAtIndex:section];
}

- (void)sectionIndexView:(KKSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section {
    [self.contactTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        sectionHeader.backgroundColor =  RGB(247, 248, 249);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake([ccui getRH:20], 0, [ccui getRH:37], [ccui getRH:30]);
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:[ccui getRH:14]];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        label.text = _allKeys[section];
        return sectionHeader;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"群成员"];

    [self.view addSubview:self.contactTableView];
    /// 三个点
    DGButton *selectOperationType = [DGButton btnWithImg:[UIImage imageNamed:@"more_threepoint_black"]];
    selectOperationType.frame = CGRectMake(SCREEN_WIDTH - [ccui getRH:50], STATUS_BAR_HEIGHT + 10, [ccui getRH:50], [ccui getRH:24]);
    [selectOperationType addTarget:self action:@selector(showPopViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:selectOperationType];
    /// 自定义索引相关
    [self.view addSubview:self.sectionIndexView];
}


#pragma mark - 网络相关
- (void)loadNewData {
    WS(weakSelf)
    /// 下拉清空原数组
    self.contactTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestGroupMemberData];
    }];
    [self.contactTableView.mj_header beginRefreshing];
}

/// 查询群成员信息
- (void)requestGroupMemberData {
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    [self.memberArray removeAllObjects];
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_MEMBER_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupModel.groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            
            [weakSelf.memberArray addObjectsFromArray:[KKGroupMember mj_objectArrayWithKeyValuesArray:responseDic[@"groupUserSimples"]]];
            /// 对数据进行处理分类
            NSMutableDictionary *dic = [KKContactDealTool sortGroupMemberArrayWithPinYin:self.memberArray];
            weakSelf.allKeys = dic[@"allKeys"];
            weakSelf.allFriends = dic[@"infoDic"];
            if (weakSelf.allFriends.count > 0) {
                [weakSelf.contactTableView reloadData];
            }
            if (weakSelf.memberArray.count > 0) {
                [weakSelf.contactTableView reloadData];
            }
            /// 自定义索引
            weakSelf.sectionIndexView.frame = CGRectMake(CGRectGetWidth(weakSelf.contactTableView.frame) - KKSECTION_INDEX_HEIGHT + 10, 0, KKSECTION_INDEX_HEIGHT, 24 * weakSelf.allKeys.count);
            weakSelf.sectionIndexView.centerY = SCREEN_HEIGHT / 2;
            [weakSelf.sectionIndexView setBackgroundViewFrame];
            [weakSelf.sectionIndexView reloadItemViews];
        }
        [weakSelf.contactTableView.mj_header endRefreshing];
    }];
}

- (void)showPopViewAction {
    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:self.groupModel.creator.userId]) {
        NSArray *optionArray = @[@"邀请新好友",@"删除群好友"];
        ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray completion:^(NSInteger index) {
            if (index == 0) {
                /// 邀请新的好友
                KKAddGroupMemberViewController *addGroupMemberVC  = [[KKAddGroupMemberViewController alloc] init];
                addGroupMemberVC.groupModel = self.groupModel;
                addGroupMemberVC.dataArray = self.memberArray;
                [self.navigationController pushViewController:addGroupMemberVC animated:YES];
            }else if (index == 1){
                /// 删除群成员
                KKDeleteGroupMemberViewController *deleteGroupMemerVC = [[KKDeleteGroupMemberViewController alloc] init];
                deleteGroupMemerVC.dataArray = self.memberArray;
                deleteGroupMemerVC.groupModel = self.groupModel;
                [self.navigationController pushViewController:deleteGroupMemerVC animated:YES];
            }
        } cancel:^{
        }];
        [sheetView show];
    }else {
        NSArray *optionArray = @[@"邀请新好友"];
        ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray completion:^(NSInteger index) {
            if (index == 0) {
                /// 邀请新的好友
                KKAddGroupMemberViewController *addGroupMemberVC  = [[KKAddGroupMemberViewController alloc] init];
                addGroupMemberVC.groupModel = self.groupModel;
                addGroupMemberVC.dataArray = self.memberArray;
                [self.navigationController pushViewController:addGroupMemberVC animated:YES];
            }
        } cancel:^{
        }];
        [sheetView show];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadNewData];
}

@end
