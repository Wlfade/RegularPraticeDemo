//
//  BaseTableViewController.m
//  微博个人主页
//
//  Created by zenglun on 16/5/4.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import "BaseTableViewController.h"
/** 默认图片高度 */
static const CGFloat headerImgHeight = 200;
/** 默认选择栏高度高度 */
static const CGFloat switchBarHeight = 40;

@interface BaseTableViewController ()

/** 行间距 */
- (CGFloat)headerImgHeight;
/** 列间距 */
- (CGFloat)switchBarHeight;
@end

@implementation BaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@初始化", self);
    
    self.tableView.showsHorizontalScrollIndicator  = NO;
    if (@available(iOS 11.0, *)) {
//        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headerImgHeight + self.switchBarHeight)];
    if (_hideHeader) {
        headerView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }
    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.backgroundColor = [UIColor blueColor];

    self.tableView.tableHeaderView = headerView;
    
//    if (self.tableView.contentSize.height < kScreenHeight + headerImgHeight - topBarHeight ) {
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight + headerImgHeight - topBarHeight - self.tableView.contentSize.height, 0);
//    }
    if (self.tableView.contentSize.height < kScreenHeight + self.headerImgHeight - STATUS_AND_NAV_BAR_HEIGHT ) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight + headerImgHeight - STATUS_AND_NAV_BAR_HEIGHT - self.tableView.contentSize.height, 0);
    }
}
- (CGFloat)headerImgHeight
{
    if ([self.delegate respondsToSelector:@selector(TableHeaderImgHeight:)]) {
        return [self.delegate TableHeaderImgHeight:self];
    }else{
        return headerImgHeight;
    }
}
- (CGFloat)switchBarHeight
{
    if ([self.delegate respondsToSelector:@selector(TableHeaderSwitchBarHeight:)]) {
        return [self.delegate TableHeaderSwitchBarHeight:self];
    } else {
        return switchBarHeight;
    }
}
- (void)dealloc {
    NSLog(@"%@销毁", self);
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
//    NSLog(@"%f", offsetY);

    if ([self.delegate respondsToSelector:@selector(tableViewScroll:offsetY:)]) {
        [self.delegate tableViewScroll:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDragging:offsetY:)]) {
        [self.delegate tableViewWillBeginDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDecelerating:offsetY:)]) {
        [self.delegate tableViewWillBeginDecelerating:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDragging:offsetY:)]) {
        [self.delegate tableViewDidEndDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDecelerating:offsetY:)]) {
        [self.delegate tableViewDidEndDecelerating:self.tableView offsetY:offsetY];
    }
}
- (void)tableViewDidEndHeadRefresh:(UITableView *)tableView{
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndHeadRefresh:)]) {
        [self.delegate tableViewDidEndHeadRefresh:self.tableView];
    }
}



@end
