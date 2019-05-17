//
//  KKGroupViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/18.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGroupViewController.h"
#import "DGItemView.h"
#import "KKMyGroupCell.h"
#import "KKGroupDetailViewController.h"
#import "KKPersonalPageController.h"
#import "KKChatVC.h"

@interface KKGroupViewController ()<DGItemViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) DGItemView *itemView;

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIScrollView *scrollView;

/// 创建
@property (nonatomic, strong) NSMutableArray *myCreateGroupArray;
/// 加入的
@property (nonatomic, strong) NSMutableArray *myJoinInGroupArray;
/// 当前页
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pages2;

@property (nonatomic, strong) UIView *createGroupNoContentFootView;
@property (nonatomic, strong) UIView *joinGroupNoContentFootView;

@end

@implementation KKGroupViewController

- (UIView *)createGroupNoContentFootView{
    if (_createGroupNoContentFootView == nil) {
        _createGroupNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"您还没有部落群哦" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_createGroupNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_group"] remindWords:attribute];
        _createGroupNoContentFootView.hidden = YES;
    }
    return _createGroupNoContentFootView;
}

- (UIView *)joinGroupNoContentFootView{
    if (_joinGroupNoContentFootView == nil) {
        _joinGroupNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"您还没有部落群哦" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_joinGroupNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_group"] remindWords:attribute];
        _joinGroupNoContentFootView.hidden = YES;
    }
    return _joinGroupNoContentFootView;
}

- (NSMutableArray *)myCreateGroupArray {
    if (!_myCreateGroupArray) {
        _myCreateGroupArray = [NSMutableArray array];
    }
    return _myCreateGroupArray;
}

- (NSMutableArray *)myJoinInGroupArray {
    if (!_myJoinInGroupArray) {
        _myJoinInGroupArray = [NSMutableArray array];
    }
    return _myJoinInGroupArray;
}

- (DGItemView *)itemView {
    if (!_itemView) {
        _itemView = [[DGItemView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, 39)];
        _itemView.titleArr = @[@"加入的", @"我建的"];
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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT + _itemView.height + 8, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 8))];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 5))];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = self.createGroupNoContentFootView;
        [_leftTableView registerClass:[KKMyGroupCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _itemView.height + 5))];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.tableFooterView = self.joinGroupNoContentFootView;
        [_rightTableView registerClass:[KKMyGroupCell class] forCellReuseIdentifier:@"cellIDWill"];
    }
    return _rightTableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.myJoinInGroupArray.count;
    }else {
        return self.myCreateGroupArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 我创建的和我加入的位置调整.
    if (tableView == self.leftTableView) {
        KKMyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.myGroup = self.myJoinInGroupArray[indexPath.row];
        return cell;
        
    }else {
        KKMyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDWill"];
        cell.myGroup = self.myCreateGroupArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 这里按照prd 应该跳转到群聊信息页
    KKMyGroup *group;
    if (tableView == self.leftTableView) {
        group = self.myJoinInGroupArray[indexPath.row];
    }else {
        group = self.myCreateGroupArray[indexPath.row];
    }
    [self pushToChatVC:group];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
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
    [self setNaviBarTitle:@"部落群"];
    
    [self.view addSubview:self.itemView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftTableView];
    [self.scrollView addSubview:self.rightTableView];
    self.pages = 1;
    self.pages2 = 1;

    [self loadNewData];
}

- (void)loadNewData {
    /// 下拉
    WS(weakSelf)
    self.leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages = 1;
        [weakSelf.myJoinInGroupArray removeAllObjects];
        [weakSelf.myCreateGroupArray removeAllObjects];
        [weakSelf requestMyGroupDataCurrentPage:weakSelf.pages isLeft:YES];
    }];
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages2 = 1;
        [weakSelf.myJoinInGroupArray removeAllObjects];
        [weakSelf.myCreateGroupArray removeAllObjects];
        [weakSelf requestMyGroupDataCurrentPage:weakSelf.pages2 isLeft:NO];
    }];
    /// 刚一进来左边的表视图刷新就好
    [self.leftTableView.mj_header beginRefreshing];

}
- (void)requestMyGroupDataCurrentPage:(NSInteger)currentPage isLeft:(BOOL)isLeft{
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"MY_GROUP_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:@"1" forKey:@"diffCreateAndJoin"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];;
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            [weakSelf.myCreateGroupArray addObjectsFromArray:[KKMyGroup mj_objectArrayWithKeyValuesArray:responseDic[@"myCreateGroups"]]];
            if (weakSelf.myCreateGroupArray.count > 0) {
                weakSelf.rightTableView.tableFooterView = [[UIView alloc] init];
                [weakSelf.rightTableView reloadData];
            }
            
            [weakSelf.myJoinInGroupArray addObjectsFromArray:[KKMyGroup mj_objectArrayWithKeyValuesArray:responseDic[@"myGroups"]]];
            if (weakSelf.myJoinInGroupArray.count > 0) {
                weakSelf.leftTableView.tableFooterView = [[UIView alloc] init];
                [weakSelf.leftTableView reloadData];
            }
        }

        weakSelf.createGroupNoContentFootView.hidden = NO;
        weakSelf.joinGroupNoContentFootView.hidden = NO;
        [weakSelf.leftTableView.mj_header endRefreshing];
        [weakSelf.rightTableView.mj_header endRefreshing];

    }];
}


#pragma mark - jump
- (void)pushToChatVC:(KKMyGroup *)group {
    KKChatVC *chatVC = [[KKChatVC alloc] init];
    chatVC.conversationType = ConversationType_GROUP;
    chatVC.targetId = group.groupId;
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
