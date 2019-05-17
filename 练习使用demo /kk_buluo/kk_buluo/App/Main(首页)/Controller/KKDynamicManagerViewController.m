//
//  KKDynamicManagerViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicManagerViewController.h"

//#import "KKDyFocusViewController.h" //关注
#import "KKMainViewController.h" //关注

#import "KKDyHotViewController.h" //热门
#import "KKDyReCommentViewController.h" //推荐


#import "KKDynamicPublishController.h"

#import "KKMyFriendViewController.h"


#import "KKDynamicViewController.h"

@interface KKDynamicManagerViewController ()

@end

@implementation KKDynamicManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%f",self.contentScrollViewHeigh);
    [self setUpAllChildViewController];
    
    [self setupNavi];

}
-(void)setupNavi {
    
    CGRect titleScrollFrame = self.titleScrollView.frame;
    titleScrollFrame.size.width -= 100;
    self.titleScrollView.frame = titleScrollFrame;

    //2.设置导航右侧按钮

    DGButton *rightItemBtn = [DGButton btnWithImg:[UIImage imageNamed:@"publicBtn_icon"]];
    WS(weakSelf);
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        KKDynamicPublishController *publicVC = [[KKDynamicPublishController alloc]init];
        publicVC.block = ^{
            UIButton *sender = self.titleBtnMutArr[0];
            
            [weakSelf titleClick:sender];
            
            KKMainViewController *mainVC = self.childViewControllers[0];
            
            UIViewController *mainShowingVC = mainVC.showingVC;
            
            if ([mainShowingVC isKindOfClass:[KKDynamicViewController class]]) {
                NSLog(@"刷新一下");
                KKDynamicViewController *dynamicVC = (KKDynamicViewController *)mainVC.showingVC;
                
                dynamicVC.paginator.page = 1;
                [dynamicVC refresh];
                
            }
        };
        [weakSelf.navigationController pushViewController:publicVC animated:YES];
        
    }];
    
    [self.view addSubview:rightItemBtn];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo([ccui getRH:50]);
        make.height.mas_equalTo([ccui getRH:24]);
        make.centerY.mas_equalTo(self.titleScrollView.mas_centerY);
    }];
}

#pragma mark - 添加自控制器
- (void)setUpAllChildViewController{
    
    KKMainViewController *mainVC = [[KKMainViewController alloc]init];
    mainVC.title = @"关注";
    mainVC.subViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, self.contentScrollViewHeigh - 44 - STATUS_BAR_HEIGHT);
    [self addChildViewController:mainVC];

    
    KKDyHotViewController *social1 = [[KKDyHotViewController alloc]init];
    social1.title = @"热门";
    social1.tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, self.contentScrollViewHeigh - 44 - STATUS_BAR_HEIGHT);
    [self addChildViewController:social1];
    
    KKDyReCommentViewController *social2 = [[KKDyReCommentViewController alloc]init];
    social2.title = @"推荐";
    social2.tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, self.contentScrollViewHeigh - 44 - STATUS_BAR_HEIGHT);
    [self addChildViewController:social2];
}

@end
