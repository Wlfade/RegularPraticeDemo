//
//  ViewController.m
//  LQPhotoAlbun
//
//  Created by liang lee on 2018/5/9.
//  Copyright © 2018年 liang lee. All rights reserved.
//

#import "ViewController.h"
#import "PhotoListTableViewCell.h"
#import "photoAlbumViewController.h"
#import <UIImageView+WebCache.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,photoAlbumTableViewCellDelegate,photoAlbumViewControllerDelegate>{
    
    UIImageView* _animatedImageView;
    
}

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *images;



@end

@implementation ViewController
static NSString *photoCell = @"photoCell";

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _images = @[@[@"http://img.qqzhi.com/upload/img_5_4011309990D1817634495_23.jpg",@"http://pic1.win4000.com/wallpaper/b/5823dc001bfde.jpg"],@[@"http://p2.wmpic.me/article/2016/01/12/1452566782_AIoOVeHR.jpg",@"http://p1.wmpic.me/article/2015/11/12/1447308864_qHlcsxOv.jpg",@"http://img4.duitang.com/uploads/item/201504/26/201504260244_zQdjc.thumb.700_0.jpeg"],@[@"http://img.sc115.com/uploads/ps/sheyingj/8809071116114.jpg",@"http://img.tukexw.com/img/30c24c4b6a2aaf8a.jpg",@"http://p1.wmpic.me/article/2015/04/15/1429060113_DqxTINBz.jpg"],@[@"http://img3.duitang.com/uploads/item/201607/10/20160710082611_ZQndX.thumb.700_0.jpeg",@"http://uploadfile.bizhizu.cn/2015/0512/20150512045835466.jpg"],@[@"http://ppt.downhot.com/d/file/p/2014/06/06/6919c18d7e1ebdb4a1512722fb2c57c5.jpg",@"http://img1.3lian.com/2015/a1/17/d/162.jpg"],@[@"http://pic1.win4000.com/wallpaper/2018-01-09/5a5439699c5fa.jpg",@"http://pic1.win4000.com/wallpaper/2018-01-09/5a543973bc4a9.jpg"],@[@"http://img3.duitang.com/uploads/item/201601/30/20160130002330_YThmk.jpeg",@"http://up.qqjia.com/z/10/tu12365_10.jpg",@"http://img.qqzhi.com/upload/img_1_3888069022D4045351399_23.jpg"]];
    [self.tableView registerClass:[PhotoListTableViewCell class] forCellReuseIdentifier:photoCell];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _images.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NSArray *subviews = cell.contentView.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    NSArray *array = _images[indexPath.row];
    [cell setUIWithArray:array];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20 + ([UIScreen mainScreen].bounds.size.width - 20*2 - 15*2)/3;
}



-(void)didSelectedImageViewOnCell:(PhotoListTableViewCell *)cell withImageView:(UIImageView *)imageView{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    photoAlbumViewController *photoVC = [[photoAlbumViewController alloc]init];
    photoVC.delegate = self;
    photoVC.images = _images[indexPath.row];
    photoVC.pageIndex = imageView.tag - 10086;
    photoVC.imageViewTag = imageView.tag;
    
    NSMutableArray* framesArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //获取装着所有 imageView 的数组
    NSArray* subviewArr = imageView.superview.subviews;
    photoVC.imageViewArr = subviewArr;
    //遍历这个数组
    for (UIView* view in subviewArr)
    {
        //把 view 的坐标从它的坐标系从父视图移动到 Window
        CGRect frame = [self.view.window convertRect:view.frame fromView:view.superview];
        
        //把 CGRect 类型的数据存到数组中需要转化成 NSValue 类型
        NSValue* frameValue = [NSValue valueWithCGRect:frame];
        
        //把这些 imageView 的 frame放入数组
        [framesArr addObject:frameValue];
        
    }
    
    photoVC.frameArr = framesArr;
    [self presentViewController:photoVC animated:NO completion:nil];
}


-(void)imageViewController:(photoAlbumViewController *)imageViewController willDidDissImageViewFrame:(CGRect)frame with:(NSURL *)url
{
    
    _animatedImageView = [[UIImageView alloc]initWithFrame:frame];
    [_animatedImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _animatedImageView.contentMode =  UIViewContentModeScaleAspectFill;
    _animatedImageView.clipsToBounds  = YES;
    _animatedImageView.center = self.view.center;
    [_animatedImageView sd_setImageWithURL:url];
    
    [self.view addSubview:_animatedImageView];
    
    
}

-(void)didDismissImageViewController:(photoAlbumViewController *)imageViewController
{
    
    [UIView animateWithDuration:0.35 animations:^{
        //将imageView的位置缩放回原来的位置
        for (UIImageView *imgV in imageViewController.imageViewArr) {
            if (imgV.tag - 10086 == imageViewController.pageIndex) {
                imgV.hidden = YES;
            }else{
                imgV.hidden = NO;
            }
        }
        self->_animatedImageView.frame = [imageViewController.frameArr[imageViewController.pageIndex] CGRectValue];
        
        
    } completion:^(BOOL finished) {
        //完成动画后，移除做动画的imageView
        [self->_animatedImageView removeFromSuperview];
        for (UIImageView *imgV in imageViewController.imageViewArr) {
            
                imgV.hidden = NO;
        }
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
