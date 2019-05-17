//
//  BBDynamicBlowUpView.m
//  BananaBall
//
//  Created by 单车 on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BBDynamicBlowUpView.h"
#import "BBDynamicBlowUpCell.h"
//#import "SubmitView.h"
#import "KKImageListItem.h"
@interface BBDynamicBlowUpView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
BBDynamicBlowUpCellDelegate>

@property (nonatomic,strong)NSMutableArray *imageInforArr;

/** collection */
@property (nonatomic,weak)UICollectionView *blowUpCollectionView;
/** 分页控件 */
@property (nonatomic,weak)UIPageControl *pageControl;

@property (nonatomic,assign)NSInteger currentPage;

/** 保存按钮 */
@property (nonatomic,weak)UIButton *saveBtn;
@end

static NSString *const cellId =@"BBDynamicBlowUpCell";

@implementation BBDynamicBlowUpView
+(instancetype)BlowUpWithImageArr:(NSMutableArray*)mutArr withCurrentPage:(NSInteger )currentPage{
    BBDynamicBlowUpView *blowUpView = [[BBDynamicBlowUpView alloc]initWithFrame:[UIScreen mainScreen].bounds WithImageInforArr:mutArr withCurrentPage:currentPage];
    
    blowUpView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.3 animations:^{
        blowUpView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    

    [[UIApplication sharedApplication].keyWindow addSubview:blowUpView];
    return blowUpView;
}
- (instancetype)initWithFrame:(CGRect)frame WithImageInforArr:(NSMutableArray *)mutArr withCurrentPage:(NSInteger )currentPage{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageInforArr = mutArr;
        self.currentPage = currentPage;
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //水平方向滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    UICollectionView *blowUpCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.blowUpCollectionView = blowUpCollectionView;
    blowUpCollectionView.delegate = self;
    blowUpCollectionView.dataSource = self;

    //关闭水平滚动条
    blowUpCollectionView.showsHorizontalScrollIndicator = NO;
    //开启分页
    blowUpCollectionView.pagingEnabled = YES;
    //关闭弹性效果
    blowUpCollectionView.bounces = NO;

    [self addSubview:blowUpCollectionView];

    [blowUpCollectionView registerClass:[BBDynamicBlowUpCell class] forCellWithReuseIdentifier:cellId];

    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(10, SCREEN_HEIGHT -45, 60, 35);
    saveBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 4;
    saveBtn.layer.borderWidth = 1;
    //    _saveBtn.enabled = NO;
    saveBtn.layer.borderColor =RGB(102, 102, 102).CGColor;
    [saveBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn addTarget:self action:@selector(saveimageClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.saveBtn = saveBtn;
    [self addSubview:saveBtn];

    UIPageControl *pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT - 43, SCREEN_WIDTH - 120, 30)];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.numberOfPages = self.imageInforArr.count;
    pageControl.currentPage = self.currentPage;
    self.pageControl = pageControl;

    [self insertSubview:pageControl aboveSubview:self.blowUpCollectionView];

     [blowUpCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
#pragma mark  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return self.imageInforArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BBDynamicBlowUpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    KKImageListItem *imageListItem = self.imageInforArr[indexPath.row];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageListItem.url]];
    cell.delegate = self;

    return cell;
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    self.currentPage = self.pageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

}
#pragma mark BBDynamicBlowUpCellDelegate
- (void)BBDynamicBlowUpCellTap:(BBDynamicBlowUpCell *)blowUpCell{
    [self close];
}
#pragma mark 保存动作
-(void)saveimageClick{
    BBLOG(@"保存图片");

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
    BBDynamicBlowUpCell *currentCell = (BBDynamicBlowUpCell *)[self.blowUpCollectionView cellForItemAtIndexPath:indexPath];



    KKImageListItem *imageListItem = self.imageInforArr[indexPath.row];
    NSString *urlStr = imageListItem.url;

    if (!currentCell.imageView.image) {
        // 图片不存在时, 请求网络加载图片
        typeof(self) weakSelf = self;
        [currentCell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                // 图片加载失败
                [weakSelf close];
                return;
            } else {
                // 图片加载成功
                [weakSelf imageSavedToPhotosAlbum:image];
            }
        }];
    }else{
        [self imageSavedToPhotosAlbum:currentCell.imageView.image];
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    });
}
- (void)imageSavedToPhotosAlbum:(NSString *)imageUrl didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {

//        SubmitView *submitView = [[SubmitView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_HEIGHT / 2 - 80, 160, 120)];
//        submitView.backgroundColor = [UIColor clearColor];
//        submitView.myImageType = CheckMark;
//        submitView.textString = @"保存图片成功";
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:submitView];
         [CC_NoticeView showError:@"保存图片成功"];
    }else{
//        SubmitView *submitView = [[SubmitView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_HEIGHT / 2 - 80, 160, 120)];
//        submitView.backgroundColor = [UIColor clearColor];
//        submitView.myImageType = CheckMark;
//        submitView.textString = @"保存图片失败";
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:submitView];
         [CC_NoticeView showError:@"保存图片失败"];
    }
    [self close];
}
- (void)close{
    if ([self.delegate respondsToSelector:@selector(BBDynamicBlowUpViewCloseAction:)]) {
        [self.delegate BBDynamicBlowUpViewCloseAction:self];
    }
}
+ (void)hiddenInpoint:(CGPoint)point completion:(void (^)(void))completion{
    for (BBDynamicBlowUpView *childView in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if([childView isKindOfClass:self]){
            //            [childView setUpHiddenAnimation:point];
            [childView setUpHiddenAnimation:point completion:^{
                //动画执行完成
                if (completion) {
                    completion();
                }
            }];
        }
    }

}
- (void)setUpHiddenAnimation:(CGPoint)point completion:(void(^)(void))completion{
//    [UIView animateWithDuration:0.5 animations:^{
//        //设置变形
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        //平移
//        transform = CGAffineTransformTranslate(transform, -self.center.x + point.x, -self.center.y + point.y);
//        //缩放
//        transform = CGAffineTransformScale(transform, 0.01, 0.01);
//        //设置
//        self.transform = transform;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        //动画完成时，也要告诉外界
//        //        [XMGCover hidden];
//        if (completion) {
//            completion();
//        }
//    }];

    [self removeFromSuperview];

    if (completion) {
        completion();
    }
}

//- (void)BBDynamicBlowUpViewCloseAction:(BBDynamicBlowUpView *)menu;

@end
