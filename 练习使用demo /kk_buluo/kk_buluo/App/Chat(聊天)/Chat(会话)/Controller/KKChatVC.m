//
//  KKChatVC.m
//  kk_buluo
//
//  Created by david on 2019/3/14.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatVC.h"
#import "KKChatSetVC.h"
#import "KKChatSetGuildVC.h"
#import "KKGroupDetailViewController.h"
#import "KKMyFriendViewController.h"
#import "KKPersonalPageController.h"
#import "DynamicDetailViewController.h"
#import "KKWebAppViewController.h"
//view
#import "KKChatMenuPopView.h"
//model
#import "KKChatMenuListModel.h"
#import "KKApplicationInfo.h"

//融云自定义消息
#import "KKChatDynamicMsgCell.h"
#import "KKChatDynamicMsgContent.h"
#import "KKChatContactMsgCell.h"
#import "KKChatContactMsgContent.h"
#import "KKChatAppMsgCell.h"
#import "KKChatAppMsgContent.h"


@interface KKChatVC ()
@property (nonatomic, strong) DGButton *menuButton;
@property (nonatomic, strong) KKChatMenuListModel *menuListModel;

@end

NSMutableDictionary *userInputStatusDic;

@implementation KKChatVC

#pragma mark - lazy load
-(DGButton *)menuButton {
    if (!_menuButton) {
        
        RCConversationType conversationType = self.conversationType;
        NSString *title = conversationType==ConversationType_GROUP ?  @"群主页" : @"公会号主页";
        _menuButton = [DGButton btnWithFontSize:[ccui getRH:17] title:title titleColor:COLOR_BLACK_TEXT];
        WS(weakSelf);
        [_menuButton addClickBlock:^(DGButton *btn) {
            
            if (conversationType == ConversationType_GROUP) {
                [weakSelf pushToPersonalPageVC:weakSelf.targetId type:PERSONAL_PAGE_GROUP];
            }else{
                NSString *targetId = [weakSelf.targetId substringFromIndex:2];
                [weakSelf pushToPersonalPageVC:targetId type:PERSONAL_PAGE_GUILD];
            }
        }];
    }
    return _menuButton;
}

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rcConfig];
    [self setupNavi];
    [self setupUI];
    //注册消息
    [self registerClass:[KKChatDynamicMsgCell class] forMessageClass:[KKChatDynamicMsgContent class]];
    [self registerClass:[KKChatContactMsgCell class] forMessageClass:[KKChatContactMsgContent class]];
    [self registerClass:[KKChatAppMsgCell class] forMessageClass:[KKChatAppMsgContent class]];
    
    //通知
    [self registerKeyboardNotification];
    [self registerClearChatHistoryMsgNotification];
    
    //请求
    [self requstMenuInfo];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    //1.检查输入类型
    [self checkUserInputStatus];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //1.保存输入类型
    [self saveUserInputSatus];
}

#pragma mark - 输入状态
/** 检查输入类型 */
-(void)checkUserInputStatus {
    NSString *userInputStatusKey = [NSString stringWithFormat:@"%lu--%@", (unsigned long)self.conversationType, self.targetId];
    if (userInputStatusDic && [userInputStatusDic.allKeys containsObject:userInputStatusKey]) {
        KBottomBarStatus inputType = (KBottomBarStatus)[userInputStatusDic[userInputStatusKey] integerValue];
        //输入框记忆功能，如果退出时是语音输入，再次进入默认语音输入
        if (inputType == KBottomBarRecordStatus) {
            self.defaultInputType = RCChatSessionInputBarInputVoice;
        } else if (inputType == KBottomBarPluginStatus) {
            //self.defaultInputType = RCChatSessionInputBarInputExtention;
        }
    }
}

/** 保存输入类型 */
-(void)saveUserInputSatus {
    KBottomBarStatus inputType = self.chatSessionInputBarControl.currentBottomBarStatus;
    if (!userInputStatusDic) {
        userInputStatusDic = [NSMutableDictionary dictionary];
    }
    NSString *userInputStatusKey =
    [NSString stringWithFormat:@"%lu--%@", (unsigned long)self.conversationType, self.targetId];
    [userInputStatusDic setObject:[NSString stringWithFormat:@"%ld", (long)inputType] forKey:userInputStatusKey];
}

#pragma mark - UI
-(void)setupNavi {
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    
    //1.title
    WS(weakSelf);
    //1.1 群聊
    if (self.conversationType == ConversationType_GROUP){
        [[RCIM sharedRCIM].groupInfoDataSource getGroupInfoWithGroupId:self.targetId completion:^(RCGroup *groupInfo) {
            [weakSelf setNaviBarTitle:groupInfo.groupName];
        }];
        
    }else if (self.conversationType == ConversationType_PRIVATE){//1.2 私聊
        
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
            [weakSelf setNaviBarTitle:userInfo.name];
        }];
    }else{
        [self setNaviBarTitle:self.title];
    }
    
    //2.rightItem
    CGFloat rightItemBtnW = [ccui getRH:60];
    DGButton *rightItemBtn = [DGButton btnWithImg:Img(@"more_threepoint_black")];
    rightItemBtn.frame = CGRectMake(SCREEN_WIDTH-rightItemBtnW, STATUS_BAR_HEIGHT, rightItemBtnW, 44);
    [self.naviBar addSubview:rightItemBtn];
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickRightItemButton:btn];
    }];
}


-(void)clickRightItemButton:(UIButton *)item {

    if (ConversationType_PRIVATE == self.conversationType ) {
        if([[KKRCloudMgr shareInstance] isGuild:self.targetId]){
            [self pushToGuildChatSetVC];
        }else {
            [self pushToChatSetVC];
        }
    }
    //讨论组
    else if (self.conversationType == ConversationType_DISCUSSION) {
        
    }
    //群组设置
    else if (self.conversationType == ConversationType_GROUP) {
        [self pushToGroupChatSetVC];
    }
    //客服设置
    else if (self.conversationType == ConversationType_CUSTOMERSERVICE ||
             self.conversationType == ConversationType_SYSTEM) {
        
    }
    //服务号
    else if (ConversationType_APPSERVICE == self.conversationType ) {
  
    }
    
}

-(void)setupUI {
    if (@available(iOS 11.0, *)) {
        self.conversationMessageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)refreshTitle {
//    if (self.userName == nil) {
//        return;
//    }
//    int count = [[[RCDataBaseManager shareInstance] getGroupByGroupId:self.targetId].number intValue];
//    if (self.conversationType == ConversationType_GROUP && count > 0) {
//        self.title = [NSString stringWithFormat:@"%@(%d)", self.userName, count];
//    } else {
//        self.title = self.userName;
//    }
}

#pragma mark - interaction

#pragma mark - notification
#pragma mark keyboard
-(void)registerKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

/*点击系统键盘的语音按钮，导致输入工具栏被遮挡*/
- (void)keyboardWillShowNotification:(NSNotification *)notification {
    if(!self.chatSessionInputBarControl.inputTextView.isFirstResponder) {
        [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
    }
}

//和上面的方法相对应，在别的页面弹出键盘导致聊天页面输入状态改变需要及时改变回来
- (void)keyboardWillHideNotification:(NSNotification *)notification {
    if(!self.chatSessionInputBarControl.inputTextView.isFirstResponder) {
        [self.chatSessionInputBarControl.inputTextView resignFirstResponder];
    }
}

#pragma mark clearChatMsg
-(void)registerClearChatHistoryMsgNotification {
    //清除历史消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHistoryMSG:)
                                                 name:@"ClearHistoryMsg"
                                               object:nil];
}

- (void)clearHistoryMSG:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationDataRepository removeAllObjects];
        [self.conversationMessageCollectionView reloadData];
    });
}

#pragma mark - request
/** 请求菜单信息 */
-(void)requstMenuInfo {
    
    //准备参数
    NSString *idStr = @"";
    NSString *typeStr = @"";
    RCConversationType conversationType = self.conversationType;
    if (conversationType == ConversationType_GROUP) {
        idStr = self.targetId;
        typeStr = @"GROUP";
    }else if ([[KKRCloudMgr shareInstance] isGuild:self.targetId]) {
        idStr = [self.targetId substringFromIndex:2];
        typeStr = @"GUILD";
    }
    
    //不是公会号,也不是群 ==> return
    if (idStr.length < 1 && typeStr.length < 1) {
        [self rcConfigMenuView:nil];
        return;
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
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error atView:self.view];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.menuListModel = [KKChatMenuListModel mj_objectWithKeyValues:responseDic];
            if(weakSelf.menuListModel.guildOutOfService){
                [weakSelf showAlertForGuildOutOfService];
            }else{
                [weakSelf rcConfigMenuView:self.menuListModel];
            }
        }
    }];
}

#pragma mark - jump
-(void)pushToMyFriendListVC {
    WS(weakSelf);
    KKMyFriendViewController *myFriendVC = [[KKMyFriendViewController alloc]init];
    myFriendVC.selectedBlock = ^(KKContactUserInfo * _Nonnull userInfo) {
        [weakSelf sendContactCardTo:userInfo];
    };
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

/** push跳转私聊设置 */
-(void)pushToChatSetVC {
    KKChatSetVC *chatSetVC = [[KKChatSetVC alloc]init];
    chatSetVC.targetId = self.targetId;
    chatSetVC.conversationType = self.conversationType;
    [self.navigationController pushViewController:chatSetVC animated:YES];
}

/** push跳转公会号私聊设置 */
-(void)pushToGuildChatSetVC {
    KKChatSetGuildVC *guildVC = [[KKChatSetGuildVC alloc]init];
    guildVC.targetId = self.targetId;
    guildVC.conversationType = self.conversationType;
    [self.navigationController pushViewController:guildVC animated:YES];
}

/** push跳转群聊设置 */
-(void)pushToGroupChatSetVC {
    KKGroupDetailViewController *detailVC = [[KKGroupDetailViewController alloc] init];
    detailVC.groupId = self.targetId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)pushToPersonalPageVC:(NSString *)userId type:(KKPersonPageType)type {
    KKPersonalPageController *pPageVC = [[KKPersonalPageController alloc]init];
    pPageVC.personalPageType = type;
    pPageVC.userId = userId;
    [self.navigationController pushViewController:pPageVC animated:YES];
}

/** 跳转 动态详情VC */
-(void)pushToDynamicDetailVC:(NSString *)subjectId {
    DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
    dydetailVC.subjectId = subjectId;
    [self.navigationController pushViewController:dydetailVC animated:YES];
}

/** 跳转 webAppVC */
-(void)presentWebAppVC:(NSString *)idStr url:(NSString *)urlStr {
    KKWebAppViewController *webAppVC = [[KKWebAppViewController alloc] init];
    KKApplicationInfo *appInfo = [[KKApplicationInfo alloc] init];
    appInfo.cdnUrl = urlStr;
    appInfo.ID = idStr;

    webAppVC.appInfo = appInfo;
    webAppVC.fromWhere = KKChatVCType;
    [self.navigationController pushViewController:webAppVC animated:YES];
}

- (void)showAlertForGuildOutOfService {
    WS(weakSelf)
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"该公会号涉嫌违规，暂时被停用，相关人员正在处理中" actions:@[backAction]];
}


#pragma mark - 融云

#pragma mark  融云配置
-(void)rcConfig {
    
    //发送新拍照的图片完成之后，是否将图片在本地另行存储。
    self.enableSaveNewPhotoToLocalSystem = YES;
    
    //------------------------显示设置--------------------------
    //当收到的消息超过一个屏幕时，进入会话之后，是否在右上角提示上方存在的未读消息数
    self.enableUnreadMessageIcon = YES;
    //当前阅读区域的下方收到消息时，是否在会话页面的右下角提示下方存在未读消息 默认NO
    self.enableNewComingMessageIcon = NO;
    //需要统计未读数的会话类型数组（在导航栏的返回按钮中显示）
    self.displayConversationTypeArray = @[@(ConversationType_PRIVATE),
                                          @(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP),
                                          @(ConversationType_CHATROOM),
                                          @(ConversationType_SYSTEM),
                                          @(ConversationType_APPSERVICE),
                                          @(ConversationType_PUBLICSERVICE)];
    
    //------------------------键盘特殊设置--------------------------
    RCChatSessionInputBarControl *inputBarC = self.chatSessionInputBarControl;
    //1. 输入扩展区
    RCPluginBoardView *pluginBoardV = inputBarC.pluginBoardView;
    [pluginBoardV updateItemAtIndex:0 image:Img(@"chat_photo") title:@"照片"];
    [pluginBoardV updateItemAtIndex:1 image:Img(@"chat_camera") title:@"拍摄"];
    [pluginBoardV updateItemAtIndex:2 image:Img(@"chat_location") title:@"位置"];
    [pluginBoardV insertItemWithImage:Img(@"chat_contactCard") title:@"个人名片" tag:PLUGIN_BOARD_ITEM_CARD_TAG];
}

/** 配置菜单 */
-(void)rcConfigMenuView:(KKChatMenuListModel *)menuListModel {
    
    WS(weakSelf);
    RCChatSessionInputBarControl *inputBarC = self.chatSessionInputBarControl;
    RCConversationType conversationType = self.conversationType;
    
    //0.判断是否需要菜单
    if (conversationType == ConversationType_GROUP ||
        [[KKRCloudMgr shareInstance] isGuild:self.targetId]) {
        [inputBarC setInputBarType:RCChatSessionInputBarControlPubType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
        
    }else {
        return ;
    }
    
    //1.如果没有配置
    UIView *menuContainerV = inputBarC.menuContainerView;
    if(!menuListModel || menuListModel.menus.count < 1){
            [menuContainerV addSubview:self.menuButton];
            [weakSelf.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        return ;
    }
    
    //2.配置了
    NSInteger menuCount = self.menuListModel.menus.count;
    if(menuCount > 4){
        menuCount = 4;
    }
    CGFloat btnW = (menuContainerV.width-menuCount+1)*1.0/menuCount;
    CGFloat grayBarW = 1.0;
    //2.2 subviews
    DGButton *leftMenuBtn;
    for (NSInteger i=0; i<menuCount; i++) {
        //2.2.1 btn
        KKChatMenuModel *menuModel = self.menuListModel.menus[i];
        DGButton *menuBtn = [DGButton btnWithFontSize:16 title:menuModel.name titleColor:rgba(64, 64, 64, 1)];
        menuBtn.tag = i;
        [menuContainerV addSubview:menuBtn];
        [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(btnW);
            if (leftMenuBtn) {
                make.left.mas_equalTo(leftMenuBtn.mas_right).mas_offset(grayBarW);
            }else{
                make.left.mas_equalTo(0);
            }
        }];
        
        [menuBtn addClickBlock:^(DGButton *btn) {
            [weakSelf clickMenuButton:btn];
        }];
        
        //2.2.2 btnTagIcon
        if (menuModel.children.count > 0) {
            UIImageView *iconImgV = [[UIImageView alloc]initWithImage:Img(@"chat_menu_btnIcon")];
            [menuBtn addSubview:iconImgV];
            [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(7);
            }];
        }
        
        //2.2.3 grayBar
        UIView *grayBar = [[UIView alloc]init];
        grayBar.backgroundColor = rgba(205, 205, 205, 1);
        [menuContainerV addSubview:grayBar];
        [grayBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(menuBtn.mas_right);
            make.top.mas_equalTo(9);
            make.bottom.mas_equalTo(-9);
            make.width.mas_equalTo(grayBarW);
        }];
        
        //2.2.4 赋值
        leftMenuBtn = menuBtn;
    }
}

#pragma mark - interaction
-(void)clickMenuButton:(UIButton *)btn {
    
    //过滤
    UIView *menuContainerV = self.chatSessionInputBarControl.menuContainerView;
    if (!menuContainerV) {
        return;
    }
    if (btn.tag >= self.menuListModel.menus.count) {
        return;
    }
    
    //1.没有submenu
    KKChatMenuModel *menuModel = self.menuListModel.menus[btn.tag];
    if (menuModel.children.count < 1) {
        [self selectedMenuModel:menuModel];
        return;
    }
    
    //2.popV
    CGRect rect = [menuContainerV convertRect:btn.frame toView:self.view];
    CGPoint anchorP = CGPointMake((CGRectGetMaxX(rect)-CGRectGetWidth(rect)/2.0), rect.origin.y-8);
    KKChatMenuPopView *menuPopV = [[KKChatMenuPopView alloc]initWithFrame:self.view.frame];
    WS(weakSelf);
    [menuPopV showPopViewWithMenus:menuModel.children atPoint:anchorP selectedBlock:^(KKChatMenuModel * _Nonnull selectedMenuModel) {
        [weakSelf selectedMenuModel:selectedMenuModel];
    }];
}

-(void)selectedMenuModel:(KKChatMenuModel *)menuModel {
    //1.打开主页
    if ([menuModel.menuType isEqualToString:@"NATIVE"]) {
        if ([menuModel.code isEqualToString:@"GROUP_HOME_PAGE"]) {
            [self pushToPersonalPageVC:self.targetId type:PERSONAL_PAGE_GROUP];
            
        }else if ([menuModel.code isEqualToString:@"GUILD_HOME_PAGE"]) {
            NSString *targetId = [self.targetId substringFromIndex:2];
            [self pushToPersonalPageVC:targetId type:PERSONAL_PAGE_GUILD];
        }
        return ;
    }
    
    //2. 打开连接url
    if ([menuModel.menuType isEqualToString:@"URL"]) {
        [self presentWebAppVC:menuModel.idStr url:menuModel.url];
        return;
    }
}

#pragma mark - 导航栏返回按钮中的未读消息数提示
/*!
 更新导航栏返回按钮中显示的未读消息数
 
 @discussion 如果您重写此方法，需要注意调用super。
 */
- (void)notifyUpdateUnreadMessageCount {
    [super notifyUpdateUnreadMessageCount];
}

#pragma mark - 消息操作的回调

/*!
 准备发送消息的回调
 */
//- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent;

/*!
 发送消息完成的回调
 */
//- (void)didSendMessage:(NSInteger)status content:(RCMessageContent *)messageContent;

/*!
 取消了消息发送的回调
 */
//- (void)didCancelMessage:(RCMessageContent *)messageContent;

/*!
 即将在会话页面插入消息的回调
 */
//- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message;

/*!
 即将显示消息Cell的回调
 */
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *msgModel = cell.model;
    NSString *objectName = msgModel.objectName;
    
    if([objectName isEqualToString:KKBLMsgIdDynamic] ||
       [objectName isEqualToString:KKBLMsgIdContactCard] ||
       [objectName isEqualToString:KKBLMsgIdApp] ){
        [cell setNeedsLayout];
    }
    CCLOG(@"objectName: %@",objectName);
    if([objectName isEqualToString:@"RC:ImgMsg"]){
    
    }
   
}

#pragma mark - 发送自定义消息
-(void)sendContactCardTo:(KKContactUserInfo *)kUserInfo {
    
    //1.准备消息内容
    KKChatContactMsgContent *contactMsg = [[KKChatContactMsgContent alloc]init];
    contactMsg.idStr = kUserInfo.userId;
    contactMsg.name = kUserInfo.loginName;
    contactMsg.imgUrl = kUserInfo.userLogoUrl;
    contactMsg.tagStr = @"个人名片";
    contactMsg.type = 1;
    
    //2.发送消息
    [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:contactMsg pushContent:@"分享名片" pushData:contactMsg.name success:^(long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:@"分享成功"];
        });
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:@"分享失败,请重试"];
        });
    }];
}

#pragma mark - 自定义消息cell
//-(RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CCLOG(@"2342567");
//    return nil;
//}
//
//- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CCLOG(@"2342567");
//    return CGSizeMake(100, 100);
//}

/*!
 未注册消息Cell显示的回调
 
 @param collectionView  当前CollectionView
 @param indexPath       该Cell对应的消息Cell数据模型在数据源中的索引值
 @return                未注册消息需要显示的Cell
 
 @discussion
 未注册消息的显示主要用于App未雨绸缪的新旧版本兼容，在使用此回调之前，需要将RCIM的showUnkownMessage设置为YES。
 比如，您App在新版本迭代中增加了某种自定义消息，当已经发布的旧版本不能识别，开发者可以在旧版本中预先定义好这些不能识别的消息的显示，
 如提示当前版本不支持，引导用户升级等。
 */
//- (RCMessageBaseCell *)rcUnkownConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

/*!
 未注册消息Cell显示的回调
 
 @param collectionView          当前CollectionView
 @param collectionViewLayout    当前CollectionView Layout
 @param indexPath               该Cell对应的消息Cell数据模型在数据源中的索引值
 @return                        未注册消息Cell需要显示的高度
 
 @discussion
 未注册消息的显示主要用于App未雨绸缪的新旧版本兼容，在使用此回调之前，需要将RCIM的showUnkownMessage设置为YES。
 比如，您App在新版本迭代中增加了某种自定义消息，当已经发布的旧版本不能识别，开发者可以在旧版本中预先定义好这些不能识别的消息的显示，
 如提示当前版本不支持，引导用户升级等。
 */
//- (CGSize)rcUnkownConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;


#pragma mark - 点击事件回调

/*!
 点击Cell中的消息内容的回调
您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
- (void)didTapMessageCell:(RCMessageModel *)model {
    
    NSString *objectName = model.objectName;
    //1.是名片类型
    if([objectName isEqualToString:KKBLMsgIdContactCard]) {
        
        KKChatContactMsgContent *contactMsgContent = (KKChatContactMsgContent *)model.content;
        KKPersonPageType type = PERSONAL_PAGE_OTHER;
        if (contactMsgContent.type == 2) {
            type = PERSONAL_PAGE_GUILD;
        }else if (contactMsgContent.type == 3){
            type = PERSONAL_PAGE_GROUP;
        }
        [self pushToPersonalPageVC:contactMsgContent.idStr type:type];
        return;
    }
    
    //2.是动态
    if([objectName isEqualToString:KKBLMsgIdDynamic]){
        KKChatDynamicMsgContent *dynamicMsgContent = (KKChatDynamicMsgContent *)model.content;
        [self pushToDynamicDetailVC:dynamicMsgContent.idStr];
        return;
    }
    
    //3.是应用
    if([objectName isEqualToString:KKBLMsgIdApp]){
        KKChatAppMsgContent *appMsgContent = (KKChatAppMsgContent *)model.content;
        [self presentWebAppVC:appMsgContent.idStr url:appMsgContent.appUrl];
        return;
    }
    
    
    
    //其他
    [super didTapMessageCell:model];
    
}

/*!
 长按Cell中的消息内容的回调
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
//- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view;

/*!
 获取长按Cell中的消息时的菜单
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
//- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model;

/*! 点击Cell中URL的回调 */
//- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model;

/*! 点击Cell中电话号码的回调 */
//- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model;

/** 点击Cell中头像的回调 */
- (void)didTapCellPortrait:(NSString *)userId {
    
    KKPersonPageType type = PERSONAL_PAGE_OTHER;
    //1.自己
    if ([userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        type = PERSONAL_PAGE_OWNER;
        
    }else if ([[KKRCloudMgr shareInstance] isGuild:userId]) {//2.公会号
        type = PERSONAL_PAGE_GUILD;
        userId = [userId substringFromIndex:2];
    }
    
    //3.跳转
    [self pushToPersonalPageVC:userId type:type];
}

/** 长按Cell中头像的回调 */
//- (void)didLongPressCellPortrait:(NSString *)userId;

#pragma mark - 键盘扩展
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    
    CCLOG(@"pluginBoardView tag: %ld",(long)tag);
    //#define PLUGIN_BOARD_ITEM_CARD_TAG 1107
    if(tag != PLUGIN_BOARD_ITEM_CARD_TAG){
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }else{
        [self pushToMyFriendListVC];
    }
    
}

@end
