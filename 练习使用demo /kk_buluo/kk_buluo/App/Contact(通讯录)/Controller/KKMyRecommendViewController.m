//
//  KKMyRecommendViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyRecommendViewController.h"
#import "DGItemView.h"
#import "KKMyRecommendCell.h"
@interface KKMyRecommendViewController ()<DGItemViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) DGItemView *itemView;
/// 推荐成功表视图
@property (nonatomic, strong) UITableView *didJoinInTableView;
/// 待加入
@property (nonatomic, strong) UITableView *willJoinInTableView;
/// 滑动视图
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation KKMyRecommendViewController

- (DGItemView *)itemView {
    if (!_itemView) {
        _itemView = [[DGItemView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, 39)];
        _itemView.titleArr = @[@"推荐成功", @"待加入"];
        _itemView.normalFont = [UIFont systemFontOfSize:14];
        _itemView.selectedFont = [UIFont systemFontOfSize:14];
        _itemView.indicatorScale = 0.4;
        _itemView.indicatorColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _itemView.selectedColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _itemView.delegate = self;
    }
    return _itemView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5))];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UITableView *)didJoinInTableView {
    if (!_didJoinInTableView) {
        _didJoinInTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _didJoinInTableView.delegate = self;
        _didJoinInTableView.dataSource = self;
        [_didJoinInTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _didJoinInTableView;
}
- (UITableView *)willJoinInTableView {
    if (!_willJoinInTableView) {
        _willJoinInTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _willJoinInTableView.delegate = self;
        _willJoinInTableView.dataSource = self;
        [_willJoinInTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellIDWill"];
    }
    return _willJoinInTableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.didJoinInTableView) {
        return 3;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.didJoinInTableView) {
        
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        return cell;
    }else {
        
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDWill"];
        return cell;
    }
}
    
#pragma mark - DGItemViewDelegate
- (BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    /// RECOMMEND_REGISTER_QUERY 状态，我的推荐 取SUCCESS，待加入的取WAIT
    if (index == 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self getMyRecommendData:@"SUCCESS"];
    }else {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [self getMyRecommendData:@"WAIT"];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.itemView.selectedIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.itemView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.didJoinInTableView];
    [self.scrollView addSubview:self.willJoinInTableView];
    self.title = @"我的推荐";
    [self getMyRecommendData:@"SUCCESS"];

}
- (void)getMyRecommendData:(NSString *)status {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"RECOMMEND_REGISTER_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:status forKey:@"status"];
    [params setValue:@"1" forKey:@"currentPage"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if ([status isEqualToString:@"SUCCESS"]) {
            [weakSelf.didJoinInTableView reloadData];
        }else {
            [weakSelf.willJoinInTableView reloadData];
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
