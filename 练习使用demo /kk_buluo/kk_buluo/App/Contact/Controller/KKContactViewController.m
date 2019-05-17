//
//  KKContactViewController.m
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKContactViewController.h"
#import "KKContactCell.h"
#import "KKContractHeaderView.h"
#import "KKNewFriendsViewController.h"
#import "KKMyRecommendViewController.h"
#import "KKContactUserInfo.h"
#import "KKGroupViewController.h"
#import "KKMyAttentionViewController.h"
//-------view
#import "MiSearchBar.h"
#import "KKChatVC.h"

@interface KKContactViewController ()<UISearchBarDelegate, MiSearchReturnDelegate, UITableViewDelegate, UITableViewDataSource, KKContractHeaderViewDelegate>

/** 搜索栏 */
@property (nonatomic,strong) MiSearchBar *searchBar;
/** 表视图 */
@property (nonatomic,strong) UITableView *contactTableView;
/** 数据字典 */
@property (nonatomic,strong) NSDictionary *contactDict;
/** keys数组 */
@property (nonatomic,strong) NSMutableArray *sectionKeys;
/// 表视图的header
@property (nonatomic, strong) KKContractHeaderView *headerView;
/// 用户好友list
@property (nonatomic, strong) NSMutableArray *userSimpleList;
/// 通过字母排序的好友
@property (nonatomic, strong) NSMutableDictionary *allFriends;
/// A, B, C
@property (nonatomic, strong) NSMutableArray *allKeys;
/// 搜索得到的匹配数组
@property (nonatomic, strong) NSMutableArray *matchFriendList;
/// 排序好的字典
@property (nonatomic, strong) NSMutableDictionary *matchFriendDic;

@property (nonatomic, assign) BOOL isBeginSearch;
@property(nonatomic, strong) dispatch_queue_t queue;
@end


@implementation KKContactViewController
- (NSMutableArray *)userSimpleList {
    if (!_userSimpleList) {
        _userSimpleList = [NSMutableArray array];
    }
    return _userSimpleList;
}

- (UITableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT - 44) style:UITableViewStylePlain];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        _contactTableView.tableHeaderView = self.headerView;
        _contactTableView.tableFooterView = [[UIView alloc] init];
        [_contactTableView registerClass:[KKContactCell class] forCellReuseIdentifier:@"cellIdentifier"];
        [_contactTableView setSectionIndexColor:[UIColor darkGrayColor]];
    }
    return _contactTableView;
}

- (MiSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, 44) placeholder:@"  搜索"];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (NSMutableArray *)matchFriendList {
    if (!_matchFriendList) {
        _matchFriendList = [NSMutableArray array];
    }
    return _matchFriendList;
}

- (KKContractHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[KKContractHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _allKeys[section];
    NSArray *array = [_allFriends objectForKey:key];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
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
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        return 40;
    }else {
        return 0.0001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

/// 现实索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _allKeys;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1/1.0];
        sectionHeader.backgroundColor =  [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1/1.0];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(22, 0, 37, 37);
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:18];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        label.text = _allKeys[section];
        return sectionHeader;
    }else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    KKGroupMember *userInfo = arrayForKey[indexPath.row];
    KKChatVC *chatVC = [[KKChatVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:userInfo.userId];
    
    [self.navigationController pushViewController:chatVC animated:YES];
}
#pragma mark KKContractHeaderViewDelegate
- (void)didSelectContractHeaderViewForRow:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            KKNewFriendsViewController *newFriendsVC = [[KKNewFriendsViewController alloc] init];
            [self.navigationController pushViewController:newFriendsVC animated:YES];
        }
            break;
        case 1:
        {
            KKGroupViewController *groupVC = [[KKGroupViewController alloc] init];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
            break;
        case 3:
        {
            KKMyRecommendViewController *myRecommendVC = [[KKMyRecommendViewController alloc] init];
            [self.navigationController pushViewController:myRecommendVC animated:YES];
        }
            break;
        case 4:
        {
            KKMyAttentionViewController *attentionVC = [[KKMyAttentionViewController alloc] init];
            [self.navigationController pushViewController:attentionVC animated:YES];
        }
        default:
            break;
    }
}
#pragma mark - UISearchBarDelegate
/**
*  执行delegate
*
*  @param searchBar  searchBar description
*  @param searchText searchText description
*/
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    [self.matchFriendList removeAllObjects];
    if (searchText.length <= 0) {
    } else {
        for (KKGroupMember *userInfo in _userSimpleList) {
            /// 忽略大小写去判断是否包含
            if ([userInfo.loginName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [[KKContactDealTool transform:userInfo.loginName] rangeOfString:searchText
                                                                            options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [self.matchFriendList addObject:userInfo];
            }
        }
    }
    /// 去排序, 并刷新列表
    [self sortAndRefreshWithList:self.matchFriendList];
}
/// 排序并刷新
- (void)sortAndRefreshWithList:(NSMutableArray *)friendList {
    dispatch_async(self.queue, ^{
        self.matchFriendDic = [KKContactDealTool sortArrayWithPinYinArray:friendList];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.allKeys = self.matchFriendDic[@"allKeys"];
            self.allFriends = self.matchFriendDic[@"infoDic"];
            [self.contactTableView reloadData];
        });
    });
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [self.matchFriendList removeAllObjects];
    _isBeginSearch = NO;
    _contactTableView.tableHeaderView = self.headerView;
    [self getData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (_isBeginSearch == NO) {
        _isBeginSearch = YES;
        _contactTableView.tableHeaderView = [[UIView alloc] init];
    }
    self.searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isBeginSearch = NO;
    self.queue = dispatch_queue_create("sealtalksearch", DISPATCH_QUEUE_SERIAL);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.contactTableView];
    [self getData];
}

#pragma mark - 获取数据
- (void)getData {
    [self.userSimpleList removeAllObjects];
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    WS(weakSelf)
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FRIEND_QUERY" forKey:@"service"];
    [params  setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params  model:nil finishCallbackBlock:^(NSString *a, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSMutableArray *userSimpleList = responseDic[@"userSimpleList"];
        [weakSelf.userSimpleList addObjectsFromArray:[KKGroupMember mj_objectArrayWithKeyValuesArray:userSimpleList]];
        if (weakSelf.userSimpleList.count == 0) {
            [CC_NoticeView showError:@"暂无好友, 请您去添加好友"];
        }else {
            //// 去排序, 取值.
            weakSelf.allKeys = [KKContactDealTool sortGroupMemberArrayWithPinYinArray:weakSelf.userSimpleList][@"allKeys"];
            weakSelf.allFriends = [KKContactDealTool sortGroupMemberArrayWithPinYinArray:weakSelf.userSimpleList][@"infoDic"];
            if (weakSelf.allFriends.count > 0) {
                [self.contactTableView reloadData];
            }
        }
    }];
}
@end
