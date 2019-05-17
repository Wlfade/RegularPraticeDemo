//
//  KKGroupDetailViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/18.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGroupDetailViewController.h"
#import "KKGroupMemberCell.h"
#import "KKLookAtGroupMemberViewController.h"
#import "KKGroupMember.h"
#import "KKMyGroup.h"
#import "KKEditGroupNameViewController.h"
#import "KKEditGroupMemoViewController.h"
#import "KKDeleteGroupMemberViewController.h"
#import "KKAddGroupMemberViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "KKChatSearchHistoryMsgVC.h"
#import "UIViewController+ImagePicker.h"
#import "KKPersonalPageController.h"
#import "KKMyQRCodeViewController.h"
#import "KKMyFriendViewController.h"
#import "KKChatContactMsgContent.h"

#define NAVBAR_CHANGE_POINT 50

@interface KKGroupDetailViewController ()<UITableViewDelegate, UITableViewDataSource, KKGroupMemberCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headeerView;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, strong) __block KKMyGroup *myGroup;
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) UILabel *groupMemoLabel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, assign) CGFloat groupMemoHeight;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) RCConversation *conversation;
@property (nonatomic, assign) BOOL isIgnoreNotification;
@property (nonatomic, copy) NSString *logoFileName;
@property (nonatomic, strong) UIButton *showQrButton;

@end

@implementation KKGroupDetailViewController

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}
- (UIImageView *)headeerView {
    if (!_headeerView) {
        _headeerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:233])];
        _headeerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateGroupHeaderImage)];
        [_headeerView addGestureRecognizer:tap];
    }
    return _headeerView;
}

#pragma mark tool
- (UISwitch *)createSwitch {
    UISwitch *sw = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, [ccui getRH:53], [ccui getRH:32])];
    sw.onTintColor = rgba(42, 62, 255, 1);
    sw.tintColor = rgba(239, 239, 239, 1);
    return sw;
}
- (UILabel *)groupNameLabel {
    if (!_groupNameLabel) {
        _groupNameLabel = [[UILabel alloc] init];
        _groupNameLabel.top = self.headeerView.height - [ccui getRH:15 + 17];
        _groupNameLabel.left = [ccui getRH:14];
        _groupNameLabel.size = CGSizeMake([ccui getRH:73], [ccui getRH:20]);
        _groupNameLabel.textColor = [UIColor whiteColor];
        _groupNameLabel.font = [UIFont systemFontOfSize:[ccui getRH:18]];
    }
    return _groupNameLabel;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.left = _groupNameLabel.right + [ccui getRH:5];
        _editButton.top = self.groupNameLabel.top;
        _editButton.hidden = YES;
        _editButton.size = CGSizeMake([ccui getRH:17], [ccui getRH:17]);
        [_editButton setImage:[UIImage imageNamed:@"edit_groupname"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editGroupNameAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UIButton *)showQrButton {
    if (!_showQrButton) {
        _showQrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showQrButton.left = [ccui getRH:316];
        _showQrButton.top = [ccui getRH:181];
        _showQrButton.size = CGSizeMake([ccui getRH:51], [ccui getRH:51]);
        [_showQrButton setImage:[UIImage imageNamed:@"group_qr_white"] forState:UIControlStateNormal];
        [_showQrButton addTarget:self action:@selector(showQrButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showQrButton;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.backgroundColor = [UIColor whiteColor];
        _operationButton.clipsToBounds = YES;
        _operationButton.layer.cornerRadius = 2.5;
        [_operationButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _operationButton.backgroundColor = [UIColor whiteColor];
        _operationButton.frame = CGRectMake([ccui getRH:15], [ccui getRH:15], SCREEN_WIDTH - [ccui getRH:30], [ccui getRH:40]);
        [_operationButton addTarget:self action:@selector(operationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headeerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[KKGroupMemberCell class] forCellReuseIdentifier:@"KKGroupMemberCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    }
    return _tableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:60])];
        _footerView.backgroundColor = RGB(244, 244, 244);
        [_footerView addSubview:self.operationButton];
    }
    return _footerView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        case 2:
        {
            return 3;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [ccui getRH:151];
//        if ([[KKUserInfoMgr shareInstance].userId isEqualToString:self.myGroup.creator.userId]) {
//            if (self.memberArray.count <= 3) {
//                return SCREEN_WIDTH / 5 + [ccui getRH:100];
//            }else if (self.memberArray.count > 3 && self.memberArray.count <= 8) {
//                return SCREEN_WIDTH / 5 * 2 + [ccui getRH:100];
//            }else if (self.memberArray.count > 8 && self.memberArray.count <= 13){
//                return SCREEN_WIDTH / 5 * 3 + [ccui getRH:100];
//            }else {
//                return SCREEN_WIDTH / 5 * 4 + [ccui getRH:100];
//            }
//        }else {
//            if (self.memberArray.count <= 4) {
//                return SCREEN_WIDTH / 5 + [ccui getRH:80];
//            }else if (self.memberArray.count > 4 && self.memberArray.count <= 9) {
//                return SCREEN_WIDTH / 5 * 2 + [ccui getRH:100];
//            }else if (self.memberArray.count > 9 && self.memberArray.count <= 14){
//                return SCREEN_WIDTH / 5 * 3 + [ccui getRH:100];
//            }else {
//                return SCREEN_WIDTH / 5 * 4 + [ccui getRH:100];
//            }
//        }
    }else {
        if (indexPath.section == 1 && indexPath.row == 0) {
            return self.groupMemoHeight + [ccui getRH:46] + 10;
        }
        return [ccui getRH:46];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0;
    }
    return [ccui getRH:10];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                KKGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKGroupMemberCell"];
                cell.textLabel.textColor = COLOR_BLACK_TEXT;
                cell.textLabel.font = [UIFont systemFontOfSize:[ccui getRH:15]];
                cell.delegate = self;
                [cell setDataArrayFromTableViewArray:self.memberArray Group:self.myGroup];
                return cell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                static NSString *reuseIdentifier = @"reuseIdentifier";
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
                }
                cell.textLabel.textColor = COLOR_BLACK_TEXT;
                cell.textLabel.font = [UIFont systemFontOfSize:[ccui getRH:15]];
                cell.textLabel.text = @"群公告";
                cell.detailTextLabel.text = self.myGroup.notice;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:[ccui getRH:14]];
                cell.detailTextLabel.numberOfLines = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.detailTextLabel.textColor = COLOR_DARK_GRAY_TEXT;
                if ([self.myGroup.creator.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                cell.detailTextLabel.height = [ccui getRH:self.groupMemoHeight];
                return cell;
                
            }else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                cell.textLabel.textColor = COLOR_BLACK_TEXT;
                cell.textLabel.font = [UIFont systemFontOfSize:[ccui getRH:15]];
                cell.textLabel.text = @"查找群聊天记录";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            cell.textLabel.textColor = COLOR_BLACK_TEXT;
            cell.textLabel.font = [UIFont systemFontOfSize:[ccui getRH:15]];
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"消息免打扰";
                UISwitch *sw = [self createSwitch];
                sw.on = self.isIgnoreNotification;
                [sw addTarget:self action:@selector(switchActionForNotifacation:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = sw;
            }else if (indexPath.row == 1){
                cell.textLabel.text = @"会话置顶";
                UISwitch *sw = [self createSwitch];
                sw.on = self.conversation.isTop;
                [sw addTarget:self action:@selector(switchActionForTop:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = sw;
            }else {
                cell.textLabel.text = @"清除聊天记录";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([self.myGroup.creator.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
            KKEditGroupMemoViewController *editMemoVC = [[KKEditGroupMemoViewController alloc] init];
            editMemoVC.myGroup = self.myGroup;
            [self.navigationController pushViewController:editMemoVC animated:YES];
        }else {
//            [CC_NoticeView showError:@"非群主, 不能修改"];
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        /// 查找聊天记录
        KKChatSearchHistoryMsgVC *historyMsgVC = [[KKChatSearchHistoryMsgVC alloc]init];
        historyMsgVC.conversationType = self.conversation.conversationType;
        historyMsgVC.targetId = self.conversation.targetId;
        [self.navigationController pushViewController:historyMsgVC animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        /// 清楚聊天记录
        [self showAlertForClearChatRecords];
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

/// alert清空历史消息
- (void)showAlertForClearChatRecords {
    WS(weakSelf);
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf clearChatRecords];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"确定清除聊天记录?" actions:@[actionCancel,actionYes]];
}

- (void)clearChatRecords {
    WS(weakSelf);
    NSArray *latestMessages = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_GROUP targetId:self.groupId count:1];
    
    if (latestMessages.count > 0) {
        RCMessage *message = (RCMessage *)[latestMessages firstObject];
        
        [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:ConversationType_GROUP targetId:weakSelf.groupId recordTime:message.sentTime success:^{
            
            [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_GROUP targetId:weakSelf.groupId success:^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CC_NoticeView showError:@"清除聊天记录成功！"];
                });
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearHistoryMsg" object:nil];
            } error:nil];
            
        } error:^(RCErrorCode status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CC_NoticeView showError:@"清除聊天记录失败！"];
            });
        }];
    }
}

#pragma mark - KKGroupMemberCellDelegate
- (void)didSelectedLookAllGroupMember {
    KKLookAtGroupMemberViewController *lookGroupMemVC = [[KKLookAtGroupMemberViewController alloc] init];
    lookGroupMemVC.groupModel = self.myGroup;
    lookGroupMemVC.memberArray = self.memberArray;
    [self.navigationController pushViewController:lookGroupMemVC animated:YES];
}

- (void)didSelectedAddGroupMember {
    /// 邀请新的好友
    KKAddGroupMemberViewController *addGroupMemberVC  = [[KKAddGroupMemberViewController alloc] init];
    addGroupMemberVC.groupModel = self.myGroup;
    addGroupMemberVC.dataArray = self.memberArray;
    [self.navigationController pushViewController:addGroupMemberVC animated:YES];
}

- (void)didSelectedDeleteGroupMember {
    /// 删除群成员
    KKDeleteGroupMemberViewController *deleteGroupMemerVC = [[KKDeleteGroupMemberViewController alloc] init];
    deleteGroupMemerVC.dataArray = self.memberArray;
    deleteGroupMemerVC.groupModel = self.myGroup;
    [self.navigationController pushViewController:deleteGroupMemerVC animated:YES];
}

- (void)didSelectedCollectionViewCellGroupModel:(KKGroupMember *)groupModel {
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    if ([groupModel.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        personVC.personalPageType = PERSONAL_PAGE_OWNER;
    }else {
        personVC.personalPageType = PERSONAL_PAGE_OTHER;
    }
    personVC.userId = groupModel.userId;
    [self.navigationController pushViewController:personVC animated:YES];
}
#pragma mark - Action
#pragma mark - 编辑群名
- (void)editGroupNameAction {
    if ([self.myGroup.creator.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        KKEditGroupNameViewController *editGroupVC = [[KKEditGroupNameViewController alloc] init];
        editGroupVC.myGroup = self.myGroup;
        [self.navigationController pushViewController:editGroupVC animated:YES];
    }else {
//        [CC_NoticeView showError:@"非群主,不可修改"];
    }
}
#pragma mark - 展示群二维码
- (void)showQrButtonAction {
    [self performSelectorOnMainThread:@selector(presentMyQRcodeVC) withObject:nil waitUntilDone:NO];
}

- (void)presentMyQRcodeVC{
    KKMyQRCodeViewController *myQRCodeVC = [[KKMyQRCodeViewController alloc]initWithType:QRCodeTypeGROUP withId:self.groupId];
    [self presentViewController:myQRCodeVC animated:YES completion:nil];
}

#pragma mark - 操作删除/解散群
- (void)operationButtonAction {
    WS(weakSelf);
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([weakSelf.operationButton.currentTitle isEqualToString:@"解散并删除"]) {
            /// 解散
            [weakSelf requestDissolveGroup];
        }else {
            /// 退出
            [weakSelf requestQuitGroup];
        }
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    if ([weakSelf.operationButton.currentTitle isEqualToString:@"解散并删除"]) {
        /// 解散
        [self alert:UIAlertControllerStyleAlert Title:@"" message:@"是否解散群?" actions:@[actionCancel,actionYes]];
    }else {
        /// 退出
        [self alert:UIAlertControllerStyleAlert Title:@"" message:@"是否退出群?" actions:@[actionCancel,actionYes]];
    }
}
#pragma mark - 网络相关
#pragma mark - 解散
- (void)requestDissolveGroup {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_DISMISS" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_NoticeView showError:str];

        }else {
            [weakSelf.navigationController.tabBarController setSelectedIndex:1];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 退出群
- (void)requestQuitGroup {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_USER_QUIT" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            /// 跳转到对应的VC
            [weakSelf.navigationController.tabBarController setSelectedIndex:1];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 查询群成员信息
- (void)requestGroupMemberData {
    [self.memberArray removeAllObjects];
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_MEMBER_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_NoticeView showError:str];

        }else {
            [weakSelf.memberArray addObjectsFromArray:[KKGroupMember mj_objectArrayWithKeyValuesArray:responseDic[@"groupUserSimples"]]];
            if (weakSelf.memberArray.count > 0) {
                /// 刷新当前的row
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}

#pragma mark - 查询群信息
- (void)requestGroupDetailMessageData {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_CHAT_INFO_QUERY" forKey:@"service"];
    [params setValue:_groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {

        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (!str) {
            weakSelf.myGroup = [KKMyGroup mj_objectWithKeyValues:responseDic[@"groupChatSimple"]];
            [weakSelf.headeerView sd_setImageWithURL: [NSURL URLWithString:weakSelf.myGroup.groupLogoUrl]];
            /// 更新缓存
            [[KKRCloudMgr shareInstance] updateGroupInfo:weakSelf.myGroup.groupId];
            /// 如果有群名
            if (weakSelf.myGroup.groupName) {
                /// 计算下groupNameLabel的宽度
                weakSelf.groupNameLabel.width = [weakSelf getWidthWithText:weakSelf.myGroup.groupName height:[ccui getRH:17] font:[ccui getRH:18]];
                weakSelf.editButton.left = weakSelf.groupNameLabel.right + [ccui getRH:5];
                weakSelf.groupNameLabel.text = weakSelf.myGroup.groupName;
            }
            if (weakSelf.myGroup != nil) {
                if (weakSelf.myGroup.notice.length > 0) {
                    weakSelf.groupMemoHeight = [weakSelf labelTextAttributed:weakSelf.myGroup.notice fontSize:14 width:SCREEN_WIDTH - [ccui getRH:40]];
                }
                if (!weakSelf.myGroup.notice) {
                    weakSelf.groupMemoHeight = 0;
                }
                if ([[KKUserInfoMgr shareInstance].userId isEqualToString:weakSelf.myGroup.creator.userId]) {
                    [weakSelf.operationButton setTitle:@"解散并删除" forState:UIControlStateNormal];
                    weakSelf.editButton.hidden = NO;
                }else {
                    [weakSelf.operationButton setTitle:@"退出并删除" forState:UIControlStateNormal];
                }
                weakSelf.tableView.tableFooterView = self.footerView;
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:1];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else {
            [CC_NoticeView showError:str];
        }
    }];
}

#pragma mark - switch 消息免打扰
- (void)switchActionForNotifacation:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId isBlocked:swch.on success:^(RCConversationNotificationStatus nStatus) {
        CCLOG(@"RCConversationNotificationStatus = %lu", (unsigned long)nStatus);
    } error:^(RCErrorCode status){ }];
}

/// 会话置顶
- (void)switchActionForTop:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:self.groupId isTop:swch.on];
}

/// 查看当前的会话设置
- (void)checkConversationSet {
    self.conversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP targetId:self.groupId];
    self.isIgnoreNotification = NO;
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId success:^(RCConversationNotificationStatus nStatus) {
        if (nStatus == DO_NOT_DISTURB) {
            self.isIgnoreNotification = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(RCErrorCode status){ }];
}
/// 刷新群信息
- (void)reloadGroupNotice {
    [self requestGroupDetailMessageData];
}

- (void)reloadGroupMember {
    [self requestGroupMemberData];
}

/**
 updateGroupHeaderImage : 更新群头像
 */
- (void)updateGroupHeaderImage {
    if ([self.myGroup.creator.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        WS(wSelf)
        [self pickImageWithpickImageCutImageWithImageSize:CGSizeMake(400, 400) CompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
            if (image != nil) {
                [wSelf uploadImage:[image compressToMaxKbSize:4000]];
            }else{
                [CC_NoticeView showError:@"图片获取失败"];
            }
        }];
    }else {
//        [CC_NoticeView showError:@"非群主,不可修改"];
    }
}

/**
 uploadImage: 上传群头像

 @param image 对象
 */
- (void)uploadImage:(UIImage *)image {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"IMAGE_TEMP_UPLOAD" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    /// 这里的方法名字需要 更新库之后改一下.
    [[CC_HttpTask getInstance] uploadImages:@[image] url:[KKNetworkConfig currentUrl] params:params imageScale:1.0 reConnectTimes:0 finishBlock:^(NSArray<NSString *> *errorStrArr, NSArray<ResModel *> *modelArr) {
        
        if (errorStrArr.firstObject.length > 0) {
            [CC_NoticeView showError:errorStrArr.firstObject];
        }else {
            NSDictionary *responseDic = modelArr.firstObject.resultDic[@"response"];
            weakSelf.logoFileName = responseDic[@"fileName"];
            [weakSelf reuestEditGroupHeaderLogoFileName:weakSelf.logoFileName];
        }
    }];
}

- (void)reuestEditGroupHeaderLogoFileName:(NSString *)logoFileName {
    WS(weasSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_CHAT_BASE_MODIFY" forKey:@"service"];
    [params setValue:self.myGroup.groupId forKey:@"groupId"];
    [params setValue:self.logoFileName forKey:@"logoFileName"];
    [params setValue:self.myGroup.groupName forKey:@"groupName"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            [weasSelf requestGroupDetailMessageData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(244, 244, 244);
    self.tableView.backgroundColor = RGB(244, 244, 244);
    [self.view addSubview:self.tableView];
    [self.headeerView addSubview:self.groupNameLabel];
    [self.headeerView addSubview:self.editButton];
    [self.headeerView addSubview:self.showQrButton];

    /// 刷新群信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupMember) name:RELOAD_GROUP_MEMBER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupNotice) name:RELOAD_GROUP_NOTICE object:nil];
    
    [self requestGroupDetailMessageData];
    [self requestGroupMemberData];
    
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    /// 修改返回按钮颜色
    [self hideBackButton:NO];
    [self.naviBar.backButton setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
    [self.naviBar.backButton setTitle:@"" forState:UIControlStateNormal];
    
    CGFloat rightItemBtnW = [ccui getRH:60];
    DGButton *rightItemBtn = [DGButton btnWithImg:Img(@"more_threepoint_white")];
    rightItemBtn.frame = CGRectMake(SCREEN_WIDTH - rightItemBtnW, STATUS_BAR_HEIGHT, rightItemBtnW, 44);
    [self.naviBar addSubview:rightItemBtn];
    WS(weakSelf);
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        [weakSelf showPopViewAction];
    }];
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

#pragma mark - 融云
- (void)sendContactCardTo:(KKContactUserInfo *)kUserInfo {
    
    //1.准备消息内容
    KKChatContactMsgContent *contactMsg = [[KKChatContactMsgContent alloc]init];
    contactMsg.idStr = self.myGroup.groupId;
    contactMsg.name = self.myGroup.groupName;
    contactMsg.imgUrl = self.myGroup.groupLogoUrl;
    contactMsg.tagStr = @"群名片";
    contactMsg.type = 3;
    
    //2.发送消息
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:kUserInfo.userId content:contactMsg pushContent:@"分享名片" pushData:contactMsg.name success:^(long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:@"分享成功"];
        });
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:@"分享失败,请重试"];
        });
    }];
    
}

#pragma mark - viewWillAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self checkConversationSet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
