//
//  KKMyQRCodeViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMyQRCodeViewController.h"
#import "RBCustomPhotoAlbum.h"

#import "KKQRCodeItem.h"
#import <CoreImage/CoreImage.h>

#import "KKQRCodeRequest.h"

@interface KKMyQRCodeViewController ()

/** 背景视图 */
@property(nonatomic,weak)UIImageView *bgImageView;

/** 标题 */
@property(nonatomic,weak)UILabel *titleLabel;
/** 二维码图片 */
@property(nonatomic,weak)UIImageView *QRCodeImageView;
/** 用户头像 */
@property(nonatomic,weak)UIImageView *userImageView;

/** 标题 */
@property(nonatomic,weak)UILabel *inforLabel;

//static CGFloat QRCodeImage = SCREEN_WIDTH - 77;

/** 二维码宽度 */
@property (nonatomic, assign) CGFloat QRCodeImageWH;
/** 白色内容视图高度 */
@property (nonatomic, assign) CGFloat whiteViewH;
/** 背景内容视图高度 */
@property (nonatomic, assign) CGFloat bgViewH;


@property (nonatomic, assign) QRCodeType type;

@property (nonatomic, strong) NSString *objctId;

/** 二维码数据 */
@property(nonatomic,strong)KKQRCodeItem *codeItem;

@end

@implementation KKMyQRCodeViewController
-(instancetype)initWithType:(QRCodeType)type withId:(NSString *)objctId{
    if (self = [super init]) {
        self.type = type;
        self.objctId = objctId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.QRCodeImageWH = SCREEN_WIDTH - 77*2;
    
    self.bgViewH = self.QRCodeImageWH + 249;
    
    self.whiteViewH = self.QRCodeImageWH + 132;
    
    [self creatSubView];
    
    switch (_type) {
        case QRCodeTypeUSER:
        {
            [KKQRCodeRequest myQRCoderequest:^(KKQRCodeItem * _Nonnull codeItem) {
                self.codeItem = codeItem;
            }];
        }
            break;
        case QRCodeTypeGROUP:
        {
            [KKQRCodeRequest QRCoderequestGroupId:_objctId complete:^(KKQRCodeItem * _Nonnull codeItem) {
                self.codeItem = codeItem;
            }];
        }
            break;
        case QRCodeTypeGUILD:
        {
            [KKQRCodeRequest QRCoderequestGuildId:_objctId complete:^(KKQRCodeItem * _Nonnull codeItem) {
                self.codeItem = codeItem;
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)setCodeItem:(KKQRCodeItem *)codeItem{
    _codeItem = codeItem;
    _titleLabel.attributedText = codeItem.titleA;
    _QRCodeImageView.image = codeItem.qrCodeImage;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:codeItem.logoUrl] placeholderImage:codeItem.sexPlaceHold];
    _inforLabel.attributedText = codeItem.userNameAtt;
    
}


#pragma mark - statusBar
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - creatSubView
//建立背景图和 按钮
- (void)creatSubView{
    //取消按钮X
    DGButton *cancelBtn = [DGButton btnWithImg:[UIImage imageNamed:@"QRCode_close_icon"]];
    cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 65, STATUS_BAR_HEIGHT + 10, 50, 50);
    WS(weakSelf);
    [cancelBtn addClickBlock:^(DGButton *btn) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:cancelBtn];
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
//    bgImageView.frame = CGRectMake((SCREEN_WIDTH - 309)/2, 76, 309, 467);
    CGFloat bgW = SCREEN_WIDTH - 60;
    CGFloat bgH = _bgViewH;
    bgImageView.image = [UIImage imageNamed:@"QRCode_bg_image"];
    self.bgImageView = bgImageView;
    [self.view addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bgW);
        make.height.mas_equalTo(bgH);
//        make.center.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-20);
    }];
    
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn setImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadBtn];
    
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@64);
//        make.top.mas_equalTo(bgImageView.mas_bottom).offset(5);
        make.top.mas_equalTo(bgImageView.mas_bottom).offset(20);

        make.centerX.mas_equalTo(bgImageView.mas_centerX);
    }];
    
    UILabel *saveTipLabel = [[UILabel alloc]init];
    saveTipLabel.font = [UIFont systemFontOfSize:15];
    saveTipLabel.text = @"保存到手机";
    saveTipLabel.textColor = rgba(255, 255, 255, 1);
    saveTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:saveTipLabel];
    [saveTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@20);
        make.top.mas_equalTo(downloadBtn.mas_bottom).offset(5);
        make.centerX.mas_equalTo(bgImageView.mas_centerX);
    }];
    
    [self makeBgImageViewSubView:bgImageView];
}
//logo和白色视图
- (void)makeBgImageViewSubView:(UIImageView *)bgImageView{
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QRCode_title_image"]];
    [bgImageView addSubview:titleImageView];
    
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@106);
        make.height.mas_equalTo(@44);
        make.top.mas_equalTo(bgImageView.mas_top).offset(22);
        make.centerX.mas_equalTo(bgImageView.mas_centerX);
    }];
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.layer.cornerRadius = 4;
    whiteView.clipsToBounds = YES;
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:whiteView];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgImageView.mas_left).offset(17);
        make.right.mas_equalTo(bgImageView.mas_right).offset(-17);
        make.top.mas_equalTo(titleImageView.mas_bottom).offset(5);
        make.bottom.mas_equalTo(bgImageView.mas_bottom).offset(-30);
    }];
    [self makeWhiteViewSubView:whiteView];
}
//白色视图内部子视图
- (void)makeWhiteViewSubView:(UIView *)whiteView{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = rgba(153, 153, 153, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textAlignment = NSTextAlignmentLeft;

//    titleLabel.text = @"扫描二维码，查看个人主页";
//    titleLabel.backgroundColor = [UIColor yellowColor];
    self.titleLabel = titleLabel;
    [whiteView addSubview:titleLabel];
    
    UIImageView *QRCodeImageView = [[UIImageView alloc]init];
    QRCodeImageView.backgroundColor = [UIColor orangeColor];

    self.QRCodeImageView = QRCodeImageView;
    [whiteView addSubview:QRCodeImageView];
    
    
    UIImageView *userImageView = [[UIImageView alloc]init];
    userImageView.layer.cornerRadius = 25;
    userImageView.clipsToBounds = YES;
    userImageView.image = [UIImage imageNamed:@"login_male_normal"];
    self.userImageView = userImageView;
    [whiteView addSubview:userImageView];
    
    UILabel *inforLabel = [[UILabel alloc]init];
    inforLabel.numberOfLines = 0;
    inforLabel.textAlignment = NSTextAlignmentLeft;

    self.inforLabel = inforLabel;
    [whiteView addSubview:inforLabel];
    
    
    [QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).offset(30);
        make.right.mas_equalTo(whiteView.mas_right).offset(-30);
        make.height.mas_equalTo(whiteView.mas_width).offset(-60);
        make.centerX.mas_equalTo(whiteView.mas_centerX);
        make.centerY.mas_equalTo(whiteView.mas_centerY);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView.mas_left).offset(10);
        make.right.mas_equalTo(whiteView.mas_right).offset(-10);
//        make.top.mas_equalTo(whiteView.mas_top).offset(10);
//        make.bottom.mas_equalTo(QRCodeImageView.mas_top).offset(-10);
        make.bottom.mas_equalTo(QRCodeImageView.mas_top);
    }];
    
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.mas_equalTo(whiteView.mas_left).offset(15);
        make.top.mas_equalTo(QRCodeImageView.mas_bottom);
//        make.bottom.mas_equalTo(whiteView.mas_bottom).offset(-10);
//        make.bottom.mas_equalTo(whiteView.mas_bottom);
    }];
    [inforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userImageView.mas_right).offset(5);
        make.right.mas_equalTo(whiteView.mas_right).offset(-15);
        make.centerY.mas_equalTo(userImageView.mas_centerY);
    }];
}


#pragma mark - 下载图片到 手机
- (void)downloadAction{
    UIImage *image = [self makeImageWithView:self.bgImageView withSize:self.bgImageView.bounds.size];
    
    
    [[RBCustomPhotoAlbum shareInstance]saveImageIntoAlbum:image withNeedReminder:YES];
}
#pragma mark 生成image 将视图转化成图片
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    NSData * imageData = UIImageJPEGRepresentation(image,1);
//
//    NSInteger length = [imageData length]/1024;

    return image;
    
}
@end
