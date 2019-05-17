//
//  KKAddGroupMemberViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKAddGroupMemberViewController.h"
#import "KKContactSelectedCollectionViewCell.h"
#import "KKContactSelectTableViewCell.h"
#import "KKGroupMember.h"
/// 这里处理一个已经是群成员, 就不能继续被邀请的逻辑
@interface KKAddGroupMemberViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, DSectionIndexViewDataSource, DSectionIndexViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIView *searchBarLeftView;
/// 用户好友list
@property (nonatomic, strong) NSMutableArray *userSimpleList;
/// 通过字母排序的好友
@property (nonatomic, strong) NSMutableDictionary *allFriends;
/// A, B, C
@property (nonatomic, strong) NSMutableArray *allKeys;
/// 选中用户集合
@property (nonatomic, strong) NSMutableArray *selectedUserList;
/// ColletionView Max 展示数量
@property (nonatomic, assign) NSInteger maxCount;
/// 数据
@property (nonatomic, strong) NSMutableArray *collectionViewDataArray;
/// 判断当前操作是否是删除操作
@property (nonatomic, assign) BOOL isDeleteUser;
/// 完成按钮
@property (nonatomic, strong) DGButton *doneButton;
/// 搜索得到的匹配数组
@property (nonatomic, strong) NSMutableArray *matchFriendList;
/// 搜索得到的排序好的字典
@property (nonatomic, strong) NSMutableDictionary *matchFriendDic;
/// 搜索得到的keys
@property (nonatomic, strong) NSMutableArray *matchKeys;
/// 判断是否是搜索
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL isBeginSearch;
@property(nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) KKSectionIndexView *sectionIndexView;

@end

@implementation KKAddGroupMemberViewController
#pragma mark - INIT
- (NSMutableArray *)collectionViewDataArray {
    if (!_collectionViewDataArray) {
        _collectionViewDataArray = [NSMutableArray array];
    }
    return _collectionViewDataArray;
}

- (NSMutableArray *)userSimpleList {
    if (!_userSimpleList) {
        _userSimpleList = [NSMutableArray array];
    }
    return _userSimpleList;
}

- (NSMutableArray *)selectedUserList {
    if (!_selectedUserList) {
        _selectedUserList = [NSMutableArray array];
    }
    return _selectedUserList;
}

- (NSMutableArray *)matchFriendList {
    if (!_matchFriendList) {
        _matchFriendList = [NSMutableArray array];
    }
    return _matchFriendList;
}
#pragma mark - UI
- (void)createCollectionView {
    CGRect tempRect = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, 0, [ccui getRH:54]);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView =
    [[UICollectionView alloc] initWithFrame:tempRect collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[KKContactSelectedCollectionViewCell class]
            forCellWithReuseIdentifier:@"KKContactSelectedCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[KKContactSelectTableViewCell class] forCellReuseIdentifier:@"KKContactSelectTableViewCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = COLOR_HEADER_BG;
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    /// 允许多选.
    _tableView.allowsMultipleSelection = YES;
    [self.view addSubview:_tableView];
}

- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, [ccui getRH:54])];
    [self.searchBar setText:NSLocalizedStringFromTable(@"ToSearch", @"RongCloudKit", nil)];
    self.searchField = [self.searchBar valueForKey:@"_searchField"];
    self.searchField.clearButtonMode = UITextFieldViewModeNever;
    self.searchField.textColor = [UIColor colorWithRed:154/255.0 green:159/255.0 blue:164/255.0 alpha:1.0];
    [self.searchBar setDelegate:self];
    [self.searchBar setKeyboardType:UIKeyboardTypeDefault];
    self.searchBarLeftView = self.searchField.leftView;
    
    for (UIView *subView in self.searchBar.subviews) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
            if ([subView isKindOfClass:NSClassFromString(@"UIView")] && subView.subviews.count > 0) {
                [[subView.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }else{
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subView removeFromSuperview];
                break;
            }
            
        }
    }
    [self.view addSubview:self.searchBar];
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

- (void)createDoneButton {
    /// 创建
    _doneButton = [DGButton btnWithFontSize:14 title:@"确定" titleColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0] bgColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]];
    _doneButton.frame = CGRectMake(SCREEN_WIDTH - [ccui getRH:60], STATUS_BAR_HEIGHT + 10, [ccui getRH:50], [ccui getRH:24]);
    _doneButton.layer.borderWidth = 0.5;
    _doneButton.layer.cornerRadius = 2.5;
    _doneButton.clipsToBounds = YES;
    _doneButton.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    [_doneButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:_doneButton];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([ccui getRH:36], [ccui getRH:36]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [ccui getRH:10];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = [ccui getRH:10];
    flowLayout.minimumLineSpacing = [ccui getRH:10];
    return UIEdgeInsetsMake([ccui getRH:10], [ccui getRH:10], [ccui getRH:10], 0);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedUserList.count > 0) {
        return self.selectedUserList.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKContactSelectedCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"KKContactSelectedCollectionViewCell"
                                              forIndexPath:indexPath];
    
    if (self.selectedUserList.count > 0) {
        cell.userInfo = self.selectedUserList[indexPath.item];
    }
    cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch == NO) {
        NSString *key = _allKeys[section];
        NSArray *array = [_allFriends objectForKey:key];
        return array.count;
    }
    return _matchFriendList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:56];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKGroupMember *userInfo;
    KKContactSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKContactSelectTableViewCell"];
    if (_isSearch == NO) {
        NSString *key = [self.allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [self.allFriends objectForKey:key];
        userInfo = arrayForKey[indexPath.row];
        
    }else {
        userInfo = _matchFriendList[indexPath.row];
    }
    
    /// 设置选中状态
    BOOL isSelected = NO;
    for (KKGroupMember *user in self.selectedUserList) {
        if ([userInfo.userId isEqualToString:user.userId]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            isSelected = YES;
        }
    }
    if (isSelected == NO) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    /// 已经是群成员不能被选中
    for (KKGroupMember *user in self.dataArray) {
        if ([userInfo.userId isEqualToString:user.userId]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            isSelected = YES;
            /// 这个标识用来区分, 灰色的图标, 在cell内使用
            userInfo.isExist = YES;
        }
    }
    cell.userInfo = userInfo;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSearch == NO) {
        return _allKeys.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isSearch == NO) {
        if (tableView == self.tableView) {
            return [ccui getRH:25];
        }else {
            return 0.0001;
        }
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
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        sectionHeader.backgroundColor =  COLOR_HEADER_BG;
        UILabel *label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.frame = CGRectMake([ccui getRH:16], [ccui getRH:5], [ccui getRH:10], [ccui getRH:20]);
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:[ccui getRH:14]];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        if (_isSearch == NO) {
            label.text = _allKeys[section];
        }else {
            return nil;
        }
        return sectionHeader;
    }else {
        return nil;
    }
}

/// 得到indexPath.row的model
- (KKGroupMember *)getCurrentCellAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    KKGroupMember *userInfo = arrayForKey[indexPath.row];
    return userInfo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KKGroupMember *userInfo;
    KKContactSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _isDeleteUser = NO;
    if (_isSearch == YES) {
        if (_matchFriendList.count == 0) {
            [self.searchBar resignFirstResponder];
            self.searchBar.showsCancelButton = NO;
            self.searchBar.text = @"搜索";
            [cell setSelected:NO];
            return;
        }
        userInfo = _matchFriendList[indexPath.row];
        if (_selectedUserList.count == 0) {
            [cell setSelected:YES];
            [self.selectedUserList addObject:userInfo];
        }else {
            for (NSInteger i = 0; i < _selectedUserList.count; i ++) {
                KKContactUserInfo *user = _selectedUserList[i];
                if (![user.userId isEqualToString:userInfo.userId] && i == _selectedUserList.count - 1) {
                    [cell setSelected:YES];
                    [self.selectedUserList addObject:userInfo];
                }
            }
        }
        
    }else {
        [cell setSelected:YES];
        NSString *key = [self.allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [self.allFriends objectForKey:key];
        userInfo = arrayForKey[indexPath.row];
        [self.selectedUserList addObject:userInfo];
    }
    /// 更新frame
    NSInteger count = self.selectedUserList.count;
    [self setCollectonViewAndSearchBarFrame:count];
    [self.collectionView reloadData];
    [self setRightButton];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKContactSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    KKGroupMember *userInfo = [self getCurrentCellAtIndexPath:indexPath];
    for (KKGroupMember *user in self.dataArray) {
        if ([userInfo.userId isEqualToString:user.userId]) {
            [cell setSelected:YES];
            return;
        }
    }
    /// 搜索状态下
    if (_isSearch == YES) {
        if (_matchFriendList.count == 0) {
            return;
        }
        KKGroupMember *userInfo = _matchFriendList[indexPath.row];
        for (NSInteger i = 0; i < _selectedUserList.count; i ++) {
            KKGroupMember *user = _selectedUserList[i];
            if ([user.userId isEqualToString:userInfo.userId]) {
                [self.selectedUserList removeObject:user];
            }
        }
    }else {
        [self.selectedUserList removeObject:[self getCurrentCellAtIndexPath:indexPath]];
    }
    [cell setSelected:NO];
    _isDeleteUser = YES;
    /// 更新frame
    NSInteger count = self.selectedUserList.count;
    [self setCollectonViewAndSearchBarFrame:count];
    [self.collectionView reloadData];
    [self setRightButton];
}

/// 设置collectionView和searchBar实时显示的frame效果
- (void)setCollectonViewAndSearchBarFrame:(NSInteger)count {
    CGRect frame = CGRectZero;
    if (count == 0) {
        /// 只显示searchBar
        frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, 0, [ccui getRH:54]);
        self.collectionView.frame = frame;
        self.searchBar.frame = [self getSearchBarFrame:frame];
        self.searchField.leftView = self.searchBarLeftView;
        self.searchBar.text = @"搜索";
    } else if (count == 1) {
        frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, [ccui getRH:46], [ccui getRH:54]);
        self.collectionView.frame = frame;
        self.searchBar.frame = [self getSearchBarFrame:frame];
        self.searchField.leftView = nil;
    } else if (count > 1 && count <= self.maxCount) {
        if (self.isDeleteUser == NO) {
            /// 如果是删除选中的联系人时候的处理
            frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, [ccui getRH:46] + (count - 1) * [ccui getRH:46], [ccui getRH:54]);
            self.collectionView.frame = frame;
            self.searchBar.frame = [self getSearchBarFrame:frame];
        } else if (self.isDeleteUser == YES) {
            if (count < self.maxCount) {
                /// 判断如果当前collectionView的显示数量小于最大展示数量的时候，collectionView和searchBar的frame都会改变
                frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, [ccui getRH:61] + (count - 1) * [ccui getRH:46], [ccui getRH:54]);
                self.collectionView.frame = frame;
                self.searchBar.frame = [self getSearchBarFrame:frame];
            }
        }
    }
}
/// 实时变化完成按钮
- (void)setRightButton {
    self.doneButton.enabled = YES;
    NSString *titleStr;
    if (self.selectedUserList.count > 0) {
        titleStr = [NSString stringWithFormat:@"确定(%zd)", [self.selectedUserList count]];
        self.doneButton.backgroundColor = [UIColor colorWithRed:42/255.0 green:62/255.0 blue:255/255.0 alpha:1.0];
        [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        titleStr = @"确定";
        [self.doneButton setTitleColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.doneButton.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    }
    [self.doneButton setTitle:titleStr forState:UIControlStateNormal];
    self.doneButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (CGRect)getSearchBarFrame:(CGRect)frame {
    CGRect searchBarFrame = CGRectZero;
    frame.origin.x = frame.size.width;
    CGFloat searchBarWidth = [UIScreen mainScreen].bounds.size.width - frame.size.width;
    frame.size.width = searchBarWidth;
    searchBarFrame = frame;
    return searchBarFrame;
}

/// 获得最大选中个数
- (void)setMaxCountForDevice {
    if (SCREEN_WIDTH < 375) {
        self.maxCount = 3;
    } else if (SCREEN_WIDTH >= 375 && SCREEN_WIDTH < 414) {
        self.maxCount = 4;
    } else {
        self.maxCount = 5;
    }
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _isSearch = YES;
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
    [self.tableView reloadData];
}

/**
 searchBarCancelButtonClicked: 点击了cancel

 @param searchBar 对象
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"搜索";
    [self.matchFriendList removeAllObjects];
    _isSearch = NO;
    
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _isSearch = YES;
    self.searchBar.showsCancelButton = YES;
    if ([self.searchField.text isEqualToString:@"搜索"] || [self.searchField.text isEqualToString:@"Search"]) {
        self.searchField.leftView = nil;
        self.searchField.text = @"";
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _isSearch = NO;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _isSearch = NO;
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"添加群成员"];
    
    // Do any additional setup after loading the view.
    self.queue = dispatch_queue_create("sealtalksearch", DISPATCH_QUEUE_SERIAL);
    _isBeginSearch = NO;
    /// 默认不是搜索
    _isSearch = NO;
    /// 默认不是删除操作.
    self.isDeleteUser = NO;
//    [self createSearchBar];
//    [self createCollectionView];
    [self createTableView];
    [self requestContactData];
    [self setMaxCountForDevice];
    [self createDoneButton];
    
    /// 自定义索引
    [self.view addSubview:self.sectionIndexView];
}

/**
 请求通讯录数据
 */
- (void)requestContactData {
    WS(weakSelf)
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FRIEND_QUERY" forKey:@"service"];
    [params  setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params  model:nil finishCallbackBlock:^(NSString *a, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        /// 把数据源传给需要作为搜索源的数组
        NSMutableArray *userSimpleList = responseDic[@"userSimpleList"];
        [weakSelf.userSimpleList addObjectsFromArray:[KKGroupMember mj_objectArrayWithKeyValuesArray:userSimpleList]];
        /// 数组去重
//        for (KKGroupMember *m1 in self.dataArray) {
//            for (KKGroupMember *m2 in self.userSimpleList) {
//                if ([m2.userId isEqualToString:m1.userId]) {
//                    [self.userSimpleList removeObject:m2];
//                    break;
//                }
//                
//            }
//        }
        if (weakSelf.userSimpleList.count == 0) {
            [CC_NoticeView showError:@"暂无好友, 请您去添加好友"];
        }else {

            //// 去排序, 取值.
            weakSelf.allKeys = [KKContactDealTool sortGroupMemberArrayWithPinYin:weakSelf.userSimpleList][@"allKeys"];
            weakSelf.allFriends = [KKContactDealTool sortGroupMemberArrayWithPinYin:weakSelf.userSimpleList][@"infoDic"];
            if (weakSelf.allFriends.count > 0) {
                [self.tableView reloadData];
            }
            /// 自定义索引, 更新frame
            self.sectionIndexView.frame = CGRectMake(CGRectGetWidth(self.tableView.frame) - KKSECTION_INDEX_HEIGHT + 10, 0, KKSECTION_INDEX_HEIGHT, 24 * self.allKeys.count);
            self.sectionIndexView.centerY = SCREEN_HEIGHT / 2;
            [self.sectionIndexView setBackgroundViewFrame];
            [self.sectionIndexView reloadItemViews];
        }
    }];
}

- (void)addButtonAction:(UIButton *)obj {
    if ([obj.titleLabel.text isEqualToString:@"确定"]) {
        return;
    }
    [self requestAddGroupMemberData];
}

- (void)requestAddGroupMemberData {
    NSMutableArray *list = [NSMutableArray array];
    for (KKGroupMember *user in self.selectedUserList) {
        [list addObject:user.userId];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_USER_INVITE_JOIN" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:[list componentsJoinedByString:@","] forKey:@"inviteUserIds"];
    [params setValue:_groupModel.groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSDictionary *dic = resModel.resultDic[@"response"];
            [CC_NoticeView showError:dic[@"error"][@"message"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_GROUP_MEMBER object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
}


@end
