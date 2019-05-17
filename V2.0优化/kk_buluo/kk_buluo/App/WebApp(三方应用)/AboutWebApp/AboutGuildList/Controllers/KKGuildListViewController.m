//
//  KKGuildListViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGuildListViewController.h"
#import "KKGuildListCell.h"
#import "KKAboutDetailInfo.h"
#import "KKPersonalPageController.h"

@interface KKGuildListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation KKGuildListViewController

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
    KKAboutDetailInfo *info = self.listArray[indexPath.row];
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    personVC.personalPageType = PERSONAL_PAGE_GUILD;
    personVC.userId = info.guildId;
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
    [self setNaviBarTitle:@"部落号"];
    [self.view addSubview:self.tableView];
}
@end
