//
//  KKPersonalPageController.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKPersonalPageController.h"
#import "KKPersonalPageViewModel.h"
#import "DynamicDetailViewController.h"
#import "KKMyFriendViewController.h"
#import "KKGroupViewController.h"
#import "KKUserInfoEditVC.h"
#import "KKChatVC.h"
//model
#import "KKPersonalPageModel.h"
#import "HHPaginator.h"
#import "KKDynamicMorePopItem.h"
//view
#import "KKDynamicWholeCell.h"
#import "KKPersonalPageNoDataCell.h"
#import "KKDynamicWholeItem.h"
#import "KKDynamicPopView.h"
#import "KKReportActionSheet.h"
#import "XMGCover.h"

//融云
#import <RongIMKit/RongIMKit.h>
//自定义消息
#import "KKChatContactMsgContent.h"
#import "KKGuildGroupListViewController.h"
#import "KKDynamicArticleCell.h"
#import "KKWebAppViewController.h"
#import "KKApplicationInfo.h"
@interface KKPersonalPageController ()<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
KKPersonPageVM_Delegate,
KKDynamicPopViewDelegate,
KKDynamicWholeCellDelegate,
KKDynamicArticleCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KKPersonalPageViewModel *viewModel;
@property (nonatomic, strong) KKPersonalPageModel *userModel;
@property (nonatomic, strong) HHPaginator *paginator;
@property (nonatomic, strong) NSString *nowDate;
/* 动态表数据数组 */
@property(nonatomic,strong)NSMutableArray *dynamicMutArr;

@property (nonatomic, strong) KKDynamicWholeCell *handleCell;//当前正在操作的cell
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) KKDynamicWholeItem *selectedWholeItem;

/** 动态在详情中的改变通知 */
@property(nonatomic,weak)id notice;

@end

@implementation KKPersonalPageController{
    UIImageView *rightNavBar;
    UIView *grayLine;
}

#pragma mark - lazy load
-(NSMutableArray *)dynamicMutArr{
    if (!_dynamicMutArr) {
        _dynamicMutArr = [NSMutableArray array];
    }
    return _dynamicMutArr;
}

-(KKPersonalPageViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[KKPersonalPageViewModel alloc] init];
        _viewModel.personalPageType = self.personalPageType;
        _viewModel.delegate = self;
    }
    return _viewModel;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(244, 244, 244);
        _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = RGB(237, 237, 237);
        _tableView.mj_footer.height = 0;
        [_tableView registerClass:[KKDynamicArticleCell class] forCellReuseIdentifier:@"KKDynamicArticleCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _tableView;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    if([self.userId isEqualToString:userId]){
        self.personalPageType = PERSONAL_PAGE_OWNER;
    }
    [self configSubView];
    [self registerNote];
    
    [self configRefresh];
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.viewModel requestUserInfo];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:_notice];
}

#pragma mark - UI
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)configSubView{
    
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    
    grayLine = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT-0.5, SCREEN_WIDTH, 0.5)];
    grayLine.backgroundColor = rgba(238, 238, 238, 1);
    
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.naviBar];
    if(self.personalPageType == PERSONAL_PAGE_OTHER
       ||self.personalPageType == PERSONAL_PAGE_OWNER || 1){
        [self.naviBar addSubview:[self getRightNavigaBar]];
    }
    self.viewModel.userId = self.userId;
}

-(void)registerNote{
    _notice = [[NSNotificationCenter defaultCenter]addObserverForName:@"DynamicRefresh" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *subjectId = note.userInfo[@"subjectId"];
        KKDynamicWholeItem *wholeItem = note.userInfo[@"dynamicWholeItem"];
        [self.dynamicMutArr enumerateObjectsUsingBlock:^(KKDynamicWholeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.subjectId isEqualToString:subjectId]) {
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:idx inSection:0];
                
                KKDynamicWholeItem *chagedItem = [self.dynamicMutArr objectAtIndex:idx];
                
                chagedItem.dynamicOperationItem = wholeItem.dynamicOperationItem;
                
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA, nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }];
}

-(void)configRefresh{
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.viewModel.pageNum = 1;
        [self.dynamicMutArr removeAllObjects];
        [self.viewModel requestDynamicList];
    }];
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        self.viewModel.pageNum += 1;
        [self.viewModel requestDynamicList];
    }];
    
    footer.triggerAutomaticallyRefreshPercent = -10;
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
}

-(void)layoutUserInfoData:(KKPersonalPageModel *)model{
    self.userModel = model;
    [self.tableView reloadData];
}

-(void)layoutTopicListData:(ResModel *)resultModel{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
    //BBLOG(@"%@",resultModel.resultDic);
    NSDictionary *resultDic = resultModel.resultDic;
    NSDictionary *responseDic = resultDic[@"response"];
    
    self.nowDate = responseDic[@"nowDate"];
    self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
    
    //取出动态数组
    NSArray *topicSimpleList = [NSArray arrayWithArray:responseDic[@"topicSimpleList"]];
    
    NSMutableArray *listTempArr = [NSMutableArray arrayWithCapacity:topicSimpleList.count];
    for (int i = 0; i<topicSimpleList.count; i ++) {
        NSDictionary *dynamicDict = topicSimpleList[i];
        KKDynamicWholeItem *dynamicWholeItem = [KKDynamicWholeItem makeTheDynamicItemWithDictionary:dynamicDict];
        [listTempArr addObject:dynamicWholeItem];
    }
    
    [self.dynamicMutArr addObjectsFromArray:listTempArr];
    if (_dynamicMutArr.count == 0) {
        self.tableView.scrollEnabled = NO;
    }else {
        self.tableView.scrollEnabled = YES;
    }
    if ((_paginator.page+1) > _paginator.pages) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.tableView reloadData];
}
- (void)getGuildHomeSubjectQueryFail {
    WS(weakSelf)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"该公会号涉嫌违规，暂时被停用，相关人员正在处理中" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:backAction];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}
- (UIImageView *)getRightNavigaBar{
    
    rightNavBar = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:330], STATUS_BAR_HEIGHT, 50, 44)];
    rightNavBar.image = [UIImage imageNamed:@"personal_page_more"];
    rightNavBar.contentMode = UIViewContentModeCenter;
    rightNavBar.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClick)];
    [rightNavBar addGestureRecognizer:ges];
    return rightNavBar;
}

#pragma mark - interaction
-(void)rightClick{
    
    UIAlertController *sheelController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [sheelController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [sheelController addAction:[UIAlertAction actionWithTitle:@"转发给朋友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
        [self pushToMyFriendListVC];
    }]];
    [self presentViewController:sheelController animated:YES completion:nil];
}

#pragma mark - tableView delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *reuseIdentifier = @"personPageHeadViewId";
    KKPersonalPageTableHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    if(!headView){
        headView = [[KKPersonalPageTableHeadView alloc] initWithReuseIdentifier:reuseIdentifier];
        headView.personalPageType = self.personalPageType;
        headView.clickTitle = ^(NSString * _Nonnull title) {
            if([title isEqualToString:@"添加好友"]){
                [self.viewModel addFriendRequest];
            }else if([title isEqualToString:@"加关注"]){
                if(self.userModel.focus){
                    [self.viewModel cancelAttentionRequest];
                }else{
                    [self.viewModel addAttentionRequest];
                }
            }else if([title isEqualToString:@"发送消息"]){
                [self pushToChatVC];
            }else if([title isEqualToString:@"申请加群"]){
                [self applyInGroup];
            }else if([title isEqualToString:@"编辑资料"]){
                KKUserInfoEditVC *vc = [KKUserInfoEditVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }else if([title isEqualToString:@"查看全部"]){
                if (self.personalPageType == PERSONAL_PAGE_GUILD) {
                    KKGuildGroupListViewController *guildGroupVC = [[KKGuildGroupListViewController alloc] init];
                    guildGroupVC.dataArray = self.userModel.myGroups;
                    guildGroupVC.guildId = self.userModel.guildSimple;
                    [self.navigationController pushViewController:guildGroupVC animated:YES];
                }else {
                    KKGroupViewController *groupVC = [[KKGroupViewController alloc] init];
                    [self.navigationController pushViewController:groupVC animated:YES];
                }
            }
        };
        if (self.personalPageType == PERSONAL_PAGE_GUILD) {
            /// 去群主页
            headView.clickGroup = ^(KKPersonalPageGroupModel * _Nonnull groupModel) {
                KKPersonalPageController *vc = [[KKPersonalPageController alloc] init];
                vc.personalPageType = PERSONAL_PAGE_GROUP;
                vc.userId = groupModel.groupId;
                [self.navigationController pushViewController:vc animated:YES];
            };
        }else {
            headView.clickGroup = ^(KKPersonalPageGroupModel * _Nonnull groupModel) {
                KKChatVC *chatVC = [[KKChatVC alloc] init];
                chatVC.conversationType = ConversationType_GROUP;
                chatVC.targetId = groupModel.groupId;
                [self.navigationController pushViewController:chatVC animated:YES];
            };
        }
        headView.openWepAppActionBlock = ^(KKPersonalPageModel * _Nonnull model) {
            KKWebAppViewController *webAppVC = [[KKWebAppViewController alloc] init];
            KKApplicationInfo *appInfo = [[KKApplicationInfo alloc] init];
            appInfo.ID = model.applicationSimple.ID;
            appInfo.cdnUrl = model.applicationSimple.cdnUrl;
            appInfo.inside = model.applicationSimple.inside;
            webAppVC.appInfo = appInfo;
            webAppVC.fromWhere = KKPersonalPageControllerType;
            [self.navigationController pushViewController:webAppVC animated:YES];
        };
    }
    headView.model = self.userModel;
    return headView;
}

-(void)applyInGroup{
    
    UIAlertController *sheelController = [UIAlertController alertControllerWithTitle:@"加入群聊" message:@"是否加入群聊?" preferredStyle:UIAlertControllerStyleAlert];
    
    [sheelController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [sheelController addAction:[UIAlertAction actionWithTitle:@"加入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
        
        [self.viewModel applyInGroup];
        
        RCConversationModel *type = [[RCConversationModel alloc] init];
        type.targetId = self.userId;
        type.conversationTitle = self.userModel.userName;
        KKChatVC *chatVC = [[KKChatVC alloc] initWithConversationType:ConversationType_GROUP targetId:self.userId];
        [self.navigationController pushViewController:chatVC animated:YES];
    }]];
    [self presentViewController:sheelController animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [KKPersonalPageTableHeadView getHeadViewHeightWithPersonalPageType:self.personalPageType andUserModel:self.userModel];
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.dynamicMutArr.count>0){
        return self.dynamicMutArr.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.dynamicMutArr.count>0){
        KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
        return [KKDynamicWholeItem cellHeight:item];
    }else{
        return [ccui getRH:600];
    }
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(self.dynamicMutArr.count>0){
        
        KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
        if ([item.objectType isEqualToString:@"PERSONAL_ARTICLE"]){
            KKDynamicArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKDynamicArticleCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.dynamicWholeItem = item;
            return cell;
        }else {
            static NSString *cellIdentify = @"dynamicCell";
            KKDynamicWholeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
            if(!cell){
                cell = [[KKDynamicWholeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
                cell.delegate = self;
            }
            item.nowDate = self.nowDate;
            cell.dynamicWholeItem = item;
            return cell;
        }
    }else{
        KKPersonalPageNoDataCell *cell = [[KKPersonalPageNoDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataCell"];
        if(!cell){
            cell = [[KKPersonalPageNoDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataCell"];
        }
        cell.bgImageView.image = [UIImage imageNamed:@"personal_page_no_dataimage"];
        return cell;
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row<self.dynamicMutArr.count){
        KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
        NSString *subjectId = item.subjectId;
        DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
        dydetailVC.subjectId = subjectId;
        [self.navigationController pushViewController:dydetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dynamicMutArr == nil) {
        return 0;
    }else{
        if (self.dynamicMutArr.count > 0) {
            return 0;
        }else{
            return 0;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dynamicMutArr == nil) {
        return nil;
    }else{
        if (self.dynamicMutArr.count > 0) {
            return nil;
        }else{
            return 0;
        }
    }
}

- (void)KKDynamicArticleCell:(KKDynamicArticleCell *)dynamicArticleCell withfunctionBtnPoint:(CGPoint)thePoint{
    KKDynamicWholeItem *wholeItem = dynamicArticleCell.dynamicWholeItem;
    NSString *userId = wholeItem.dynamicArticleItem.userId;
    [self KKDynamicPopViewUserId:userId withPoint:thePoint withKKDynamicWholeItem:wholeItem withCell:dynamicArticleCell];
}
#pragma mark KKDynamicWholeCellDelegate
- (void)KKDynamicWholeCell:(KKDynamicWholeCell *)dynamicWholeCell withHeadViewPoint:(CGPoint)thePoint{
    KKDynamicWholeItem *wholeItem = dynamicWholeCell.dynamicWholeItem;
    self.handleCell = dynamicWholeCell;
    [self KKDynamicPopViewUserId:wholeItem.dynamicHeadItem.userId withPoint:thePoint withKKDynamicWholeItem:wholeItem withCell:dynamicWholeCell];
}
/**
 KKDynamicWholeCellfocusActionFocus: 关注

 @param dynamicWholeCell 除了长文的动态
 */
- (void)KKDynamicWholeCellfocusActionFocus:(KKDynamicWholeCell *)dynamicWholeCell{
    KKDynamicWholeItem *dynamicWholeItem = dynamicWholeCell.dynamicWholeItem;
    
    KKDynamicHeadItem *headItem = dynamicWholeItem.dynamicHeadItem;
    
    NSString *typeName = headItem.commonObjectTypeName;
    
    NSString *userId = headItem.userId;
    [self requstToAttentionTypeName:typeName withUserId:userId withComplete:^(bool Yes) {

        NSMutableArray *indexPaths = [NSMutableArray array];
        [self.dynamicMutArr enumerateObjectsUsingBlock:^(KKDynamicWholeItem * _Nonnull WholeItem, NSUInteger idx, BOOL * _Nonnull stop) {
            if (WholeItem.dynamicHeadItem) {
                KKDynamicHeadItem *headItem = WholeItem.dynamicHeadItem;
                if ([headItem.userId isEqualToString:userId]) {
                    headItem.focus = Yes;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                }
            }
        }];

        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];
}

/**
 requstToAttentionTypeName

 @param typeName typeName
 @param userId userId
 @param complete complete
 */
- (void)requstToAttentionTypeName:(NSString *)typeName withUserId:(NSString *)userId withComplete:(void(^)(bool))complete{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
    if ([typeName isEqualToString:@"GUILD_INDEX"]) {
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }else {
        [params setValue:@"USER" forKey:@"subscribeType"];
    }
    [params setValue:userId forKey:@"objectId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else{
            [CC_NoticeView showError:@"关注成功"];
            complete(YES);
        }
    }];
}

- (void)KKDynamicPopViewUserId:(NSString *)userId withPoint:(CGPoint )thePoint withKKDynamicWholeItem:(KKDynamicWholeItem *)selectedItem withCell:(UITableViewCell *)selectedCell{
    NSArray *popInforArr = nil;
    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:userId]) {
        KKDynamicMorePopItem *item = [[KKDynamicMorePopItem alloc]init];
        item.titleImage = [UIImage imageNamed:@"dynamic_delete_icon"];
        item.title = @"删除";
        
        popInforArr = @[item];
    }else{
        KKDynamicMorePopItem *item1 = [[KKDynamicMorePopItem alloc]init];
        item1.titleImage = [UIImage imageNamed:@"waring_icon"];
        item1.title = @"反馈垃圾内容";
        item1.subTitle = @"低俗、标题党等";
        
        KKDynamicMorePopItem *item2 = [[KKDynamicMorePopItem alloc]init];
        item2.titleImage = [UIImage imageNamed:@"dynamic_unlike_icon"];
        item2.title = @"不感兴趣";
        
        popInforArr = @[item1,item2];
    }
    [XMGCover showIn];
    KKDynamicPopView *pop = [KKDynamicPopView KKDynamicPopViewShow:popInforArr witSelectedPoint:thePoint];
    pop.delegate = self;
    
    self.selectedIndexPath = [self.tableView indexPathForCell:selectedCell];
    self.selectedWholeItem = selectedItem;
}

#pragma mark - tableview scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
  
    NSLog(@"offsetY:%f", offsetY);
    CGFloat alpha = offsetY * 1 / [ccui getRH:88];;
    if (alpha >=1) {
        alpha = 0.99;
    }
 
    if(offsetY <= 88){
        
        if(rightNavBar)rightNavBar.image = [UIImage imageNamed:@"personal_page_more"];
        self.naviBarTitle = @"";
        [self.naviBar.backButton setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
        [grayLine removeFromSuperview];
    }else{
        
        self.naviBarTitle = self.userModel.userName;
        if(rightNavBar){
            [rightNavBar setImage:[UIImage imageNamed:@"dydetail_more_icon"]];
        }
        [self.naviBar.backButton setImage:[UIImage imageNamed:@"navi_back_gray"] forState:UIControlStateNormal];
        [self.naviBar addSubview:grayLine];
    }
    
    [self.naviBar setBackgroundColor:rgba(255, 255, 255, alpha)];
}


#pragma mark KKDynamicPopViewDelegate
- (void)KKDynamicPopView:(KKDynamicPopView *)screenView withSelectedSting:(NSString *)selectString{
    
}
-(void)KKDynamicPopViewClicked:(KKDynamicPopView *)screenView withSelectedSting:(NSString *)selectString {
    WS(weakSelf);
    //1.隐藏popView
    [KKDynamicPopView hide:^{
        
        //2.隐藏背景corver
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XMGCover hidden];
        });
        
        //3.处理
        if([selectString isEqualToString:@"删除"]){
            [weakSelf showAlertForDelete];
            return ;
        }
        
        if([selectString isEqualToString:@"反馈垃圾内容"]){
            [KKReportActionSheet KKReportActionSheetPersent:self animated:YES completion:nil];
            return ;
        }
        
        if ([selectString isEqualToString:@"不感兴趣"]) {
            return;
        }
    }];
    
}
- (void)KKDynamicPopViewClosed:(KKDynamicPopView *)screenView{
    [KKDynamicPopView hide:^{
        [XMGCover hidden];
    }];
}

#pragma mark - alert
/** alert确认实名 */
-(void)showAlertForDelete {
    WS(weakSelf);
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requstDeleteDynamic];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"该动态删除后不可撤回，是否确认删除？" actions:@[actionCancel,actionYes]];
}


#pragma mark - request
-(void)requstDeleteDynamic {
    
    //过滤
    if (!self.handleCell) {
        return;
    }
    
    //对应的model
    KKDynamicWholeItem *wholeItem = self.handleCell.dynamicWholeItem;
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"SUBJECT_DELETE" forKey:@"service"];
    [params safeSetObject:wholeItem.subjectId forKey:@"subjectId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        weakSelf.handleCell = nil;
        
        if (error) {
            [CC_NoticeView showError:error atView:self.view];
        }else{
            if ([weakSelf.dynamicMutArr containsObject:wholeItem]) {
                [weakSelf.dynamicMutArr removeObject:wholeItem];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

#pragma mark - jump
-(void)pushToChatVC {
    
    //1.群聊
    if(self.personalPageType == PERSONAL_PAGE_GROUP){
        KKChatVC *chatVC = [[KKChatVC alloc] init];
        chatVC.conversationType = ConversationType_GROUP;
        chatVC.targetId = self.userId;
        [self.navigationController pushViewController:chatVC animated:YES];
        return ;
    }
    
    //2.私聊
    NSString *targetId = self.userId;
    if (self.personalPageType == PERSONAL_PAGE_GUILD) {//公会号
        if(!self.userModel.focus){
            [CC_NoticeView showError:@"请先关注公会号"];
            return;
        }
        targetId = [NSString stringWithFormat:@"K_%@",self.userId];
    }
    
    KKChatVC *chatVC = [[KKChatVC alloc] init];
    chatVC.conversationType = ConversationType_PRIVATE;
    chatVC.targetId = targetId;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)pushToMyFriendListVC {
    
    WS(weakSelf);
    KKMyFriendViewController *myFriendVC = [[KKMyFriendViewController alloc]init];
    myFriendVC.selectedBlock = ^(KKContactUserInfo * _Nonnull userInfo) {
        
         [weakSelf sendContactCardTo:userInfo];
    };
    [self.navigationController pushViewController:myFriendVC animated:YES];
}

#pragma mark - 融云
-(void)sendContactCardTo:(KKContactUserInfo *)kUserInfo {
    
    //1.准备消息内容
    KKChatContactMsgContent *contactMsg = [[KKChatContactMsgContent alloc]init];
    contactMsg.idStr = self.userId;
    contactMsg.name = self.userModel.userName;
    contactMsg.imgUrl = self.userModel.userLogoUrl;
    NSString *tagStr = @"个人名片";
    NSInteger type = 1;
    if (self.personalPageType == PERSONAL_PAGE_GUILD) {
       tagStr = @"公会号名片";
        type = 2;
    }else if (self.personalPageType == PERSONAL_PAGE_GROUP) {
        tagStr = @"群名片";
        type = 3;
    }
    contactMsg.tagStr = tagStr;
    contactMsg.type = type;
    
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
