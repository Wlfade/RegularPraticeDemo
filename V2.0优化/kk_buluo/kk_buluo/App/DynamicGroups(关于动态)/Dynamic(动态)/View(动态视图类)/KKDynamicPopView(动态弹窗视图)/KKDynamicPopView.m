//
//  KKDynamicPopView.m
//  KKTribe
//
//  Created by 单车 on 2019/2/19.
//  Copyright © 2019 杭州鼎代. All rights reserved.
//

#import "KKDynamicPopView.h"

#import "KKDynamicMorePopItem.h"

static const CGFloat cellHeight = 50;

@interface KKDynamicPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UIView *clearBackGroundView; //透明的背景视图

@property (nonatomic,weak)UIView *grayBackGroundView; //会儿的背景视图

//@property (nonatomic,weak)UIView *menu; //菜单视图
@property (nonatomic,weak)UITableView *menu; //菜单视图

@property (nonatomic,strong) NSArray *inforTextArr;

@property (nonatomic,strong) NSMutableArray *btnMutArr;


@property (nonatomic,assign) CGPoint selectedPoint;
@end

@implementation KKDynamicPopView



- (NSMutableArray *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = [NSMutableArray array];
    }
    return _btnMutArr;
}

+ (instancetype)KKDynamicPopViewShow:(NSArray * _Nonnull )inforTextArr witSelectedPoint:(CGPoint)selectedPoint{
    KKDynamicPopView *menu = [[KKDynamicPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    menu.selectedPoint = selectedPoint;
    menu.inforTextArr = inforTextArr;
    
    [menu creatSubView];
    
    [[AppDelegate sharedAppDelegate].window addSubview:menu];
    
    return menu;
}

- (void)creatSubView{

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamicPop_icon"]];
    imageView.frame = CGRectMake(0, 0, 12, 24);
//   [self insertSubview:imageView aboveSubview:grayBackGroundView];
    [self addSubview:imageView];


    CGFloat imageViewY = 0;
    CGFloat imageViewX = self.selectedPoint.x - 6;

    CGFloat tableViewHeight = cellHeight * self.inforTextArr.count;
    CGFloat tablViewY = 0;
    
    if (self.selectedPoint.y < SCREEN_HEIGHT/2) {
        imageViewY = self.selectedPoint.y - 4;
        tablViewY = imageViewY + 24;
    }else{
        imageViewY = self.selectedPoint.y-24 + 4;

        tablViewY = imageViewY - tableViewHeight;
        
        imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.x = imageViewX;
    imageFrame.origin.y = imageViewY;
    imageView.frame = imageFrame;
    
    UITableView *menu = [[UITableView alloc]initWithFrame:CGRectMake(10, tablViewY, SCREEN_WIDTH - 20, tableViewHeight) style:UITableViewStylePlain];
    menu.layer.cornerRadius = 4;
    menu.layer.masksToBounds = YES;
    menu.delegate = self;
    menu.dataSource = self;
    
//    [menu registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify];
    
    self.menu = menu;
//    [self insertSubview:menu aboveSubview:grayBackGroundView];
    [self addSubview:menu];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self cancelAction];
    if ([self.delegate respondsToSelector:@selector(KKDynamicPopViewClosed:)]) {
        [self.delegate KKDynamicPopViewClosed:self];
    }
}



- (void)cancelAction{
//    [KKDynamicPopView hide:^{
//        
//    }];
}


+ (void)hide:(void(^)(void))completion{
    for (KKDynamicPopView *childView in [AppDelegate sharedAppDelegate].window.subviews) {
        if ([childView isKindOfClass:[self class]]) {
            //            [self removeFromSuperview];
            [childView setUpHiddentAnimation:^{
                if (completion) {
                    completion();
                }
            }];
        }
    }
}

- (void)setUpHiddentAnimation:(void(^)(void))completion{
    //    [self removeFromSuperview];

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //        self.transform = CGAffineTransformMakeTranslation(0, self.height);


//        self.menu.transform = CGAffineTransformMakeTranslation(0, self.menu.height);
        [self setViewNil];
    } completion:^(BOOL finished) {
        //        [blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
    if (completion) {
        completion();
    }
}
- (void)setViewNil{
    [self.clearBackGroundView removeFromSuperview];
    self.clearBackGroundView = nil;
    [self.grayBackGroundView removeFromSuperview];
    self.grayBackGroundView = nil;
    [self.menu removeFromSuperview];
    self.menu = nil;
}


#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inforTextArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const cellIdentify = @"dynamicPopCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =
        cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.65];
    }
    
    KKDynamicMorePopItem *popItem = self.inforTextArr[indexPath.row];
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = rgba(51, 51, 51, 1);
//    cell.textLabel.text = @"反馈垃圾内容";
    cell.textLabel.text = popItem.title;

    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.textColor = rgba(153, 153, 153, 1);
//    cell.detailTextLabel.text = @"低俗，标题党等";
    
    if (popItem.subTitle) {
        cell.detailTextLabel.text = popItem.subTitle;
    }
    
    if (popItem.titleImage) {
//        cell.imageView.image = [UIImage imageNamed:@"waring_icon"];
        cell.imageView.image = popItem.titleImage;

    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self cancelAction];
    KKDynamicMorePopItem *popItem = self.inforTextArr[indexPath.row];
    NSString *titleStr = popItem.title;
    
    if ([self.delegate respondsToSelector:@selector(KKDynamicPopViewClicked:withSelectedSting:)]) {
        [self.delegate KKDynamicPopViewClicked:self withSelectedSting:titleStr];
    }
}
@end
