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

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation KKMyAttentionViewController

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
- (UITableView *)didJoinInTableView {
    if (!_leftTableView) {
        _leftTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _leftTableView;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [_rightTableView registerClass:[KKMyRecommendCell class] forCellReuseIdentifier:@"cellIDWill"];
    }
    return _rightTableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 3;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        
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
    }else {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
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
    [self.scrollView addSubview:self.leftTableView];
    [self.scrollView addSubview:self.rightTableView];
    self.title = @"我的关注";

}


@end
