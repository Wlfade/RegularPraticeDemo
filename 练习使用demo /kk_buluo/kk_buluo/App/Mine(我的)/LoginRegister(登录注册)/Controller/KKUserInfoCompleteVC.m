//
//  KKUserInfoCompleteVC.m
//  kk_buluo
//
//  Created by david on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKUserInfoCompleteVC.h"
#import "KKRootContollerMgr.h"
#import "TWSelectCityView.h"
//view
#import "KKDatePicker.h"

@interface KKUserInfoCompleteVC (){
    CGFloat _leftSpace;
    CGFloat _commonFontSize;
}

@property (nonatomic, assign) BOOL isSelectedMale;
//男
@property (nonatomic, weak) DGLabel *maleLabel;
@property (nonatomic, weak) DGButton *maleButton;
@property (nonatomic, weak) DGButton *maleIndicatorButton;

//女
@property (nonatomic, weak) DGLabel *femaleLabel;
@property (nonatomic, weak) DGButton *femaleButton;
@property (nonatomic, weak) DGButton *femaleIndicatorButton;

//年龄
@property (nonatomic, strong) KKDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormater;
@property (nonatomic, weak) UILabel *ageLabel;
//城市
@property (nonatomic, weak) UILabel *cityLabel;
//确认
@property (nonatomic, weak) DGButton *confirmButton;

@end

@implementation KKUserInfoCompleteVC


#pragma mark - lazy load

-(NSDateFormatter *)dateFormater {
    
    if (_dateFormater == nil) {
        _dateFormater = [[NSDateFormatter alloc]init];
        [_dateFormater setDateFormat:@"yyyy.MM.dd"] ;
        NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
        _dateFormater.timeZone = sourceTimeZone;
    }
    
    return _dateFormater;
}

#pragma mark - setter
-(void)setIsSelectedMale:(BOOL)isSelectedMale {
    _isSelectedMale = isSelectedMale;
    
    self.maleButton.selected = isSelectedMale;
    self.maleIndicatorButton.selected = isSelectedMale;
    self.femaleButton.selected = !isSelectedMale;
    self.femaleIndicatorButton.selected = !isSelectedMale;
}

#pragma mark - life circle
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self setupNavi];
    [self setupUI];
}

#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:36];
    _commonFontSize = [ccui getRH:15];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    self.fd_interactivePopDisabled = YES;
}

-(void)setupUI {
    
    WS(weakSelf);
    CGFloat leftSpace = _leftSpace;
    //0.bg
    self.view.backgroundColor = UIColor.whiteColor;
//    UIImageView *bgImgV = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"login_bg"]];
//    [self.view addSubview:bgImgV];
//    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.mas_equalTo(0);
//    }];
    
    //1.topV
    //1.1 标题
    CGFloat titleTopSpace = iPhoneX ? [ccui getRH:74] : [ccui getRH:98];
    DGLabel *titleL = [DGLabel labelWithText:@"选择您的性别" fontSize:_commonFontSize color:COLOR_BLACK_TEXT bold:YES];
    [self.view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.top.mas_equalTo(titleTopSpace);
    }];
    
    //1.2 跳过
    DGButton *skipBtn = [DGButton btnWithFontSize:_commonFontSize bold:YES title:@"跳过" titleColor:COLOR_BLACK_TEXT];
    [self.view addSubview:skipBtn];
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:20]);
        make.centerY.mas_equalTo(titleL);
        make.width.mas_equalTo([ccui getRH:40]);
        make.height.mas_equalTo([ccui getRH:40]);
    }];
    
    
    [skipBtn addClickBlock:^(DGButton *btn) {
        [KKRootContollerMgr loadRootVC:nil];
    }];
    
    //2.性别
    CGFloat sexViewH = [ccui getRH:95];
    CGFloat sexViewLeftSpace = [ccui getRH:45];
    UIView *sexV = [[UIView alloc]init];
    [self.view addSubview:sexV];
    [sexV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).mas_offset([ccui getRH:40]);
        make.left.mas_equalTo(sexViewLeftSpace);
        make.right.mas_equalTo(-sexViewLeftSpace);
        make.height.mas_equalTo(sexViewH);
    }];
    //2.1 subvies
    [self setupSexView:sexV viewHetight:sexViewH];
    
    //2.2 设置
    self.isSelectedMale = YES;
    [self.maleButton addClickBlock:^(DGButton *btn) {
        weakSelf.isSelectedMale = YES;
    }];
    
    [self.femaleButton addClickBlock:^(DGButton *btn) {
        weakSelf.isSelectedMale = NO;
    }];
    
    //3.items
    //3.1 年龄
    UIView *ageV = [[UIView alloc]init];
    UITapGestureRecognizer *tapAgeGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAgeItemView:)];
    [ageV addGestureRecognizer:tapAgeGr];
    self.ageLabel = [self setupItemView:ageV after:sexV title:@"生日" subTitle:@"选择生日"];
    
    //3.2 城市
    UIView *cityV = [[UIView alloc]init];
    UITapGestureRecognizer *tapCityGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCityItemView:)];
    [cityV addGestureRecognizer:tapCityGr];
    self.cityLabel = [self setupItemView:cityV after:ageV title:@"所在城市" subTitle:@"选择城市"];
    
    //4.确认btn
    DGButton *confirmBtn = [DGButton btnWithFontSize:[ccui getRH:16] title:@"确定" titleColor:UIColor.whiteColor];
    self.confirmButton = confirmBtn;
    [confirmBtn setNormalBgColor:rgba(204, 217, 252, 1) selectedBgColor:rgba(61, 82, 245, 1)];
    confirmBtn.selected = NO;
    confirmBtn.userInteractionEnabled = NO;
    
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:40]);
        make.right.mas_equalTo(-[ccui getRH:40]);
        make.bottom.mas_equalTo(-[ccui getRH:64]-HOME_INDICATOR_HEIGHT);
        make.bottom.height.mas_equalTo(44);
    }];
    
    [confirmBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickConfirmButton:btn];
    }];
}

/** 设置sexView的subView */
-(void)setupSexView:(UIView *)sexView viewHetight:(CGFloat)height {
    
    CGFloat mLabeltopSpace = [ccui getRH:5];
    CGFloat mBtnLeftSpace = [ccui getRH:10];
    CGFloat mIndicatorRightSpace = [ccui getRH:8];
    CGFloat mIndicatorBottomSpace = [ccui getRH:2];
    CGFloat mIndicatorW = [ccui getRH:18];
    
    //1.男
    //1.1 label
    DGLabel *maleL = [DGLabel labelWithText:@"男" fontSize:[ccui getRH:11] color:COLOR_DARK_GRAY_TEXT];
    self.maleLabel = maleL;
    [sexView addSubview:maleL];
    [maleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(mLabeltopSpace);
    }];
    
    //1.2 btn
    DGButton *maleBtn = [[DGButton alloc]init];
    self.maleButton = maleBtn;
    maleBtn.layer.cornerRadius = height/2.0;
    maleBtn.layer.masksToBounds = YES;
    [maleBtn setNormalBgImg:Img(@"login_male_normal") selectedBgImg:Img(@"login_male_selected")];
    
    [sexView addSubview:maleBtn];
    [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(mBtnLeftSpace);
        make.height.width.mas_equalTo(height);
    }];
    
    //1.3 indicator
    DGButton *maleIndicatorBtn = [[DGButton alloc]init];
    self.maleIndicatorButton = maleIndicatorBtn;
    [maleIndicatorBtn setNormalBgImg:Img(@"") selectedBgImg:Img(@"checkmark_round_blueBg")];//checkmark_onlyCircle_gray
    maleIndicatorBtn.userInteractionEnabled = NO;
    
    [sexView addSubview:maleIndicatorBtn];
    [maleIndicatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(maleBtn.mas_right).mas_offset(-mIndicatorRightSpace);
        make.bottom.mas_equalTo(-mIndicatorBottomSpace);
        make.width.height.mas_equalTo(mIndicatorW);
    }];
    
    //2.grayBar
    UIView *grayBar = [[UIView alloc]init];
    grayBar.backgroundColor = rgba(212, 212, 212, 1);
    [sexView addSubview:grayBar];
    [grayBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:1.8]);
    }];
    grayBar.transform = CGAffineTransformMakeRotation(M_PI_4/6);
    
    //3.女
    //3.1 label
    DGLabel *femaleL = [DGLabel labelWithText:@"女" fontSize:[ccui getRH:11] color:COLOR_DARK_GRAY_TEXT];
    self.femaleLabel = femaleL;
    [sexView addSubview:femaleL];
    [femaleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(mLabeltopSpace);
    }];
    
    //3.2 btn
    DGButton *femaleBtn = [[DGButton alloc]init];
    self.femaleButton = femaleBtn;
    femaleBtn.layer.cornerRadius = height/2.0;
    femaleBtn.layer.masksToBounds = YES;
    [femaleBtn setNormalBgImg:Img(@"login_female_normal") selectedBgImg:Img(@"login_female_selected")];
    [sexView addSubview:femaleBtn];
    [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-mBtnLeftSpace);
        make.height.width.mas_equalTo(height);
    }];
    
    //3.3 indicator
    DGButton *femaleIndicatorBtn = [[DGButton alloc]init];
    self.femaleIndicatorButton = femaleIndicatorBtn;
    [femaleIndicatorBtn setNormalBgImg:Img(@"") selectedBgImg:Img(@"checkmark_round_blueBg")];
    femaleIndicatorBtn.userInteractionEnabled = NO;
    
    [sexView addSubview:femaleIndicatorBtn];
    [femaleIndicatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(femaleBtn.mas_right).mas_offset(-mIndicatorRightSpace);
        make.bottom.mas_equalTo(-mIndicatorBottomSpace);
        make.width.height.mas_equalTo(mIndicatorW);
    }];
    
}


#pragma mark tool

/** 设置(创建)item */
-(UILabel *)setupItemView:(UIView *)view after:(UIView *)topV title:(NSString *)title subTitle:(NSString *)subTitle {
    
    CGFloat leftSpace = _leftSpace;
    CGFloat topSpace = [ccui getRH:50];
    CGFloat itemH = [ccui getRH:70];
    
    //1.view
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.top.mas_equalTo(topV.mas_bottom).mas_offset(topSpace);
        make.height.mas_equalTo(itemH);
    }];
    
    //2.itemL
    DGLabel *itemL = [DGLabel labelWithText:title fontSize:_commonFontSize color:COLOR_BLACK_TEXT bold:YES];
    [view addSubview:itemL];
    [itemL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    //3.subTitleL
    DGLabel *subTitleL = [DGLabel labelWithText:subTitle fontSize:[ccui getRH:12] color:COLOR_GRAY_TEXT bold:NO];
    [view addSubview:subTitleL];
    [subTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-[ccui getRH:10]);
        make.left.mas_equalTo(0);
    }];
    
    //4.arrowImgV
    UIImageView *arrowImgV = [[UIImageView alloc]initWithImage:Img(@"arrow_down_gray")];
    [view addSubview:arrowImgV];
    [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(subTitleL);
        make.width.mas_equalTo([ccui getRH:10]);
        make.height.mas_equalTo([ccui getRH:8]);
    }];
    
    //5.grayL
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = rgba(238, 238, 238, 1);
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //6.return
    return subTitleL;
}

-(void)updateConfirmButtonStatus {
    if ([self.ageLabel.text isEqualToString:@"选择生日"] ||
        [self.cityLabel.text isEqualToString:@"选择城市"]) {
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
}

#pragma mark - interaction

-(void)clickConfirmButton:(UIButton *)btn {
    [self.view endEditing:YES];
    [self requstUserInfoComplete];
}

-(void)tapAgeItemView:(UITapGestureRecognizer *)gr {
    WS(weakSelf);
    KKDatePicker *datePicker = [[KKDatePicker alloc] initWithFrame:self.view.bounds];
    [datePicker showDatePiker:^(NSDate * _Nonnull date) {
        NSString *str = [self.dateFormater stringFromDate:date];
        [weakSelf setAgeLabelText:str];
    }];
}

-(void)setAgeLabelText:(NSString *)text {
    //1.赋值
    self.ageLabel.text = text;
    self.ageLabel.textColor = COLOR_BLACK_TEXT;
    self.ageLabel.font = Font([ccui getRH:_commonFontSize]);
    //2.更新确认按钮状态
    [self updateConfirmButtonStatus];
}

-(void)tapCityItemView:(UITapGestureRecognizer *)gr {
    
    WS(weakSelf);
    TWSelectCityView *city = [[TWSelectCityView alloc] initWithFrame:self.view.bounds];
    [city showCityView:^(NSString *proviceStr, NSString *cityStr) {
        NSString *str = [NSString stringWithFormat:@"%@-%@",proviceStr,cityStr];
        if([str containsString:@"北京市"]){
            str = @"北京市";
        }else if([str containsString:@"天津市"]){
            str = @"天津市";
        }else if([str containsString:@"上海市"]){
            str = @"上海市";
        }else if([str containsString:@"重庆市"]){
            str = @"重庆市";
        }
        [weakSelf setCityLabelText:str];
    }];
}

-(void)setCityLabelText:(NSString *)text {
    //1.赋值
    self.cityLabel.text = text;
    self.cityLabel.textColor = COLOR_BLACK_TEXT;
    self.cityLabel.font = Font([ccui getRH:_commonFontSize]);
    //2.更新确认按钮状态
    [self updateConfirmButtonStatus];
}

#pragma mark - delegate


#pragma mark - notification


#pragma mark - request
-(void)requstUserInfoComplete {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_INFO_COMPLETE" forKey:@"service"];
    NSString *sexStr = @"U";
    if (self.maleButton.selected) {
        sexStr = @"M";
    }else if (self.femaleButton.selected){
        sexStr = @"F";
    }
    [params safeSetObject:sexStr forKey:@"sex"];
    [params safeSetObject:self.cityLabel.text forKey:@"location"];//birthday
    [params safeSetObject:self.ageLabel.text forKey:@"birthday"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error atView:self.view];
        }else{
            [CC_NoticeView showError:@"成功" atView:self.view];
             [KKRootContollerMgr loadRootVC:nil];
        }
    }];
}

#pragma mark - jump


@end
