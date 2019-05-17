//
//  KKDynamicViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicViewController.h"
#import "KKDyManagerViewModel.h"
#import "KKMyFollowerCell.h"
#import "KKFollowerItem.h"

//--------------controller
#import "KKAttentionMoreViewController.h"
#import "KKPersonalPageController.h"



@interface KKDynamicViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
/* 动态表视图 */

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UICollectionView *collectionView;

@end
static NSString *const collectcell = @"followerCell";


@implementation KKDynamicViewController
#pragma mark lazy
/** 顶层视图 */
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
        
        _topView.backgroundColor = COLOR_BG;
        
        [_topView addSubview:self.collectionView];
        
    }
    return _topView;
}

/** collectionView */
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60,80);
        layout.minimumLineSpacing = 5; //设置行与行之间的间距的最小距离
        layout.minimumInteritemSpacing = 10; //设置列与列之间的间距的最小距离
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[KKMyFollowerCell class] forCellWithReuseIdentifier:collectcell];
        
    }
    return _collectionView;
}

#pragma mark -lifeCircle
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dynamicTableView setTableHeaderView:self.topView];

    [self requsetInfor];
}

- (void)requsetInfor{
    [KKDyManagerViewModel requestMyFollowTopicQuery:self.paginator?@(self.paginator.page):@(1) complete:^(NSString * _Nonnull errorStr, ResModel * _Nonnull resultModel, NSMutableArray * _Nonnull resultMutArr) {
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


#pragma mark  UICollectionViewRelaod
- (void)setFollowList:(NSMutableArray *)followList{
    _followList = followList;
    
    [self.collectionView reloadData];
}

#pragma mark  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.followList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KKFollowerItem *item = self.followList[indexPath.row];
    
    KKMyFollowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectcell forIndexPath:indexPath];
    cell.followerItem = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KKFollowerItem *item = self.followList[indexPath.row];
    if ([item.commonObjectName isEqualToString:@"关注更多"]) {
        KKAttentionMoreViewController *attentionMoreVC = [[KKAttentionMoreViewController alloc] init];
        [self.navigationController pushViewController:attentionMoreVC animated:YES];
    }else{
        if (!item.commonObjectId) {
            return;
        }
        KKPersonalPageController *personalPageVC = [[KKPersonalPageController alloc]init];
        
        if ([item.commonObjectTypeName isEqualToString:@"USER"]) {
            personalPageVC.personalPageType = PERSONAL_PAGE_OTHER;
        }else if([item.commonObjectTypeName isEqualToString:@"GUILD_INDEX"]){
            personalPageVC.personalPageType = PERSONAL_PAGE_GUILD;
        }
        personalPageVC.userId = item.commonObjectId;
        [self.navigationController pushViewController:personalPageVC animated:YES];
    }
}

@end
