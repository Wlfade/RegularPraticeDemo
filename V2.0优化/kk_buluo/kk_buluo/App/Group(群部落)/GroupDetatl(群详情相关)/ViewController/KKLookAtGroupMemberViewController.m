//
//  KKLookAtGroupMemberViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/19.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKLookAtGroupMemberViewController.h"
#import "KKContactCell.h"
#import "KKContactUserInfo.h"
#import "KKGroupMember.h"
#import "KKChatVC.h"
#import "KKDeleteGroupMemberViewController.h"
#import "KKAddGroupMemberViewController.h"
#import <RongContactCard/RongContactCard.h>

@interface KKLookAtGroupMemberViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *contactTableView;
/// 通过字母排序的好友
@property (nonatomic, strong) NSMutableDictionary *allFriends;
/// A, B, C
@property (nonatomic, strong) NSMutableArray *allKeys;
@property (nonatomic, strong) NSMutableArray *memberArray;

@end

@implementation KKLookAtGroupMemberViewController

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}

- (UITableView *)contactTableView {
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        [_contactTableView registerClass:[KKContactCell class] forCellReuseIdentifier:@"cellIdentifier"];
        [_contactTableView setSectionIndexColor:[UIColor darkGrayColor]];
        _contactTableView.tableFooterView = [[UIView alloc] init];
    }
    return _contactTableView;
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _allKeys[section];
    NSArray *array = [_allFriends objectForKey:key];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:56];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (self.allKeys.count == 0) {
        return nil;
    }
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [self.allFriends objectForKey:key];
    KKGroupMember *userInfo = arrayForKey[indexPath.row];
    cell.userInfo = userInfo;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allKeys.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        return [ccui getRH:30];
    }else {
        return 0.0001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

/// 现实索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _allKeys;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.contactTableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1/1.0];
        sectionHeader.backgroundColor =  [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1/1.0];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake([ccui getRH:20], 0, [ccui getRH:37], [ccui getRH:30]);
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:18];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        label.text = _allKeys[section];
        return sectionHeader;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectFriend){
        
//        RCContactCardMessage *mesContent = [[RCMessageContent alloc] init];
//        mesContent.senderUserInfo = [[RCUserInfo alloc] initWithUserId:self.personModel.userId name:self.personModel.userName portrait:self.personModel.userLogoUrl];
        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:self.personModel.userId name:self.personModel.userName portrait:self.personModel.userLogoUrl];
        RCContactCardMessage *content = [RCContactCardMessage messageWithUserInfo:userInfo];
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.personModel.userId content:content pushContent:nil pushData:nil success:^(long messageId) {
//            NSString *key = [self.allKeys objectAtIndex:indexPath.section];
//            NSArray *arrayForKey = [self.allFriends objectForKey:key];
//            KKContactUserInfo *userInfo = arrayForKey[indexPath.row];
            KKChatVC *chatVC = [[KKChatVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.personModel.userId];
            [self.navigationController pushViewController:chatVC animated:YES];
        } error:^(RCErrorCode nErrorCode, long messageId) {
            NSLog([NSString stringWithFormat:@"%@", nErrorCode]);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //// 去排序, 取值.
    [self.view addSubview:self.contactTableView];
    
    DGButton *selectOperationType = [DGButton btnWithImg:[UIImage imageNamed:@"more_threepoint_black"]];
    selectOperationType.frame = CGRectMake(SCREEN_WIDTH - [ccui getRH:80], STATUS_BAR_HEIGHT, [ccui getRH:40], [ccui getRH:40]);
    [selectOperationType addTarget:self action:@selector(showPopViewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectOperationType];
}

#pragma mark - 网络相关
/// 查询群成员信息
- (void)getGroupMember {
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    [self.memberArray removeAllObjects];
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_MEMBER_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupModel.groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSNumber *success = responseDic[@"success"];
        if (success.integerValue == 1) {
            [weakSelf.memberArray addObjectsFromArray:[KKGroupMember mj_objectArrayWithKeyValuesArray:responseDic[@"groupUserSimples"]]];
            
            weakSelf.allKeys = [KKContactDealTool sortGroupMemberArrayWithPinYinArray:self.memberArray][@"allKeys"];
            weakSelf.allFriends = [KKContactDealTool sortGroupMemberArrayWithPinYinArray:self.memberArray][@"infoDic"];
            if (weakSelf.allFriends.count > 0) {
                [weakSelf.contactTableView reloadData];
            }
            if (weakSelf.memberArray.count > 0) {
                [weakSelf.contactTableView reloadData];
            }
        }else {
            [CC_NoticeView showError:@"获取群成员失败了!"];
        }
    }];
}

#pragma mark - 获取好友列表
- (void)getFriend{
    [self.memberArray removeAllObjects];
    [self.allKeys removeAllObjects];
    [self.allFriends removeAllObjects];
    WS(weakSelf)
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FRIEND_QUERY" forKey:@"service"];
    [params  setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params  model:nil finishCallbackBlock:^(NSString *a, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSNumber *success = responseDic[@"success"];
        if (success.integerValue == 1) {
            NSMutableArray *userSimpleList = responseDic[@"userSimpleList"];
            [weakSelf.memberArray addObjectsFromArray:[KKContactUserInfo mj_objectArrayWithKeyValuesArray:userSimpleList]];
            if (weakSelf.memberArray.count == 0) {
                [CC_NoticeView showError:@"暂无好友, 请您去添加好友"];
            }else {
                //// 去排序, 取值.
                weakSelf.allKeys = [KKContactDealTool sortArrayWithPinYinArray:weakSelf.memberArray][@"allKeys"];
                weakSelf.allFriends = [KKContactDealTool sortArrayWithPinYinArray:weakSelf.memberArray][@"infoDic"];
                if (weakSelf.allFriends.count > 0) {
                    [self.contactTableView reloadData];
                }
            }
        }
    }];
}
- (void)showPopViewAction {
    NSArray *optionArray = @[@"邀请新好友",@"删除群好友"];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray completion:^(NSInteger index) {
        if (index == 0) {
            /// 邀请新的好友
            KKAddGroupMemberViewController *addGroupMemberVC  = [[KKAddGroupMemberViewController alloc] init];
            addGroupMemberVC.groupModel = self.groupModel;
            addGroupMemberVC.dataArray = self.memberArray;
            [self.navigationController pushViewController:addGroupMemberVC animated:YES];
        }else if (index == 1){
            /// 删除群成员
            KKDeleteGroupMemberViewController *deleteGroupMemerVC = [[KKDeleteGroupMemberViewController alloc] init];
            deleteGroupMemerVC.dataArray = self.memberArray;
            deleteGroupMemerVC.groupModel = self.groupModel;
            [self.navigationController pushViewController:deleteGroupMemerVC animated:YES];
        }
    } cancel:^{
        
    }];
    [sheetView show];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.selectFriend){
        [self getFriend];
    }else{
        [self getGroupMember];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@end
