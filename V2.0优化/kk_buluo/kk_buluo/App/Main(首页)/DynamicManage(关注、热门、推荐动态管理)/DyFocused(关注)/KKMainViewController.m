//
//  KKMainViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMainViewController.h"

#import "KKRecomViewController.h"

#import "KKDynamicViewController.h"


//--------------model
#import "HHPaginator.h"
#import "KKFollowerItem.h"

@interface KKMainViewController ()
<KKRecomViewControllerDelegate>

@property(nonatomic,strong)HHPaginator *paginator;

@property(nonatomic,strong)NSString *nowDate;



@property(nonatomic,strong) NSMutableArray *mutArr;
@end

@implementation KKMainViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestMyFollowObjectQuery:^(bool follow) {
        [self->_showingVC.view removeFromSuperview];
        if (follow == YES) {
            KKDynamicViewController *newVC = self.childViewControllers[0];
            newVC.followList = self.mutArr;
            if (!newVC.view.superview) {
                [self.view addSubview:newVC.view];
                newVC.view.frame = CGRectMake(0, 0, self->_subViewFrame.size.width, self->_subViewFrame.size.height);
            }
            self->_showingVC = newVC;
        }else{
            KKRecomViewController *newVC = self.childViewControllers[1];
            if (!newVC.view.superview) {
                [self.view addSubview:newVC.view];
                newVC.view.frame = CGRectMake(0, 0, self->_subViewFrame.size.width, self->_subViewFrame.size.height);

                [newVC reFreshRecommendUser];
            }
            self->_showingVC = newVC;
        }
    }];
}
- (void)setSubViewFrame:(CGRect)subViewFrame{
    _subViewFrame = subViewFrame;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self addChildViewControllers];
    
    
}
-(void)setupNavi {    
//    [self setNaviBarWithType:DGNavigationBarTypeWhite];
}

/**
 添加子控制器
 */
- (void)addChildViewControllers{
    KKDynamicViewController *mainDyVC = [[KKDynamicViewController alloc]init];
    mainDyVC.tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, _subViewFrame.size.height);

    [self addChildViewController:mainDyVC];
    
    KKRecomViewController *recomVC = [[KKRecomViewController alloc]init];
    recomVC.viewFrameH = _subViewFrame.size.height;
    recomVC.delegate = self;
    [self addChildViewController:recomVC];
}

//关注的人信息查询
- (void)requestMyFollowObjectQuery:(void(^)(bool))finish{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"MY_FOLLOW_OBJECT_QUERY" forKey:@"service"];
    [params setObject:self.paginator?@(self.paginator.page):@(1) forKey:@"currentPage"];
    [params setValue:@"15" forKey:@"pageSize"];
    [params safeSetObject:@"GUILD_INDEX,USER" forKey:@"types"];

    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
            finish(NO);
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
            self.nowDate = responseDic[@"nowDate"];
            
            self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            
            //取出动态数组
            NSArray *followList = [NSArray arrayWithArray:responseDic[@"myFollowObjects"]];
            
            NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:followList.count];
            for (NSDictionary *itemDic in followList) {
                KKFollowerItem *item = [KKFollowerItem mj_objectWithKeyValues:itemDic];
                [mutArr addObject:item];
            }
            
            if (followList.count > 0) {
                KKFollowerItem *item = [[KKFollowerItem alloc]init];
                item.titleColor = rgba(102, 102, 102,1);
                item.placeholdImage = [UIImage imageNamed:@"follow_more_icon"];
                item.commonObjectName = @"关注更多";
                [mutArr addObject:item];
                
                self.mutArr = mutArr;

                finish(YES);
            }else{
                finish(NO);
            }
        }
    }];
}

#pragma mark -  KKRecomViewControllerDelegate
- (void)KKRecomViewController:(KKRecomViewController *)viewController isFocusUser:(BOOL)foucus{
    [self requestMyFollowObjectQuery:^(bool follow) {
        [self->_showingVC.view removeFromSuperview];
        if (follow == YES) {
            KKDynamicViewController *newVC = self.childViewControllers[0];
            newVC.followList = self.mutArr;
            if (!newVC.view.superview) {
                [self.view addSubview:newVC.view];
                newVC.view.frame = CGRectMake(0, 0, self->_subViewFrame.size.width, self->_subViewFrame.size.height);
            }
            self->_showingVC = newVC;
            
        }else{
            KKRecomViewController *newVC = self.childViewControllers[1];
            if (!newVC.view.superview) {
                [self.view addSubview:newVC.view];

                newVC.view.frame = CGRectMake(0, 0, self->_subViewFrame.size.width, self->_subViewFrame.size.height);
                [newVC reFreshRecommendUser];
            }
            self->_showingVC = newVC;
        }
    }];
}
@end
