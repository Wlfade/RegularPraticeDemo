//
//  KKDiscoverVC.m
//  kk_buluo
//
//  Created by david on 2019/4/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDiscoverVC.h"
#import "KKDiscoverCell.h"
#import "KKWebAppViewController.h"
#import "KKWebAppService.h"
#import "BaseNavigationController.h"

@interface KKDiscoverVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation KKDiscoverVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UI
- (UITableView *)tableView {
    
    if(!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT + 10, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[KKDiscoverCell class] forCellReuseIdentifier:@"cellIdentifier"];
    }
    return _tableView;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:150];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.appInfo = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelectorOnMainThread:@selector(presentViewControlleIndexPath:) withObject:indexPath waitUntilDone:NO];
}

- (void)presentViewControlleIndexPath:(NSIndexPath *)indexPath{
    KKWebAppViewController *webAppVC = [[KKWebAppViewController alloc] init];
    webAppVC.appInfo = self.dataArray[indexPath.row];
    webAppVC.fromWhere = KKDiscoverVCType;
    [self.navigationController pushViewController:webAppVC animated:YES];
}

-(void)setupNavi {
    
    //1.navi
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:self.title];
    
    CGFloat itemW = [ccui getRH:60];
    //2.left
    DGLabel *leftItemL = [DGLabel labelWithText:@"发现" fontSize:[ccui getRH:18] color:COLOR_BLACK_TEXT bold:YES];
    leftItemL.frame = CGRectMake([ccui getRH:10], STATUS_BAR_HEIGHT, itemW, 44);
    [self.naviBar addSubview:leftItemL];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self.view addSubview:self.tableView];
}

/**
 请求发现页webApp
 */
- (void)requestDiscoverWebAppData{
    WS(weakSelf)
    [KKWebAppService requestDiscoverListWebAppSuccess:^(NSMutableArray * _Nonnull applicationList) {
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:applicationList];
        [weakSelf.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestDiscoverWebAppData];
}
@end
