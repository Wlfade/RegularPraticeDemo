//
//  KKMyWebAppListViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyWebAppListViewController.h"
#import "KKMyWebAppsListCell.h"
#import "KKWebAppViewController.h"
@interface KKMyWebAppListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *noDataMyWebAppView;

@end

@implementation KKMyWebAppListViewController

- (UIView *)noDataMyWebAppView{
    if (_noDataMyWebAppView == nil) {
        _noDataMyWebAppView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"您还没有添加应用哦" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_noDataMyWebAppView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_none"] remindWords:attribute];
        _noDataMyWebAppView.hidden = YES;
    }
    return _noDataMyWebAppView;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UI
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.noDataMyWebAppView;
        [_tableView registerClass:[KKMyWebAppsListCell class] forCellReuseIdentifier:@"KKMyWebAppsListCell"];
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
    return [ccui getRH:83];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKMyWebAppsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKMyWebAppsListCell"];
    cell.appInfo = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelectorOnMainThread:@selector(presentViewControlleIndexPath:) withObject:indexPath waitUntilDone:NO];
}

- (void)presentViewControlleIndexPath:(NSIndexPath *)indexPath{
    KKWebAppViewController *webAppVC = [[KKWebAppViewController alloc] init];
    webAppVC.appInfo = self.dataArray[indexPath.row];
    /// 这里是应用的入口, 标识从我的应用列表push过来的
    webAppVC.fromWhere = KKMyWebAppListViewControllerType;
    [self.navigationController pushViewController:webAppVC animated:YES];
}

- (void)setupNavi {
    //1.navi
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"我的应用"];
}

/**
 请求MyWebAppData
 */
- (void)requestWebAppData{
    [self.dataArray removeAllObjects];
    WS(weakSelf)
    [KKWebAppService requestWebAppSuccess:^(NSMutableArray * _Nonnull applicationList) {
        [weakSelf.dataArray addObjectsFromArray:applicationList];
        if (weakSelf.dataArray.count != 0) {
            weakSelf.noDataMyWebAppView.hidden = YES;
        }
        [weakSelf.tableView reloadData];
    } Fail:^{
        weakSelf.noDataMyWebAppView.hidden = NO;
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestWebAppData];
}

@end
