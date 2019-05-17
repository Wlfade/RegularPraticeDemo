//
//  KKGuildGroupListViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGuildGroupListViewController.h"
#import "KKGuildGroupListCell.h"
#import "KKPersonalPageModel.h"
#import "KKPersonalPageController.h"

@interface KKGuildGroupListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation KKGuildGroupListViewController

- (void)setDataArray:(NSMutableArray *)dataArray {
    self.listArray = dataArray;
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[KKGuildGroupListCell class] forCellReuseIdentifier:@"KKGuildGroupListCell"];
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
    KKGuildGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKGuildGroupListCell"];
    cell.info = self.listArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKPersonalPageGroupModel *model = self.listArray[indexPath.row];
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    personVC.personalPageType = PERSONAL_PAGE_GROUP;
    personVC.userId = model.groupId;
    [self.navigationController pushViewController:personVC animated:YES];
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
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"公会号相关群"];
    [self.view addSubview:self.tableView];
}

@end
