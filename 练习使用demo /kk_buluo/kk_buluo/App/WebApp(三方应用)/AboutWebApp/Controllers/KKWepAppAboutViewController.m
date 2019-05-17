//
//  KKAboutViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKWepAppAboutViewController.h"
#import "KKWebAppAboutCell.h"
#import "KKAboutWebAppFooterView.h"
#import "KKApplicationInfo.h"
#import "KKWepAppAboutDetailInfo.h"
#import "KKUserFeedbackVC.h"
#import "KKWepAppMoreInfoViewController.h"
#import "KKWepAppGuildListViewController.h"
#import "KKMyFriendViewController.h"
#import "KKChatAppMsgContent.h"
#import "KKChatVC.h"
#import "KKDiscoverVC.h"
#import "KKMyWebAppListViewController.h"
#import "KKPersonalPageController.h"
#import "KKChatSetGuildVC.h"

@interface KKWepAppAboutViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dt;
@property (nonatomic, strong) KKAboutWebAppFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) KKApplicationInfo *applicationInfo;
@property (nonatomic, assign) CGFloat desHeight;

@end

@implementation KKWepAppAboutViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (KKAboutWebAppFooterView *)footerView {
    if (!_footerView) {
        WS(weakSelf)
        _footerView = [[KKAboutWebAppFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:22 + 45])];
        _footerView.toOpenWebAppBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _footerView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = self.footerView;
        [_tableView registerClass:[KKWebAppAboutCell class] forCellReuseIdentifier:@"KKAboutWebAppCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    }
    return _tableView;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dt.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 220 + self.desHeight;
    }
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KKWebAppAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKAboutWebAppCell"];
        cell.appInfo = self.applicationInfo;
        cell.desHeight = self.desHeight;
        
        WS(weakSelf)
        cell.didSelectedToSendFriendBlock = ^{
            [weakSelf showPopViewAction];
        };
        
        cell.didSelectedDeleteOrAddWebAppBlock = ^(UIButton * _Nonnull button) {
            /// 这里实时改变页面显示效果, 移除与添加操作.
            if (weakSelf.applicationInfo.collect.integerValue == 0) {
                [weakSelf requestAddWebAppToCollectionSuccess:^{
                    [button setTitle:@"从我的应用移除" forState:UIControlStateNormal];
                    [button setImage:Img(@"add_wepApp_to_myCollection") forState:UIControlStateNormal];
                    [weakSelf requestAboutWebAppDetailData];
                }];
            }else {
                [weakSelf requestDeleteWebAppFromCollectionSuccess:^{
                    [button setTitle:@"添加进我的应用" forState:UIControlStateNormal];
                    [button setImage:Img(@"delete_wepApp_from_myCollection") forState:UIControlStateNormal];
                    [weakSelf requestAboutWebAppDetailData];
                }];
            }
        };
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dt[indexPath.row];
    if (indexPath.row == 0) {
        if (self.dataArray.count > 3) {
            for (NSInteger i = 2; i >= 0; i --) {
                [cell.contentView addSubview:[self logoGuildinfoIndex:i]];
            }
        }else {
            for (NSInteger i = self.dataArray.count - 1; i >= 0; i --) {
                [cell.contentView addSubview:[self logoGuildinfoIndex:i]];
            }
        }
    }
    return cell;
}

/**
 创建公会头像

 @param index 当前索引
 @return 返回Image
 */
- (UIImageView *)logoGuildinfoIndex:(NSInteger)index {
    KKWepAppAboutDetailInfo *detailInfo = self.dataArray[index];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - [ccui getRH:65] - index * [ccui getRH:15], [ccui getRH:16], [ccui getRH:24], [ccui getRH:24])];
    image.layer.cornerRadius = [ccui getRH:12];
    image.clipsToBounds = YES;
    [image sd_setImageWithURL:[NSURL URLWithString:detailInfo.guildLogoUrl]];
    return image;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    if (self.dataArray.count > 0) {
        if (indexPath.row == 0) {
            KKWepAppGuildListViewController *vc = [[KKWepAppGuildListViewController alloc] init];
            vc.fromWhere = self.fromWhere;
            vc.dataArray = self.dataArray;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1) {
            KKUserFeedbackVC *vc = [[KKUserFeedbackVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2) {
            KKWepAppMoreInfoViewController *vc = [[KKWepAppMoreInfoViewController alloc] init];
            vc.appInfo = self.applicationInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        if (indexPath.row == 0) {
            KKUserFeedbackVC *vc = [[KKUserFeedbackVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1) {
            KKWepAppMoreInfoViewController *vc = [[KKWepAppMoreInfoViewController alloc] init];
            vc.appInfo = self.applicationInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

- (void)showPopViewAction {
    WS(weakSelf)
    NSArray *optionArray = @[@"推荐给朋友"];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray completion:^(NSInteger index) {
        
        [weakSelf pushToMyFriendListVC];
    } cancel:^{
        
    }];
    [sheetView show];
}

- (void)pushToMyFriendListVC {
    WS(weakSelf);
    KKMyFriendViewController *myFriendVC = [[KKMyFriendViewController alloc]init];
    myFriendVC.selectedBlock = ^(KKContactUserInfo * _Nonnull userInfo) {
        [weakSelf sendContactCardTo:userInfo];
    };
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

- (void)sendContactCardTo:(KKContactUserInfo *)kUserInfo {

    //1.准备消息内容
    KKChatAppMsgContent *contactMsg = [[KKChatAppMsgContent alloc]init];
    contactMsg.idStr = _applicationInfo.ID;
    contactMsg.name = _applicationInfo.name;
    contactMsg.imgUrl = _applicationInfo.logoUrl;
    contactMsg.summary = _applicationInfo.descs;;
    contactMsg.appUrl = _applicationInfo.cdnUrl;
    contactMsg.tagStr = @"推荐应用";
    WS(weakSelf)
    //2.发送消息
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:kUserInfo.userId content:contactMsg pushContent:@"推荐应用" pushData:contactMsg.name success:^(long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf pushChatVCWithUserInfo:kUserInfo];
            [CC_NoticeView showError:@"分享成功"];
        });
    } error:^(RCErrorCode nErrorCode, long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:@"推荐失败,请重试"];
        });
    }];
}

- (void)pushChatVCWithUserInfo:(KKContactUserInfo *)userInfo {
    KKChatVC *chatVC = [[KKChatVC alloc] init];
    chatVC.conversationType = ConversationType_PRIVATE;
    chatVC.targetId = userInfo.userId;
    chatVC.title = userInfo.loginName;
    [self.navigationController pushViewController:chatVC animated:YES];
    if (self.fromWhere == KKDiscoverVCType) {
        [self lastVC:chatVC fromWhereClassVC:[KKDiscoverVC class]];
    }else if (self.fromWhere == KKMyWebAppListViewControllerType) {
        [self lastVC:chatVC fromWhereClassVC:[KKMyWebAppListViewController class]];
    }else if (self.fromWhere == KKPersonalPageControllerType) {
        [self lastVC:chatVC fromWhereClassVC:[KKPersonalPageController class]];
    }else if (self.fromWhere == KKChatSetGuildVCType) {
        [self lastVC:chatVC fromWhereClassVC:[KKChatSetGuildVC class]];
    }else if (self.fromWhere == KKChatVCType) {
        [self lastVC:chatVC fromWhereClassVC:[KKPersonalPageController class]];
    }
}

/**
 请求关于WebApp的详细信息
 */
- (void)requestAboutWebAppDetailData {
    [self.dataArray removeAllObjects];
    WS(weakSelf)
    [KKWebAppService shareInstance].appId = self.appInfo.ID;
    [KKWebAppService requestAboutWebAppDetailDataSuccess:^(NSMutableArray * _Nonnull guildList, KKApplicationInfo * _Nonnull appInfo) {
        weakSelf.applicationInfo = appInfo;
        weakSelf.desHeight = [weakSelf labelTextAttributed:appInfo.descs fontSize:[ccui getRH:13] width:SCREEN_WIDTH - [ccui getRH:120]];
        [weakSelf.dataArray addObjectsFromArray:guildList];
        if (self.dataArray.count > 0) {
            weakSelf.dt = @[@"相关公会号", @"反馈与投诉", @"更多资料"];
        }else {
            weakSelf.dt = @[@"反馈与投诉", @"更多资料"];
        }
        [weakSelf.tableView reloadData];
    }];
}

/**
 添加进入我的应用
 */
- (void)requestAddWebAppToCollectionSuccess:(void(^)(void))success {
    [KKWebAppService shareInstance].objectId = self.appInfo.ID;
    [KKWebAppService shareInstance].objectType = @"APPLICATION";
    [KKWebAppService requestWebAppAddToMyCollecttionSuccess:^{
        success();
    }];
}

/**
 requestDeleteWebAppFromCollectionSuccess: 移除应用

 @param success 成功
 */
- (void)requestDeleteWebAppFromCollectionSuccess:(void(^)(void))success {
    [KKWebAppService shareInstance].objectId = self.appInfo.ID;
    [KKWebAppService shareInstance].objectType = @"APPLICATION";
    [KKWebAppService requestWebAppDeleteToMyCollecttionSuccess:^{
        success();
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self.view addSubview:self.tableView];
    [self requestAboutWebAppDetailData];
}
@end
