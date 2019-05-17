//
//  KKChatSetGuildVC.m
//  kk_buluo
//
//  Created by david on 2019/4/28.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatSetGuildVC.h"
#import "KKChatSearchHistoryMsgVC.h"
#import "KKPersonalPageController.h"
#import "KKMyFriendViewController.h"
#import "KKWebAppViewController.h"
#import "KKMyQRCodeViewController.h"
//model
#import "KKContactUserInfo.h"
#import "KKChatContactMsgContent.h"
#import "KKApplicationInfo.h"
#import "KKChatMenuListModel.h"

@interface KKChatSetGuildVC ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _tableHeaderViewHeight;
    CGFloat _tableHeaderTopBgViewHeight;
    CGFloat _headerIconWidth;
    CGFloat _headerIconBorderWidth;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, weak) UIView *tableHeaderTopBgView;
@property (nonatomic, weak) UIImageView *headIconImageView;
@property (nonatomic, strong) NSString *headIconImgUrl;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) DGButton *deleteButton;
@property (nonatomic, weak) DGButton *qrCodeButton;

@property (nonatomic, strong) NSArray <NSArray *>*titleArr;
@property (nonatomic, assign) BOOL isIgnoreNotification;
@property (nonatomic, strong) RCConversation *conversation;
@property (nonatomic, strong) KKApplicationInfo *webAppInfo;
@property (nonatomic, strong) UIImageView *webAppImageView;
@end

@implementation KKChatSetGuildVC
#pragma mark - lazy load
-(NSArray <NSArray *>*)titleArr {
    if (!_titleArr) {
        _titleArr = @[@[@"查找聊天记录"],@[@"消息免打扰",@"会话置顶",@"清除聊天记录",@"相关应用"]];
    }
    return _titleArr;
}

-(UIView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, _tableHeaderViewHeight)];
        _tableHeaderView.backgroundColor = UIColor.whiteColor;
        
        CGFloat topBgH = _tableHeaderTopBgViewHeight;
        CGFloat imgW = _headerIconWidth;
        CGFloat imgBorderW = _headerIconBorderWidth;
        
        //1.topBg
        UIView *topBgV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, topBgH)];
        self.tableHeaderTopBgView = topBgV;
        topBgV.backgroundColor = UIColor.lightGrayColor;
        [_tableHeaderView addSubview:topBgV];
        
        //qrcode
        DGButton *qrCodeBtn = [DGButton btnWithImg:Img(@"QRCode_icon_white")];
        self.qrCodeButton = qrCodeBtn;
        [_tableHeaderView addSubview:qrCodeBtn];
        [qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(topBgV.mas_bottom).mas_offset(-8);
            make.width.height.mas_equalTo([ccui getRH:22]);
        }];
        WS(weakSelf);
        [qrCodeBtn addClickBlock:^(DGButton *btn) {
            [weakSelf pushToQRCodeVC];
        }];
        
        //2.headIcon
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.backgroundColor = UIColor.grayColor;
        imageV.layer.cornerRadius = imgW/2.0;
        imageV.layer.masksToBounds = YES;
        imageV.layer.borderColor = UIColor.whiteColor.CGColor;
        imageV.layer.borderWidth = imgBorderW;
        self.headIconImageView = imageV;
        [_tableHeaderView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(topBgH-imgW/2.0-imgBorderW);
            make.width.height.mas_equalTo(imgW);
        }];
        
        //3.nameL
        DGLabel *nameL = [DGLabel labelWithText:@"" fontSize:[ccui getRH:18] color:COLOR_BLACK_TEXT bold:YES];
        self.nameLabel = nameL;
        [_tableHeaderView addSubview:nameL];
        [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(imageV.mas_bottom).mas_offset([ccui getRH:12]);
        }];
    }
    
    return _tableHeaderView;
}

-(UIImageView *)webAppImageView {
    if (!_webAppImageView) {
        _webAppImageView = [[UIImageView alloc]init];
    }
    return _webAppImageView;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self setupUI];
    [self setupNavi];
    [self requestWebAppInfo];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self checkConversationSet];
    [self requstMenuInfo];
}

#pragma mark - UI

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(void)setDimension {
    _tableHeaderViewHeight = [ccui getRH:240 + (iPhoneX?24:0)];
    _tableHeaderTopBgViewHeight = [ccui getRH:140 + (iPhoneX?24:0)];
    _headerIconBorderWidth = 3;
    _headerIconWidth = [ccui getRH:105];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    
    //1.left
    [self hideBackButton:NO];
    [self.naviBar.backButton setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
    [self.naviBar.backButton setTitle:@"" forState:UIControlStateNormal];
    
    //2.right
    CGFloat rightItemBtnW = [ccui getRH:50];
    DGButton *rightItemBtn = [DGButton btnWithImg:Img(@"more_threepoint_white")];
    rightItemBtn.frame = CGRectMake(SCREEN_WIDTH - rightItemBtnW, STATUS_BAR_HEIGHT, rightItemBtnW, 44);
    [self.naviBar addSubview:rightItemBtn];
    WS(weakSelf);
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        [weakSelf showPopViewAction];
    }];
}


-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT+STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView = tableV;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorColor = UIColor.clearColor;//COLOR_HEX(0xdfdfdf);
    tableV.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:tableV];
    
    //header
    WS(weakSelf);
    tableV.tableHeaderView = self.tableHeaderView;
    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
        weakSelf.headIconImgUrl = userInfo.portraitUri;
        [weakSelf.headIconImageView sd_setImageWithURL:Url(userInfo.portraitUri) placeholderImage:Img(@"userLogo_defualt") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *scaledImg = [image scaleToDefineWidth:50];
            weakSelf.tableHeaderTopBgView.backgroundColor = [UIImage mostColor:scaledImg ignoreDeviation:5];
        }];
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
    NSString *title = @"进入公会号";
    UIColor *bgColor = COLOR_BLUE;
    UIColor *titleColor = UIColor.whiteColor;
    DGButton *logoutBtn = [DGButton btnWithFontSize:[ccui getRH:16] bold:NO title:title titleColor:titleColor bgColor:bgColor];
    self.deleteButton = logoutBtn;
    logoutBtn.layer.cornerRadius = 4;
    logoutBtn.layer.masksToBounds = YES;
    
    WS(weakSelf);
    logoutBtn.clickTimeInterval = 2.0;
    [logoutBtn addClickBlock:^(DGButton *btn) {
        [weakSelf pushToGuildVC:[self.targetId substringFromIndex:2]];
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

- (void)showPopViewAction {
    WS(weakSelf)
    NSArray *optionArray = @[@"推荐给朋友"];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray completion:^(NSInteger index) {
        [weakSelf pushToMyFriendListVC];
    } cancel:^{
        
    }];
    [sheetView show];
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
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //去掉分割线
//    for (UIView *subview in cell.subviews) {
//        if ([subview isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]]){
//            [subview removeFromSuperview];
//        }
//    }
    
    if ([title isEqualToString:@"会话置顶"]){
        UISwitch *sw = [self createSwitch];
        sw.on = self.conversation.isTop;
        [sw addTarget:self action:@selector(switchActionForTop:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        
    }else if ([title isEqualToString:@"消息免打扰"]){
        UISwitch *sw = [self createSwitch];
        sw.on = self.isIgnoreNotification;
        [sw addTarget:self action:@selector(switchActionForNotifacation:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    
    }else if ([title isEqualToString:@"相关应用"]){
        if (self.webAppInfo) {
            [self.webAppImageView sd_setImageWithURL:Url(self.webAppInfo.logoUrl) placeholderImage:Img(@"")];
            [cell.contentView addSubview:self.webAppImageView];
            CGFloat w = [ccui getRH:24];
            self.webAppImageView.layer.cornerRadius = w/2.0;
            self.webAppImageView.layer.masksToBounds = YES;
            [self.webAppImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.width.height.mas_equalTo(w);
            }];
        }
    }
    
    
    //添加灰色线
    NSArray *rowArr = self.titleArr[indexPath.section];
    if (rowArr.count > indexPath.row) {
        [self addGrayLineToCell:cell];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:50];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    
    if ([title isEqualToString:@"查找聊天记录"]) {
        KKChatSearchHistoryMsgVC *historyMsgVC = [[KKChatSearchHistoryMsgVC alloc]init];
        historyMsgVC.conversationType = self.conversation.conversationType;
        historyMsgVC.targetId = self.conversation.targetId;
        [self.navigationController pushViewController:historyMsgVC animated:YES];
        
    }else if ([title isEqualToString:@"清除聊天记录"]){
        [self showAlertForClearChatRecords];
    }else if ([title isEqualToString:@"相关应用"]){
        if (self.webAppInfo) {
            [self presentWebAppVC];
        }else{
            [CC_NoticeView showError:@"该工会号暂未关联应用"];
        }
    }
}
#pragma mark tool
-(void)addGrayLineToCell:(UITableViewCell *)cell {
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = COLOR_HEX(0xdfdfdf);
    [cell addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

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

-(void)requestWebAppInfo {
    WS(weakSelf);
    [KKWebAppService shareInstance].guildId = [self.targetId substringFromIndex:2];
    [KKWebAppService requestGuildRelevanceWebAppDataSuccess:^(KKApplicationInfo * _Nonnull appInfo) {
        weakSelf.webAppInfo = appInfo;
        weakSelf.titleArr = @[@[@"查找聊天记录"],@[@"消息免打扰",@"会话置顶",@"清除聊天记录",@"相关应用"]];
        [weakSelf.tableView reloadData];
    } Fail:^{
        weakSelf.titleArr = @[@[@"查找聊天记录"],@[@"消息免打扰",@"会话置顶",@"清除聊天记录"]];
        [weakSelf.tableView reloadData];
    }];
}

/** 请求菜单信息 */
-(void)requstMenuInfo {
    
    //准备参数
    NSString *idStr = @"";
    NSString *typeStr = @"";
    if ([[KKRCloudMgr shareInstance] isGuild:self.targetId]) {
        idStr = [self.targetId substringFromIndex:2];
        typeStr = @"GUILD";
        
    }else{
        return ;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //服务名
    [params setObject:@"GUILD_GROUP_MENU_QUERY" forKey:@"service"];
    //公会号id/部落群id
    [params safeSetObject:idStr forKey:@"extId"];
    //公会号：GUILD,部落群：GROUP
    [params safeSetObject:typeStr forKey:@"extIdType"];
    
    //2.请求
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        if (error) {
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            KKChatMenuListModel *menuListModel = [KKChatMenuListModel mj_objectWithKeyValues:responseDic];
            if(menuListModel.guildOutOfService){
                [weakSelf showAlertForGuildOutOfService];
            }
        }
    }];
}

#pragma mark - jump

-(void)pushToQRCodeVC {
    NSString *idStr = [self.targetId substringFromIndex:2];
    KKMyQRCodeViewController *myQRCodeVC = [[KKMyQRCodeViewController alloc]initWithType:QRCodeTypeGUILD withId:idStr];
    [self presentViewController:myQRCodeVC animated:YES completion:nil];
}

-(void)pushToGuildVC:(NSString *)targetId {
    KKPersonalPageController *pPageVC = [[KKPersonalPageController alloc]init];
    pPageVC.personalPageType = PERSONAL_PAGE_GUILD;
    pPageVC.userId = targetId;
    [self.navigationController pushViewController:pPageVC animated:YES];
}

- (void)pushToMyFriendListVC {
    
    WS(weakSelf);
    KKMyFriendViewController *myFriendVC = [[KKMyFriendViewController alloc]init];
    myFriendVC.selectedBlock = ^(KKContactUserInfo * _Nonnull userInfo) {
        
        [weakSelf sendContactCardTo:userInfo];
    };
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

/** 跳转 webAppVC */
-(void)presentWebAppVC {
    KKWebAppViewController *webAppVC = [[KKWebAppViewController alloc] init];
    webAppVC.appInfo = self.webAppInfo;
    webAppVC.fromWhere = KKChatSetGuildVCType;
    [self.navigationController pushViewController:webAppVC animated:YES];
}

-(void)popTwice {
   
    NSUInteger selfIndex = [self.navigationController.viewControllers indexOfObject:self];
    if (selfIndex > 1) {
        UIViewController *toVC = self.navigationController.viewControllers[selfIndex-2];
        [self.navigationController popToViewController:toVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showAlertForGuildOutOfService {
    WS(weakSelf)
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf popTwice];
    }];
    
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"该公会号涉嫌违规，暂时被停用，相关人员正在处理中" actions:@[backAction]];
}



#pragma mark - 融云
- (void)sendContactCardTo:(KKContactUserInfo *)kUserInfo {
    
    //1.准备消息内容
    KKChatContactMsgContent *contactMsg = [[KKChatContactMsgContent alloc]init];
    contactMsg.idStr = [self.targetId substringFromIndex:2];
    contactMsg.name = self.nameLabel.text;
    contactMsg.imgUrl = self.headIconImgUrl;
    contactMsg.tagStr = @"公会号名片";
    contactMsg.type = 2;
    
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


@end
