//
//  KKRecomViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRecomViewController.h"

#import "KKMyRecommendCell.h"

#import "HHPaginator.h"

#import "KKMyRecommend.h"

#import "DGFloatButton.h"

#import "KKDynamicPublishController.h"

#import "KKPersonalPageController.h"

@interface KKRecomViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *canFollowObjects;

//@property (nonatomic,strong)DGFloatButton *floatButton;

@property(nonatomic,strong)HHPaginator *paginator;


@property(nonatomic,assign)BOOL isFoucedUser;

@end
static CGFloat const topViewH = 160;
static NSString* const cellIdentify = @"CellIdentify";

@implementation KKRecomViewController
- (void)setViewFrameH:(CGFloat)viewFrameH{
    _viewFrameH = viewFrameH;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFoucedUser = NO;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
    
    [self requestRecommendUser];
    
//    [self.view addSubview:self.floatButton];
}
-(void)setupRefresh
{
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SS(strongSelf)

        if (weakSelf.isFoucedUser == YES) {
            [strongSelf.tableView.mj_header endRefreshing];
            if ([strongSelf.delegate respondsToSelector:@selector(KKRecomViewController:isFocusUser:)]) {
                [strongSelf.delegate KKRecomViewController:strongSelf isFocusUser:strongSelf.isFoucedUser];
            }
        }else{
            strongSelf->_paginator.page = 1;
            [strongSelf requestRecommendUser] ;
        }
    }];
    
    MJRefreshAutoFooter *foot = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [strongSelf requestRecommendUser] ;
        }else{
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];

        }
    }];
    foot.triggerAutomaticallyRefreshPercent = -10;
    
    self.tableView.mj_footer = foot;
}
- (void)reFreshRecommendUser{
    self.paginator.page = 1;
    self.isFoucedUser = NO;
    [self requestRecommendUser] ;
}
//- (DGFloatButton *)floatButton{
//    if (!_floatButton) {
//        _floatButton = [[DGFloatButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 50, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TAB_BAR_HEIGHT - 50, 50, 50)];
//        [_floatButton setBackgroundImage:[UIImage imageNamed:@"public_icon"] forState:UIControlStateNormal];
//        WS(weakSelf);
//        _floatButton.clickBlock = ^{
//            [weakSelf pushToPublicVC];
//        };
//    }
//    return _floatButton;
//}
- (NSMutableArray *)canFollowObjects {
    if (!_canFollowObjects) {
        _canFollowObjects = [NSMutableArray array];
    }
    return _canFollowObjects;
}
//跳转到发动态控制器
- (void)pushToPublicVC{
    KKDynamicPublishController *publicVC = [[KKDynamicPublishController alloc]init];
    [self.navigationController pushViewController:publicVC animated:YES];
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, topViewH)];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainView_image"]];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 155);
        imageView.contentMode = UIViewContentModeCenter;
        [_topView addSubview:imageView];
        
    }
    return _topView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topViewH, SCREEN_WIDTH, _viewFrameH - topViewH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"KKMyRecommendCell"];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.canFollowObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKMyRecommendCell"];
    WS(weakSelf);
    cell.attentionButtonActionBlock = ^(KKMyRecommend * _Nonnull recommend , KKMyRecommendCell *cell) {
        [weakSelf requstToAttentionuserId:recommend withComplete:^(bool foucs) {
            if ([[KKUserInfoMgr shareInstance].userId isEqualToString:recommend.userId]) {
                return ;
            }
            recommend.focus = YES;
            cell.myRecommend = recommend;
        }];
    };
    KKMyRecommend *recommendItem = self.canFollowObjects[indexPath.row];
    recommendItem.isHasFocus = YES;
    cell.myRecommend = recommendItem;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     KKMyRecommend *recommendItem = self.canFollowObjects[indexPath.row];
    
    KKPersonalPageController *personVC = [[KKPersonalPageController alloc] init];
    // 公会号
    if ([recommendItem.objectType.name isEqualToString:@"GUILD_INDEX"]) {
        personVC.personalPageType = PERSONAL_PAGE_GUILD;
    }else {
        personVC.personalPageType = PERSONAL_PAGE_OTHER;
    }
    personVC.userId = recommendItem.userId;
    [self.navigationController pushViewController:personVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"推荐";
    titleLabel.textColor = RGB(153, 153, 153);
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 29);
    [headView addSubview:titleLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 29, SCREEN_WIDTH - 20, 1)];
    lineView.backgroundColor = COLOR_BG;
    [headView addSubview:lineView];
    return headView;
}

- (void)requestRecommendUser{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"RECOMMEND_FOLLOW_QUERY" forKey:@"service"];
    [params setObject:self.paginator?@(self.paginator.page):@(1) forKey:@"currentPage"];
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            NSDictionary *responseDic = resultModel.resultDic[@"response"];
            
            self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            
            NSArray *follows = [NSArray arrayWithArray:responseDic[@"canFollowObjects"]];
            NSMutableArray *mutFollows = [NSMutableArray arrayWithCapacity:follows.count];
            for (NSDictionary *dict in follows) {
                KKMyRecommend *recommend = [KKMyRecommend mj_objectWithKeyValues:dict];
                [mutFollows addObject:recommend];
            }
            if (self.paginator.page == 1) {
                self.canFollowObjects = mutFollows;
            }else{
                [self.canFollowObjects addObjectsFromArray:mutFollows];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
//关注用户
- (void)requstToAttentionuserId:(KKMyRecommend *)obj withComplete:(void(^)(bool))complete{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
    if ([obj.objectType.name isEqualToString:@"GUILD_INDEX"]) {
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }else {
        [params setValue:@"USER" forKey:@"subscribeType"];
    }
    [params setValue:obj.userId forKey:@"objectId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else{
            complete(YES);
            self.isFoucedUser = YES;
        }
    }];
}
@end
