//
//  KKDyReCommentViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyReCommentViewController.h"
#import "KKDyManagerViewModel.h"

@interface KKDyReCommentViewController ()

@end

@implementation KKDyReCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requsetInfor];
}
- (void)requsetInfor{
    [KKDyManagerViewModel requestAllGuileSubjectQuery:self.paginator?@(self.paginator.page):@(1) complete:^(NSString * _Nonnull errorStr, ResModel * _Nonnull resultModel, NSMutableArray * _Nonnull resultMutArr) {
        [self.dynamicTableView.mj_header endRefreshing];
        [self.dynamicTableView.mj_footer endRefreshing];
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
            self.nowDate = responseDic[@"nowDate"];
            self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            
            if (self.paginator.page == 1) {
                self.dynamicMutArr = resultMutArr;
            }else{
                [self.dynamicMutArr addObjectsFromArray:resultMutArr];
            }
            [self.dynamicTableView reloadData];
        }
    }];
}

- (void)refresh{
    NSLog(@"刷新");
    [self requsetInfor];
}
- (void)loadMore{
    NSLog(@"加载");
    [self requsetInfor];
}

@end
