//
//  KKAddFriendVC.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKAddFriendVC.h"
#import "MiSearchBar.h"
#import "UIImage+Extension.h"
#import "KKAddFriendSearchView.h"
#import "KKAddFriendViewModel.h"
#import "KKContactCell.h"

@interface KKAddFriendVC()<UITableViewDelegate,UITableViewDataSource,KKAddFriendVM_Delegate>

//searchController
@property (strong, nonatomic)  UISearchController *searchController;
//tableView
@property (strong, nonatomic)  UITableView *tableView;
//数据源
@property (strong,nonatomic) NSMutableArray  *userListArray;

@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic, strong) KKAddFriendSearchView *searchView;

@property (nonatomic, strong) KKAddFriendViewModel *viewModel;

@property (nonatomic, strong) UIView *tempView;

@property (nonatomic, strong) UILabel *searchLabel;

@end

@implementation KKAddFriendVC

-(UIView *)tempView{
    if(!_tempView){
        _tempView = [self getTempView];
    }
    return _tempView;
}

-(NSMutableArray *)userListArray{
    if(!_userListArray){
        _userListArray = [NSMutableArray array];
    }
    return _userListArray;
}

-(KKAddFriendViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [KKAddFriendViewModel new];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

-(KKAddFriendSearchView *)searchView{
    if(!_searchView){
        _searchView = [[KKAddFriendSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:44])];
        WS(weakSelf)
        _searchView.cancelClick = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _searchView.textChangeBlock = ^(NSString *text) {
            weakSelf.searchLabel.text = [@"搜索:" stringByAppendingString:text];
            weakSelf.viewModel.phoneNum = text;
        };
    }
    return _searchView;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(244, 244, 244);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.hidden = YES;
    }
    return _tableView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self configSubView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)configNavigationBar{
    
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, NAV_BAR_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:RGB(244, 244, 244) size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}

-(void)configSubView{
    
    self.navigationItem.titleView = self.searchView;
//    [self.view addSubview:[self getTempView]];
    [self.view addSubview:self.tempView];
}


-(UIView *)getTempView{
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:56])];
    tempView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSearch)];
    tempView.userInteractionEnabled = YES;
    [tempView addGestureRecognizer:tap];
    
    UIImageView *leftSearchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_friend_left_black_search"]];
    leftSearchImage.contentMode = UIViewContentModeCenter;
    leftSearchImage.frame = CGRectMake(0, 0, [ccui getRH:57], tempView.height);
    [tempView addSubview:leftSearchImage];
    
    _searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSearchImage.right, 0, [ccui getRH:300], [ccui getRH:30])];
    _searchLabel.centerY = leftSearchImage.centerY;
    _searchLabel.font = [UIFont systemFontOfSize:18];
    _searchLabel.textColor = RGB(0, 0, 0);
    _searchLabel.text = @"搜索:";
    [tempView addSubview:_searchLabel];
    
    return tempView;
}

-(void)clickSearch{
    
    [self.viewModel triggerRequest];
}

-(void)layoutData:(KKUserInfoModel *)model{
    
    [self.userListArray removeAllObjects];
    [self.userListArray addObject:model];
    if(self.userListArray.count>0){
        self.tempView.hidden = YES;
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:56];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[KKContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    KKContactUserInfo *userInfo = self.userListArray[indexPath.row];
    cell.userInfo = userInfo;
    return cell;
}
@end
