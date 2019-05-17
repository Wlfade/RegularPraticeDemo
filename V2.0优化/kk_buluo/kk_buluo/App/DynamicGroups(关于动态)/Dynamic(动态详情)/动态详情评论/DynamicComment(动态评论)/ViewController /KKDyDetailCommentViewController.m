//
//  KKDyDetailCommentViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailCommentViewController.h"

#import "KKComDeViewController.h"

//--------------model
#import "HHPaginator.h"
#import "KKDynamicCommentItem.h"

//--------------View
#import "NoContentReminderView.h"
#import "KKDyDetailCommentCell.h"

@interface KKDyDetailCommentViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong)NSMutableArray *commentMutArr;

@property(nonatomic,strong)HHPaginator *paginator;

/** 无内容提醒 */
@property (nonatomic, strong)UIView *noContentFootView ;

@property(nonatomic,strong)NSString *nowDate;

@end

static NSString *cellIdentify = @"cellId";

@implementation KKDyDetailCommentViewController
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
/** 评论数组 */
- (NSMutableArray *)commentMutArr{
    if (!_commentMutArr) {
        _commentMutArr = [NSMutableArray array];
    }
    return _commentMutArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.tableView registerClass:[KKDyDetailCommentCell class] forCellReuseIdentifier:cellIdentify];

    [self requestCommentQuery];
    
    [self setupRefresh];
    
}
#pragma mark function
- (void)refreshCommentInfor{
    self.paginator.page = 1;
    [self requestCommentQuery] ;
}
#pragma mark Refresh
-(void)setupRefresh
{
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SS(strongSelf)
        strongSelf->_paginator.page = 1;
        [strongSelf requestCommentQuery] ;
        
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [strongSelf requestCommentQuery] ;
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
    
    KKDynamicCommentItem *item = self.commentMutArr[indexPath.row];
    return [KKDynamicCommentItem cellHeight:item] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDyDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];

    WS(weakSelf);
    cell.block = ^(KKDynamicCommentItem * commentItem) {
        //跳转到评论详情页
        KKComDeViewController *comDeVC = [[KKComDeViewController alloc]init];
        comDeVC.objectId = weakSelf.objectId;
        comDeVC.commentId = commentItem.commentId;
        
        [weakSelf.navigationController pushViewController:comDeVC animated:YES];
    };
    KKDynamicCommentItem *item = self.commentMutArr[indexPath.row];
    item.nowDate = self.nowDate;
    cell.dyCommentItem = item;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDynamicCommentItem *item = self.commentMutArr[indexPath.row];
    
    KKComDeViewController *comDeVC = [[KKComDeViewController alloc]init];
    comDeVC.objectId = _objectId;
    comDeVC.commentId = item.commentId;
    
    [self.navigationController pushViewController:comDeVC animated:YES];

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

#pragma mark request
/** COMMENT_QUERY */
- (void)requestCommentQuery
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GMT_CREATE_DESC" forKey:@"orderBy"];

    [params setObject:_objectId forKey:@"objectId"];
    
    [params setObject:@"COMMENT_QUERY" forKey:@"service"];
    [params setObject:@"SUBJECT" forKey:@"objectType"];
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
            
            self.nowDate = responseDic[@"nowDate"];
            
            self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            
            NSMutableArray *mutTempArr = [KKDynamicCommentItem makeTheDynamicCommentItem:responseDic];
            
            if (self.paginator.page == 1) {
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
    
    if (self.tableView.contentSize.height < kScreenHeight + ([self.delegate TableHeaderImgHeight:self] - STATUS_AND_NAV_BAR_HEIGHT)) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}

@end
