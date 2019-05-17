//
//  KKSelectFriendsViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKSelectFriendsViewController.h"
#import "KKContactSelectedCollectionViewCell.h"
#import "KKContactSelectTableViewCell.h"
#import "KKContactUserInfo.h"
#import "KKChatVC.h"
#import "KKPersonalPageController.h"
#import "KKSectionIndexItemView.h"
#import "KKSectionIndexView.h"

@interface KKSelectFriendsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, DSectionIndexViewDelegate, DSectionIndexViewDataSource>
#warning 这个VC的collectionView暂时没用到, 不要删除. 用来动态显示好友选中个数的.
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
/// 是否开始搜索
@property (nonatomic, assign) BOOL isBeginSearch;
@property (nonatomic, strong) dispatch_queue_t queue;
/// 自定义UITableView索引
@property (nonatomic, strong) KKSectionIndexView *sectionIndexView;
@end

@implementation KKSelectFriendsViewController

#pragma mark - INIT

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
    CGRect tempRect = CGRectMake(0, self.searchBar.bottom, 0, [ccui getRH:54]);
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_HEADER_BG;
    [_tableView registerClass:[KKContactSelectTableViewCell class] forCellReuseIdentifier:@"KKContactSelectTableViewCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
    /// 允许多选.
    _tableView.allowsMultipleSelection = YES;
    [self.view addSubview:_tableView];
}

- (void)createSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, [ccui getRH:54])];
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

- (void)createDoneButton {
    /// 创建
    _doneButton = [DGButton btnWithFontSize:[ccui getRH:14] title:@"确定" titleColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0] bgColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]];
    _doneButton.frame = CGRectMake(SCREEN_WIDTH - [ccui getRH:60] - [ccui getRH:20], STATUS_BAR_HEIGHT + 10, [ccui getRH:50], [ccui getRH:24]);
    _doneButton.layer.borderWidth = 0.5;
    _doneButton.layer.cornerRadius = 2.5;
    _doneButton.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    [_doneButton addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    KKContactUserInfo *userInfo;
    KKGroupMember *member = [[KKGroupMember alloc] init];
    KKContactSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKContactSelectTableViewCell"];
    if (_isSearch == NO) {
        NSString *key = [self.allKeys objectAtIndex:indexPath.section];
        NSArray *arrayForKey = [self.allFriends objectForKey:key];
        userInfo = arrayForKey[indexPath.row];
        member.loginName = userInfo.loginName;
        member.userLogoUrl = userInfo.userLogoUrl;
        member.userId = userInfo.userId;
        cell.userInfo = member;
    }else {
        userInfo = _matchFriendList[indexPath.row];
        member.loginName = userInfo.loginName;
        member.userLogoUrl = userInfo.userLogoUrl;
        member.userId = userInfo.userId;
        cell.userInfo = member;
    }
    /// 跳转到他人个人主页
    cell.tapPortraitImageViewBlock = ^{
        KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
        personVC.userId = userInfo.userId;
        personVC.personalPageType = PERSONAL_PAGE_OTHER;
        [self.navigationController pushViewController:personVC animated:YES];
    };
    /// 设置选中状态
    BOOL isSelected = NO;
    for (KKContactUserInfo *user in self.selectedUserList) {
        if ([userInfo.userId isEqualToString:user.userId]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            isSelected = YES;
        }
    }
    if (isSelected == NO) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    /// 是否为搜索状态
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
        sectionHeader.backgroundColor = COLOR_HEADER_BG;
        UILabel *label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.frame = CGRectMake([ccui getRH:16], [ccui getRH:5], [ccui getRH:10], [ccui getRH:11]);
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:[ccui getRH:14]];
        label.textColor = COLOR_BLACK_TEXT;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
}

/// 得到indexPath.row的model
- (KKContactUserInfo *)getCurrentCellAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    KKContactUserInfo *userInfo = arrayForKey[indexPath.row];
    return userInfo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKContactUserInfo *userInfo;
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
    
    /// 搜索状态下
    if (_isSearch == YES) {
        if (_matchFriendList.count == 0) {
            return;
        }
        KKContactUserInfo *userInfo = _matchFriendList[indexPath.row];
        for (NSInteger i = 0; i < _selectedUserList.count; i ++) {
            KKContactUserInfo *user = _selectedUserList[i];
            if ([user.userId isEqualToString:userInfo.userId]) {
                [self.selectedUserList removeObject:user];
            }
        }
    }else {
        [self.selectedUserList removeObject:[self getCurrentCellAtIndexPath:indexPath]];
    }
    KKContactSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
            //如果是删除选中的联系人时候的处理
            frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, [ccui getRH:46] + (count - 1) * [ccui getRH:46], [ccui getRH:54]);
            self.collectionView.frame = frame;
            self.searchBar.frame = [self getSearchBarFrame:frame];
        } else if (self.isDeleteUser == YES) {
            if (count < self.maxCount) {
                //判断如果当前collectionView的显示数量小于最大展示数量的时候，collectionView和searchBar的frame都会改变
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
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _isSearch = YES;
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
    [self.tableView reloadData];
}
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"选择联系人"];
    
    self.queue = dispatch_queue_create("sealtalksearch", DISPATCH_QUEUE_SERIAL);
    _isBeginSearch = NO;
    /// 默认不是搜索
    _isSearch = NO;
    /// 默认不是删除操作.
    self.isDeleteUser = NO;
    
//    [self createSearchBar];
//    [self createCollectionView];
    [self createTableView];
//    [self createCollectionView];
    [self getData];
    [self setMaxCountForDevice];
    [self createDoneButton];
    
    [self.view addSubview:self.sectionIndexView];
}

#pragma mark - 获取数据
- (void)getData {

    WS(weakSelf)
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FRIEND_QUERY" forKey:@"service"];
    [params  setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params  model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            
            [CC_NoticeView showError:str];
        }else {
            
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSMutableArray *userSimpleList = responseDic[@"userSimpleList"];
            [weakSelf.userSimpleList addObjectsFromArray:[KKContactUserInfo mj_objectArrayWithKeyValuesArray:userSimpleList]];
            if (weakSelf.userSimpleList.count == 0) {
                [CC_NoticeView showError:@"暂无无好友, 请您去添加好友"];
            }else {
                //// 去排序, 取值.
                weakSelf.allKeys = [KKContactDealTool sortArrayWithPinYin:weakSelf.userSimpleList][@"allKeys"];
                weakSelf.allFriends = [KKContactDealTool sortArrayWithPinYin:weakSelf.userSimpleList][@"infoDic"];
                if (weakSelf.allFriends.count > 0) {
                    [self.tableView reloadData];
                }
                
                /// 自定义索引
                weakSelf.sectionIndexView.frame = CGRectMake(CGRectGetWidth(weakSelf.tableView.frame) - KKSECTION_INDEX_HEIGHT + 10, 0, KKSECTION_INDEX_HEIGHT, 24 * weakSelf.allKeys.count);
                weakSelf.sectionIndexView.centerY = SCREEN_HEIGHT / 2;
                [weakSelf.sectionIndexView setBackgroundViewFrame];
                [weakSelf.sectionIndexView reloadItemViews];
            }
        }
        
    }];
}

#pragma mark - 创建群Action
- (void)createButtonAction:(UIButton *)btn {
    WS(weakSelf)
    _doneButton.userInteractionEnabled = NO;
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
        [CC_NoticeView showError:@"请邀请至少一位好友"];
        _doneButton.userInteractionEnabled = YES;
        return;
    }
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    /// userJoinMode
    NSMutableArray *list = [NSMutableArray array];
    for (KKContactUserInfo *user in self.selectedUserList) {
        [list addObject:user.userId];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_CHAT_CREATE" forKey:@"service"];
    [params safeSetObject:_groupName forKey:@"groupName"];
    [params setValue:_groupIntroduce forKey:@"memo"];
    [params setValue:[list componentsJoinedByString:@","] forKey:@"inviteUserIds"];
    [params setValue:_groupImageFileName forKey:@"logoFileName"];
    [params setValue:@"GROUP_CHAT" forKey:@"typeCode"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        [HUD stop];
        /// 如果不为空
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            KKMyGroup *group= [[KKMyGroup alloc] init];
            group.groupId = responseDic[@"groupId"];
            group.groupName = weakSelf.groupName;
            KKChatVC *chat = [[KKChatVC alloc] init];
            chat.targetId = [responseDic objectForKey:@"groupId"];
            chat.conversationType = ConversationType_GROUP;
            chat.title = weakSelf.groupName;
            [weakSelf.navigationController pushViewController:chat animated:YES];
        }
        weakSelf.doneButton.userInteractionEnabled = YES;
    }];
}
@end
