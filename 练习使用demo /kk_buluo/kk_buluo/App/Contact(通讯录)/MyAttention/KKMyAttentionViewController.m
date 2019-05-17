//
//  KKMyAttentionViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/18.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyAttentionViewController.h"
#import "DGItemView.h"
#import "KKMyRecommendCell.h"
@interface KKMyAttentionViewController ()<DGItemViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) DGItemView *itemView;

@property (nonatomic, strong) UITableView *lTableView;

@property (nonatomic, strong) UITableView *rTableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) NSMutableArray *userArray;


@end

@implementation KKMyAttentionViewController
- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

- (DGItemView *)itemView {
    if (!_itemView) {
        _itemView = [[DGItemView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, 39)];
        _itemView.titleArr = @[@"消息号", @"达人"];
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
- (UITableView *)lTableView {
    if (!_lTableView) {
        _lTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5))];
        _lTableView.delegate = self;
        _lTableView.dataSource = self;
        _lTableView.tableFooterView = [UIView new];
        [_lTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _lTableView;
}
- (UITableView *)rTableView {
    if (!_rTableView) {
        _rTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + 50 + 5))];
        _rTableView.delegate = self;
        _rTableView.dataSource = self;
        _rTableView.tableFooterView = [UIView new];
        [_rTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellIDWill"];
    }
    return _rTableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.lTableView) {
        return self.messageArray.count;
    }else {
        return self.userArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.lTableView) {
        
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        return cell;
    }else {
        
        KKMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDWill"];
        return cell;
    }
}

#pragma mark - DGItemViewDelegate
- (BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    if (index == 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
        [self getMyAttenttionType:@"GUILD_INDEX"];
    }else {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [self getMyAttenttionType:@"USER"];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.itemView.selectedIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
}

#pragma mark - 网络
- (void)getMyAttenttionType:(NSString *)type {
    if ([type isEqualToString:@"GUILD_INDEX"]) {
        [self.messageArray removeAllObjects];
    }else {
        [self.userArray removeAllObjects];
    }
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"MY_FOLLOW_OBJECT_QUERY" forKey:@"service"];
//    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    [params setValue:@"10004001792637545700290980135543" forKey:@"authedUserId"];
    [params setValue:type forKey:@"type"];
    [params setValue:@"1" forKey:@"currentPage"];
    [params setValue:@"10" forKey:@"pageSize"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSNumber *success = responseDic[@"success"];
        if (success.integerValue == 1) {
            if ([type isEqualToString:@"GUILD_INDEX"]) {
                
                [weakSelf.messageArray addObjectsFromArray:[KKMyRecommend mj_objectArrayWithKeyValuesArray:responseDic[@"list"]]];
                if (weakSelf.messageArray.count > 0) {
                    [weakSelf.lTableView reloadData];
                }
            }else {
                
                [weakSelf.userArray addObjectsFromArray:[KKMyRecommend mj_objectArrayWithKeyValuesArray:responseDic[@"list"]]];
                if (weakSelf.userArray.count > 0) {
                    [weakSelf.rTableView reloadData];
                }
            }
        }else {
            
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    [self.view addSubview:self.itemView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.lTableView];
    [self.scrollView addSubview:self.rTableView];
    [self getMyAttenttionType:@"GUILD_INDEX"];
}

@end
