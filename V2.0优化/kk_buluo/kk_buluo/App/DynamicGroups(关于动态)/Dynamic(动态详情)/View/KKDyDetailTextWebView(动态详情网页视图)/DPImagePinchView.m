//
//  DPImagePinchView.m
//  JCZJ
//
//  Created by sunny_ios on 16/3/28.
//  Copyright © 2016年 apple. All rights reserved.
//
#import "AppDelegate.h"
#import "DPImagePinchView.h"
//#import "SubmitView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDWebImageManager.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation DPImagePinchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.minimumZoomScale = 0.5;
        self.maximumZoomScale = 2;
        self.bounces = NO;
        self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

//让图片居中
- (void)scrollViewDidZoom:(UIScrollView *)aScrollView {
    CGFloat offsetX = (aScrollView.bounds.size.width > aScrollView.contentSize.width) ? (aScrollView.bounds.size.width - aScrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (aScrollView.bounds.size.height > aScrollView.contentSize.height) ? (aScrollView.bounds.size.height - aScrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(aScrollView.contentSize.width * 0.5 + offsetX,
                                        aScrollView.contentSize.height * 0.5 + offsetY);
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];

        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

@end

static NSString *const reuseIdentifier = @"browserCell";

//collectionCell
@interface DPImgShowCollectCell : UICollectionViewCell

@property (nonatomic, strong) DPImagePinchView *imageScrollView;


@end

@implementation DPImgShowCollectCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageScrollView];
    }
    return self;
}
- (UIView *)creteateMaskView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    return view;
}

- (DPImagePinchView *)imageScrollView {
    if (_imageScrollView == nil) {
        _imageScrollView = [[DPImagePinchView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.frame))];
    }
    return _imageScrollView;
}

@end

@interface DPImageShowViewControl () <UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate> {
    UICollectionView *_collectionView;
    NSInteger _selectCount;
}
@property (nonatomic, strong) UIButton *confrimButton;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *imageUrlsArray;
@property (nonatomic, strong) UIPageControl *pageContol;
@property (nonatomic, assign) BOOL _isEndable;


@end

@implementation DPImageShowViewControl

- (instancetype)initWitImageUrlStrs:(NSArray *)urls currentIndex:(NSInteger)curIndex {
    self = [super init];
    if (self) {
        self.imageUrlsArray = urls;
        self.currentIndex = curIndex;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createCollectionView];
    [self createBottomView];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)]];
    
    //    [_collectionView scrollRectToVisible:CGRectMake(self.currentIndex*CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) animated:YES];
}

- (void)dissMissView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)createCollectionView {
    //flowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.view.frame) - 20);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[DPImgShowCollectCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.delegate = self;
    _collectionView.bounces = NO;
    _collectionView.dataSource = self;

    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}

- (void)createBottomView {
    UIView *backView = [[UIView alloc] init];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];

    [backView addSubview:self.confrimButton];
    
    [self.confrimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(13);
        make.bottom.equalTo(backView.mas_bottom).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(35);
    }];
    [backView addSubview:self.pageContol];
    [self.pageContol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(backView.mas_bottom).offset(-10);
    }];
}

#pragma mark -

- (UIPageControl *)pageContol {
    if (_pageContol == nil) {
        _pageContol = [[UIPageControl alloc] init];
        _pageContol.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageContol.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageContol.numberOfPages = self.imageUrlsArray.count;
        _pageContol.currentPage = 0;
    }

    return _pageContol;
}

- (UIButton *)confrimButton {
    if (_confrimButton == nil) {
        _confrimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confrimButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_confrimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confrimButton.layer.masksToBounds = YES;
        _confrimButton.layer.cornerRadius = 4;
        _confrimButton.layer.borderWidth = 1;
        _confrimButton.layer.borderColor =RGB(102, 102, 102).CGColor;
        [_confrimButton setTitle:@"保存" forState:(UIControlStateNormal)];
        _confrimButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confrimButton addTarget:self action:@selector(pvt_confirm) forControlEvents:UIControlEventTouchUpInside];
    }

    return _confrimButton;
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    self.pageContol.currentPage = currentIndex;
}

#pragma mark - 响应事件
- (void)pvt_confirm {
     BBLOG (@"保存图片");
    
    if (!self._isEndable) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{  
        DPImgShowCollectCell *cell = (DPImgShowCollectCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
        UIImageView *imgView = cell.imageScrollView.imageView;
        
        UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
        
        
    });
}
- (void)saveGifData:(NSData *)data toGroup:(ALAssetsGroup *)group inLibrary:(ALAssetsLibrary *)library
{
    NSDictionary *metadata = @{@"UTI":(__bridge NSString *)kUTTypeGIF};
    // 开始写数据
    [library writeImageDataToSavedPhotosAlbum:data metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if (error) {
            BBLOG (@"写数据失败：%@",error);
        }else{
            
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                BBLOG (@"成功保存到相册");
                
                if ([group isEditable]) {
                    [group addAsset:asset];
                }else{
                    BBLOG (@"系统gif相册不可编辑或者为nil");
                }
                
            } failureBlock:^(NSError *error) {
                BBLOG (@"gif保存到的ALAsset有问题, URL：%@，err:%@",assetURL,error);
            }];
        }
    }];
}
/**
 判断图片类型

 @param data 图片的data
 @return 图片类型String
 */
- (NSString *)contentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
        case 0x52:
            
            if ([data length] < 12) {
                
                return nil;
                
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                
                return @"webp";
                
            }
            
            return nil;
            
    }
    
    return nil;
    
}
- (void)imageSavedToPhotosAlbum:(NSString *)imageUrl didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
//        SubmitView *submitView = [[SubmitView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_HEIGHT / 2 - 80, 160, 120)];
//        submitView.backgroundColor = [UIColor clearColor];
//        submitView.myImageType = CheckMark;
//        submitView.textString = @"保存图片成功";
//        [self.view.window addSubview:submitView];
         [CC_NoticeView showError:@"保存图片成功"];
    }else{
        
//        SubmitView *submitView = [[SubmitView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_HEIGHT / 2 - 80, 160, 120)];
//        submitView.backgroundColor = [UIColor clearColor];
//        submitView.myImageType = CheckMark;
//        submitView.textString = @"保存图片失败";
//        [self.view.window addSubview:submitView];
         [CC_NoticeView showError:@"保存图片失败"];
    }
}


#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrlsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DPImgShowCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blackColor];
    self._isEndable = NO;
//    [self.confrimButton setTitleColor:RGB(88, 88, 88) forState:(UIControlStateNormal)];

    //下载图片显示图片[]
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.imageUrlsArray[indexPath.row]] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        if (image) {
            cell.imageScrollView.imageView.image = image;
        }else
        {
            cell.imageScrollView.imageView.image = [UIImage imageNamed:@"crash_noImage_placholder"];
        }
        CGFloat scale = image.size.height / image.size.width;
        
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(cell.imageScrollView.bounds), 0);
        frame.size.height = MIN(scale * CGRectGetWidth(cell.imageScrollView.bounds), CGRectGetHeight(cell.imageScrollView.bounds));
        cell.imageScrollView.imageView.frame = frame;
        cell.imageScrollView.imageView.center = cell.imageScrollView.center;
        cell.imageScrollView.contentSize = cell.imageScrollView.imageView.frame.size;
        self._isEndable = YES;
        
    }] ;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    DPImgShowCollectCell *curCell = (DPImgShowCollectCell *)cell;
    [curCell.imageScrollView setZoomScale:1.0 animated:NO];
    [curCell.imageScrollView setNeedsLayout];
    [curCell.imageScrollView layoutIfNeeded];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    if (index < 0) return;
    self.currentIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
