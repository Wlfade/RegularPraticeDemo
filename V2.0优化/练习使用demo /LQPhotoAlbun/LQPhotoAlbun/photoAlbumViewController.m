//
//  photoAlbumViewController.m
//  LQPhotoAlbun
//
//  Created by liang lee on 2018/5/9.
//  Copyright © 2018年 liang lee. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#import "photoAlbumViewController.h"
#import "photoAlbumCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@interface photoAlbumViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,photoAlbumCollectionViewCellDelegate,UIScrollViewDelegate> {
    
    //展示高清大图的collectionView
    UICollectionView* _collectionView;
    //装着图片url的数组
    NSArray* _imageArr;
    //执行手势的imageview
    UIImageView* _saveImageView;
    //显示图片位置的label
    UILabel* _pageNumLabel;
    
    //做动画的 imageView
    UIImageView* _animatedImageView;
}


@end

@implementation photoAlbumViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //做动画的block块
    [UIView animateWithDuration:0.35 animations:^{
        //获得_animatedImageView的大小
        CGSize imageSize = _animatedImageView.image.size;
        //获得图片的宽高比
        CGFloat imageScale = imageSize.width/imageSize.height;
        //获取屏幕的宽高比
        CGFloat screenScale = self.view.frame.size.width/self.view.frame.size.height;
        //变化后的_animatedImageView的大小
        CGSize imageScaleSize = CGSizeZero;
        //如果图片的宽高比大于屏幕的宽高比
        if (imageScale > screenScale)
        {
            //高相等的情况下，图片的宽比较大
            imageScaleSize.width = self.view.frame.size.width;
            
            imageScaleSize.height = self.view.frame.size.width/imageScale;
        }else
        {
            //宽度相同时，图片的高度比较大
            
            imageScaleSize.height = self.view.frame.size.height;
            
            imageScaleSize.width = self.view.frame.size.height* imageScale;
            
        }
        //重新给_animatedImageView 赋值
        CGRect frame = self->_animatedImageView.frame;
        
        frame.size = imageScaleSize;
        
        self->_animatedImageView.frame = frame;
        //并把_animatedImageView的中心点设置为屏幕的中心点
        self->_animatedImageView.center = self.view.center;
        
        
    } completion:^(BOOL finished) {
        //动画完成之后显示_collectionView,来展示高清大图
        self->_collectionView.hidden = NO;
        //并且把上面放着缩略图的_animatedImageView移除
        [self->_animatedImageView removeFromSuperview];
        
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 30;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.view.frame.size;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 30);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 30, self.view.frame.size.height) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.hidden = YES;
//    _collectionView.contentOffset = CGPointMake((ScreenWidth + 30) * _pageIndex, 0);
    [_collectionView registerClass:[photoAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    
    //创建显示当前页码的label
    _pageNumLabel = [[UILabel alloc]init];
    
    _pageNumLabel.frame = CGRectMake(0, 20, self.view.frame.size.width, 30);
    
    _pageNumLabel.textAlignment = NSTextAlignmentCenter;
    
    //设置label的字的style和size
    _pageNumLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    
    _pageNumLabel.textColor = [UIColor whiteColor];
    
    //给lable赋值
    _pageNumLabel.text = [NSString stringWithFormat:@"%ld / %ld",_pageIndex + 1,_images.count];
    
    [self.view addSubview:_pageNumLabel];
    
    
    //创建每显示动画效果的imageView并设置位置为上个界面传过来的imageView的位置
    _animatedImageView  = [[UIImageView alloc]initWithFrame:[_frameArr[_pageIndex]CGRectValue]];
    //    //按照上个界面传过来的tag值设置模型的index
    //    PBPic* pic = _imageUrls[_tag - 9];
    NSURL* thURL = [NSURL URLWithString:self.images[self.imageViewTag - 10086]];
    //把缩略图赋值给imageView
    [_animatedImageView sd_setImageWithURL:thURL];
    
    [self.view addSubview:_animatedImageView];
    
    //把点击的imageView的tag值赋值给 indexPathForItem
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:_pageIndex inSection:0];
    
    //获得滑动的时候滑到item
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}


#pragma mark ---------- collectionViewDataSource
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

-(UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    photoAlbumCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegete = self;
    NSString* urlStr = _images[indexPath.item];
    NSURL* url = nil;
    if ([urlStr containsString:@"http"]) {
        url = [NSURL URLWithString:urlStr];
    }
//    else{
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Test,urlStr]];
//        NSLog(@"url-------->>>>>>%@",url);
//    }
    //    NSURL* url = [NSURL URLWithString:urlStr];
    cell.scrollowView.zoomScale = 1.0f;
    SDImageCache* imageCache = [SDImageCache sharedImageCache];
    //从缓存中找大图
    NSArray* arr = _images;
    NSString* originImageKey = arr[indexPath.item];
    UIImage* originImage = [imageCache imageFromMemoryCacheForKey:originImageKey];
    if (originImage)
    {
        cell.imageView.image = originImage;
        //重新计算 imageView 和 scrollowView 的 frame
        [self updateFrameWith:cell WithImage:originImage];
    }else
    {
        //如果不存在去沙盒中找
        originImage = [imageCache imageFromDiskCacheForKey:originImageKey];
        if (originImage)
        {
            cell.imageView.image = originImage;
            [self updateFrameWith:cell WithImage:originImage];
        }else
        {
            UIImage* placholderImage = nil;
            NSString* thumbnailImageKey = _images[indexPath.item];
            UIImage* thumbnailImage = [imageCache imageFromMemoryCacheForKey:thumbnailImageKey];
            if (thumbnailImage)
            {
                placholderImage = thumbnailImage;
            }else
            {
                thumbnailImage = [imageCache imageFromDiskCacheForKey:thumbnailImageKey];
                if (thumbnailImage)
                {
                    placholderImage = thumbnailImage;
                }else
                {
                    placholderImage = [UIImage imageNamed:@"分类详情零食精选默认图"];
                }
            }
            cell.scrollowView.maximumZoomScale = 1.0f;
            cell.scrollowView.minimumZoomScale = 1.0f;
            __weak typeof(self) weakSelf = self;
            __weak typeof(cell) weakCell = cell;
            [cell.imageView sd_setImageWithURL:url placeholderImage:placholderImage options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [weakSelf updateFrameWith:weakCell WithImage:image];
            }];
            
        }
    }
    return cell;
}
#pragma mark  代理传过来的单机手势
-(void)textAndImageView:(photoAlbumCollectionViewCell *)item didTapWithImageView:(UIImageView *)imageView{
//    NSLog(@"执行了单机操作");
//        [self dismissViewControllerAnimated:NO completion:^{
//
//        }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(imageViewController:willDidDissImageViewFrame:with:)])
    {
        //获得点击的 item 的 cell 的 indexPath
//        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:self.pageIndex inSection:0];
        NSIndexPath* indexPath = [_collectionView indexPathForCell:item];
        
        //通过 cell 的 indexPath 找到 cell
//        photoAlbumCollectionViewCell* cell = (photoAlbumCollectionViewCell* )[_collectionView cellForItemAtIndexPath:indexPath];
        
        //获得点击的 imageView 的 Frame
        CGRect frame = item.imageView.frame;
        
//        NSURL* url = [NSURL URLWithString:self.images[self.pageIndex]];
        NSURL* url = [NSURL URLWithString:self.images[indexPath.item]];

        self.pageIndex = indexPath.item;
        
        [_delegate imageViewController:self willDidDissImageViewFrame:frame with:url];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        if (self->_delegate && [self->_delegate respondsToSelector:@selector(didDismissImageViewController:)])
        {
            [self->_delegate didDismissImageViewController:self];
        }
        
        
    }];
    
//    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark  代理传过来的长按手势
-(void)textAndImageView:(photoAlbumCollectionViewCell *)item didLongPressWithImageView:(UIImageView *)imageView WithPoint:(CGPoint)point{
    if ([self isFirstResponder])
    {
        
        
    }else
    {
        [self becomeFirstResponder];
    }
    _saveImageView = imageView;
    UIMenuItem* saveItem = [[UIMenuItem alloc]initWithTitle:@"保存" action:@selector(saveImage:)];
    UIMenuItem* shareItem = [[UIMenuItem alloc]initWithTitle:@"分享" action:@selector(shareImage:)];
    UIMenuController* menuController = [[UIMenuController alloc]init];
    menuController.menuItems = @[saveItem,shareItem];
    //    [menuController setTargetRect:CGRectMake(imageView.center.x, imageView.center.y, 10, 10) inView:imageView];
    [menuController setTargetRect:CGRectMake(point.x, point.y, 10, 10) inView:imageView];
    [menuController setMenuVisible:YES animated:YES];
    
}
-(void)saveImage:(id)sender{
    //保存的时候可能需要一些时间，为了防止阻塞主线程，把寸照片这个任务放入分线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UIImage* image = _saveImageView.image;
        
        UIImageWriteToSavedPhotosAlbum(image,self , @selector(image: didFinishSavingWithError:contextInfo:), nil);
        
        
    });
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (error) {
        
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"保存图片到相册" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
#pragma mark ----------  scrollowView滑动停止后调用的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger pageIndex = scrollView.contentOffset.x/scrollView.frame.size.width ;
    
    _pageNumLabel.text = [NSString stringWithFormat:@"%ld / %ld",pageIndex+1,_images.count];
    
}

#pragma mark ---------- 通过返回的图片的大小计算 scrollowView 的大小
-(void)updateFrameWith:(photoAlbumCollectionViewCell* )cell WithImage:(UIImage*)image
{
    NSLog(@"image---->>>%@",image);
    cell.scrollowView.maximumZoomScale = 3.0f;
    cell.scrollowView.minimumZoomScale = 1.0f;
    //获得图片的大小
    CGSize imageSize = image.size;
    //对图片的大小进行等比例缩放，要么和屏幕等宽，要么和屏幕等高
    //图片的宽高比
    CGFloat imageScale = imageSize.width/imageSize.height;
    //获得屏幕的宽高比
    CGFloat screenScale = self.view.frame.size.width/self.view.frame.size.height;
    //等比例缩放后的大小
    CGSize newImageSize = CGSizeZero;
    if (imageScale > screenScale)
    {
        //高度相等时 图片的宽度大 所以图片的宽要和屏幕的宽相等
        newImageSize.width = self.view.frame.size.width;
        newImageSize.height = self.view.frame.size.width/imageScale;
    }else
    {
        //宽度相等时，图片的高度大
        //要等高
        newImageSize.height = self.view.frame.size.height;
        newImageSize.width = self.view.frame.size.height * imageScale;
    }
    //    if ([self.postsId containsString:@"http"]) {
    //        //获取 cell.imageView 的大小保持和 imageSize 一致
    //        CGRect frame = cell.imageView.frame;
    //        frame.size = newImageSize;
    //        cell.imageView.frame = frame;
    //    }
    
    //获取 cell.imageView 的大小保持和 imageSize 一致
    if (image != nil) {
        CGRect frame = cell.imageView.frame;
        frame.size = newImageSize;
        cell.imageView.frame = frame;
    }
    
    
    
    //同步修改 scrollowView 的 frame
    cell.scrollowView.frame = cell.imageView.frame;
    //把 scrollowView 放在屏幕的中心
    cell.scrollowView.center = self.view.center;
    //修改 scrollowView 的 contentSize 处理重用
    cell.scrollowView.contentSize = newImageSize;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
