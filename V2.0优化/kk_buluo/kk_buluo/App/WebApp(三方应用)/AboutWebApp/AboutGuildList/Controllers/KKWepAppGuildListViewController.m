//
//  KKGuildListViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKWepAppGuildListViewController.h"
#import "KKGuildListCell.h"
#import "KKWepAppAboutDetailInfo.h"
#import "KKPersonalPageController.h"
#import "KKDiscoverVC.h"
#import "KKChatVC.h"
#import "KKMyWebAppListViewController.h"
@interface KKWepAppGuildListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation KKWepAppGuildListViewController

- (void)setDataArray:(NSMutableArray *)dataArray {
    [self.listArray removeAllObjects];
    self.listArray = dataArray;
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[KKGuildListCell class] forCellReuseIdentifier:@"KKGuildListCell"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKGuildListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKGuildListCell"];
    cell.info = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKWepAppAboutDetailInfo *info = self.listArray[indexPath.row];
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    personVC.personalPageType = PERSONAL_PAGE_GUILD;
    personVC.userId = info.guildId;
    [self.navigationController pushViewController:personVC animated:YES];
    /// 这里处理的是应用跳转逻辑
    if (self.fromWhere == KKDiscoverVCType) {
        [self lastVC:personVC fromWhereClassVC:[KKDiscoverVC class]];
    }else if (self.fromWhere == KKMyWebAppListViewControllerType) {
        [self lastVC:personVC fromWhereClassVC:[KKMyWebAppListViewController class]];
    }else if (self.fromWhere == KKChatVCType) {
        [self lastVC:personVC fromWhereClassVC:[KKChatVC class]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 30, 0, 30)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //// webApp相关的公会号列表
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"相关公会号列表"];
    [self.view addSubview:self.tableView];
}
@end
