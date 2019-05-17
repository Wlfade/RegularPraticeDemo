//
//  KKLoginVC.m
//  kk_buluo
//
//  Created by david on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKLoginVC.h"
#import "KKRegisterVC.h"
#import "KKRootContollerMgr.h"
#import "KKVerifyPhoneNoVC.h"
#import "KKProtocolVC.h"
#import "KKRoleSelectVC.h"
//
#import "KKUserInfoCompleteVC.h"
#import "KKRegisterVC.h"

//view
#import "DGItemView.h"
#import "KKLoginTF.h"
#import "KKAccountAlertView.h"
//MLKit
#import "LoginKit.h"
#import "LoginKitCellSmsServiceTool.h"

@interface KKLoginVC ()<KKAccountAlertViewDelegate,DGItemViewDelegate,UITextFieldDelegate>{
    CGFloat _leftSpace;
}

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger leftTime;

@property (nonatomic, weak) DGItemView *itemView;
//手机号
@property (nonatomic,weak) CC_Button *phoneNoDeleteButton;
@property (nonatomic,weak) KKLoginTF *phoneNoTF;
//密码-验证码
@property (nonatomic,weak) KKLoginTF *pwdTF;
//密码
@property (nonatomic, strong) DGButton *eyeButton;
//验证码
@property (nonatomic, strong) DGButton *getVerifyCodeButton;
@property (nonatomic, copy) NSString *smsId;
//接受(对勾)btn
@property (nonatomic,weak) UIButton *acceptButton;
//接受label
@property (nonatomic, weak) DGLabel *acceptLabel;
//协议label
@property (nonatomic, weak) DGLabel *protocolLabel;
//忘记密码btn
@property (nonatomic, weak) UIButton *forgetPwdButton;
//确认按钮
@property (nonatomic,weak) DGButton *confirmButton;

@end

@implementation KKLoginVC
#pragma mark - lazy load
-(DGButton *)eyeButton {
    if (!_eyeButton) {
        _eyeButton = [[DGButton alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:40], [ccui getRH:40])];
        [_eyeButton setNormalImg:Img(@"login_icon_pwd_cantSee") selectedImg:Img(@"login_icon_pwd_canSee")];
        _eyeButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        WS(weakSelf);
        [_eyeButton addClickBlock:^(DGButton *btn) {
            btn.selected = !btn.selected;
            weakSelf.pwdTF.inputTextField.secureTextEntry = !btn.selected;
        }];
    }
    return _eyeButton;
}

-(DGButton *)getVerifyCodeButton {
    if (!_getVerifyCodeButton) {
        _getVerifyCodeButton = [DGButton btnWithFontSize:[ccui getRH:12] title:@"获取验证码" titleColor:COLOR_BLUE];
        _getVerifyCodeButton.frame = CGRectMake(0, 0, [ccui getRH:80], [ccui getRH:40]);
    }
    WS(weakSelf);
    [_getVerifyCodeButton addClickBlock:^(DGButton *btn) {
        [weakSelf requestGetSmsCode];
    }];
    return _getVerifyCodeButton;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self setupNavi];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - status bar
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - UI
-(void)setDimension {
    
    _leftSpace = [ccui getRH:28];
}

-(void)setupNavi {
    
}

-(void)setupUI {
    WS(weakSelf);
    CGFloat textFieldH = [ccui getRH:40];
    
    //0.bg
    self.view.backgroundColor = UIColor.whiteColor;
//    UIImageView *bgImgV = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"login_bg"]];
//    [self.view addSubview:bgImgV];
//    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.mas_equalTo(0);
//    }];
    
    
    //1.icon
    CGFloat loginIconOrignY = [ccui getRH:(STATUS_AND_NAV_BAR_HEIGHT + 8)];
    UIImageView *loginIconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-[ccui getRH:40], loginIconOrignY, [ccui getRH:80], [ccui getRH:80])];
    loginIconImageV.image = [UIImage imageNamed:@"kklogo"];
    [self.view addSubview:loginIconImageV];
    
    //2.itemV
    [self setupItemView:loginIconImageV];
    //2.1 grayLine
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(_leftSpace+[ccui getRH:8], self.itemView.bottom-1, self.view.width-2*_leftSpace-[ccui getRH:16], 1)];
    grayLine.backgroundColor = rgba(238, 238, 238, 1);
    [self.view insertSubview:grayLine belowSubview:self.itemView];
    
    //3.手机号
    KKLoginTF *phoneNumTF = [[KKLoginTF alloc] initWithFrame:CGRectMake(_leftSpace, self.itemView.bottom + [ccui getRH:25], SCREEN_WIDTH-_leftSpace*2, textFieldH)];
    self.phoneNoTF = phoneNumTF;
    phoneNumTF.itemType = KKLoginTfItemTypeLabel;
    [phoneNumTF setupWithItem:@"手机号" placeholder:@"请输入手机号"];
    
    phoneNumTF.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    //phoneNumTF.inputTextField.font = FontB([ccui getRH:26]);
    [phoneNumTF.inputTextField addTarget:self action:@selector(phoneNumDidChanged:) forControlEvents: UIControlEventEditingChanged];
    phoneNumTF.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:phoneNumTF];
    
    //删除
    CC_Button *deleteBtn = [[CC_Button alloc] initWithFrame:CGRectMake(0, 0, [ccui getRH:40], [ccui getRH:40])];
    self.phoneNoDeleteButton = deleteBtn;
    [deleteBtn setImage:[UIImage imageNamed:@"login_icon_delete"] forState:UIControlStateNormal];
    deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    deleteBtn.hidden = YES;
    [phoneNumTF setRightView:deleteBtn];
    [deleteBtn addTappedBlock:^(UIButton *button) {
        phoneNumTF.inputTextField.text = nil;
        weakSelf.phoneNoDeleteButton.hidden = YES;
        [weakSelf phoneNumDidChanged:phoneNumTF.inputTextField];
    }];
    
    //4.密码
    KKLoginTF *pwdTF = [[KKLoginTF alloc] initWithFrame:CGRectMake(phoneNumTF.left, phoneNumTF.bottom+[ccui getRH:25], phoneNumTF.width, textFieldH)];
    self.pwdTF = pwdTF;
    pwdTF.itemType = KKLoginTfItemTypeLabel;
    [pwdTF setupWithItem:@"密码" placeholder:@"请输入密码"];//请输入验证码
    pwdTF.inputTextField.secureTextEntry=YES;
    pwdTF.inputTextField.delegate = self;
    //pwdTF.inputTextField.clearsOnBeginEditing = NO;
    pwdTF.inputTextField.keyboardType = UIKeyboardTypeDefault;
    pwdTF.inputTextField.font = [ccui getRFS:14];
    [pwdTF.inputTextField addTarget:self action:@selector(pwdDidChange:) forControlEvents: UIControlEventEditingChanged];
    pwdTF.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:pwdTF];
    //睁眼
    [pwdTF setRightView:self.eyeButton];
    
    //5.接受
    UIView *acceptView = [self setupAcceptView:pwdTF];
    
    //6.确认btn
    DGButton *confirmBtn = [DGButton btnWithFontSize:[ccui getRH:16] title:@"登录" titleColor:UIColor.whiteColor];
    confirmBtn.frame = CGRectMake(pwdTF.left,acceptView.bottom+[ccui getRH:20], SCREEN_WIDTH - 2*pwdTF.left, [ccui getRH:55]);
    self.confirmButton = confirmBtn;
    [self.view addSubview:confirmBtn];
    [confirmBtn setNormalBgColor:rgba(204, 217, 252, 1) selectedBgColor:rgba(61, 82, 245, 1)];
    confirmBtn.selected = NO;
    confirmBtn.userInteractionEnabled = NO;
    [confirmBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickConfirmButton:btn];
    }];
    
    //7.设置最初状态
    [self setAsLogin];
}

-(void)setupItemView:(UIView *)topV {
    
    DGItemView *itemV = [[DGItemView alloc]initWithFrame:CGRectMake(_leftSpace, topV.bottom+[ccui getRH:24], [ccui getRH:90], [ccui getRH:30])];
    self.itemView = itemV;
    [self.view addSubview:itemV];
    
    itemV.backgroundColor = [UIColor clearColor];
    itemV.normalFont = Font(14) ;
    itemV.selectedFont = FontB(15);//要在title1前面
    itemV.titleArr = @[@"登录",@"注册"];
    itemV.normalColor = rgba(153, 153, 153, 1);
    itemV.selectedColor = rgba(51, 51, 51, 1);
    itemV.delegate = self;
    itemV.indicatorImage = Img(@"item_scrollLine");
    itemV.indicatorColor = UIColor.greenColor;
    itemV.indicatorScale = 0.6;
}

-(UIView *)setupAcceptView:(UIView *)topV {
    //1.acceptV
    UIView *acceptV = [[UIView alloc]initWithFrame:CGRectMake(_leftSpace, topV.bottom+[ccui getRH:10], self.view.width-2*_leftSpace,[ccui getRH:24])];
    [self.view addSubview:acceptV];
    
    //2. btn
    CGFloat btnH = [ccui getRH:14];
    DGButton *acceptBtn = [[DGButton alloc]initWithFrame:CGRectMake([ccui getRH:10], (acceptV.height-btnH)/2.0, btnH, btnH)];
    self.acceptButton = acceptBtn;
    [acceptV addSubview:acceptBtn];
    
    [acceptBtn setNormalBgImg:Img(@"checkmark_onlyCircle_gray") selectedBgImg:Img(@"checkmark_round_blueBg")];
    acceptBtn.selected = YES;
    acceptBtn.userInteractionEnabled = NO;
    WS(weakSelf);
    [acceptBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickAcceptButton];
    }];
    
    //3.acceptL
    DGLabel *acceptL = [DGLabel labelWithText:@" 使用默认角色登录" fontSize:[ccui getRH:12] color:COLOR_BLACK_TEXT];
    self.acceptLabel = acceptL;
    [acceptV addSubview:acceptL];
    [acceptL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(acceptBtn.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(0);
    }];
    //tap
    acceptL.userInteractionEnabled = NO;
    UITapGestureRecognizer *tapAcceptLabelGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAcceptButton)];
    [acceptL addGestureRecognizer:tapAcceptLabelGr];
    
    //4.protocolL
    DGLabel *protocolL = [DGLabel labelWithText:@"《用户注册协议》" fontSize:[ccui getRH:12] color:COLOR_BLUE];
    self.protocolLabel = protocolL;
    [acceptV addSubview:protocolL];
    [protocolL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(acceptL.mas_right).mas_offset(1);
        make.centerY.mas_equalTo(0);
    }];
    protocolL.hidden = YES;
    [protocolL addTapWithTimeInterval:0 tapBlock:^(NSInteger tag) {
        [weakSelf requestRegisterProtocol];
    }];
    
    
    //5.忘记密码
    CGFloat forgetPwdBtnW = [ccui getRH:80];
    DGButton *forgetPwdBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"忘记密码?" titleColor:COLOR_HEX(0x666666)];
    forgetPwdBtn.frame = CGRectMake(acceptV.width-forgetPwdBtnW, 0, forgetPwdBtnW, acceptV.height);
    self.forgetPwdButton = forgetPwdBtn;
    [acceptV addSubview:forgetPwdBtn];
    //forgetPwdBtn.right = 0;
    forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPwdBtn addClickBlock:^(DGButton *btn) {
        [self pushToVerifyPhoneNoVC];
    }];
    
    //6.return
    return acceptV;
}

#pragma mark tool
-(void)setAsRegister {
    //1.输入
    //self.phoneNoTF.inputTextField.text = @"";
    self.pwdTF.inputTextField.text = @"";
    [self.pwdTF setupWithItem:@"验证码" placeholder:@"请输入验证码"];
    [self.pwdTF setRightView:self.getVerifyCodeButton];
    //2.协议
    self.acceptButton.userInteractionEnabled = YES;
    self.acceptButton.selected = YES;
    self.acceptLabel.userInteractionEnabled = YES;
    self.acceptLabel.text = @"我已阅读并同意";
    self.protocolLabel.hidden = NO;
    self.forgetPwdButton.hidden = YES;
    //3.confirmBtn
    [self.confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self updateComfirmButtonStatus];
}

-(void)setAsLogin {
    //1.输入
    //self.phoneNoTF.inputTextField.text = @"";
    self.pwdTF.inputTextField.text = @"";
    [self.pwdTF setupWithItem:@"密码" placeholder:@"请输入密码"];
    [self.pwdTF setRightView:self.eyeButton];
    //2.协议
    self.acceptButton.userInteractionEnabled = NO;
    self.acceptButton.selected = YES;
    self.acceptLabel.userInteractionEnabled = NO;
    self.acceptLabel.text = @"使用默认角色登录";
    self.protocolLabel.hidden = YES;
    self.forgetPwdButton.hidden = NO;
    //3.confirmBtn
    [self.confirmButton setTitle:@"登录" forState:UIControlStateNormal];
    [self updateComfirmButtonStatus];
}


/** 更新NextStepButton的状态 */
-(void)updateComfirmButtonStatus {
    
    //1.不可点击
    if(self.phoneNoTF.inputTextField.text.length < 1
       || self.pwdTF.inputTextField.text.length < 1){
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.注册时,必须接受协议
    if(self.itemView.selectedIndex == 1 &&
       self.acceptButton.selected == NO){
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.可点击
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
    return ;
}

#pragma mark - UITextField输入改变
-(void)phoneNumDidChanged:(UITextField *)textField {
    if(textField.text.length > 0){
        textField.font = [DGFont dgFontStyle:DGFontStyleFestivoLettersNo19 size:26];
    }else{
        textField.font = Font(13);
    }
    
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
    self.phoneNoDeleteButton.hidden = textField.text.length < 1;
    [self updateComfirmButtonStatus];
}

-(void)pwdDidChange:(UITextField *)textField {
    NSInteger pwdMaxLength = 20;
    //1.最大长度限制
    if (textField.text.length > pwdMaxLength) {
        textField.text = [textField.text substringToIndex:pwdMaxLength];
    }
    
    [self updateComfirmButtonStatus];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 只要设置为密文，再次输入就是会清空原来的
    NSString * textfieldContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.pwdTF.inputTextField && textField.isSecureTextEntry ) {
        textField.text = textfieldContent;
        [self updateComfirmButtonStatus];
        return NO;
    }
    return YES;
}


#pragma mark - timer
-(void)startTimer:(NSDictionary *)result {
    self.getVerifyCodeButton.enabled = NO;
    
    self.leftTime=[[result  objectForKey:@"waitNextPrepareSeconds"]intValue];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod:) userInfo:self.getVerifyCodeButton repeats:YES];
}

- (void)timerMethod:(NSTimer*)timer{
    
    UIButton *button = (UIButton*)(timer.userInfo);
    self.leftTime--;
    if (self.leftTime<=0) {
        button.enabled=YES;
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:COLOR_BLUE forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }else{
        button.enabled = NO;
        [button setTitle:[NSString stringWithFormat:@"%lds",(long)self.leftTime] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_HEX(0x666666) forState:UIControlStateNormal];
    }
}

#pragma mark - interaction
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
//    KKUserInfoCompleteVC *VC= [[KKUserInfoCompleteVC alloc]init];
//    KKRegisterVC *VC = [[KKRegisterVC alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
}


-(void)clickAcceptButton {
    self.acceptButton.selected = !self.acceptButton.selected;
    [self updateComfirmButtonStatus];
}

-(void)clickConfirmButton:(UIButton *)sender {
    
    UITextField *pwdTF = self.pwdTF.inputTextField;
    NSString *cell = self.phoneNoTF.inputTextField.text;
    
    //1.获取验证码
    if (self.itemView.selectedIndex == 1) {
        if(![self checkCellValidity:cell]){
            return ;
        }
        if (self.smsId.length < 1) {
            [CC_NoticeView showError:@"请获取验证码"];  
            return;
        }
        [self requestVerifySmsCode];
        return ;
    }
    
    //2.登录
    //2.1 密码不能为空
    if (pwdTF.text.length==0) {
        BBLOG(@"请输入密码");
        [CC_NoticeView showError:@"请输入密码"];
        return ;
    }
    //2.2 密码过长
    NSString *psd = pwdTF.text;
    if (psd.length>20) {
        [CC_NoticeView showError:@"密码超过20字"];
        return ;
    }
    
    //2.2 手机号检查
    if(![self checkCellValidity:self.phoneNoTF.inputTextField.text]){
        return ;
    }
    
    //2.3 请求登录
    [self.view endEditing:YES];
    [self requestLogin];
}

#pragma mark tool
/** 检查手机号有效性 */
-(BOOL)checkCellValidity:(NSString *)cellStr {
    
    //1.为空
    if(cellStr.length == 0) {
        [CC_NoticeView showError:@"请输入手机号"];
        return NO;
    }
    
    //2. 位数不符
    if(cellStr.length != 11) {
        [CC_NoticeView showError:@"请输入正确的手机号"];
        return NO;
    }
    
    //3.手机号验证
    NSString *regex = @"^[1][0-9]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:cellStr]) {
        [CC_NoticeView showError:@"请输入正确的手机号"];
        return NO;
    }
    
    //4.有效
    return YES;
}

#pragma mark - delegate
-(void)AccountAlertViewButtonClickPassValue:(UIButton *)button AccountAlertView:(UIView *)AccountAlertView {
    self.phoneNoTF.inputTextField.text = @"";
    self.pwdTF.inputTextField.text = @"";
}

#pragma mark DGItemViewDelegate
-(BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    
    if (index == 1) {
        [self setAsRegister];
    }else{
        [self setAsLogin];
    }
    return YES;
}


#pragma mark - request
/** 请求 注册协议 */
-(void)requestRegisterProtocol {
    //1.参数
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:@"CMS_INFO_CONTENT_QUERY" forKey:@"service"];
    [para setObject:@"user_protocol" forKey:@"infoCode"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        if (error) {
            [CC_NoticeView showError:error];
            
        }else{
            NSDictionary *resultDic = resModel.resultDic;
            NSString *contentStr = resultDic[@"response"][@"content"];
            [self pushToProtocolVC:contentStr];
        }
    }];
}

/** 请求 获取短信验证码 */
-(void)requestGetSmsCode {
    
    LoginKitCellSmsServiceTool *sTool = [[LoginKitCellSmsServiceTool alloc]initWithType:LoginKitCellSmsTypeRegister cell:self.phoneNoTF.inputTextField.text extraParamDic:nil];
    [sTool sendSmsAtView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        self.smsId = responseDic[@"smsId"];
        [self startTimer:responseDic];
    }];
}

/** 请求 验证短信验证码 */
-(void)requestVerifySmsCode {
    LoginKitCellSmsServiceTool *sTool = [[LoginKitCellSmsServiceTool alloc]initWithType:LoginKitCellSmsTypeRegister cell:self.phoneNoTF.inputTextField.text extraParamDic:nil];
    
    NSString *checkCode = self.pwdTF.inputTextField.text;
    WS(weakSelf);
    [sTool verifySmsWithCheckCode:checkCode smsId:self.smsId verifyCellSign:nil randomStr:nil atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
       NSDictionary *responseDic = resModel.resultDic[@"response"];
        [weakSelf pushToRegisterVCWithRandomStr:responseDic[@"randomString"] verifyCellSign:responseDic[@"verifyCellSign"]];
    }];
}

/** 请求 登录 */
-(void)requestLogin {
    
    WS(weakSelf);
    [[LoginKit getInstance] loginWithCell:self.phoneNoTF.inputTextField.text pwd:self.pwdTF.inputTextField.text useDefaultUser:self.acceptButton.selected extraParamDic:nil atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        BOOL needSelectRole = [responseDic[@"gotoUserList"] boolValue];
        
        //1.处理成功
        if ([KKLoginVC handleLoginSuccess:responseDic needSelectRole:needSelectRole]) {
            
            //2.跳转角色列表
            if (needSelectRole) {
                [weakSelf pushToRoleSelectVC];
                
            }else{
                //3.登录成功
                [CC_NoticeView showError:@"登录成功"];
                //设置rootVC
                [KKRootContollerMgr loadRootVC:nil];
            }
            
        }else{
            [CC_NoticeView showError:@"网络异常,请重试"];
        }
        
    }];
    
}


#pragma mark tool
/**
 @brief登录成功处理
 @param needSelectRole 是否需要选择角色,如果是,oneAuth签名之后就算处理成功
 @return 代表处理是否成功
 */
+(BOOL)handleLoginSuccess:(NSDictionary *)responseDic needSelectRole:(BOOL)needSelectRole {
    
    NSDictionary *userInfoDic = responseDic[@"loginUserInfo"];
    NSDictionary *oneAuthDic = responseDic[@"oneAuthPlatformLogin"];
    NSDictionary *userDic = responseDic[@"userPlatformLogin"];
    
    //1.只进行oneAuth签名
    if(needSelectRole){
        //1.1 判空
        if(!oneAuthDic){
            return NO;
        }
        
        //1.2 oneAuth签名
        [[KKNetworkConfig shareInstance] saveOneAuthInfo:@{
                                                           kNetConfig_id : oneAuthDic[@"oneAuthId"],
                                                           kNetConfig_loginKey : oneAuthDic[@"loginKey"],
                                                           kNetConfig_signKey  : oneAuthDic[@"signKey"],
                                                           kNetConfig_cryptKey : oneAuthDic[@"cryptKey"]
                                                           }];
        return YES;
    }
    
    
    //2. 正常登录
    if (!userInfoDic ||
        !oneAuthDic ||
        !userDic ) {
        return NO;
    }
    
    //2.1 oneAuth签名
    [[KKNetworkConfig shareInstance] saveOneAuthInfo:@{
                                                       kNetConfig_id : oneAuthDic[@"oneAuthId"],
                                                       kNetConfig_loginKey : oneAuthDic[@"loginKey"],
                                                       kNetConfig_signKey  : oneAuthDic[@"signKey"],
                                                       kNetConfig_cryptKey : oneAuthDic[@"cryptKey"]
                                                       }];
    
    //2.2 用户信息(要在user签名前,因为user签名后会去链接融云,链接融云的过程中用到user信息)
    [KKUserInfoMgr shareInstance].userId = userInfoDic[@"userId"];
    [KKUserInfoMgr shareInstance].userInfoModel.loginName = userInfoDic[@"loginName"];
    [KKUserInfoMgr shareInstance].userInfoModel.userLogoUrl = userInfoDic[@"userLogoUrl"];
    
    //2.3 user签名
    [[KKNetworkConfig shareInstance] saveUserInfo:@{
                                                    kNetConfig_id : userDic[@"userId"],
                                                    kNetConfig_loginKey : userDic[@"loginKey"],
                                                    kNetConfig_signKey  : userDic[@"signKey"],
                                                    kNetConfig_cryptKey : userDic[@"cryptKey"]
                                                    }];
    // return
    return YES;
}

#pragma mark - jump

-(void)pushToRegisterVCWithRandomStr:(NSString *)randomStr verifyCellSign:(NSString *)verifyCellSign {
    KKRegisterVC *vc = [[KKRegisterVC alloc]init];
    vc.randomStr = randomStr;
    vc.verifyCellSign = verifyCellSign;
    vc.cell = self.phoneNoTF.inputTextField.text;
    vc.checkCode = self.pwdTF.inputTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushToVerifyPhoneNoVC {
    
    KKVerifyPhoneNoVC *verifyPhoneNoVC = [[KKVerifyPhoneNoVC alloc]initWithType:KKVerifyPhoneNoTypeForPwdReset];
    
    NSString *phoneNoStr = self.phoneNoTF.inputTextField.text;
    verifyPhoneNoVC.phoneNoStr = phoneNoStr;
    [self.navigationController pushViewController:verifyPhoneNoVC animated:YES];
}

-(void)pushToProtocolVC:(NSString *)contentStr{
    KKProtocolVC *protocolVC = [[KKProtocolVC alloc]init];
    protocolVC.content = contentStr;
    protocolVC.naviTitle = @"用户注册协议";
    [self.navigationController pushViewController:protocolVC animated:YES];
}

-(void)pushToRoleSelectVC {
    KKRoleSelectVC *vc = [[KKRoleSelectVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
