//
//  photoAlbumViewController.h
//  LQPhotoAlbun
//
//  Created by liang lee on 2018/5/9.
//  Copyright © 2018年 liang lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol photoAlbumViewControllerDelegate;
@interface photoAlbumViewController : UIViewController


//接收上个界面传过来的点击的 imageView 的 tag 值
@property(nonatomic,assign)NSInteger imageViewTag;

//当前展示的第几张图片
//@property(nonatomic,assign)NSInteger pageIndex;

//接收上个界面传过来的点击的 imageViews 的 frames
@property(nonatomic,strong)NSArray* frameArr;

/** 接受上个界面传过来的imageview数组 */
@property (nonatomic,strong)NSArray *imageViewArr;


/** 图片数组 */
@property (nonatomic,strong)NSArray *images;

/** 展示的图片的index */
@property (nonatomic,assign)NSInteger pageIndex;

@property (nonatomic,weak)id<photoAlbumViewControllerDelegate>delegate;
@end

@protocol photoAlbumViewControllerDelegate <NSObject>

-(void)imageViewController:(photoAlbumViewController* )imageViewController willDidDissImageViewFrame:(CGRect) frame with:(NSURL*)url;

-(void)didDismissImageViewController:(photoAlbumViewController* )imageViewController;

@end
