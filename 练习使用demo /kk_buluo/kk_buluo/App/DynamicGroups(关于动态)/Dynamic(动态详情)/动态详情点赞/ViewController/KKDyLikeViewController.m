//
//  KKDyLikeViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyLikeViewController.h"
#import "KKDydeLikeCell.h"
//--------------model
#import "HHPaginator.h"
#import "KKDydeLikeItem.h"

#import "NoContentReminderView.h"

@interface KKDyLikeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong)NSMutableArray *commentMutArr;

@property(nonatomic,strong)HHPaginator *paginator;

/** 无内容提醒 */
@property (nonatomic, strong)UIView *noContentFootView ;
@end

static NSString *cellIdentify = @"cellId";

@implementation KKDyLikeViewController
#pragma mark lazy
/** 暂无界面 */
- (UIView *)noContentFootView{
    if (_noContentFootView == nil) {
        UIView *noContentFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"咦~暂时还没有内容哦" withColor:[UIColor grayColor]];
        noContentFootView.backgroundColor = [UIColor whiteColor];
        
        CGFloat topY = 20;

        [NoContentReminderView showReminderViewToView:noContentFootView imageTopY:topY image:[UIImage imageNamed:@"empty_image"] remindWords:attribute];
        
        _noContentFootView = noContentFootView;
    }
    return _noContentFootView;
}

/** 点赞数据数组 */
- (NSMutableArray *)commentMutArr{
    if (!_commentMutArr) {
        _commentMutArr = [NSMutableArray array];
    }
    return _commentMutArr;
}
#pragma mark LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.tableView registerClass:[KKDydeLikeCell class] forCellReuseIdentifier:cellIdentify];
    [self requestLikeQuery];
    [self setupRefresh];
}
#pragma mark Function
- (void)refreshLikeInfor{
    self.paginator.page = 1;
    [self requestLikeQuery] ;
}
#pragma mark Refresh
-(void)setupRefresh
{
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SS(strongSelf)
        strongSelf->_paginator.page = 1;
        [strongSelf requestLikeQuery] ;
        
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [strongSelf requestLikeQuery] ;
        }else{
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentMutArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KKDydeLikeItem *item = self.commentMutArr[indexPath.row];
    return [KKDydeLikeItem cellHeight:item] + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDydeLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    
    KKDydeLikeItem *item = self.commentMutArr[indexPath.row];
    
    cell.dydeLikeItem = item;
        
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.commentMutArr == nil) {
        return 0;
    }else{
        if (self.commentMutArr.count > 0) {
            return 0;
        }else{
            return self.noContentFootView.height;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.commentMutArr == nil) {
        return nil;
    }else{
        if (self.commentMutArr.count > 0) {
            return nil;
        }else{
            return self.noContentFootView;
        }
    }
}

#pragma mark - Request
/** LIKE_QUERY */
- (void)requestLikeQuery
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:_sourceId forKey:@"objectId"];
    [params setObject:@"LIKE_QUERY" forKey:@"service"];
    [params setObject:self.paginator?@(self.paginator.page):@(1) forKey:@"currentPage"];
    
    [self.view showMaskProgressHUDInWindow] ;

    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        [self.view hiddenMaskProgressHUDInWindow] ;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            
            NSArray *transmitList = [NSArray arrayWithArray:responseDic[@"list"]];
            NSMutableArray *mutTempArr = [NSMutableArray arrayWithCapacity:transmitList.count];
            for (NSDictionary *transDic in transmitList) {
                KKDydeLikeItem *transmitItem = [KKDydeLikeItem KKDydeLikeItemWithDictionary:transDic];
                [mutTempArr addObject:transmitItem];
            }
            if (self.paginator.page == 1 || self.paginator.page == 0) {
                self.commentMutArr = mutTempArr;
            }else{
                [self.commentMutArr addObjectsFromArray:mutTempArr];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self resetContentInset];
            });
        }
    }];
}


#pragma mark - Private
- (void)resetContentInset {
    [self.tableView layoutIfNeeded];
    
    if (self.tableView.contentSize.height < kScreenHeight + ([self.delegate TableHeaderImgHeight:self] - STATUS_AND_NAV_BAR_HEIGHT)) {  // 136 = 200
        //        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight+88-self.tableView.contentSize.height, 0);
        self.tableView.contentInset = UIEdgeInsetsZero;
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}
@end
