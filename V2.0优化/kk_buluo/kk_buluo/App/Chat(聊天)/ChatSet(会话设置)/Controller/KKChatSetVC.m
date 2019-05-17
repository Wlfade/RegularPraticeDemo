//
//  KKChatSetVC.m
//  kk_buluo
//
//  Created by david on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatSetVC.h"
#import "KKChatSearchHistoryMsgVC.h"
#import "KKPersonalPageController.h"


@interface KKChatSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, weak) UIImageView *headIconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) DGButton *deleteButton;

@property (nonatomic, strong) NSArray <NSArray *>*titleArr;
@property (nonatomic, assign) BOOL isIgnoreNotification;
@property (nonatomic, strong) RCConversation *conversation;
@end

@implementation KKChatSetVC

#pragma mark - lazy load
-(NSArray <NSArray *>*)titleArr {
    if (!_titleArr) {
        _titleArr = @[@[@"查找聊天记录"],@[@"消息免打扰",@"会话置顶",@"清除聊天记录"]];
    }
    return _titleArr;
}
-(UIView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, [ccui getRH:60])];
        _tableHeaderView.backgroundColor = UIColor.whiteColor;
        
        //1.grayLine
//        UIView *grayLine = [[UIView alloc]init];
//        grayLine.backgroundColor = COLOR_BG;
//        [_tableHeaderView addSubview:grayLine];
//        [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.left.right.mas_equalTo(0);
//            make.height.mas_equalTo(1);
//        }];
        
        //2.headIcon
        CGFloat imgW = [ccui getRH:40];
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.backgroundColor = UIColor.grayColor;
        imageV.layer.cornerRadius = imgW/2.0;
        imageV.layer.masksToBounds = YES;
        self.headIconImageView = imageV;
        [_tableHeaderView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([ccui getRH:10]);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(imgW);
        }];
        
        //3.nameL
        DGLabel *nameL = [DGLabel labelWithText:@"" fontSize:[ccui getRH:14] color:COLOR_BLACK_TEXT];
        self.nameLabel = nameL;
        [_tableHeaderView addSubview:nameL];
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageV.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    return _tableHeaderView;
}

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self checkConversationSet];
}




#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"聊天详情"];
}


-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView = tableV;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorColor = COLOR_HEX(0xdfdfdf);
    tableV.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:tableV];
    //header
    WS(weakSelf);
    tableV.tableHeaderView = self.tableHeaderView;
    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
        [weakSelf.headIconImageView sd_setImageWithURL:Url(userInfo.portraitUri) placeholderImage:Img(@"userLogo_defualt")];
        weakSelf.nameLabel.text = userInfo.name;
    }];
    //fotter
    tableV.tableFooterView = [self createTableFooterView];
}

#pragma mark tool
-(UISwitch *)createSwitch {
    UISwitch *sw = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, [ccui getRH:53], [ccui getRH:32])];
    sw.onTintColor = rgba(42, 62, 255, 1);
    sw.tintColor = rgba(239, 239, 239, 1);
    //sw.transform = CGAffineTransformMakeScale(0.85,0.85);
    return sw;
}

-(UIView *)createTableFooterView {
    
    //1.button
    BOOL isGuild = [[KKRCloudMgr shareInstance] isGuild:self.targetId];
    NSString *title = isGuild ? @"进入公会号" : @"删除好友";
    UIColor *bgColor = isGuild ? COLOR_BLUE : UIColor.whiteColor;
    UIColor *titleColor = isGuild ? UIColor.whiteColor : UIColor.redColor;
    DGButton *logoutBtn = [DGButton btnWithFontSize:[ccui getRH:16] bold:NO title:title titleColor:titleColor bgColor:bgColor];
    self.deleteButton = logoutBtn;
    //[logoutBtn setImage:Img(@"set_logout") forState:UIControlStateNormal];
    logoutBtn.layer.cornerRadius = 4;
    logoutBtn.layer.masksToBounds = YES;
    
    WS(weakSelf);
    logoutBtn.clickTimeInterval = 2.0;
    [logoutBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickDeleteButton];
    }];
    
    //2.footerV
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:80])];
    footView.backgroundColor = self.view.backgroundColor;
    [footView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(-[ccui getRH:10]);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo([ccui getRH:44]);
    }];
    
    //3.return
    return footView;
}

/** 查看会话设置 */
- (void)checkConversationSet {
    self.conversation = [[RCIMClient sharedRCIMClient] getConversation:self.conversationType targetId:self.targetId];
    
    self.isIgnoreNotification = NO;
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:self.conversationType targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
        if (nStatus == DO_NOT_DISTURB) {
            self.isIgnoreNotification = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(RCErrorCode status){
                                                                   
    }];
}

-(void)attempToReloadData {
    
}

#pragma mark - interaction
- (void)switchActionForNotifacation:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:self.conversationType targetId:self.targetId isBlocked:swch.on success:^(RCConversationNotificationStatus nStatus) { } error:^(RCErrorCode status){
        CCLOG(@"chatSerVC: RCErrorCode:%ld",status);
    }];
}

- (void)switchActionForTop:(id)sender {
    UISwitch *swch = sender;
    [[RCIMClient sharedRCIMClient] setConversationToTop:self.conversationType targetId:self.targetId isTop:swch.on];
}

/** alert清空历史消息 */
-(void)showAlertForClearChatRecords {
    WS(weakSelf);
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf clearChatRecords];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"确定清除聊天记录?" actions:@[actionCancel,actionYes]];
}

/** 清空聊天记录 */
-(void)clearChatRecords {
    
    WS(weakSelf);
    NSArray *latestMessages = [[RCIMClient sharedRCIMClient] getLatestMessages:self.conversationType targetId:self.targetId count:1];
    
    if (latestMessages.count > 0) {
        RCMessage *message = (RCMessage *)[latestMessages firstObject];
        
        [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:self.conversationType targetId:weakSelf.targetId recordTime:message.sentTime success:^{
            
            [[RCIMClient sharedRCIMClient] deleteMessages:self.conversationType targetId:weakSelf.targetId success:^{
                
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

-(void)clickDeleteButton {
    [self requstDeleteFriend];
}

#pragma mark - delegate
#pragma mark  tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.titleArr[section];
    return arr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdStr = @"cellId";
    //1.获取cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdStr];
    }
    //2.赋值
    NSString *title = self.titleArr[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font = Font([ccui getRH:15]);
    cell.textLabel.textColor = COLOR_BLACK_TEXT;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([title isEqualToString:@"查找聊天记录"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if ([title isEqualToString:@"会话置顶"]){
        UISwitch *sw = [self createSwitch];
        sw.on = self.conversation.isTop;
        [sw addTarget:self action:@selector(switchActionForTop:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        
    }else if ([title isEqualToString:@"消息免打扰"]){
        UISwitch *sw = [self createSwitch];
        sw.on = self.isIgnoreNotification;
        [sw addTarget:self action:@selector(switchActionForNotifacation:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ccui getRH:10];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:50];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    
    if ([title isEqualToString:@"查找聊天记录"]) {
        [self pushToSearchHistoryMsgVC];
        
    }else if ([title isEqualToString:@"清除聊天记录"]){
        [self showAlertForClearChatRecords];
    }
}

#pragma mark - notification


#pragma mark - request
/** 删除好友 */
-(void)requstDeleteFriend {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"DELETE_FRIEND" forKey:@"service"];
    [params setValue:self.targetId forKey:@"friendId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error];
        }else{
            [CC_NoticeView showError:@"删除成功"];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:self.targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_CONTACT_DATA object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

/** 取消关注 */
-(void)requstFollowCancel {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_FOLLOW_CANCEL" forKey:@"service"];
    [params setObject:@"GUILD_INDEX" forKey:@"subscribeType"];
    [params setObject:self.targetId forKey:@"objectId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error atView:self.view];
        }else{
            [CC_NoticeView showError:@"已取消关注"];
        }
    }];
}

#pragma mark - jump
-(void)pushToSearchHistoryMsgVC {
    KKChatSearchHistoryMsgVC *historyMsgVC = [[KKChatSearchHistoryMsgVC alloc]init];
    historyMsgVC.conversationType = self.conversation.conversationType;
    historyMsgVC.targetId = self.conversation.targetId;
    [self.navigationController pushViewController:historyMsgVC animated:YES];
}

@end
