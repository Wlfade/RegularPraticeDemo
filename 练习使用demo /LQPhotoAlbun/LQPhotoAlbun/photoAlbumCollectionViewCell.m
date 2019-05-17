//
//  photoAlbumCollectionViewCell.m
//  LQPhotoAlbun
//
//  Created by liang lee on 2018/5/9.
//  Copyright © 2018年 liang lee. All rights reserved.
//

#import "photoAlbumCollectionViewCell.h"

@implementation photoAlbumCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.contentView.frame];
        self.scrollowView = [[UIScrollView alloc]initWithFrame:self.contentView.frame];
        self.scrollowView.center = self.contentView.center;
        self.scrollowView.delegate = self;
        //        self.scrollowView.backgroundColor =[UIColor purpleColor];
        //对图片进行等比例缩放，保证等宽或者等高
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.scrollowView];
        [self.scrollowView addSubview:self.imageView];
        
        [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageView.contentMode =  UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds  = YES;
        //创建单击手势
        UITapGestureRecognizer* onceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onceTap:)];
        [self.imageView addGestureRecognizer:onceTap];
        //创建双击手势
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [onceTap requireGestureRecognizerToFail:doubleTap];
        [self.imageView addGestureRecognizer:doubleTap];
        //创建长安手势，用于长按保存
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        //设置长按最短生效时间
        longPress.minimumPressDuration = 0.5;
        [self.imageView addGestureRecognizer:longPress];
    }
    
    return self;
    
}
#pragma mark ---------- 手势触发事件
-(void)onceTap:(UITapGestureRecognizer* )tap
{
    
    //    NSLog(@"触发了单击手势");
    
    UIImageView* imageView = (UIImageView* )tap.view;
    
    if (_delegete && [_delegete respondsToSelector:@selector(textAndImageView:didTapWithImageView:)])
    {
        
        [_delegete textAndImageView:self didTapWithImageView:imageView];
        
    }
}

-(void)doubleTap:(UITapGestureRecognizer* )tap
{
    //    NSLog(@"触发了双击手势");
    
    if (self.scrollowView.zoomScale < self.scrollowView.maximumZoomScale)
    {
        
        //找到屏幕上点击的点
        CGPoint point = [tap locationInView:tap.view];
        
        //方法到一个自定义的位置  以某个点坐标点边长为10 10的矩形方法到最大倍数
        [self.scrollowView zoomToRect:CGRectMake(point.x, point.y, 10, 10) animated:YES];
        
    }else
    {
        //如果不是1.0倍就变回1.0倍
        [self.scrollowView setZoomScale:1.0f animated:YES];
    }
    
}

-(void)longPress:(UILongPressGestureRecognizer* )longPress
{
    
    //    NSLog(@"触发了长按手势");
    
    CGPoint point = [longPress locationInView:longPress.view];
    
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        if (_delegete && [_delegete respondsToSelector:@selector(textAndImageView:didLongPressWithImageView:WithPoint:)])
        {
            
            UIImageView* imageView = (UIImageView* )longPress.view;
            
            [_delegete textAndImageView:self didLongPressWithImageView:imageView WithPoint:point];
            
        }
    }
}

#pragma mark ---------- scrollowViewDelegate
//返回一个我们要进行缩放操作的 view
-(UIView* )viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

//设置 scrollowView 和 imageView 的缩放方式
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGRect frame = scrollView.frame;
    
    if (self.imageView.frame.size.width > self.frame.size.width)
    {
        
        frame.size.width = self.frame.size.width;
        
    }else
    {
        frame.size.width = self.imageView.frame.size.width;
    }
    
    if (self.imageView.frame.size.height > self.frame.size.height)
    {
        frame.size.height = self.frame.size.height;
    }else
    {
        frame.size.height = self.imageView.frame.size.height;
    }
    
    scrollView.frame = frame;
    
    scrollView.center = self.contentView.center;
    
}


@end
