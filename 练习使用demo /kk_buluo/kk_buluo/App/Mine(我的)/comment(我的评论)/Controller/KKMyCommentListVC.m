//
//  KKMyCommentListVC.m
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMyCommentListVC.h"
#import "DynamicDetailViewController.h"
//view
#import "KKMyCommentTableViewCell.h"
#import "XMGCover.h"
#import "KKDynamicPopView.h" //动态弹窗
//model
#import "KKMyCommentListModel.h"
#import "KKDynamicMorePopItem.h"
//tool
#import "KKReMakeDictionary.h"


@interface KKMyCommentListVC ()
<UITableViewDelegate,
UITableViewDataSource,
KKMyCommentTableViewCellDelegate,
KKDynamicPopViewDelegate>

/* 动态表视图 */
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)HHPaginator *paginator;
@property (nonatomic, strong) KKMyCommentTableViewCell *handleCell;
/* 动态表数据数组 */
@property(nonatomic,strong)NSMutableArray <KKMyCommentSimpleModel *>*mutArr;
@property(nonatomic,strong)NSString *nowDate;

/** 无内容提醒 */
@property (nonatomic, strong)UIView *noContentFootView ;

@end

@implementation KKMyCommentListVC

static NSString *const cellIdentify = @"commentCell";

#pragma mark - lazy load
-(NSMutableArray <KKMyCommentSimpleModel *>*)mutArr{
    if (!_mutArr) {
        _mutArr = [NSMutableArray array];
    }
    return _mutArr;
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

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupUI];
}

#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"我的评论"];
}


-(void)setupUI {
    WS(weakSelf);
    //1.创建
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.naviBar.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(0);
    }];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[KKMyCommentTableViewCell class] forCellReuseIdentifier:cellIdentify];
    //tableView.tableFooterView = [UIView new];
    
    //3. refresh
    //3.1 header
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求
        weakSelf.paginator = nil;
        [weakSelf requestCommentList];
        
    }];
    [tableView.mj_header beginRefreshing];
    
    //3.2 footer
    MJRefreshAutoStateFooter *mjFooter = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        //请求
        if (weakSelf.paginator) {
            weakSelf.paginator.page += 1;
        }
        [weakSelf requestCommentList];
    }];
    mjFooter.triggerAutomaticallyRefreshPercent = 0;
    tableView.mj_footer = mjFooter;
    
}

#pragma mark - delegate
#pragma mark  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [ccui getRH:157];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKMyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    KKMyCommentSimpleModel *model = self.mutArr[indexPath.row];
    model.nowDate = self.nowDate;
    cell.model = model;
    cell.commentDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.mutArr.count > 0 ) {
        return 0;
    }else{
        return self.noContentFootView.height;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.mutArr.count > 0 ) {
        return nil;
    }else{
        return self.noContentFootView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    KKMyCommentSimpleModel *model = self.mutArr[indexPath.row];
    NSString *subjectId = model.topicSimple.topicObject.subjectId;
    if (subjectId.length < 1) {
        [CC_NoticeView showError:@"原文已删除"];
        return ;
    }
    [self pushDynamicDetailVC:subjectId];
}

#pragma mark KKMyCommentTableViewCellDelegate
-(void)commentCell:(KKMyCommentTableViewCell *)cell withHeadViewPoint:(CGPoint)point {
    //1.显示cover
    [XMGCover showIn];
    //2.记录操作cell
    self.handleCell = cell;
    //3.popV
    KKDynamicMorePopItem *item = [[KKDynamicMorePopItem alloc]init];
    item.titleImage = [UIImage imageNamed:@"dynamic_delete_icon"];
    item.title = @"删除";
    NSArray *popInforArr = @[item];
    KKDynamicPopView *pop = [KKDynamicPopView KKDynamicPopViewShow:popInforArr witSelectedPoint:point];
    pop.delegate = self;
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
    }];
    
}

- (void)KKDynamicPopViewClosed:(KKDynamicPopView *)screenView{
    [KKDynamicPopView hide:^{
        [XMGCover hidden];
    }];
}



#pragma mark - request
/* 请求 评论list */
- (void)requestCommentList {
    
    //超页过滤
    if (self.paginator) {
        if (self.paginator.page > self.paginator.pages) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //service
    [params safeSetObject:@"MY_COMMENT_SUBJECT_QUERY" forKey:@"service"];
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
            KKMyCommentListModel *commentListModel = [KKMyCommentListModel mj_objectWithKeyValues:responseDic];
            self.paginator = commentListModel.paginator;
            
            //3.1 取出动态数组
            
            //3.2 更新数据
            if (self.paginator.page == 1) {
                [self.mutArr removeAllObjects];
            }
            
            //转换评论
            for (KKMyCommentSimpleModel *model in commentListModel.commentSimpleList) {
                model.attributedContent = [self convertToAttributedStr:model.content font:FontB(16)];
                model.topicSimple.topicObject.attributedSummary = [self convertToAttributedStr:model.topicSimple.topicObject.summary font:Font(13)];
            }
            
            [self.mutArr addObjectsFromArray:commentListModel.commentSimpleList];
            
            //3.3 刷新tableView
            [self.tableView reloadData];
        }
        
        //3.4 停止刷新
        self.noContentFootView.hidden = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

/* 请求 删除 */
-(void)requstDeleteComment {
    
    //过滤
    if (!self.handleCell) {
        return;
    }
    
    //对应的model
    KKMyCommentSimpleModel *commentModel = self.handleCell.model;
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"COMMENT_DELETE" forKey:@"service"];
    [params safeSetObject:commentModel.idStr forKey:@"commentId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        weakSelf.handleCell = nil;
        if (error) {
            [CC_NoticeView showError:error atView:self.view];
        }else{
            if ([weakSelf.mutArr containsObject:commentModel]) {
                [weakSelf.mutArr removeObject:commentModel];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

#pragma mark tool
-(NSAttributedString *)convertToAttributedStr:(NSString *)str font:(UIFont *)font {
    NSDictionary *titleAttdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:str withTextFont:font withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
    return [titleAttdict objectForKey:@"html"];
}

#pragma mark - alert
/** alert确认实名 */
-(void)showAlertForDelete {
    WS(weakSelf);
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requstDeleteComment];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"该评论删除后不可撤回，是否确认删除？" actions:@[actionCancel,actionYes]];
}

#pragma mark - jump
-(void)pushDynamicDetailVC:(NSString *)subjectId {
    DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
    dydetailVC.subjectId = subjectId;
    [self.navigationController pushViewController:dydetailVC animated:YES];
}

@end
