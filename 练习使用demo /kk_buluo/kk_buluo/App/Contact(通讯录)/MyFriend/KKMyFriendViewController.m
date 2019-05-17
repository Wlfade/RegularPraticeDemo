//
//  KKMyFriendViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/3/26.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyFriendViewController.h"
#import "KKContactCell.h"


@interface KKMyFriendViewController ()<UITableViewDelegate, UITableViewDataSource, DSectionIndexViewDataSource, DSectionIndexViewDelegate>
/** 表视图 */
@property (nonatomic,strong) UITableView *contactTableView;
/// 用户好友list
@property (nonatomic, strong) NSMutableArray *userSimpleList;
/// 通过字母排序的好友
@property (nonatomic, strong) NSMutableDictionary *allFriends;
/// A, B, C
@property (nonatomic, strong) NSMutableArray *allKeys;
@property (nonatomic, strong) KKSectionIndexView *sectionIndexView;


@end

@implementation KKMyFriendViewController
#pragma mark - lazy load
- (NSMutableArray *)userSimpleList {
    if (!_userSimpleList) {
        _userSimpleList = [NSMutableArray array];
    }
    return _userSimpleList;
}
- (UITableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        _contactTableView.tableFooterView = [[UIView alloc] init];
        [_contactTableView registerClass:[KKContactCell class] forCellReuseIdentifier:@"cellIdentifier"];
        [_contactTableView setSectionIndexColor:[UIColor darkGrayColor]];
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

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"选择联系人"];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.contactTableView];
    [self requestNetGetFriends];
    
    /// 自定义索引
    [self.view addSubview:self.sectionIndexView];
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
    KKContactUserInfo *userInfo = arrayForKey[indexPath.row];
    cell.userInfo = userInfo;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        return 30;
    }else {
        return 0.0001;
    }
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
    return [_allKeys objectAtIndex:section];
}

- (void)sectionIndexView:(KKSectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section {
    [self.contactTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        sectionHeader.backgroundColor = RGB(244, 244, 244);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(22, 0, 37, 30);
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
    KKContactUserInfo *userInfo = arrayForKey[indexPath.row];

    if (self.selectedBlock) {
        //1.myFriendVC选完好友就没用了,该从导航中移除
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [mArr removeLastObject];
        self.navigationController.viewControllers = mArr;
        //2.执行block
        self.selectedBlock(userInfo);
    }
}

#pragma mark - 获取数据
- (void)requestNetGetFriends {
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    HUD.titleStr = @"正在获取好友";
    [self.userSimpleList removeAllObjects];
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    WS(weakSelf)
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FRIEND_QUERY" forKey:@"service"];
    [params  setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params  model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        [HUD stop];
        if (!str) {
            NSMutableArray *userSimpleList = responseDic[@"userSimpleList"];
            [weakSelf.userSimpleList addObjectsFromArray:[KKContactUserInfo mj_objectArrayWithKeyValuesArray:userSimpleList]];
            if (weakSelf.userSimpleList.count == 0) {
                [CC_NoticeView showError:@"暂无好友, 请您去添加好友"];
            }else {
                //// 去排序, 取值.
                weakSelf.allKeys = [KKContactDealTool sortArrayWithPinYin:weakSelf.userSimpleList][@"allKeys"];
                weakSelf.allFriends = [KKContactDealTool sortArrayWithPinYin:weakSelf.userSimpleList][@"infoDic"];
                if (weakSelf.allFriends.count > 0) {
                    [self.contactTableView reloadData];
                }
                
                /// 自定义索引
                weakSelf.sectionIndexView.frame = CGRectMake(CGRectGetWidth(weakSelf.contactTableView.frame) - KKSECTION_INDEX_HEIGHT + 10, 0, KKSECTION_INDEX_HEIGHT, 24 * weakSelf.allKeys.count);
                weakSelf.sectionIndexView.centerY = SCREEN_HEIGHT / 2;
                [weakSelf.sectionIndexView setBackgroundViewFrame];
                [weakSelf.sectionIndexView reloadItemViews];
            }
        }else {
            [CC_NoticeView showError:str];
        }
    }];
}

@end
