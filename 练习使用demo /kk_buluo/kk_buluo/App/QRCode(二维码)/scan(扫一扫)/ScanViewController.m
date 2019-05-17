//
//  ScanViewController.m
//  LotteryOrderSystem
//
//  Created by adu on 2018/6/20.
//  Copyright © 2018 杭州鼎代. All rights reserved.
//

#import "ScanViewController.h"
#import "KKMyQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

//#import "LCQRCodeUtil.h"
#import "ZBarReaderController.h"
#import "KKQRCodeInforTool.h"

#define kScreenW     ([UIScreen mainScreen].bounds.size.width)
#define kScreenH     ([UIScreen mainScreen].bounds.size.height)
#define kNaviBarH    (44.0f)
#define kStatusBarH  (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat _cornerlineL;//扫描4个角画线的线长
    CGFloat _cornerlineW;//扫描4个角画线的线宽
    
    CGRect _scanRect;
    CGFloat _scanRectW;//扫描正方形的边长
    CGFloat _leftCornerX;//扫描框 左侧转角的x坐标
    CGFloat _rightCornerX;     //右侧转角的x坐标
    CGFloat _topCornerY;       //顶部转角的y坐标
    CGFloat _bottomCornerY;    //底部转角的y坐标
    
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) NSTimer* lineTimer;

@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIImageView* lineImgV;
@property (nonatomic,strong) UIButton* torchBtn;

@end

@implementation ScanViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setDimension];
    [self setupNavi];
    [self setupScanView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startTimerAndScan];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self stopTimerAndScan];
}

#pragma mark - request





#pragma mark - UI
-(void)setDimension {
    
    CGFloat scale = kScreenW/375.0;
    _cornerlineL = 10 * scale;
    _cornerlineW = 3 * scale;
    
    _scanRectW = kScreenW-100;
    _leftCornerX = (kScreenW - _scanRectW)/2;
    _rightCornerX = (kScreenW - _scanRectW)/2 + _scanRectW;
    _topCornerY = (kScreenH-(kStatusBarH+kNaviBarH)-_scanRectW)/2;
    _bottomCornerY = (kScreenH-(kStatusBarH+kNaviBarH)-_scanRectW)/2 + _scanRectW;
    _scanRect = CGRectMake(_leftCornerX, _topCornerY, _scanRectW, _scanRectW);
}

-(void)setupNavi {
    //1.naviV
    UIView *naviV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kStatusBarH + kNaviBarH )];
    naviV.backgroundColor = UIColor.grayColor;
    [self.view addSubview:naviV];
    
    //2.backBtn
    CGFloat backBtnH = 44;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kStatusBarH+(kNaviBarH-backBtnH)/2.0, 20, backBtnH)];
    [backBtn setImage:[UIImage imageNamed:@"scan_leftArrow"]forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [naviV addSubview:backBtn];
    
    //3.title
    CGFloat titleW = 100;
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-titleW)/2.0, kStatusBarH, titleW, kNaviBarH)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:19];
    titleL.text = @"扫码";
    [naviV addSubview:titleL];
    
    //4.right 相册
    CGFloat photosBtnH = kNaviBarH;
    UIButton *photosBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW-60, kStatusBarH, 50, photosBtnH)];
    [photosBtn setTitle:@"相册" forState:UIControlStateNormal];
    [photosBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [photosBtn addTarget:self action:@selector(clickPhotosButton:) forControlEvents:UIControlEventTouchUpInside];
    [naviV addSubview:photosBtn];
}

-(void)setupScanView {
    
    //1.扫描边框
    [self drawCorner];
    
    //2.扫描线
    [self drawSpinLine];
    
    //3.裁剪框(相当于蒙板)
    [self setupCropRect:_scanRect];
    
    //4.二维码图片
    self.photoImageView = [[UIImageView alloc] initWithFrame:_scanRect];
    //photoImageView.hidden = YES;
    [self.view addSubview:self.photoImageView];
    
    //5.手电筒
    CGFloat torchBtnH = 24 * (kScreenW/375);
    self.torchBtn = [[UIButton alloc]init];
    self.torchBtn.center = CGPointMake(kScreenW/2.0, _bottomCornerY - torchBtnH);
    self.torchBtn.bounds = CGRectMake(0, 0, torchBtnH, torchBtnH);
    [self.torchBtn setImage:[UIImage imageNamed:@"scan_flashLight_off"] forState:UIControlStateNormal];
    [self.torchBtn setImage:[UIImage imageNamed:@"scan_flashLight_on"] forState:UIControlStateSelected];
    [self.torchBtn addTarget:self action:@selector(clickTorchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.torchBtn];
    
    //6.提示
    CGFloat reminderOriginY = _scanRect.origin.y + _scanRect.size.height + 20;
    CGFloat reminderOriginX = _scanRect.origin.x;
    UILabel *reminderL = [[UILabel alloc]initWithFrame:CGRectMake(reminderOriginX, reminderOriginY, kScreenW-2*reminderOriginX, 20)];
    reminderL.font = [UIFont systemFontOfSize:13];
    reminderL.textColor = UIColor.whiteColor;
    reminderL.textAlignment = NSTextAlignmentCenter;
    reminderL.text = @"将二维码放入框内，即可自动扫描";
    self.reminderL = reminderL;
    [self.view addSubview:reminderL];
    
    //7.我的二维码
    CGFloat myQRCodeBtnW = 100;
    UIButton *myQRCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-myQRCodeBtnW)/2.0, CGRectGetMaxY(reminderL.frame)+15, myQRCodeBtnW, 30)];
    [myQRCodeBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
    [myQRCodeBtn setTitleColor:RGB(10, 120, 224) forState:UIControlStateNormal];
    myQRCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:myQRCodeBtn];
    [myQRCodeBtn addTarget:self action:@selector(clickMyQRCodeButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)drawCorner{
    
    //1.准备参数
    CGFloat lineL = _cornerlineL;//绘画线的长度
    CGFloat lineW = _cornerlineW;//绘画线的宽度
    CGFloat aSpace = lineW/2.0;
    
    //颜色
    CGColorRef strokeColorRef = RGB(10, 120, 224).CGColor;
    CGColorRef fillColorRef = [UIColor clearColor].CGColor;

    //2.1 左上角小图标
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    [leftTopPath moveToPoint:CGPointMake(_leftCornerX + aSpace, _topCornerY + aSpace + lineL)];
    [leftTopPath addLineToPoint:CGPointMake(_leftCornerX + aSpace, _topCornerY + aSpace)];
    [leftTopPath addLineToPoint:CGPointMake(_leftCornerX + aSpace + lineL, _topCornerY + aSpace)];
    //[leftTopPath stroke];
    
    CAShapeLayer *leftTopLayer = [CAShapeLayer layer];
    leftTopLayer.path = leftTopPath.CGPath;
    leftTopLayer.lineWidth = lineW;
    leftTopLayer.strokeColor = strokeColorRef;
    leftTopLayer.fillColor = fillColorRef;
    
    //2.2 左下角小图标
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    [leftBottomPath moveToPoint:CGPointMake(_leftCornerX + aSpace, _bottomCornerY - aSpace - lineL)];
    [leftBottomPath addLineToPoint:CGPointMake(_leftCornerX + aSpace, _bottomCornerY - aSpace)];
    [leftBottomPath addLineToPoint:CGPointMake(_leftCornerX + aSpace + lineL, _bottomCornerY - aSpace)];
    //[leftBottomPath stroke];
    
    CAShapeLayer *leftBottomLayer = [CAShapeLayer layer];
    leftBottomLayer.path = leftBottomPath.CGPath;
    leftBottomLayer.lineWidth = lineW;
    leftBottomLayer.strokeColor = strokeColorRef;
    leftBottomLayer.fillColor = fillColorRef;
    
    //2.3 右上角小图标
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    [rightTopPath moveToPoint:CGPointMake(_rightCornerX - lineL - aSpace, _topCornerY + aSpace)];
    [rightTopPath addLineToPoint:CGPointMake(_rightCornerX - aSpace, _topCornerY + aSpace)];
    [rightTopPath addLineToPoint:CGPointMake(_rightCornerX-aSpace, _topCornerY + aSpace + lineL)];
    //[rightTopPath stroke];
    
    CAShapeLayer *rightTopLayer = [CAShapeLayer layer];
    rightTopLayer.path = rightTopPath.CGPath;
    rightTopLayer.lineWidth = lineW;
    rightTopLayer.strokeColor = strokeColorRef;
    rightTopLayer.fillColor = fillColorRef;
    
    //2.4 右下角小图标
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    [rightBottomPath moveToPoint:CGPointMake(_rightCornerX - lineL - aSpace, _bottomCornerY - aSpace)];
    [rightBottomPath addLineToPoint:CGPointMake(_rightCornerX - aSpace, _bottomCornerY - aSpace)];
    [rightBottomPath addLineToPoint:CGPointMake(_rightCornerX - aSpace, _bottomCornerY - lineL - aSpace)];
    //[rightBottomPath stroke];
    
    CAShapeLayer *rightBottomLayer = [CAShapeLayer layer];
    rightBottomLayer.path = rightBottomPath.CGPath;
    rightBottomLayer.lineWidth = lineW;
    rightBottomLayer.strokeColor = strokeColorRef;
    rightBottomLayer.fillColor = fillColorRef;
    
    //3.添加layer
    [self.view.layer addSublayer:leftTopLayer];
    [self.view.layer addSublayer:leftBottomLayer];
    [self.view.layer addSublayer:rightTopLayer];
    [self.view.layer addSublayer:rightBottomLayer];
}

-(void)drawSpinLine{
 
    //1.lineImgV
    self.lineImgV = [[UIImageView alloc]initWithFrame:CGRectMake(_leftCornerX, _topCornerY, _scanRectW, 2)];
    _lineImgV.image = [UIImage imageNamed:@"scan_spinLine"];
    [self.view addSubview:_lineImgV];
}

/** 设置mask (蒙板的作用) */
- (void)setupCropRect:(CGRect)cropRect{
    
    CGFloat statusAndNaviHeight = kStatusBarH+kNaviBarH;
    CAShapeLayer *cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, CGRectMake(0, statusAndNaviHeight, kScreenW, kScreenH-statusAndNaviHeight));
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:UIColor.blackColor.CGColor];
    [cropLayer setOpacity:0.6];
    
    [cropLayer setNeedsDisplay];
    [self.view.layer addSublayer:cropLayer];
    
    
}

#pragma mark - scan and timer
-(void)startTimerAndScan {
    //1.photoImage和torchBtn处理
    self.photoImageView.image = nil;
    self.photoImageView.hidden = YES;
    self.torchBtn.hidden = NO;
    
    [self startScan];
    [self startTimer];
    [self startLineTimer];
}
    
-(void)stopTimerAndScan {
    [self stopScan];
    [self stopTimer];
    [self stopLineTimer];
}
    
#pragma mark scan
/** 设置扫描 */
- (void)setupScanCapture {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.device = device;
    
    //1.没有摄像头
    if (device==nil) {
        [self presentAlertWithTitle:@"提示" msg:@"设备没有摄像头" hasAction:NO];
        return;
    }
    
    //2.输入输出
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (self.input == nil) {
        [self presentAlertWithTitle:@"提示" msg:@"没有权限" hasAction:NO];
        return;
    }
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //3.设置扫描区域
    CGFloat top =(kStatusBarH+kNaviBarH)/kScreenW;
    CGFloat left =0;
    CGFloat width =1;
    CGFloat height = (kScreenH-(kStatusBarH+kNaviBarH))/2.0;
    ///top 与 left 互换  width 与 height 互换
    [self.output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    //4.AVCaptureSession
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
//    [self.output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    [self.output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];

    
    //5.Preview
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //6.扫描启动
    [self startScan];
}

-(void)startScan {
    //1.如果没有session
    if (!self.session) {
        [self setupScanCapture];
    }
    
    //2.开始扫描
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
}
    
-(void)stopScan {
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
}
    
#pragma mark  timer
-(void)startTimer {
    if (!self.timer.isValid || !self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:30.1 target:self selector:@selector(timerMethod) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


-(void)timerMethod{
    [self presentAlertWithTitle:@"提示" msg:@"未发现二维码" hasAction:YES];
}

#pragma mark lineTimer
-(void)startLineTimer {
    if (!self.lineTimer.isValid || !self.lineTimer) {
        self.lineTimer = [NSTimer timerWithTimeInterval:0.015 target:self selector:@selector(lineTimerMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.lineTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)stopLineTimer {
    if (self.lineTimer.isValid) {
        [self.lineTimer invalidate];
        self.lineTimer = nil;
    }
}

-(void)lineTimerMethod{
    CGRect rect = self.lineImgV.frame;
    if (rect.origin.y - _topCornerY < _scanRectW) {
        rect.origin.y += 1;
    }else{
        rect.origin.y = _topCornerY;
    }
    self.lineImgV.frame = rect;
}

#pragma mark - interaction
-(void)clickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

/** 点击相册 */
-(void)clickPhotosButton:(UIButton *)sender {
    
    //1.停止timer
    [self stopTimer];
    [self stopLineTimer];
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    //请求、检查访问权限
    //如果用户还没有做出选择、会自动弹框，用户对弹框做出选择后，才会调用block
    //如果之前已经做出选择,会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied) {
                //用户拒绝当前APP 访问权限
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    [self showAlertMessage:@"请允许打开访问相册权限"];
                }
            }else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前App访问相册
                [self pushtoImagePickerController];
//                [self allowdToSaveImage:image withRemind:reminder];
            } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
                [self showAlertMessage:@"因系统原因，无法访问相册"];
            }
        });
    }];
}
- (void)pushtoImagePickerController{
    //2.相册
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //导航栏设置
    //    UIColor *naviColor = UIColor.darkGrayColor;
    //    if ([imagePickerController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
    //        [imagePickerController.navigationBar setBarTintColor:naviColor];
    //        [imagePickerController.navigationBar setTranslucent:YES];
    //        [imagePickerController.navigationBar setTintColor:[UIColor blackColor]];
    //    }else{
    //        [imagePickerController.navigationBar setBackgroundColor:naviColor];
    //    }
    //    [imagePickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    //跳转
    //[self showDetailViewController:imagePickerController sender:nil];
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

- (void)showAlertMessage:(NSString *)message {
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
//                                                   message:message
//                                                  delegate:nil
//                                         cancelButtonTitle:nil
//                                         otherButtonTitles:@"确定", nil];
//
//    [alert show];
    
    WS(weakSelf);
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf startTimer];
        [weakSelf startLineTimer];
    }];
    
    [self alert:UIAlertControllerStyleAlert Title:@"" message:message actions:@[actionYes]];
    
}

/** 打开关闭手电筒 */
-(void)clickTorchButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    //1.没有手电筒
    if (![captureDevice hasTorch]) {
        return ;
    }
    
    //2.点亮闪光灯
    if (sender.selected) {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
            [captureDevice unlockForConfiguration];
        }
        
    }else{//3.关闭
        [captureDevice lockForConfiguration:nil];
        [captureDevice setTorchMode:AVCaptureTorchModeOff];
        [captureDevice unlockForConfiguration];
    }
}

-(void)clickMyQRCodeButton:(UIButton *)btn {
    [self presentMyQRcodeVC];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //1.停止timer和扫描
    [self stopTimerAndScan];
    
    //2.无信息过滤
    if (metadataObjects.count < 1) {
        [self presentAlertWithTitle:@"提示" msg:@"暂不支持该类型二维码" hasAction:YES];
        return;
    }
    
    //3.获取扫描信息
    AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
    NSString *urlStr = metadataObject.stringValue;
    BBLOG(@"扫描结果：%@",urlStr);
    
    //4.不符合过滤
    if ([self judgeValidityQRUrlStr:urlStr]) {
        
        //将获取的数据（urlString 地址）转出成为一个字典
        NSDictionary *dict = [KKQRCodeInforTool seperateURLIntoDictionary:urlStr];
        
        [self makeTheResultDict:dict];
        
    }
    
    //5.扫描结果处理
    
}
//- (void)makeTheResultString:(NSString *)resultStr{
//    
//}
#pragma mark - 选择相册 delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //1.停止扫描
    [self stopTimerAndScan];
    
    //2.退出选图vc
//    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:^{
        //3.获取选择的图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *img = [self resizeImageWithBorder:image];
        self.photoImageView.image = img;
        self.photoImageView.hidden = NO;
        self.torchBtn.hidden = YES;
        
        //4.扫描
        //自带的无法扫描旁边有其他图片、有两个二维码等情况，也无法全图，上面是拼贴了两张图但只能解决无法全图的情况 暂时换用第三方库
        //    NSString *urlStr = [LCQRCodeUtil readQRCodeFromImage:ZImage];
        NSString *urlStr = [self decodeQRImage:img];
        
        //4.不符合过滤
        if ([self judgeValidityQRUrlStr:urlStr]) {
            //        return ;
            
            NSDictionary *dict = [KKQRCodeInforTool seperateURLIntoDictionary:urlStr];
            //5.扫描结果处理
            [self makeTheResultDict:dict];
        }
    }];
}

#pragma mark - 扫描图片
/** decode二维码 */
- (NSString *)decodeQRImage:(UIImage*)aImage {
    
    //1.图片尺寸过小
    if (aImage.size.width < 600) {
        aImage = [self TransformImage:aImage toSize:CGSizeMake(600, 600)];
    }
    
    //2.第三方扫码
    NSString *qrResult = nil;
    ZBarReaderController* read = [ZBarReaderController new];
    CGImageRef cgImageRef = aImage.CGImage;
    ZBarSymbol* symbol = nil;
    for(symbol in [read scanImage:cgImageRef]) break;
    qrResult = symbol.data ;
    return qrResult;
    
    /*
      NSString *qrResult = nil;
    //iOS8及以上可以使用系统自带的识别二维码图片接口，但此api有问题，在一些机型上detector为nil。
    if (iOS8_OR_LATER) {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        CIImage *image = [CIImage imageWithCGImage:aImage.CGImage];
        NSArray *features = [detector featuresInImage:image];
        CIQRCodeFeature *feature = [features firstObject];
        
        qrResult = feature.messageString;
    }
     */
}

/** 验证二维码urlStr的有效性 */
-(BOOL)judgeValidityQRUrlStr:(NSString *)urlString {
    
//    if (![urlStr containsString:@"fromUserId"] || ![urlStr containsString:@"branchId"]) {
//        [self presentAlertWithTitle:@"提示" msg:@"无法识别该链接-1001" hasAction:YES];
//        return NO;
//    }
    
    NSString *appDomainStr = [KKNetworkConfig shareInstance].domainStr;
    NSURL *appDomainStrUrl = [NSURL URLWithString:appDomainStr];
    NSString *appHostName = appDomainStrUrl.host;
    
    NSURL *resultUrl = [NSURL URLWithString:urlString];
    NSString *hostName = resultUrl.host;
 
    if ([hostName isEqualToString:appHostName]) {
        return YES;
    }else{
        [self presentAlertWithTitle:@"提示" msg:@"无法识别该链接-1001" hasAction:YES];
        return NO;
    }

    return NO;
}


#pragma mark 图片处理
-(UIImage *)TransformImage:(UIImage *)image toSize:(CGSize)size{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}

/**
 将对应的图片缩放到 一定的尺寸
 
 @param rect 尺寸
 @param image 图片
 @return 新的图片
 */
-(UIImage*)subImageWithSize:(CGRect)rect image:(UIImage *)image {
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

/** 给图片画白边 */
-(UIImage *)resizeImageWithBorder:(UIImage *)image {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 600, 600);
    
    UIGraphicsBeginImageContext(rect.size);
    //1.画白底
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    CGContextFillRect(context, rect);
    //2.画图片
    [image drawInRect:CGRectMake(12, 12, 576, 576)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - jump
/** presentAlert弹窗 */
-(void)presentAlertWithTitle:(NSString *)title msg:(NSString *)msg hasAction:(BOOL)hasAction {
    //1.创建
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //2.action
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (hasAction) {
            [self startTimerAndScan];
        }
    }];
    [alert addAction:confirmAction];
    
    //3.present
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)presentMyQRcodeVC{
    KKMyQRCodeViewController *myQRCodeVC = [[KKMyQRCodeViewController alloc]initWithType:QRCodeTypeUSER withId:nil];
    [self presentViewController:myQRCodeVC animated:YES completion:nil];
}

-(void)popAction {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
