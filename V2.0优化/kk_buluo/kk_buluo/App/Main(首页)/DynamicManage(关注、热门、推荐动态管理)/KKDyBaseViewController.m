//
//  KKDyBaseViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyBaseViewController.h"
#import "XMGCover.h"

//--------------view
#import "KKDynamicWholeCell.h" //单元格
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
KKDynamicPopViewDelegate
>


/** 无内容提醒 */
@property (nonatomic, strong)UIView *noContentFootView ;

@end
static NSString *const cellIdentify = @"dynamicCell";

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
}
- (void)setTableFrame:(CGRect)tableFrame{
    _tableFrame = tableFrame;
}
/** 表视图 */
- (UITableView *)dynamicTableView{
    if (!_dynamicTableView) {
        
        UITableView *dynamicTableView = [[UITableView alloc]initWithFrame:_tableFrame style:UITableViewStylePlain];
        
        dynamicTableView.delegate = self;
        dynamicTableView.dataSource = self;
        
        dynamicTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        dynamicTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        [dynamicTableView registerClass:[KKDynamicWholeCell class] forCellReuseIdentifier:cellIdentify];
        _dynamicTableView = dynamicTableView;
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
//    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
    return [KKDynamicWholeItem cellHeight:item];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDynamicWholeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    cell.delegate = self;

    KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
    
    item.nowDate = self.nowDate;
    
    cell.dynamicWholeItem = item;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDynamicWholeItem *item = self.dynamicMutArr[indexPath.row];
    
    NSString *subjectId = item.subjectId;
    
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
    [XMGCover showIn];
    
    KKDynamicWholeItem *wholeItem = dynamicWholeCell.dynamicWholeItem;
    
    NSArray *popInforArr = nil;
    
    if (![[KKUserInfoMgr shareInstance].userId isEqualToString:wholeItem.dynamicHeadItem.userId]) {
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
    
    KKDynamicPopView *pop = [KKDynamicPopView KKDynamicPopViewShow:popInforArr witSelectedPoint:thePoint];
    pop.delegate = self;
}
#pragma mark KKDynamicPopViewDelegate
- (void)KKDynamicPopViewClicked:(KKDynamicPopView *)screenView withSelectedSting:(nonnull NSString *)selectString{
    
    if ([selectString isEqualToString:@"不感兴趣"]) {
        [KKDynamicPopView hide:^{
            [XMGCover hidden];
        }];
    }else if ([selectString isEqualToString:@"反馈垃圾内容"]){
        //关闭视图
        [KKDynamicPopView hide:^{
            //举报
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XMGCover hidden];
            });
            [KKReportActionSheet KKReportActionSheetPersent:self animated:YES completion:nil];
        }];
    }else if ([selectString isEqualToString:@"删除"]){
        [KKDynamicPopView hide:^{
            [XMGCover hidden];
        }];
    }
    
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
@end
