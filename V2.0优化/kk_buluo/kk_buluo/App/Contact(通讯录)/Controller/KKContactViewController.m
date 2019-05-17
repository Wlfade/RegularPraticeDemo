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
#import "KKPersonalPageController.h"
#import "XTPopView.h"
#import "MiSearchBar.h"
#import "KKChatVC.h"
#import "KKCreateGroupViewController.h"
#import "KKAddFriendVC.h"
#import "KKSectionIndexItemView.h"
#import "KKSectionIndexView.h"
@interface KKContactViewController ()<UISearchBarDelegate, MiSearchReturnDelegate, UITableViewDelegate, UITableViewDataSource, KKContractHeaderViewDelegate, SelectIndexPathDelegate, DSectionIndexViewDataSource, DSectionIndexViewDelegate>

/** 搜索栏 */
@property (nonatomic,strong) MiSearchBar *searchBar;
/** 表视图 */
@property (nonatomic,strong) UITableView *contactTableView;
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
/// 是否开始搜索的标志
@property (nonatomic, assign) BOOL isBeginSearch;
@property (nonatomic, strong) dispatch_queue_t queue;
/// 暂无数据视图
@property (nonatomic, strong) UIView *noContentFootView;
/// 自定义索引
@property (nonatomic, strong) KKSectionIndexView *sectionIndexView;
/// 新朋友数量
@property (nonatomic, copy) NSString *friendNewCount;

@end


@implementation KKContactViewController

- (UIView *)noContentFootView{
    if (_noContentFootView == nil) {
        _noContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"还没有联系人, 快去添加吧" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_noContentFootView imageTopY:5 image:[UIImage imageNamed:@"noData_contact"] remindWords:attribute];
        _noContentFootView.hidden = YES;
    }
    return _noContentFootView;
}

- (NSMutableArray *)userSimpleList {
    if (!_userSimpleList) {
        _userSimpleList = [NSMutableArray array];
    }
    return _userSimpleList;
}

- (UITableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT - 44 - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        _contactTableView.tableHeaderView = self.headerView;
//        _contactTableView.tableFooterView = self.noContentFootView;
        _contactTableView.tableFooterView = [[UIView alloc] init];
        _contactTableView.backgroundColor = RGB(247, 248, 249);
        [_contactTableView registerClass:[KKContactCell class] forCellReuseIdentifier:@"cellIdentifier"];
        [_contactTableView setSectionIndexColor:[UIColor darkGrayColor]];
    }
    return _contactTableView;
}

- (MiSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, 44) placeholder:@" 请输入好友角色名"];
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        searchField.font = Font([ccui getRH:16]);
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
        _headerView = [[KKContractHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:224])];
        _headerView.delegate = self;
        
    }
    return _headerView;
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
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    if (arrayForKey.count == 0) {
        return nil;
    }
    KKContactUserInfo *userInfo = arrayForKey[indexPath.row];
    cell.userInfo = userInfo;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

/// 自定义索引处理
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
    if (_allKeys.count == 0) {
        return @"";
    }
    return [_allKeys objectAtIndex:section];
}

- (void)sectionIndexView:(KKSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section {
    [self.contactTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        sectionHeader.backgroundColor = RGB(247, 248, 249);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(22, 0, 37, 30);
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:[ccui getRH:16]];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        label.text = _allKeys[section];
        return sectionHeader;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allKeys.count == 0 || self.allFriends.count == 0) {
        return;
    }
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    
    if (indexPath.row > arrayForKey.count) {
        return;
    }
    
    KKContactUserInfo *userInfo = arrayForKey[indexPath.row];
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    personVC.userId = userInfo.userId;
    personVC.personalPageType = PERSONAL_PAGE_OTHER;
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contactTableView setSeparatorInset:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.contactTableView setLayoutMargins:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
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
        case 2:
        {
            KKMyRecommendViewController *myRecommendVC = [[KKMyRecommendViewController alloc] init];
            [self.navigationController pushViewController:myRecommendVC animated:YES];
        }
            break;
        case 3:
        {
            KKMyAttentionViewController *attentionVC = [[KKMyAttentionViewController alloc] init];
            [self.navigationController pushViewController:attentionVC animated:YES];
        }
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    [self.matchFriendList removeAllObjects];
    if (searchText.length <= 0) {
    } else {
        for (KKContactUserInfo *userInfo in _userSimpleList) {
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

- (void)sortAndRefreshWithList:(NSMutableArray *)friendList {
    WS(weakSelf)
    dispatch_async(self.queue, ^{
        self.matchFriendDic = [KKContactDealTool sortArrayWithPinYin:friendList];
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.allKeys = self.matchFriendDic[@"allKeys"];
            weakSelf.allFriends = self.matchFriendDic[@"infoDic"];
            [weakSelf.contactTableView reloadData];
            
            /// 搜索也要相应的刷新索引
            weakSelf.sectionIndexView.frame = CGRectMake(CGRectGetWidth(weakSelf.contactTableView.frame) - KKSECTION_INDEX_HEIGHT + 10, 0, KKSECTION_INDEX_HEIGHT, 24 * weakSelf.allKeys.count);
            weakSelf.sectionIndexView.centerY = SCREEN_HEIGHT / 2;
            [weakSelf.sectionIndexView setBackgroundViewFrame];
            [weakSelf.sectionIndexView reloadItemViews];
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
    [self loadNewData];
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

#pragma mark -
- (void)loadNewData {
    WS(weakSelf)
    self.contactTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestContactData];
    }];
    [self.contactTableView.mj_header beginRefreshing];
}

#pragma mark - interaction
- (void)clickRightItemButton:(UIBarButtonItem *)item {
    [self showPopView];
}

#pragma mark - PopView show
- (void)showPopView {
    CGPoint originP = CGPointMake(SCREEN_WIDTH - [ccui getRH:50] + 20, STATUS_AND_NAV_BAR_HEIGHT-[ccui getRH:5]);
    UIColor *color = [UIColor whiteColor];
    XTPopTableView *popView = [[XTPopTableView alloc]initWithOrigin:originP Width:[ccui getRH:161] Height:60*2 Type:XTTypeNarmol bgColor:color cornerRadius:5];
    popView.dataArray       = @[@"创建部落群", @"添加好友"];
    popView.images          = @[@"create_group_white", @"add_friends"];
    popView.row_height      = 60;
    popView.delegate        = self;
    popView.fontSize = 17;
    popView.titleTextColor  = COLOR_BLACK_TEXT;
    [popView popView];
}

- (void)selectIndexPathRow:(NSInteger)index {
    if (index == 0) {
        KKCreateGroupViewController *createGroupVC = [[KKCreateGroupViewController alloc] init];
        [self.navigationController pushViewController:createGroupVC animated:YES];
        
    }else if (index == 1) {
        KKAddFriendVC *addFriendVC = [KKAddFriendVC new];
        [self.navigationController pushViewController:addFriendVC animated:YES];
    }
}

#pragma mark - 获取数据
- (void)requestContactData {
//    self.noContentFootView.hidden = YES;
    [self.userSimpleList removeAllObjects];
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    WS(weakSelf)
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FRIEND_QUERY" forKey:@"service"];
    [params  setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params  model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (!str) {
            
            NSMutableArray *userSimpleList = responseDic[@"userSimpleList"];
            [weakSelf.userSimpleList addObjectsFromArray:[KKContactUserInfo mj_objectArrayWithKeyValuesArray:userSimpleList]];
            if (weakSelf.userSimpleList.count == 0) {
                
            }else {
                weakSelf.contactTableView.tableFooterView = [[UIView alloc] init];
                //// 去排序, 取值.
                NSMutableDictionary *dic = [KKContactDealTool sortArrayWithPinYin:weakSelf.userSimpleList];
                weakSelf.allKeys = dic[@"allKeys"];
                weakSelf.allFriends = dic[@"infoDic"];
                [weakSelf.contactTableView reloadData];
                
                /// 自定义索引
                weakSelf.sectionIndexView.frame = CGRectMake(CGRectGetWidth(weakSelf.contactTableView.frame) - KKSECTION_INDEX_HEIGHT + 10, 0, KKSECTION_INDEX_HEIGHT, 24 * weakSelf.allKeys.count);
                weakSelf.sectionIndexView.centerY = SCREEN_HEIGHT / 2;
                [weakSelf.sectionIndexView setBackgroundViewFrame];
                [weakSelf.sectionIndexView reloadItemViews];
            }
        }else {
            [CC_NoticeView showError:str];
        }
        [weakSelf.contactTableView.mj_header endRefreshing];
    }];
}

- (void)requestToNoReadNotesCount {
    WS(weakSelf)
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setValue:@"USER_READ_RECORD_QUERY" forKey:@"service"];
    [params  setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params  model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            weakSelf.friendNewCount = responseDic[@"newFriendCount"];
            [weakSelf.headerView headerViewReloadDataNoReadNotesCount:weakSelf.friendNewCount.integerValue];
        }
    }];
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
    [self requestToNoReadNotesCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    DGLabel *leftItemL = [DGLabel labelWithText:@"通讯录" fontSize:[ccui getRH:18] color:COLOR_BLACK_TEXT bold:YES];
    [self.naviBar addSubview:leftItemL];
    [leftItemL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.naviBar.bottom).offset(-12);
        make.left.mas_equalTo(10);
    }];
    _isBeginSearch = NO;
    self.queue = dispatch_queue_create("sealtalksearch", DISPATCH_QUEUE_SERIAL);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.contactTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestContactData) name:RELOAD_CONTACT_DATA object:nil];
    [self loadNewData];
    /// right button
    DGButton *rightItem = [DGButton btnWithImg:Img(@"navi_add_black")];
    rightItem.frame = CGRectMake(SCREEN_WIDTH - [ccui getRH:50], STATUS_BAR_HEIGHT, 40, 40);
    [rightItem addTarget:self action:@selector(clickRightItemButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:rightItem];
    /// 自定义索引
    [self.view addSubview:self.sectionIndexView];
}
@end
