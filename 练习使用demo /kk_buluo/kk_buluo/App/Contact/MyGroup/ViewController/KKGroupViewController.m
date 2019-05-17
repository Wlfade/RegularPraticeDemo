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
@interface KKGroupViewController ()<DGItemViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) DGItemView *itemView;

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIScrollView *scrollView;

/// 创建
@property (nonatomic, strong) NSMutableArray *myCreateGroupArray;
/// 加入的
@property (nonatomic, strong) NSMutableArray *myJoinInGroupArray;
@end

@implementation KKGroupViewController

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
        _itemView = [[DGItemView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, 39)];
        _itemView.titleArr = @[@"我建的", @"加入的"];
        _itemView.normalFont = [UIFont systemFontOfSize:14];
        _itemView.selectedFont = [UIFont systemFontOfSize:14];
        _itemView.indicatorScale = 0.4;
        _itemView.indicatorColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _itemView.selectedColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _itemView.delegate = self;
    }
    return _itemView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5))];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5))];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView registerClass:[KKMyGroupCell class] forCellReuseIdentifier:@"cellID"];
        _leftTableView.tableFooterView = [[UIView alloc] init];
    }
    return _leftTableView;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5))];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [_rightTableView registerClass:[KKMyGroupCell class] forCellReuseIdentifier:@"cellIDWill"];
        _rightTableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _rightTableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.myCreateGroupArray.count;
    }else {
        return self.myJoinInGroupArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        
        KKMyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.myGroup = self.myCreateGroupArray[indexPath.row];
        return cell;
    }else {
        
        KKMyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDWill"];
        cell.myGroup = self.myJoinInGroupArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKGroupDetailViewController *detailVC = [[KKGroupDetailViewController alloc] init];
    if (tableView == self.leftTableView) {
        
        detailVC.groupModel = self.myCreateGroupArray[indexPath.row];
    }else {
        
        detailVC.groupModel = self.myJoinInGroupArray[indexPath.row];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
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
    self.itemView.selectedIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.itemView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftTableView];
    [self.scrollView addSubview:self.rightTableView];
    self.title = @"群部落";
    [self getMyGroupData];
}

- (void)getMyGroupData{
    
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"MY_GROUP_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:@"1" forKey:@"diffCreateAndJoin"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];;
        

        [weakSelf.myCreateGroupArray addObjectsFromArray:[KKMyGroup mj_objectArrayWithKeyValuesArray:responseDic[@"myCreateGroups"]]];
        if (weakSelf.myCreateGroupArray.count > 0) {
            [weakSelf.leftTableView reloadData];
        }
        
        [weakSelf.myJoinInGroupArray addObjectsFromArray:[KKMyGroup mj_objectArrayWithKeyValuesArray:responseDic[@"myJoinGroups"]]];
        if (weakSelf.myJoinInGroupArray.count > 0) {
            [weakSelf.rightTableView reloadData];
        }
    }];
}

@end
