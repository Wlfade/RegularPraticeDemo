//
//  KKMyRelativeDynamicVC.m
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMyRelativeDynamicVC.h"
#import "KKDynamicPublishController.h"
#import "DynamicDetailViewController.h"
//view
#import "XMGCover.h"
#import "KKDynamicWholeCell.h" //动态单元格
#import "KKDynamicArticleCell.h" //长文单元格
#import "KKDynamicPopView.h" //动态弹窗
#import "KKReportActionSheet.h" //举报视图
//model
#import "KKDynamicWholeItem.h"
#import "HHPaginator.h"
#import "KKDynamicMorePopItem.h"



@interface KKMyRelativeDynamicVC ()
<UITableViewDelegate,
UITableViewDataSource,
KKDynamicWholeCellDelegate,
KKDynamicArticleCellDelegate,
KKDynamicPopViewDelegate>

@property (nonatomic, assign) KKMyDynamicType type;
/* 动态表视图 */
@property (nonatomic,strong)UITableView *dynamicTableView;
@property(nonatomic,strong)HHPaginator *paginator;
/* 动态表数据数组 */
@property(nonatomic,strong)NSMutableArray *dynamicMutArr;
@property (nonatomic, strong) NSIndexPath *selectecdIndexPath;//当前正在操作的cell

@property(nonatomic,strong)NSString *nowDate;

/** 无内容提醒 */
@property (nonatomic, strong)UIView *noContentFootView ;
/** 动态在详情中的改变通知 */
@property(nonatomic,weak)id notice;

@end

@implementation KKMyRelativeDynamicVC


static NSString *const cellIdentify = @"dynamicCell";
static NSString *const articleCellIdentify = @"dynamicArtCell";

#pragma mark - lazy load
-(NSMutableArray *)dynamicMutArr{
    if (!_dynamicMutArr) {
        _dynamicMutArr = [NSMutableArray array];
    }
    return _dynamicMutArr;
}

//暂无界面
- (UIView *)noContentFootView{
    if (_noContentFootView == nil) {
        _noContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_AND_NAV_BAR_HEIGHT)];
        
        UIView *reminderV = [[UIView alloc]initWithFrame:CGRectMake(0, (_noContentFootView.height-180)/2.0, SCREEN_WIDTH, 150)];
        [_noContentFootView addSubview:reminderV];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无数据" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:reminderV imageTopY:5 image:[UIImage imageNamed:@"noData_none"] remindWords:attribute];
        
        _noContentFootView.hidden = YES;
    }
    return _noContentFootView;
}

#pragma mark - life circle

-(instancetype)initWithType:(KKMyDynamicType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupUI];
    [self registNote];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:_notice];
}

#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    
    NSString *title = @"";
    switch (self.type) {
        case KKMyDynamicTypeCreate:
            title = @"我的发布";
            break;
        case KKMyDynamicTypeTransmit:
            title = @"我的转发";
            break;
        case KKMyDynamicTypeLike:
            title = @"我的点赞";
            break;
        case KKMyDynamicTypeCollect:
            title = @"我的收藏";
            break;
        default:
            break;
    }
    
    [self setNaviBarTitle:title];
    
    //2.rightItem
    if (![title isEqualToString:@"我的发布"]) {return ; }
    
    CGFloat rightItemBtnW = [ccui getRH:60];
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:16] title:@"发布" titleColor:COLOR_BLACK_TEXT bgColor:nil];
    rightItemBtn.frame = CGRectMake(SCREEN_WIDTH-rightItemBtnW, STATUS_BAR_HEIGHT, rightItemBtnW, 44);
    [self.naviBar addSubview:rightItemBtn];
    rightItemBtn.clickTimeInterval = 1.0;
    WS(weakSelf);
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        [weakSelf pushToPublicVC];
    }];
}


-(void)setupUI {
    WS(weakSelf);
    //1.创建
    UITableView *tableView = [[UITableView alloc]init];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.dynamicTableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.naviBar.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(0);
    }];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[KKDynamicWholeCell class] forCellReuseIdentifier:cellIdentify];
     [_dynamicTableView registerClass:[KKDynamicArticleCell class] forCellReuseIdentifier:articleCellIdentify];
//    tableView.tableFooterView = [UIView new];
    
    
    //3. refresh
    //3.1 header
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求
        weakSelf.paginator = nil;
        [weakSelf requestDynamicList];
        
    }];
    [tableView.mj_header beginRefreshing];
    
    //3.2 footer
    MJRefreshAutoStateFooter *mjFooter = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        //请求
        if (weakSelf.paginator) {
            weakSelf.paginator.page += 1;
        }
        [weakSelf requestDynamicList];
    }];
    mjFooter.triggerAutomaticallyRefreshPercent = 0;
    tableView.mj_footer = mjFooter;
    
}

#pragma mark - interaction
//注册一个通知 来刷新 数据
- (void)registNote{
    _notice = [[NSNotificationCenter defaultCenter]addObserverForName:@"DynamicRefresh" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *subjectId = note.userInfo[@"subjectId"];
        KKDynamicWholeItem *wholeItem = note.userInfo[@"dynamicWholeItem"];
        [self.dynamicMutArr enumerateObjectsUsingBlock:^(KKDynamicWholeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.subjectId isEqualToString:subjectId]) {
                NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:idx inSection:0];
                KKDynamicWholeItem *chagedItem = [self.dynamicMutArr objectAtIndex:idx];
                chagedItem.dynamicOperationItem = wholeItem.dynamicOperationItem;
                
                [self.dynamicTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA, nil] withRowAnimation:UITableViewRowAnimationNone];
                //                [self.dynamicTableView reloadData];
            }
        }];
    }];
}


#pragma mark - delegate
#pragma mark  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dynamicMutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
    return [KKDynamicWholeItem cellHeight:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
    item.nowDate = self.nowDate;
    
    if ([item.objectType isEqualToString:@"PERSONAL_ARTICLE"]){
        KKDynamicArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellIdentify forIndexPath:indexPath];
        cell.delegate = self;
        cell.dynamicWholeItem = item;
        return cell;
    }else{
        KKDynamicWholeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
        cell.delegate = self;
        cell.dynamicWholeItem = item;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dynamicMutArr == nil) {
        return 0;
    }else{
        if (self.dynamicMutArr.count > 0) {
            return 0;
        }else{
            return self.noContentFootView.height;
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
            return self.noContentFootView;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
    if (item.subjectId.length < 1) {
        return ;
    }
    [self pushToDynamicDetailVC:item.subjectId];
}



#pragma mark KKDynamicWholeCellDelegate
- (void)KKDynamicWholeCell:(KKDynamicWholeCell *)dynamicWholeCell withHeadViewPoint:(CGPoint)thePoint{
    
    KKDynamicWholeItem *wholeItem = dynamicWholeCell.dynamicWholeItem;
    self.selectecdIndexPath = [self.dynamicTableView indexPathForCell:dynamicWholeCell];
    
    NSString *userId = wholeItem.dynamicHeadItem.userId;
    [self showDynamicPopView:userId point:thePoint];
    
}

#pragma mark KKDynamicArticleCellDelegate
- (void)KKDynamicArticleCell:(KKDynamicArticleCell *)dynamicArticleCell withfunctionBtnPoint:(CGPoint)thePoint{
    KKDynamicWholeItem *wholeItem = dynamicArticleCell.dynamicWholeItem;
    self.selectecdIndexPath = [self.dynamicTableView indexPathForCell:dynamicArticleCell];
    
    NSString *userId = wholeItem.dynamicArticleItem.userId;
    [self showDynamicPopView:userId point:thePoint];
}

- (void)KKDynamicWholeCellfocusActionFocus:(KKDynamicWholeCell *)dynamicWholeCell{
    //1.准备数据
    KKDynamicWholeItem *dynamicWholeItem = dynamicWholeCell.dynamicWholeItem;
    KKDynamicHeadItem *headItem = dynamicWholeItem.dynamicHeadItem;
    NSString *typeName = headItem.commonObjectTypeName;
    NSString *userId = headItem.userId;
    
    //2.请求关注
    [self requstToAttentionTypeName:typeName withUserId:userId withComplete:^(BOOL hasFocused) {
        //3.调整model
        NSMutableArray *indexPaths = [NSMutableArray array];
        [self.dynamicMutArr enumerateObjectsUsingBlock:^(KKDynamicWholeItem * _Nonnull wholeItem, NSUInteger idx, BOOL * _Nonnull stop) {
            if (wholeItem.dynamicHeadItem) {
                KKDynamicHeadItem *hItem = wholeItem.dynamicHeadItem;
                if ([hItem.userId isEqualToString:userId]) {
                    hItem.focus = hasFocused;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                }
            }
        }];
        //4.刷新tableView
        [self.dynamicTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    }];
}

#pragma mark KKDynamicPopViewDelegate

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



#pragma mark - request
-(void)requstDeleteDynamic {
    
    //过滤
    if (!self.selectecdIndexPath) {
        return;
    }
    
    //对应的model
    KKDynamicWholeItem *wholeItem = (KKDynamicWholeItem *)self.dynamicMutArr[self.selectecdIndexPath.row];
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"SUBJECT_DELETE" forKey:@"service"];
    [params safeSetObject:wholeItem.subjectId forKey:@"subjectId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        weakSelf.selectecdIndexPath = nil;
        
        if (error) {
            [CC_NoticeView showError:error atView:self.view];
        }else{
            if ([weakSelf.dynamicMutArr containsObject:wholeItem]) {
                [weakSelf.dynamicMutArr removeObject:wholeItem];
                [weakSelf.dynamicTableView reloadData];
            }
        }
    }];
}

//关注用户
- (void)requstToAttentionTypeName:(NSString *)typeName withUserId:(NSString *)userId withComplete:(void(^)(BOOL))complete{
    //1.参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
    if ([typeName isEqualToString:@"GUILD_INDEX"]) {
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }else {
        [params setValue:@"USER" forKey:@"subscribeType"];
    }
    [params setValue:userId forKey:@"objectId"];
    
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else{
            [CC_NoticeView showError:@"关注成功"];
            complete(YES);
        }
    }];
}

/* 动态 */
- (void)requestDynamicList {
    
    //超页过滤
    if (self.paginator) {
        if (self.paginator.page > self.paginator.pages) {
            [self.dynamicTableView.mj_header endRefreshing];
            [self.dynamicTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //service
    NSString *serviceStr = @"";
    switch (self.type) {
        case KKMyDynamicTypeCreate:
            serviceStr = @"MY_CREATE_SUBJECT_QUERY";
            break;
        case KKMyDynamicTypeTransmit:
            serviceStr = @"MY_TRANSMIT_SUBJECT_QUERY";
            break;
        case KKMyDynamicTypeLike:
            serviceStr = @"MY_LIKE_SUBJECT_QUERY";
            break;
        case KKMyDynamicTypeCollect:
            serviceStr = @"MY_COLLECT_SUBJECT_QUERY";
            break;
        default:
            break;
    }
    [params safeSetObject:serviceStr forKey:@"service"];
    [params setObject:self.paginator?@(self.paginator.page):@(1) forKey:@"currentPage"];
    
    //2.请求
    self.noContentFootView.hidden = YES;
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
            
        }else{
            //BBLOG(@"%@",resultModel.resultDic);
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
            self.nowDate = responseDic[@"nowDate"];
            self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            
            //3.1 取出动态数组
            NSArray *topicSimpleList = [NSArray arrayWithArray:responseDic[@"topicSimpleList"]];
            
            NSMutableArray *listTempArr = [NSMutableArray arrayWithCapacity:topicSimpleList.count];
            for (int i = 0; i<topicSimpleList.count; i ++) {
                NSDictionary *dynamicDict = topicSimpleList[i];
                KKDynamicWholeItem *dynamicWholeItem = [KKDynamicWholeItem makeTheDynamicItemWithDictionary:dynamicDict];
                [listTempArr addObject:dynamicWholeItem];
            }
            
            //3.2 更新数据
            if (self.paginator.page == 1) {
                self.dynamicMutArr = listTempArr;
            }else{
                [self.dynamicMutArr addObjectsFromArray:listTempArr];
            }
            //3.3 刷新tableView
            [self.dynamicTableView reloadData];
        }
        
        //3.停止刷新
        self.noContentFootView.hidden = NO;
        [self.dynamicTableView.mj_header endRefreshing];
        [self.dynamicTableView.mj_footer endRefreshing];
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
        weakSelf.selectecdIndexPath = nil;
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"该动态删除后不可撤回，是否确认删除？" actions:@[actionCancel,actionYes]];
}

- (void)showDynamicPopView:(NSString *)userId point:(CGPoint )thePoint {
    
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
}

#pragma mark - jump
/** 跳转 发动态VC */
- (void)pushToPublicVC{
    KKDynamicPublishController *publicVC = [[KKDynamicPublishController alloc]init];
//    NSMutableArray *VCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    int index = (int)[VCs indexOfObject:self];
//    [VCs removeObjectAtIndex:index];
//    [VCs addObject:publicVC];
//    [self.navigationController setViewControllers:VCs animated:YES];

    [self.navigationController pushViewController:publicVC animated:YES];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [mArr removeObjectAtIndex:mArr.count -2];
    self.navigationController.viewControllers = mArr;
}

/** 跳转 动态详情VC */
-(void)pushToDynamicDetailVC:(NSString *)subjectId {
    DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
    dydetailVC.subjectId = subjectId;
    [self.navigationController pushViewController:dydetailVC animated:YES];
}

@end
