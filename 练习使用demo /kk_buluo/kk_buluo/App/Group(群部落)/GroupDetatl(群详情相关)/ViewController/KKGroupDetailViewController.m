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
    }
    return _headeerView;
}

- (UILabel *)groupNameLabel {
    if (!_groupNameLabel) {
        _groupNameLabel = [[UILabel alloc] init];
        _groupNameLabel.top = self.headeerView.height - [ccui getRH:15 + 17];
        _groupNameLabel.left = [ccui getRH:14];
        _groupNameLabel.size = CGSizeMake([ccui getRH:73], [ccui getRH:17]);
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
        _editButton.size = CGSizeMake([ccui getRH:17], [ccui getRH:17]);
        [_editButton setImage:[UIImage imageNamed:@"edit_groupname"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editGroupNameAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT + STATUSBAR_ADD_NAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headeerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[KKGroupMemberCell class] forCellReuseIdentifier:@"KKGroupMemberCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
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
        NSLog(@"self.myGroup.creator.userId = %@", self.myGroup.creator.userId);
        if ([[KKUserInfoMgr shareInstance].userId isEqualToString:self.myGroup.creator.userId]) {
            if (self.memberArray.count <= 3) {
                return SCREEN_WIDTH / 5 + [ccui getRH:100];
            }else if (self.memberArray.count > 3 && self.memberArray.count <= 8) {
                return SCREEN_WIDTH / 5 * 2 + [ccui getRH:100];
            }else if (self.memberArray.count > 8 && self.memberArray.count <= 13){
                return SCREEN_WIDTH / 5 * 3 + [ccui getRH:100];
            }else {
                return SCREEN_WIDTH / 5 * 4 + [ccui getRH:100];
            }
        }else {
            if (self.memberArray.count <= 4) {
                return SCREEN_WIDTH / 5 + [ccui getRH:80];
            }else if (self.memberArray.count > 4 && self.memberArray.count <= 9) {
                return SCREEN_WIDTH / 5 * 2 + [ccui getRH:100];
            }else if (self.memberArray.count > 9 && self.memberArray.count <= 14){
                return SCREEN_WIDTH / 5 * 3 + [ccui getRH:100];
            }else {
                return SCREEN_WIDTH / 5 * 4 + [ccui getRH:100];
            }
        }
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
    
    if (indexPath.section == 0) {
        KKGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKGroupMemberCell"];
        cell.delegate = self;
        [cell setDataArrayFromTableViewArray:self.memberArray Group:self.myGroup];
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"群公告";
            UILabel *groupMemoLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:20], [ccui getRH:46], SCREEN_WIDTH - [ccui getRH:40], [ccui getRH:self.groupMemoHeight])];
            groupMemoLabel.numberOfLines = 0;
            [cell.contentView addSubview:groupMemoLabel];
            groupMemoLabel.text = self.myGroup.notice;

        }else {
            cell.textLabel.text = @"查找群聊天记录";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"消息免打扰";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"会话置顶";
        }else {
            cell.textLabel.text = @"清除聊天记录";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        KKEditGroupMemoViewController *editMemoVC = [[KKEditGroupMemoViewController alloc] init];
        editMemoVC.myGroup = self.myGroup;
        [self.navigationController pushViewController:editMemoVC animated:YES];
    }
}

#pragma mark - KKGroupMemberCellDelegate
- (void)didSelectedLookAllGroupMember {
    KKLookAtGroupMemberViewController *lookGroupMemVC = [[KKLookAtGroupMemberViewController alloc] init];
    lookGroupMemVC.groupModel = self.myGroup;
    [self.navigationController pushViewController:lookGroupMemVC animated:YES];
}

- (void)didSelectedAddGroupMember {
    /// 邀请新的好友
    KKAddGroupMemberViewController *addGroupMemberVC  = [[KKAddGroupMemberViewController alloc] init];
    addGroupMemberVC.groupModel = self.groupModel;
    addGroupMemberVC.dataArray = self.memberArray;
    [self.navigationController pushViewController:addGroupMemberVC animated:YES];
}

- (void)didSelectedDeleteGroupMember {
    /// 删除群成员
    KKDeleteGroupMemberViewController *deleteGroupMemerVC = [[KKDeleteGroupMemberViewController alloc] init];
    deleteGroupMemerVC.dataArray = self.memberArray;
    deleteGroupMemerVC.groupModel = self.groupModel;
    [self.navigationController pushViewController:deleteGroupMemerVC animated:YES];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor *color = [UIColor whiteColor];
    CGFloat offset_y = scrollView.contentOffset.y;
    NSLog(@"offset_y === %f", offset_y);
    if (offset_y > 0) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offset_y) / 64));
        [self.navigationController.navigationBar xtSetBackgroundColor:[color colorWithAlphaComponent: alpha]];
        
    }else
    {
        [self.navigationController.navigationBar xtSetBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark - Action
- (void)editGroupNameAction {
    KKEditGroupNameViewController *editGroupVC = [[KKEditGroupNameViewController alloc] init];
    editGroupVC.myGroup = self.myGroup;
    [self.navigationController pushViewController:editGroupVC animated:YES];
}

- (void)operationButtonAction {
    if ([self.operationButton.currentTitle isEqualToString:@"解散并删除"]) {
        /// 解散
        [self dissolveGroup];
    }else {
        /// 退出
        [self quitGroup];
    }
}
#pragma mark - 网络相关
#pragma mark - 解散
- (void)dissolveGroup {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_DISMISS" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupModel.groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSNumber *success = responseDic[@"success"];
        if (success.integerValue == 1) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [CC_NoticeView showError:@"解散失败!"];
        }
    }];
}
#pragma mark - 退出
- (void)quitGroup {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_USER_QUIT" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupModel.groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSNumber *success = responseDic[@"success"];
        if (success.integerValue == 1) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [CC_NoticeView showError:@"退出群聊失败, 请稍后重试"];
        }
    }];
}
#pragma mark - 查询群成员信息
- (void)getGroupMember {
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
            if (weakSelf.memberArray.count > 0) {
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else {
            [CC_NoticeView showError:@"获取群成员失败了!"];
        }
    }];
}
#pragma mark - 查询群信息
- (void)getGroupDetailMessage {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_CHAT_INFO_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupModel.groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {

        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSNumber *success = responseDic[@"success"];
        if (success.integerValue == 1) {
            weakSelf.myGroup = [KKMyGroup mj_objectWithKeyValues:responseDic[@"groupChatSimple"]];
            [weakSelf.headeerView sd_setImageWithURL: [NSURL URLWithString:weakSelf.myGroup.groupLogoUrl]];
            if (weakSelf.groupModel.groupName) {
                weakSelf.groupNameLabel.width = [weakSelf getWidthWithText:weakSelf.groupModel.groupName height:[ccui getRH:17] font:[ccui getRH:18]];
                weakSelf.editButton.left = weakSelf.groupNameLabel.right + [ccui getRH:5];
                weakSelf.groupNameLabel.text = weakSelf.myGroup.groupName;
            }
            if (weakSelf.myGroup != nil) {
                if (weakSelf.myGroup.notice.length > 0) {
                    weakSelf.groupMemoHeight = [[weakSelf labelTextAttributed:weakSelf.myGroup.notice] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - [ccui getRH:40], 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
                }
                if ([[KKUserInfoMgr shareInstance].userId isEqualToString:weakSelf.myGroup.creator.userId]) {
                    [weakSelf.operationButton setTitle:@"解散并删除" forState:UIControlStateNormal];
                }else {
                    [weakSelf.operationButton setTitle:@"退出并删除" forState:UIControlStateNormal];
                }
                weakSelf.tableView.tableFooterView = self.footerView;
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:1];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else {
            [CC_NoticeView showError:@"获取群信息失败了!"];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupMember) name:RELOAD_GROUP_MEMBER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupNotice) name:RELOAD_GROUP_NOTICE object:nil];
    
    
    [self getGroupDetailMessage];
    [self getGroupMember];

}
#pragma mark - viewWillAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)reloadGroupNotice {
    [self getGroupDetailMessage];
}

- (void)reloadGroupMember {
    [self getGroupMember];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar xtReset];
}

@end
