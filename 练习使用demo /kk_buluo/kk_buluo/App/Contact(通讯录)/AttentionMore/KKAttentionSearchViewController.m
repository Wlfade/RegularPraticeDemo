//
//  KKAttentionSearchViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/3/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKAttentionSearchViewController.h"
#import "KKAddFriendSearchView.h"
#import "KKMyRecommendCell.h"
#import "KKPersonalPageController.h"
#import "MiSearchBar.h"
@interface KKAttentionSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *searchNoContentFootView;
@property (nonatomic, strong) MiSearchBar *searchBar;

@end

@implementation KKAttentionSearchViewController

- (UIView *)searchNoContentFootView{
    if (_searchNoContentFootView == nil) {
        _searchNoContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"咦~ 没有搜索到内容呢" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_searchNoContentFootView imageTopY:(SCREEN_HEIGHT - 200) / 2 image:[UIImage imageNamed:@"noData_search"] remindWords:attribute];
        _searchNoContentFootView.hidden = YES;
    }
    return _searchNoContentFootView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT - 5, SCREEN_WIDTH, 50) placeholder:@" 请输入关键字或手机号"];
        _searchBar.searchTextField.returnKeyType = UIReturnKeySearch;
        _searchBar.showsCancelButton = YES;
        [_searchBar becomeFirstResponder];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = COLOR_HEADER_BG;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"KKMyRecommendCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKMyRecommendCell"];
    KKMyRecommend *myRecommend = self.dataArray[indexPath.row];
    myRecommend.isHasFocus = YES;
    myRecommend.type = commonObjectCertType;
    cell.myRecommend = myRecommend;
    cell.attentionButtonActionBlock = ^(KKMyRecommend * _Nonnull recommend , KKMyRecommendCell *cell) {
        [weakSelf requstToAttentionRecommend:recommend withComplete:^{
            if ([[KKUserInfoMgr shareInstance].userId isEqualToString:recommend.userId]) {
                return ;
            }
            recommend.focus = YES;
            cell.myRecommend = recommend;
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKMyRecommend *recommend = self.dataArray[indexPath.row];
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    //// 公会号
    if ([recommend.objectType.name isEqualToString:@"GUILD_INDEX"]) {
        personVC.personalPageType = PERSONAL_PAGE_GUILD;
    }else {
        personVC.personalPageType = PERSONAL_PAGE_OTHER;
    }
    personVC.userId = recommend.userId;
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

#pragma mark -
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self requestToSearchContent:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络
- (void)requstToAttentionRecommend:(KKMyRecommend *)recommend withComplete:(void(^)(void))complete{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
    if ([recommend.objectType.name isEqualToString:@"GUILD_INDEX"]) {
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }else {
        [params setValue:@"USER" forKey:@"subscribeType"];
    }
    [params setValue:recommend.userId forKey:@"objectId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            complete();
        }
    }];
}

/**
 requestToSearchContent 搜索的网络请求

 @param content 关键字/ 内容
 */
- (void)requestToSearchContent:(NSString *)content {
    [self.dataArray removeAllObjects];
    /// FOLLOW_SEARCH
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"FOLLOW_SEARCH" forKey:@"service"];
    [params setValue:content forKey:@"content"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];;
            [weakSelf.dataArray addObjectsFromArray:[KKMyRecommend mj_objectArrayWithKeyValuesArray:responseDic[@"canFollowObjects"]]];
            if (weakSelf.dataArray.count > 0) {
                weakSelf.tableView.tableFooterView = [[UIView alloc] init];
                [weakSelf.tableView reloadData];
            }
            
            if (weakSelf.dataArray.count == 0) {
                weakSelf.tableView.tableFooterView = weakSelf.searchNoContentFootView;
                [weakSelf.tableView reloadData];
            }
        }
        weakSelf.searchNoContentFootView.hidden = NO;
    }];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self hideBackButton:YES];
    [self.naviBar addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}
- (void)dealloc {
    CCLOG(@"dealloc");
}
@end
