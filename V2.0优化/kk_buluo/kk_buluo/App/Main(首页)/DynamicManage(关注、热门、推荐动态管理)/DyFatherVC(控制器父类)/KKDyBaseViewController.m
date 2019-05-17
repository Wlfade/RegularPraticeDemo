//
//  KKDyBaseViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyBaseViewController.h"
//-----tool
#import "XMGCover.h" //灰色蒙层
#import "KKDyManagerViewModel.h" //网络请求工具类

//--------------view
#import "KKDynamicWholeCell.h" //单元格
#import "KKDynamicArticleCell.h" //单元格
#import "KKDynamicPopView.h" //动态弹窗
#import "KKReportActionSheet.h" //举报视图

//--------------model
#import "KKDynamicWholeItem.h"
#import "KKDynamicMorePopItem.h"

//--------------controller
#import "DynamicDetailViewController.h"


@interface KKDyBaseViewController ()
<UITableViewDelegate,
UITableViewDataSource,
KKDynamicWholeCellDelegate,
KKDynamicArticleCellDelegate,
KKDynamicPopViewDelegate
>

/** 无内容提醒 */
@property (nonatomic, strong)UIView *noContentFootView ;

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@property(nonatomic,strong) KKDynamicWholeItem *selectedWholeItem;

/** 动态在详情中的改变通知 */
@property(nonatomic,weak)id notice;

@end
static NSString *const cellIdentify = @"dynamicCell";

static NSString *const articleCellIdentify = @"dynamicArtCell";

@implementation KKDyBaseViewController
#pragma mark lazy
/** lazyFootView */
- (UIView *)noContentFootView{
    if (_noContentFootView == nil) {
        UIView *noContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.dynamicTableView.bounds.size.height)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"咦~暂时还没有内容哦" withColor:[UIColor grayColor]];
        noContentFootView.backgroundColor = [UIColor whiteColor];
        [NoContentReminderView showReminderViewToView:noContentFootView imageTopY:30 image:[UIImage imageNamed:@"empty_image"] remindWords:attribute];
        
        _noContentFootView = noContentFootView;
    }
    return _noContentFootView;
}
/** 动态数组 */
-(NSMutableArray *)dynamicMutArr{
    if (!_dynamicMutArr) {
        _dynamicMutArr = [NSMutableArray array];
    }
    return _dynamicMutArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.dynamicTableView];
    [self setupRefresh];
    [self registNote];
}
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
- (void)setTableFrame:(CGRect)tableFrame{
    _tableFrame = tableFrame;
}
/** 表视图 */
- (UITableView *)dynamicTableView{
    if (_dynamicTableView == nil) {
       _dynamicTableView = [[UITableView alloc]initWithFrame:_tableFrame style:UITableViewStylePlain];
        
        _dynamicTableView.delegate = self;
        _dynamicTableView.dataSource = self;
        
        _dynamicTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _dynamicTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        [_dynamicTableView registerClass:[KKDynamicWholeCell class] forCellReuseIdentifier:cellIdentify];
        
        [_dynamicTableView registerClass:[KKDynamicArticleCell class] forCellReuseIdentifier:articleCellIdentify];
        [_dynamicTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _dynamicTableView;
}

#pragma mark TableViewRefresh
-(void)setupRefresh
{
    WS(weakSelf)
    self.dynamicTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SS(strongSelf)
        strongSelf->_paginator.page = 1;
        [strongSelf refresh];
    }];
    
    MJRefreshAutoStateFooter *foot = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [strongSelf loadMore];
        }else{
            [strongSelf.dynamicTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    foot.triggerAutomaticallyRefreshPercent = -10;
    
    self.dynamicTableView.mj_footer = foot;
}
#pragma mark -UITableViewDataSource
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
    
    NSString *subjectId = item.subjectId;
    
//    DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
//    dydetailVC.subjectId = subjectId;
//
//    __block NSIndexPath *indexPathA = indexPath;
//    WS(weakSelf);
//    dydetailVC.dynamicBlock = ^(KKDynamicWholeItem * _Nonnull dynamicWholeItem) {
//        SS(strongSelf);
//        [strongSelf.dynamicMutArr replaceObjectAtIndex:indexPathA.row withObject:dynamicWholeItem];
//        [strongSelf.dynamicTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
//    };
//
//    [self.navigationController pushViewController:dydetailVC animated:YES];
    
    [self pushDynamicDetailViewController:subjectId];
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
#pragma mark refresh LoadMore
//下拉刷新
- (void)refresh{
    BBLOG(@"父类下拉刷新");
//    [self.dynamicTableView.mj_footer endRefreshing];
//    [self.dynamicTableView.mj_header endRefreshing];
}
- (void)loadMore{
    BBLOG(@"父类加载更多");
}


#pragma mark KKDynamicWholeCellDelegate
- (void)KKDynamicWholeCell:(KKDynamicWholeCell *)dynamicWholeCell withHeadViewPoint:(CGPoint)thePoint{
    
    KKDynamicWholeItem *wholeItem = dynamicWholeCell.dynamicWholeItem;
    
    NSString *userId = wholeItem.dynamicHeadItem.userId;
    
    [self KKDynamicPopViewUserId:userId withPoint:thePoint withKKDynamicWholeItem:wholeItem withCell:dynamicWholeCell];
}
- (void)KKDynamicWholeCellfocusActionFocus:(KKDynamicWholeCell *)dynamicWholeCell{
    KKDynamicWholeItem *dynamicWholeItem = dynamicWholeCell.dynamicWholeItem;
    
    KKDynamicHeadItem *headItem = dynamicWholeItem.dynamicHeadItem;
    
    NSString *typeName = headItem.commonObjectTypeName;
    
    NSString *userId = headItem.userId;
    
    WS(weakSelf);
    [KKDyManagerViewModel requstToAttentionTypeName:typeName withUserId:userId withComplete:^(bool Foucsed) {
        SS(strongSelf);
        NSMutableArray *indexPaths = [NSMutableArray array];
        [strongSelf.dynamicMutArr enumerateObjectsUsingBlock:^(KKDynamicWholeItem * _Nonnull WholeItem, NSUInteger idx, BOOL * _Nonnull stop) {
            if (WholeItem.dynamicHeadItem) {
                KKDynamicHeadItem *headItem = WholeItem.dynamicHeadItem;
                if ([headItem.userId isEqualToString:userId]) {
                    headItem.focus = Foucsed;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                }
            }
        }];
        
        [strongSelf.dynamicTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark KKDynamicArticleCellDelegate
- (void)KKDynamicArticleCell:(KKDynamicArticleCell *)dynamicArticleCell withfunctionBtnPoint:(CGPoint)thePoint{
    KKDynamicWholeItem *wholeItem = dynamicArticleCell.dynamicWholeItem;
    NSString *userId = wholeItem.dynamicArticleItem.userId;
    [self KKDynamicPopViewUserId:userId withPoint:thePoint withKKDynamicWholeItem:wholeItem withCell:dynamicArticleCell];
}
#pragma mark 弹出警告视图
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
    
    self.selectedIndexPath = [self.dynamicTableView indexPathForCell:selectedCell];
    self.selectedWholeItem = selectedItem;
}
#pragma mark KKDynamicPopViewDelegate
- (void)KKDynamicPopViewClicked:(KKDynamicPopView *)screenView withSelectedSting:(nonnull NSString *)selectString{
    
    if ([selectString isEqualToString:@"不感兴趣"]) {
        [KKDynamicPopView hide:^{
            [XMGCover hidden];
            self.selectedIndexPath = nil;
            self.selectedWholeItem = nil;
        }];
    }else if ([selectString isEqualToString:@"反馈垃圾内容"]){
        //关闭视图
        [KKDynamicPopView hide:^{
            //举报
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XMGCover hidden];
                self.selectedIndexPath = nil;
                self.selectedWholeItem = nil;
            });
            [KKReportActionSheet KKReportActionSheetPersent:self animated:YES completion:nil];
        }];
    }else if ([selectString isEqualToString:@"删除"]){
        WS(weakSelf);
        [KKDynamicPopView hide:^{
            
            //2.隐藏背景corver
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XMGCover hidden];
            });
            
             [weakSelf showAlertForDelete];

        }];
    }
    
}
#pragma mark - alert
/** alert确认实名 */
-(void)showAlertForDelete {
    WS(weakSelf);
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        SS(strongSelf);
        [KKDyManagerViewModel requstDeleteDynamicSubjectId:strongSelf.selectedWholeItem.subjectId complete:^{
            [strongSelf.dynamicMutArr removeObjectAtIndex:self->_selectedIndexPath.row];
                NSArray *indexPaths = @[self->_selectedIndexPath];
                [strongSelf.dynamicTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
                strongSelf.selectedIndexPath = nil;
                strongSelf.selectedWholeItem = nil;
        }];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectedIndexPath = nil;
        self.selectedWholeItem = nil;
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"该动态删除后不可撤回，是否确认删除？" actions:@[actionCancel,actionYes]];
}

- (void)KKDynamicPopViewClosed:(KKDynamicPopView *)screenView{
    [KKDynamicPopView hide:^{
        [XMGCover hidden];
    }];
}

#pragma mark Push
/** 跳转到动态详情控制器 */
- (void)pushDynamicDetailViewController:(NSString *)subjectId{
    DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
    dydetailVC.subjectId = subjectId;
    [self.navigationController pushViewController:dydetailVC animated:YES];
}

//关注用户
//- (void)requstToAttentionTypeName:(NSString *)typeName withUserId:(NSString *)userId withComplete:(void(^)(bool))complete{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
//    if ([typeName isEqualToString:@"GUILD_INDEX"]) {
//        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
//    }else {
//        [params setValue:@"USER" forKey:@"subscribeType"];
//    }
//    [params setValue:userId forKey:@"objectId"];
//    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
//        if (str) {
//            [CC_NoticeView showError:str];
//        }else{
//            [CC_NoticeView showError:@"关注成功"];
//            complete(YES);
//        }
//    }];
//}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:_notice];
}
@end
