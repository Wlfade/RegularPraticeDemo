//
//  DGImageSelectVC.m
//  DGImagePicker
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGImagePreviewVC.h"
#import "DGImageSelectVC.h"
#import "DGImageClipVC.h"
//view
#import "DGToast.h"
#import "DGAssetsGroupListTableViewCell.h"
#import "DGAssetsListCollectionViewCell.h"
//tool
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "DGIP_Header.h"

#pragma mark - 相机CameraCell
@interface DGCameraCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *cameraImage;
@end

#define kImageMaxW 750.0f
#define kScreenW       ([UIScreen mainScreen].bounds.size.width)
#define kScreenH       ([UIScreen mainScreen].bounds.size.height)

@implementation DGCameraCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DGIP_COLOR_GRAY;
        [self.contentView addSubview:self.cameraImage];
    }
    return self;
}

- (UIImageView *)cameraImage {
    if (_cameraImage == nil) {
        _cameraImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _cameraImage.image = [UIImage imageNamed:@"dgip_camera.png"];
        _cameraImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cameraImage;
}
@end


#pragma mark - DGImageSelectVC
@interface DGImageSelectVC ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UITableViewDataSource,
UITableViewDelegate>{
    CGFloat _bottomViewHeight;
}

//展示相册list
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic,assign) NSInteger assetsGroupIndex;

//展示图片list
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *assets;
//选中的图片对应的index
@property (nonatomic, strong) NSMutableSet *selectedIndexSet;

//navi
@property (nonatomic, strong) UIButton *naviCancelItem;
@property (nonatomic, strong) UIButton *naviTitleItem;

//bottom
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIButton *previewButton;

@end

static NSString *const kCellIdentifier = @"CellId";
static NSString *const kCameraCellIdentifier = @"CameraCellId";

@implementation DGImageSelectVC
#pragma mark - lazy load
-(NSMutableSet *)selectedIndexSet {
    if (!_selectedIndexSet) {
        _selectedIndexSet = [NSMutableSet set];
    }
    return _selectedIndexSet;
}

-(NSMutableArray *)assets {
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

#pragma mark - life circel
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.assetsGroupIndex = 0;
    [self setupDimension];
    [self setupUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    [self.confirmButton setTitle:[NSString stringWithFormat:@"完成(%zd)", self.selectedIndexSet.count] forState:UIControlStateNormal];
}

#pragma mark - setter
- (void)setAssertsGroupArray:(NSArray *)assertsGroupArray {
    _assertsGroupArray = assertsGroupArray;
    
    if (assertsGroupArray.count > _assetsGroupIndex) {
        self.assetsGroup = _assertsGroupArray[_assetsGroupIndex];
    } else {
        [self.assets removeAllObjects];
    }
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup {
    _assetsGroup = assetsGroup;
    
    //1.清空
    [self.assets removeAllObjects];
    
    //2.设置NaviTitle
    NSString *title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self updataNaviTitle:title];
    
    //3.Load assets
    //3.1  设置assets filter
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    //3.2 Load
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            
            if ([type isEqualToString:ALAssetTypePhoto]) {
                result.isSelected = [self isHaveTheAsset:result];
                [self.assets addObject:result];
            }
        }
    }];
    
    //4.刷新collectionView
    [self.collectionView reloadData];
}

#pragma mark - statusBar
-(BOOL)shouldAutorotate {
    return NO;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - UI
-(void)setupDimension {
    _bottomViewHeight = self.needClip ? 0 : 44 + DGIP_HOME_INDICATOR_HEIGHT;
}

/** 设置UI */
-(void)setupUI {
    self.tabBarController.tabBar.hidden = YES;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupNavi];
    [self setupBottomView];
    [self setupCollectionView];
    [self setupTableView];
}

/** 设置Navi */
-(void)setupNavi {
    
    UIColor *naviTintColor = self.navigationController.navigationBar.tintColor;
    
    //1.title
    UIButton *titleBtn = [[UIButton alloc]init];
    self.naviTitleItem = titleBtn;
    titleBtn.backgroundColor = UIColor.clearColor;
    UIFont *titleFont = [UIFont systemFontOfSize:18];
    titleBtn.titleLabel.font = titleFont;
    titleBtn.selected = NO;
    [titleBtn setImage:[UIImage imageNamed:@"dgip_navi_down"] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"dgip_navi_up"] forState:UIControlStateSelected];
    [titleBtn setTitleColor:naviTintColor forState:UIControlStateNormal];
    NSString *title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self updataNaviTitle:title];
    
    [titleBtn addTarget:self action:@selector(clickNaviTitleItem:) forControlEvents:UIControlEventTouchUpInside];
    
    //2.cancel
    self.naviCancelItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.naviCancelItem.frame = CGRectMake(0, 0, 45, 30);
    [self.naviCancelItem setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.naviCancelItem setTitleColor:naviTintColor forState:UIControlStateNormal];
    [self.naviCancelItem addTarget:self action:@selector(clickNaviCancelItem:) forControlEvents:(UIControlEventTouchUpInside)];
    self.naviCancelItem.hidden = YES;
    
    UIBarButtonItem *topCancelItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviCancelItem];
    self.navigationItem.rightBarButtonItem = topCancelItem;
    
    //3.back
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"dgip_navi_back_black"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(clickNaviCancelItem:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

/** 更新naviTitle */
-(void)updataNaviTitle:(NSString *)title {
    
    //1.改title
    [self.naviTitleItem setTitle:title forState:UIControlStateNormal];
    
    //2.改frame和EdgeInsets
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
    CGFloat indicatorImgW = [UIImage imageNamed:@"dgip_navi_up"].size.width+2;
    CGFloat titleW = [title boundingRectWithSize:CGSizeMake(200, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
    
    self.naviTitleItem.frame = CGRectMake(0, 0, titleW+indicatorImgW, 30);
    self.naviTitleItem.titleEdgeInsets = UIEdgeInsetsMake(0, -indicatorImgW, 0, indicatorImgW);
    self.naviTitleItem.imageEdgeInsets = UIEdgeInsetsMake(0, titleW, 0, 0);
    
    //3.重新设置navigationItem.titleView
    self.navigationItem.titleView = nil;
    self.navigationItem.titleView = self.naviTitleItem;
}


/** 更新 previewButton状态,confirmButton的title */
-(void)updatePreviewButtonStatusAndConfirmButtonTitle {
    [self.confirmButton setTitle:[NSString stringWithFormat:@"完成(%zd)", self.selectedIndexSet.count] forState:UIControlStateNormal];
    self.previewButton.enabled = self.selectedIndexSet.count;
}

/** 设置CollectionView */
-(void)setupCollectionView {
    //1.layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((DGIP_SCREEN_W - 20) / 3.0, (DGIP_SCREEN_W - 20) / 3.0);
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //2.clollctionV
    CGFloat collectionViewH = DGIP_SCREEN_H - DGIP_STATUS_AND_NAVI_BAR_HEIGHT - _bottomViewHeight;
    
    //y设为0
    //DGImagePickerManager中添加naviC.navigationBar.translucent = NO;后做的适配
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DGIP_SCREEN_W, collectionViewH) collectionViewLayout:layout];
    self.collectionView = collectionV;
    [self.view addSubview:collectionV];
    
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.alwaysBounceVertical = YES;
    collectionV.backgroundColor = UIColor.whiteColor;
    
    [collectionV registerClass:[DGAssetsListCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [collectionV registerClass:[DGCameraCell class] forCellWithReuseIdentifier:kCameraCellIdentifier];
    
    
}


/** 设置tableView */
-(void)setupTableView {
    //1.创建
    CGFloat height = DGIP_SCREEN_H - DGIP_STATUS_AND_NAVI_BAR_HEIGHT - DGIP_HOME_INDICATOR_HEIGHT;
    
    //y设为0
    //DGImagePickerManager中添加naviC.navigationBar.translucent = NO;后做的适配
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DGIP_SCREEN_W, height) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.hidden = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/** 设置BottomView */
- (void)setupBottomView {
    
    
    //1.bottomView
    //多减去DGIP_STATUS_AND_NAVI_BAR_HEIGHT
    //DGImagePickerManager中添加naviC.navigationBar.translucent = NO;后做的适配
    CGFloat y = DGIP_SCREEN_H - _bottomViewHeight-DGIP_STATUS_AND_NAVI_BAR_HEIGHT;
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, y, DGIP_SCREEN_W, _bottomViewHeight)];
    self.bottomView = bottomV;
    [self.view addSubview:bottomV];
    
    bottomV.backgroundColor =[UIColor colorWithWhite:1 alpha:0.9];
    bottomV.clipsToBounds = YES;

    //2.预览
    CGFloat showBtnH = 44;//等于非iphoneX下的bottomV的高
    CGFloat showBtnW = 60;
    UIButton *showBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, showBtnW, showBtnH)];
    self.previewButton = showBtn;
    [bottomV addSubview:showBtn];
    
    showBtn.enabled = NO;
    [showBtn setTitle:@"预览  " forState:UIControlStateNormal];
    showBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [showBtn setTitleColor:DGIP_COLOR_NAVI forState:UIControlStateNormal];
    [showBtn setTitleColor:UIColor.grayColor forState:UIControlStateDisabled];
    [showBtn addTarget:self action:@selector(clickPreviewButton:) forControlEvents:UIControlEventTouchUpInside];

    //3.完成
    CGFloat sureBtnW = 68;
    CGFloat sureBtnH = 28;
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(DGIP_SCREEN_W-sureBtnW-5, (showBtnH-sureBtnH)/2.0, sureBtnW, sureBtnH)];
    self.confirmButton = sureBtn;
    [bottomV addSubview:sureBtn];
    
    sureBtn.backgroundColor = DGIP_COLOR_NAVI;
    [sureBtn setTitle:@"完成()" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    
    [sureBtn addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - interacton
#pragma mark navi
/** 点击naviTitle 选择图片类型 */
- (void)clickNaviTitleItem:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tableView.hidden = !sender.selected;
}

/** 点击naviCancelItem */
- (void)clickNaviCancelItem:(id)sender {
    if (!self.tableView.hidden) {
        self.naviTitleItem.selected = NO;
        self.tableView.hidden = YES;
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if (self.finishHandler) {
        self.finishHandler(YES, NO, nil);
    }
}

#pragma mark bottomView
/** 点击完成按钮 */
- (void)clickConfirmButton:(id)sender {
    
    if (self.finishHandler) {
        self.finishHandler(NO, NO, [self.selectedIndexSet allObjects]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 点击预览按钮 */
- (void)clickPreviewButton:(UIButton *)sender {
    
    //1.创建previewVC
    DGImagePreviewVC *previewVC = [[DGImagePreviewVC alloc] init];
    
    //2.设置属性
    previewVC.isAssetPreview = YES;
    previewVC.assetArray = [self.selectedIndexSet allObjects];
    
    //3.设置选中状态block
    //previewVC中asset选状态切换时,调整selectedVC的asset选中
    DGIP_WeakS(weakSelf);
    previewVC.selectBlock = ^(ALAsset *curAssert, BOOL isSelect) {
        //3.1 选中,当前selectedIndexSet没有 => 添加
        if (isSelect && ![weakSelf isHaveTheAsset:curAssert]) {
            [weakSelf.selectedIndexSet addObject:curAssert];
        
        //3.2 没选中,当前selectedIndexSet有 => 删除
        } else if (!isSelect && [weakSelf isHaveTheAsset:curAssert]) {
            [weakSelf removeAssetWithAsset:curAssert];
        }
    };
    
    //3.设置选择完成block
    previewVC.finishBlock = ^{
        [weakSelf clickConfirmButton:nil];
    };
    
    //4.跳转
    [self.navigationController pushViewController:previewVC animated:YES];
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assertsGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentify = @"cellIdentify";
    NSInteger row = indexPath.row;

    //1.获取cell
    DGAssetsGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[DGAssetsGroupListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =
            cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.65];
    }

    //2.获取相册
    ALAssetsGroup *assertsGroup = (ALAssetsGroup *)self.assertsGroupArray[row];
    [assertsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];

    NSString *assertName = [assertsGroup valueForProperty:ALAssetsGroupPropertyName];
    NSInteger count = [assertsGroup numberOfAssets];
    
    //3.设置cell
    cell.titleLabel.text = [NSString stringWithFormat:@"%@(%zd)", assertName, count];
    cell.iconView.image = [UIImage imageWithCGImage:assertsGroup.posterImage];
    cell.selectBtn.hidden = row != self.assetsGroupIndex;
    
    //4.return
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.调整tableView
    self.naviTitleItem.selected = NO;
    [self.tableView reloadData];
    tableView.hidden = YES;
    
    //2.更新collectionV所需的数据
    self.assetsGroupIndex = indexPath.row;
    self.assetsGroup = self.assertsGroupArray[self.assetsGroupIndex];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {

        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    //1.照相机cell
    if ( row == 0) {
        DGCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCameraCellIdentifier forIndexPath:indexPath];
        return cell;
    }

    //2.CollectionViewCell
    DGAssetsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];

    ALAsset *curAsset = [self.assets objectAtIndex: row-1];
    cell.asset = curAsset;
    cell.hasBeenSelected = curAsset.isSelected;
    cell.checkmarkHidden = self.needClip;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    //1.相机cell
    if (row == 0) {
        [self presentToCamera];
        return;
    }

    //2.CollectionViewCell
    DGAssetsListCollectionViewCell *cell = (DGAssetsListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    ALAsset *curAsset = [self.assets objectAtIndex:row-1];

    //2.1 需要裁剪
    if (self.needClip) {
        DGIP_WeakS(weakSelf);
        [ALAsset getorignalImage:curAsset completion:^(UIImage *image) {
            [weakSelf pushToImageClipVC:image];
        }];
        return;
    }

    //2.2 选图
    //2.2.1 取消选中
    if ([self isHaveTheAsset:curAsset]) {
        [self removeAssetWithAsset:curAsset];
        cell.hasBeenSelected = NO;
        curAsset.isSelected = NO;
        [self updatePreviewButtonStatusAndConfirmButtonTitle];

    }else {//2.2.2 添加选中
        
        //2.2.2.1 超选了
        if (self.selectedIndexSet.count >= self.maxCount) {
            NSString *msg = [NSString stringWithFormat:@"您最多只能选择%zd张图片", self.maxCount];
            [DGToast showMsg:msg duration:2.0];
            return;
        }

        //2.2.2.2 未超选
        [ALAsset getorignalImage:curAsset completion:^(UIImage *image) {

            NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            NSInteger length = imageData.length;

            //2.2.2.2.1 图片过大,不处理
            if (imageData.length / (1024.0 * 1024.0) > 5.0) {
                [[DGToast makeText:@"图片大于5M"] showWithOffset:DGIP_SCREEN_H/2 - 40];
                
            } else {//2.2.2.2.2 处理选图
                [self.selectedIndexSet addObject:curAsset];
                cell.hasBeenSelected = YES;
                curAsset.isSelected = YES;
                [self updatePreviewButtonStatusAndConfirmButtonTitle];
            }
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //1.拍照,使用图片
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];

        //1.裁剪
        if (self.needClip) {
            selectImage = [self imageByScaledToMaxSize:selectImage];
            [self pushToImageClipVC:selectImage];

        } else {
            UIImage *tempImage = nil;
            if (selectImage.imageOrientation != UIImageOrientationUp) {
                UIGraphicsBeginImageContext(selectImage.size);
                [selectImage drawInRect:CGRectMake(0, 0, selectImage.size.width, selectImage.size.height)];
                tempImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            } else {
                tempImage = selectImage;
            }

            if (self.finishHandler) {
                self.finishHandler(NO, YES, @[tempImage]);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - image tool
- (UIImage *)imageByScaledToMaxSize:(UIImage *)image {
    
    //1.小于kImageMaxW, 不处理
    if (image.size.width < kImageMaxW){ return image;}
    
    //2.计算目标size
    CGFloat targetW = 0.0f;
    CGFloat targetH = 0.0f;
    if (image.size.width > image.size.height) {
        targetH = kImageMaxW;
        targetW = image.size.width * (targetH / image.size.height);
    } else {
        targetW = kImageMaxW;
        targetH = image.size.height * (targetW / image.size.width);
    }
    CGSize targetSize = CGSizeMake(targetW, targetH);
    
    //3.缩放画图
    return [self imageByScaledAndClipedForSourceImage:image targetSize:targetSize];
}

/** 对目标图片进行缩放,裁剪 */
- (UIImage *)imageByScaledAndClipedForSourceImage:(UIImage *)image targetSize:(CGSize)targetSize {
    
    //1.过滤,不需要改变的情况
    if (CGSizeEqualToSize(image.size, targetSize)){
        return image;
    }
    
    //2.要裁剪
    //2.1 准备参数
    //宽高
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGFloat targetW = targetSize.width;
    CGFloat targetH = targetSize.height;

    //缩放比例
    CGFloat wFactor = targetW / w;
    CGFloat hFactor = targetH / h;
    CGFloat scaleFactor = wFactor > hFactor ? wFactor : hFactor;
    
    //缩放后的宽高
    CGFloat scaledW = w * scaleFactor;
    CGFloat scaledH = h * scaleFactor;
    
    // center the image
    CGPoint drawPoint = CGPointMake(0.0, 0.0);
    if (wFactor > hFactor) {
        drawPoint.y = (targetH - scaledH) * 0.5;
    } else if (wFactor < hFactor) {
        drawPoint.x = (targetW - scaledW) * 0.5;
    }
    
    //2.2 绘制
    UIGraphicsBeginImageContext(targetSize);// 画布大小
    CGRect drawRect = CGRectMake(drawPoint.x, drawPoint.y, scaledW, scaledH);//贴图大小,及位置
    [image drawInRect:drawRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //2.3 return
    return newImage;
}

#pragma mark - selected操作
- (BOOL)isHaveTheAsset:(ALAsset *)asset {
    for (ALAsset *theAsset in self.selectedIndexSet) {
        if ([asset.defaultRepresentation.url isEqual:theAsset.defaultRepresentation.url]) {
            return YES;
        }
    }
    return NO;
}


- (void)removeAssetWithAsset:(ALAsset *)asset {
    
    ALAsset *theAsset;
    for (ALAsset *curAsset in self.selectedIndexSet) {
        if ([curAsset.defaultRepresentation.url isEqual:asset.defaultRepresentation.url]) {
            theAsset = curAsset;
            break;
        }
    }
    
    if (theAsset) {
        [self.selectedIndexSet removeObject:theAsset];
    }
}


#pragma mark - jump
/** 打开相机 */
-(void)presentToCamera {
    
    //1.权限过滤
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            return;
        }
    } else {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            return;
        }
    }
    
    //2.跳转相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}


-(void)pushToImageClipVC:(UIImage *)image {
    //1.创建
    DGImageClipVC *clipVC ;
    if (self.needCircle) {
        clipVC = [[DGImageClipVC alloc] initWithImage:image maxScale:3.0 rectangleSize:self.rectangleSize needCircle:YES];
    } else {
        clipVC = [[DGImageClipVC alloc] initWithImage:image  maxScale:3.0 rectangleSize:self.rectangleSize needCircle:NO];
    }
    
    //2.完成block
    DGIP_WeakS(weakSelf);
    clipVC.finishhandle = ^(DGImageClipVC *controller, UIImage *image) {
        
        //2.1处理图片
        if (weakSelf.finishHandler) {
            weakSelf.finishHandler(NO, YES, image ? [NSArray arrayWithObject:image] : nil);
        }
        
        //2.3 退出self
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    };
    
    //3.push跳转
    [self.navigationController pushViewController:clipVC animated:YES];
}

@end
