//
//  KKLinkageViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKLinkageViewController.h"

@interface KKLinkageViewController ()<UIScrollViewDelegate>


/** 选中的按钮 */
@property (nonatomic,weak)UIButton *selectedBtn;

/** 内容scrollView */
@property (nonatomic,weak) UIScrollView *contentScrollView;

/** 是否添加过 */
@property (nonatomic, assign) BOOL isInitialize;
@end

static CGFloat const btnW = 50;

@implementation KKLinkageViewController
#pragma mark - lazy
- (NSMutableArray *)titleBtnMutArr{
    if (!_titleBtnMutArr) {
        _titleBtnMutArr = [NSMutableArray array];
    }
    return _titleBtnMutArr;
}


#pragma mark - lifePeriod
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (_isInitialize == NO) {
        [self setUpAllTitles];
        
        _isInitialize = YES;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
        
    // 1.添加标题滚动视图
    [self setUpTitleScrollView];
    
    // 2.添加内容滚动视图
    [self setUpContentScrollView];
    
}
#pragma mark - 添加标题滚动视图
- (void)setUpTitleScrollView{
    UIScrollView *titleScrollView = [[UIScrollView alloc]init];
    CGFloat y = 0;
    if (_topY != 0) {
        y = _topY;
    }
    titleScrollView.frame = CGRectMake(0, y, self.view.bounds.size.width, 44);
    
    [self.view addSubview:titleScrollView];
    
    if (@available(iOS 11.0, *)) {
        titleScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    titleScrollView.showsHorizontalScrollIndicator = NO;
        
    _titleScrollView = titleScrollView;
}
#pragma mark - 添加内容滚动视图
- (void)setUpContentScrollView{
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);

    CGFloat height = self.view.bounds.size.height;
    if (self.contentScrollViewHeigh != 0) {
        height = _contentScrollViewHeigh;
    }
    
    contentScrollView.frame = CGRectMake(0, y, self.view.bounds.size.width, height - y);
    
    
    [self.view addSubview:contentScrollView];
    
    if (@available(iOS 11.0, *)) {
        contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    //设置contentscrol的属性
    //分页
    contentScrollView.pagingEnabled = YES;
    //弹簧
//    contentScrollView.bounces = YES;
    contentScrollView.bounces = NO;
    
    //指示器
    contentScrollView.showsHorizontalScrollIndicator = NO;
    //设置代理
    contentScrollView.delegate = self;
    
    _contentScrollView = contentScrollView;    
}

#pragma mark - 添加所有的标题
- (void)setUpAllTitles{
    
    //已经把内容展示上去 ->展示的效果是否是我们想要的（调整细节）
    
    //1.标题颜色为黑色
    
    //2.需要让titleScrollView可以滚动
    
    //添加所有的标题按钮
    int count = (int)self.childViewControllers.count;
    
    CGFloat btnH = self.titleScrollView.bounds.size.height;
    CGFloat btnX = 0;
    
    for (int i = 0; i < count; i ++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];

        titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:[ccui getRH:14]];

        titleButton.tag = i;
        
        UIViewController *vc = self.childViewControllers[i];
        
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        
        [titleButton setTitleColor:RGB(174, 174, 174) forState:UIControlStateNormal];

        btnX = btnW * i ;
        
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        //监听按钮的点击
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleBtnMutArr addObject:titleButton];
        
        [self.titleScrollView addSubview:titleButton];
        
        if (i == 0) {
            [self titleClick:titleButton];
        }

    }
    
    self.titleScrollView.contentSize = CGSizeMake(count * btnW, btnH);
    
    
    self.contentScrollView.contentSize = CGSizeMake(count * SCREEN_WIDTH, self.contentScrollView.bounds.size.height);
    
}
#pragma mark -处理标题点击
- (void)titleClick:(UIButton *)sender{
    
    [self selectedBtn:sender];
    
    //2.把对应子控制器的View 加上去
    NSInteger tag = sender.tag;
    
    [self setUpOneViewController:tag];
    
    CGFloat X = tag * SCREEN_WIDTH;
    
    //3.内容滚动视图滚动到对应的位置
    self.contentScrollView.contentOffset = CGPointMake(X, 0);
}
#pragma mark - 选中标题
- (void)selectedBtn:(UIButton *)sender{

    if (_selectedBtn != sender) {
        [_selectedBtn setTitleColor:RGB(174, 174, 174) forState:UIControlStateNormal];
        //1.把标题颜色 变成 红色
        [sender setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];

    
        sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
        _selectedBtn.transform = CGAffineTransformIdentity;
    
        _selectedBtn = sender;
    }else{
        return;
    }
}
#pragma mark - UIScrollViewDelegate
//滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前角标
    NSInteger i = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    //获取标题按钮
    UIButton *titleBtn = self.titleBtnMutArr[i];
    
    //1.选中标题
    [self selectedBtn:titleBtn];
    
    //2.将对应的view添加上去
    [self setUpOneViewController:i];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //字体缩放1.缩放比例
    
    //获取角标
    NSInteger i = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    NSInteger leftI = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    NSInteger rightI = leftI + 1;
    
    //获取左边的按钮
    UIButton *leftBtn = self.titleBtnMutArr[leftI];
    
    NSInteger count = self.titleBtnMutArr.count;
    
    UIButton *rightBtn ;
    //获取右边的按钮
    if (rightI < count) {
        rightBtn = self.titleBtnMutArr[rightI];
    }
    
    
    //计算缩放比例
    CGFloat scaleR = scrollView.contentOffset.x / SCREEN_WIDTH; //右边的缩放比例
    
    scaleR -= leftI;
    
    CGFloat scaleL = 1 - scaleR; //左边的缩放比例
    
    NSLog(@"比例：%f",scaleL);
    //缩放按钮
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL * 0.3 + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * 0.3 + 1, scaleR * 0.3 + 1);
    
//    UIColor *rightColor = [UIColor colorWithRed:scaleR * 0.48 + 0.2 green:scaleR * 0.48 + 0.2 blue:scaleR * 0.48 + 0.2 alpha:1];
//
//    UIColor *leftColor = [UIColor colorWithRed:scaleL * 0.48 + 0.2 green:scaleL * 0.48 + 0.2 blue:scaleL * 0.48 + 0.2 alpha:1];

    
//    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
//startTimerAndScan//    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    
//    [self setTitleCenterWithIndex:i];

}
#pragma mark 标题居中
- (void)setTitleCenterWithIndex:(NSInteger )index
{
    //本质：修改titleScrollView的偏移量
    CGFloat offetX = ((index+1) * btnW - btnW / 2) - SCREEN_WIDTH * 0.5;
    
    if (offetX < 0) {
        offetX = 0;
    }
    
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - SCREEN_WIDTH;
    if (offetX>maxOffsetX) {
        offetX = maxOffsetX;
    }
    
//    [self.titleScrollView setContentOffset:CGPointMake(offetX, 0) animated:YES];
    [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    
}
#pragma mark 添加一个子控制器的View
- (void)setUpOneViewController:(NSInteger )tag{
    
    UIViewController *childVC = self.childViewControllers[tag];
    
    //判断这个控制器的视图是否已经加载
    //9.0后方法
    //    if (childVC.viewIfLoaded) {
    //        return;
    //    }
    if (childVC.view.superview) {
        return;
    }
    
    CGFloat X = tag * SCREEN_WIDTH;
    CGFloat H = self.contentScrollView.bounds.size.height;
    childVC.view.frame = CGRectMake(X, 0, SCREEN_WIDTH, H);
    [self.contentScrollView addSubview:childVC.view];
}
@end

