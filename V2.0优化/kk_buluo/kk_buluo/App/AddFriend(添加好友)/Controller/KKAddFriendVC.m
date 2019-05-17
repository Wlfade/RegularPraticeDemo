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
#import "KKAddAddFriendShareView.h"
#import "KKAddFriendViewModel.h"
#import "KKPersonalPageController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "KKAddFriendModel.h"
#import "KKContactCell.h"

@interface KKAddFriendVC()<UITableViewDelegate,UITableViewDataSource,KKAddFriendVM_Delegate, MFMessageComposeViewControllerDelegate>

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

@property (nonatomic, strong) KKAddAddFriendShareView *shareView;

@end

@implementation KKAddFriendVC

#pragma mark - lazy load
-(UIView *)tempView{
    if(!_tempView){
        _tempView = [self getTempView];
    }
    return _tempView;
}

-(UIView *)shareView{
    if(!_shareView){
        _shareView = [[KKAddAddFriendShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:602])];
        [self.view addSubview:_shareView];
        _shareView.hidden = YES;
          WS(weakSelf);
        _shareView.clickTitle = ^(NSString *title){
            if([title isEqualToString:@"微信"]){
                [weakSelf.viewModel triggerShareToWeChat];
            }else if([title isEqualToString:@"短信"]){
                [weakSelf sendMessage];
            }
        };
    }
    return _shareView;
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
        _searchView.inputTF.placeholder = @"请输入好友手机号";
        WS(weakSelf)
        _searchView.cancelClick = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _searchView.textChangeBlock = ^(NSString *text) {
            
            weakSelf.shareView.hidden = YES;
            weakSelf.tempView.hidden = NO;
            
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

#pragma mark - life circle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self configNavigationBar];
    [self configSubView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UI
-(void)configNavigationBar{
    
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, NAV_BAR_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:RGB(244, 244, 244) size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}

-(void)configSubView{
    
    self.navigationItem.titleView = self.searchView;
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

#pragma mark - interaction
-(void)clickSearch{
    [self.viewModel triggerRequest];
    [self.searchView endEditing:YES];
}

-(void)layoutData:(KKAddFriendModel *)model{
    
    //搜素的用户的类型type 1：未注册, 2 :已注册，未登录过 3 ：已注册，并且已经登陆过
    if([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]){
        self.shareView.hidden = NO;
        self.shareView.phoneNum = self.viewModel.phoneNum;
        self.tempView.hidden = YES;
    }else if([model.type isEqualToString:@"3"]){
        KKPersonalPageController *vc = [KKPersonalPageController new];
        vc.personalPageType = PERSONAL_PAGE_OTHER;
        vc.userId = model.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 发短信
-(void)sendMessage{
 
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]){
        controller.body = [@"kk部落邀请你的加入:" stringByAppendingString:self.viewModel.model.duanxin_url];
        controller.recipients = @[self.viewModel.phoneNum];
        controller.messageComposeDelegate = self;
        [self.navigationController presentViewController:controller animated:YES completion:^{
            
        }];
    }else{
        UIAlertController *sheelController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [sheelController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
        }]];
        [self presentViewController:sheelController animated:YES completion:nil];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [CC_NoticeView showError:@"发送成功"];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [CC_NoticeView showError:@"发送失败"];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
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
