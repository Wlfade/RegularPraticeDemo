//
//  KKChatListVC.m
//  kk_buluo
//
//  Created by david on 2019/3/14.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatListVC.h"
#import "KKChatVC.h"
#import "KKChatSearchVC.h"
#import "KKCreateGroupViewController.h"
#import "KKAddFriendVC.h"
//view
#import "XTPopView.h"
#import "KKChatSearchBar.h"
#import "KKAttentionMoreViewController.h"
#import "KKMyFriendViewController.h"
#import "KKChatCellTopTagImageView.h"

//model
#import "KKChatListUserInfoModel.h"

@interface KKChatListVC ()<UISearchBarDelegate,KKChatSearchVcDelegate,SelectIndexPathDelegate>

@property (nonatomic, weak) DGButton *rightItemButton;

//是否可点击cell,防止重复点击
@property(nonatomic, assign) BOOL canClickCell;
//search
@property(nonatomic, strong) UINavigationController *searchNavigationController;
@property(nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) KKChatSearchBar *searchBar;

//user头像,名字保存
@property (nonatomic, strong) NSMutableArray *userIdArr;
@property (nonatomic, strong) NSMutableDictionary *userInfoModelDic;
@end

@implementation KKChatListVC


#pragma mark - lazy load

-(NSMutableArray *)userIdArr {
    if (!_userIdArr) {
        _userIdArr = [NSMutableArray array];
    }
    return _userIdArr;
}

-(NSMutableDictionary *)userInfoModelDic {
    if (!_userInfoModelDic) {
        _userInfoModelDic = [NSMutableDictionary dictionary];
    }
    return _userInfoModelDic;
}

- (KKChatSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar =
        [[KKChatSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44) hasBorder:NO];
    }
    return _searchBar;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
    }
    return _headerView;
}

#pragma mark - life circle

-(void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    [self.view addSubview:self.conversationListTableView];
    
    [self rcConfig];
    [self setupNavi];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;

    //1.设为可蒂娜及
    self.canClickCell = YES;
    //2.检查连接
    [[KKRCloudMgr shareInstance] rcCheckConnectStatus];
    //3.更新小红点
    [self updateBadgeValueForTabBarItem];
    
    //---------------------------内容为空的显示---------------------------
    UIView *noContentV = [[UIView alloc]initWithFrame:self.emptyConversationView.bounds];
    for (UIView *subView in self.emptyConversationView.subviews) {
        [subView removeFromSuperview];
    }
    noContentV.backgroundColor = self.conversationListTableView.backgroundColor;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
    attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无数据" withColor:[UIColor grayColor]];
    [NoContentReminderView showReminderViewToView:noContentV imageTopY:5 image:[UIImage imageNamed:@"noData_none"] remindWords:attribute];
    [self.emptyConversationView addSubview:noContentV];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.conversationListTableView.frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_AND_NAV_BAR_HEIGHT-TAB_BAR_HEIGHT);
}

-(void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - StatusBar
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UI

-(void)setupNavi {
   
    //1.navi
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:self.title];
    
    CGFloat itemW = [ccui getRH:60];
    //2.left
    DGLabel *leftItemL = [DGLabel labelWithText:@"聊天" fontSize:[ccui getRH:18] color:COLOR_BLACK_TEXT bold:YES];
    leftItemL.frame = CGRectMake([ccui getRH:10], STATUS_BAR_HEIGHT, itemW, 44);
    [self.naviBar addSubview:leftItemL];
    
    //3.rightItem
    DGButton *rightItemBtn = [DGButton btnWithImg:Img(@"navi_add_black")];
    self.rightItemButton = rightItemBtn;
    rightItemBtn.frame = CGRectMake(SCREEN_WIDTH-itemW, STATUS_BAR_HEIGHT, itemW, 44);
    [self.naviBar addSubview:rightItemBtn];
    WS(weakSelf);
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickRightItemButton:btn];
    }];
}


-(void)setupUI {
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = UIColor.whiteColor;
    [self.headerView addSubview:self.searchBar];
    self.conversationListTableView.tableHeaderView = self.headerView;
    self.conversationListTableView.separatorColor = COLOR_GRAY_LINE;
    self.conversationListTableView.separatorInset = UIEdgeInsetsMake(0, [ccui getRH:70], 0, 0);
    self.conversationListTableView.backgroundColor = COLOR_BG;
}

#pragma mark tool
-(void)updateBadgeValueForTabBarItem {
    WS(weakSelf);
    
    
    //1.未连接 不许推送 => 直接return
    if(![KKRCloudMgr shareInstance].canPushNotification ||
       ![[KKRCloudMgr shareInstance] rcConectSuccess]){
        return ;
    }
    
    //2.计算
    dispatch_async(dispatch_get_main_queue(),^{
        
        //1.计算count
        NSString *countStr = nil;
        NSArray <RCConversation *>*blockedArr = [[RCIMClient sharedRCIMClient] getBlockedConversationList:self.displayConversationTypeArray];
        NSMutableArray <RCConversation *>*allArr = [NSMutableArray arrayWithArray:[[RCIMClient sharedRCIMClient] getConversationList:self.displayConversationTypeArray]];
        NSMutableArray  <RCConversation *>*removeArr = [NSMutableArray array];
        for (RCConversation *conversationB in blockedArr) {
            for (RCConversation *conversationA in allArr) {
                if ([conversationA.targetId isEqualToString:conversationB.targetId]) {
                    [removeArr addObject:conversationA];
                }
            }
        }
        [allArr removeObjectsInArray:removeArr];
        int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount:allArr];
        if (count > 0) {
            countStr = [NSString stringWithFormat:@"%d",count];
        }
        
        //2.赋值
        NSArray *tabBarItems = weakSelf.navigationController.tabBarController.tabBar.items;
        UITabBarItem *tabBarItem = [tabBarItems objectAtIndex:1];
        tabBarItem.badgeValue = countStr;
    });
    
}

#pragma mark - interaction
-(void)clickRightItemButton:(UIButton *)btn {
    [self showPopView];
}

#pragma mark - PopView show
- (void)showPopView {
    
    CGPoint originP = CGPointMake(self.rightItemButton.center.x, self.rightItemButton.bottom-5);
    UIColor *color = [UIColor whiteColor];
    
    XTPopTableView *popView = [[XTPopTableView alloc]initWithOrigin:originP Width:[ccui getRH:161] Height:60*2 Type:XTTypeNarmol bgColor:color cornerRadius:5];
    popView.dataArray       = @[@"创建部落群", @"添加好友"];
    popView.images          = @[@"create_group_white", @"add_friends"];
    popView.row_height      = 60;
    popView.delegate        = self;
    popView.fontSize = 17;
    popView.titleTextColor  = COLOR_BLACK_TEXT;
    [popView popView];
}


- (void)selectIndexPathRow:(NSInteger)index {
    if (index == 0) {
        KKCreateGroupViewController *createGroupVC = [[KKCreateGroupViewController alloc] init];
        [self.navigationController pushViewController:createGroupVC animated:YES];
    }else if (index == 1) {
        KKAddFriendVC *addFriendVC = [KKAddFriendVC new];
        [self.navigationController pushViewController:addFriendVC animated:YES];
    }else {
        KKMyFriendViewController *vc = [[KKMyFriendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - delegate

#pragma mark tableView edit
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf);
    RCConversationModel *cModel = self.conversationListDataSource[indexPath.row];
    
    //1.置顶
    NSString *topTitle = cModel.isTop ? @"取消置顶" : @"置顶";
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:topTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        cModel.isTop = !cModel.isTop;
        [[RCIMClient sharedRCIMClient] setConversationToTop:cModel.conversationType targetId:cModel.targetId isTop:cModel.isTop];
        [weakSelf refreshConversationTableViewIfNeeded];
        
    }];
    topAction.backgroundColor = rgba(194, 194, 194, 1);
    
    //2.删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [[RCIMClient sharedRCIMClient] removeConversation:cModel.conversationType targetId:cModel.targetId];
        [weakSelf refreshConversationTableViewIfNeeded];
    }];
    deleteAction.backgroundColor = rgba(255, 44, 44, 1);
    
    return @[deleteAction,topAction];
    
    
}

#pragma mark  UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    KKChatSearchVC *searchVC = [[KKChatSearchVC alloc] init];
    self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    searchVC.delegate = self;
    [self.navigationController.view addSubview:self.searchNavigationController.view];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark KKChatSearchVcDelegate
- (void)onSearchCancelClick {
    [self.searchNavigationController.view removeFromSuperview];
    [self.searchNavigationController removeFromParentViewController];
    self.tabBarController.tabBar.hidden = NO;
    [self refreshConversationTableViewIfNeeded];
}

#pragma mark - notification

#pragma mark - jump

#pragma mark - 融云

#pragma mark 配置
/** 融云配置 */
-(void)rcConfig {
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_SYSTEM),
                                          @(ConversationType_CUSTOMERSERVICE),
                                          @(ConversationType_PUSHSERVICE)]];
    
    //当前会话列表是否为从聚合Cell点击进入的子会话列表
    self.isEnteredToCollectionViewController = YES;
    
    //设置tableView样式
    //self.conversationListTableView.separatorColor = COLOR_BG;
    self.conversationListTableView.tableFooterView = [UIView new];
    
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    
    //显示相关
    self.topCellBackgroundColor = UIColor.clearColor;
}

#pragma mark interaction
/*!
 点击会话列表中Cell的回调
 
 @param conversationModelType   当前点击的会话的Model类型
 @param model                   当前点击的会话的Model
 @param indexPath               当前会话在列表数据源中的索引值
 
 @discussion 您需要重写此点击事件，跳转到指定会话的会话页面。
 如果点击聚合Cell进入具体的子会话列表，在跳转时，需要将isEnteredToCollectionViewController设置为YES。
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    [self didClickCell:model];
//    NSString *str = [RCIM sharedRCIM].currentUserInfo.userId;
//    NSLog(@"currentId: %@",str);

}

/*!
 点击Cell头像的回调
 
 @param model   会话Cell的数据模型
 */
- (void)didTapCellPortrait:(RCConversationModel *)model {
    [self didClickCell:model];
}



-(void)didClickCell:(RCConversationModel *)model {
    
    // 不能点击
    if (!self.canClickCell) {  return; }
    
    // 处理点击
    self.canClickCell = NO;
    
    RCConversationModelType conversationModelType = model.conversationModelType;
    RCConversationType conversationType = model.conversationType;
    
    //1. 公众服务的会话显示
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
        KKChatVC *chatVC = [[KKChatVC alloc] init];
        chatVC.conversationType = model.conversationType;
        chatVC.targetId = model.targetId;
        chatVC.title = model.conversationTitle;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    //2. 聚合会话类型
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        KKChatListVC *chatListVC = [[KKChatListVC alloc] init];
        
        NSArray *typeArr = [self.displayConversationTypeArray arrayByAddingObjectsFromArray:self.collectionConversationTypeArray];
        [chatListVC setDisplayConversationTypes:typeArr];
        [chatListVC setCollectionConversationType:nil];
        chatListVC.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:chatListVC animated:YES];
    }
    
    //3.默认显示
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        
        /*
         if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
         RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
         addressBookVC.needSyncFriendList = YES;
         
         [self.navigationController pushViewController:addressBookVC animated:YES];
         return;
         }
         */
        
        KKChatVC *chatVC = [[KKChatVC alloc] init];
        chatVC.conversationType = model.conversationType;
        chatVC.targetId = model.targetId;
        chatVC.title = model.conversationTitle;
        chatVC.unReadMessage = model.unreadMessageCount;
        chatVC.enableNewComingMessageIcon = YES; //开启消息提醒
        chatVC.enableUnreadMessageIcon = YES;
        
        if (conversationType == ConversationType_GROUP){
            
        }else if (conversationType == ConversationType_PRIVATE){
            chatVC.displayUserNameInCell = NO;
            
        }else if (conversationType == ConversationType_SYSTEM) {
            chatVC.title = @"系统消息";
        }
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    
    
    //4.自定义会话类型
    //    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
    //        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    //
    //        if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
    //            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
    //            [self.navigationController pushViewController:addressBookVC animated:YES];
    //        }
    //    }
    
}

#pragma mark Cell加载显示的回调
-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    RCConversationModel *model = cell.model;
    RCConversationModelType conversationModelType = model.conversationModelType;
    RCConversationType conversationType = model.conversationType;
    
    
    RCConversationCell *cCell = (RCConversationCell *)cell;
    cCell.conversationTitle.textColor = COLOR_BLACK_TEXT;
    
    //选中背景色
    //cCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *color = rgba(230, 230, 230, 1.0);//通过RGB来定义自己的颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];//这句不可省略
    cell.selectedBackgroundView.backgroundColor = color;
    
    //1.title
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        if (conversationType == ConversationType_GROUP){
//            [[RCIM sharedRCIM].groupInfoDataSource getGroupInfoWithGroupId:model.targetId completion:^(RCGroup *groupInfo) {
//                cCell.conversationTitle.text = groupInfo.groupName;
//            }];
            cCell.conversationTitle.textColor = COLOR_BLACK_TEXT;
            
        }else if (conversationType == ConversationType_PRIVATE){
//            [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
//                cCell.conversationTitle.text = userInfo.name;
//            }];
            if([[KKRCloudMgr shareInstance] isGuild:model.targetId]){
                cCell.conversationTitle.textColor = rgba(92, 105, 143, 1);
            }else {
                cCell.conversationTitle.textColor = COLOR_BLACK_TEXT;
            }
        }
    }
     
    
    //2.小红点
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:conversationType targetId:model.targetId success:^(RCConversationNotificationStatus nStatus) {
        BOOL show = YES;
        if (nStatus == DO_NOT_DISTURB) {
            show = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            cCell.isShowNotificationNumber = show;
        });
    } error:^(RCErrorCode status){
        
    }];
  
    
    //3.检查置顶tag
    [self checkTopTagForCell:cell];
    
}

/** 检查置顶tag */
-(void)checkTopTagForCell:(RCConversationBaseCell *)cell {

    RCConversationModel *model = cell.model;
    
    //1.尝试获取topTagV
    UIView *topTagV;
    for (UIView *subV in cell.subviews) {
        if ([subV isMemberOfClass:[KKChatCellTopTagImageView class]]) {
            topTagV = subV;
            break;
        }
    }
    CCLOG(@"topTagV:%@",topTagV);
    
    //2.是置顶
    if (model.isTop) {
        //没有就添加
        if (!topTagV) {
            KKChatCellTopTagImageView *topTagImgV = [[KKChatCellTopTagImageView alloc]initWithImage:Img(@"chatList_topTag")];
            [cell addSubview:topTagImgV];
            [topTagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(3);
                make.left.mas_equalTo(3);
                make.width.height.mas_equalTo([ccui getRH:10]);
            }];
        }
    }
    
    //3.不是置顶
    else{
        //有就移除
        if (topTagV) {
            [topTagV removeFromSuperview];
        }
    }
}


/*!
 删除会话的回调
 
 @param model   会话Cell的数据模型
 */
- (void)didDeleteConversationCell:(RCConversationModel *)model {
    CCLOG(@"融云didDeleteConversationCell");
}

- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath {
    CCLOG(@"融云updateCellAtIndexPath:%@",indexPath);
}

#pragma mark 收到新消息
-(void)didReceiveMessageNotification:(NSNotification *)notification {
    //[super didReceiveMessageNotification:notification];
    CCLOG(@"新msg: %@",notification);
    
    [self updateBadgeValueForTabBarItem];

    if ([notification.object isMemberOfClass:[RCMessage class]]) {
        [self refreshConversationTableViewIfNeeded];
    }
}

@end
