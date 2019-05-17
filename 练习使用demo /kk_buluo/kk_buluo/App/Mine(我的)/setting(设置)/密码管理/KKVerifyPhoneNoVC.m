//
//  KKVerifyPhoneNoVC.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKVerifyPhoneNoVC.h"
#import "KKLoginTF.h"
#import "KKPwdSetVC.h"
//loginKit
#import "LoginKitCellSmsServiceTool.h"

@interface KKVerifyPhoneNoVC ()<UITextFieldDelegate> {
    CGFloat _leftSpace;
    CGFloat _topSpace;
}

@property (nonatomic, weak)  KKLoginTF *phoneNoTF;
@property (nonatomic, weak)  KKLoginTF *verifyCodeTF;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger leftTime;

@property(nonatomic,assign)KKVerifyPhoneNoType type;
@property (nonatomic,weak) UIButton *getVerifyCodeButton;
@property (nonatomic,weak) UIButton *protocolIndicatorBtn;
@property (nonatomic,weak) UIButton *confirmButton;

@property (nonatomic,copy) NSString *smsIdStr;//验证码;


@end

@implementation KKVerifyPhoneNoVC

#pragma mark - life circle
-(instancetype)initWithType:(KKVerifyPhoneNoType)type {
    
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_HEX(0xebebeb);
    
    [self setDimension];
    [self setupNavi];
    [self setupUI];
}


#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:20];
    _topSpace = [ccui getRH:10];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    NSArray *titleArray = @[@"换绑手机号",@"找回密码",@"找回密码"];
    [self setNaviBarTitle:titleArray[self.type]];
    
    //2.rightItem
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"确定" titleColor:UIColor.whiteColor];
    [rightItemBtn setNormalBgColor:COLOR_LIGHT_BLUE selectedBgColor:COLOR_BLUE];
    rightItemBtn.selected = NO;
    rightItemBtn.userInteractionEnabled = NO;
    rightItemBtn.layer.cornerRadius = 2.0;
    rightItemBtn.layer.masksToBounds = YES;
    
    self.confirmButton = rightItemBtn;
    [self.naviBar addSubview:rightItemBtn];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-9);
        make.width.mas_equalTo([ccui getRH:50]);
        make.height.mas_equalTo([ccui getRH:24]);
    }];
    
    WS(weakSelf);
    rightItemBtn.clickTimeInterval = 2.0;
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickConfirmButton:btn];
    }];
}

-(void)setupUI {
    
    //1.头部背景图.
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT+_topSpace, SCREEN_WIDTH, [ccui getRH:95])];
    topV.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topV];
    
    //2.手机号
    KKLoginTF *phoneNoTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(_leftSpace, 0, topV.width - 2*_leftSpace, topV.height/2)];
    self.phoneNoTF = phoneNoTf;
    [topV addSubview:phoneNoTf];
    
    phoneNoTf.itemType = KKLoginTfItemTypeIcon;
    [phoneNoTf setupWithItem:@"login_icon_phone" placeholder:@"请输入手机号"];
    phoneNoTf.inputTextField.text = self.phoneNoStr;
    phoneNoTf.inputTextField.keyboardType=UIKeyboardTypeNumberPad;
    [phoneNoTf.inputTextField addTarget:self action:@selector(phoneNoDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //3.验证码
    KKLoginTF *verifyCodeTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(_leftSpace, topV.height/2, topV.width - 2*_leftSpace, topV.height/2)];
    self.verifyCodeTF = verifyCodeTf;
    [topV addSubview:verifyCodeTf];
    
    verifyCodeTf.itemType = KKLoginTfItemTypeIcon;
    [verifyCodeTf setupWithItem:@"login_icon_shield" placeholder:@"请输入验证码"];
    verifyCodeTf.separateLine.hidden = YES;
    [verifyCodeTf.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [verifyCodeTf.inputTextField addTarget:self action:@selector(verifyCodeDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //4.获取验证码
    UIButton *getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    getVerifyCodeBtn.frame = CGRectMake(0, 0, [ccui getRH:100], [ccui getRH:40]);
    getVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [getVerifyCodeBtn setTitle:@"获取验证码" forState: UIControlStateNormal];
    [getVerifyCodeBtn setTitleColor:RGBA(14, 138, 225, 1) forState:UIControlStateNormal];
    [getVerifyCodeBtn setBackgroundColor:[UIColor whiteColor]];
    
    getVerifyCodeBtn.layer.borderColor = [UIColor clearColor].CGColor;
    getVerifyCodeBtn.layer.borderWidth = 1;
    getVerifyCodeBtn.layer.cornerRadius = 3;
    getVerifyCodeBtn.layer.masksToBounds = YES;
    
    [getVerifyCodeBtn addTarget:self action:@selector(clickGetVerifyCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.getVerifyCodeButton = getVerifyCodeBtn;
    [self.verifyCodeTF setRightView:getVerifyCodeBtn];
    
}

#pragma mark tool
/** 更新confirmButton的状态 */
-(void)updateConfirmButtonStatus {
    
    //1.不可点击
    //1.1 手机号,验证码
    if(self.phoneNoTF.inputTextField.text.length < 1
       || self.verifyCodeTF.inputTextField.text.length < 1){
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.可点击
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
}


#pragma mark - UITextField相关
-(void)verifyCodeDidChanged:(UITextField *)tf {
    
    if (tf.text.length > 6) {
        tf.text = [tf.text substringToIndex:6];
    }
    
    [self updateConfirmButtonStatus];
}

-(void)phoneNoDidChanged:(UITextField *)tf {
    if (tf.text.length > 11) {
        tf.text = [tf.text substringToIndex:11];
    }
    [self updateConfirmButtonStatus];
}

-(BOOL)isValidPhoneNumber {
    
    if(self.phoneNoTF.inputTextField.text.length == 0) {
        [CC_NoticeView showError:@"请输入手机号"];
        return NO;
    }
    
    if (self.phoneNoTF.inputTextField.text.length != 11) {
        [CC_NoticeView showError:@"输入的手机号有误"];
        return NO;
    }
    
    NSString *regex = @"^[1][0-9]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:self.phoneNoTF.inputTextField.text]) {
        [CC_NoticeView showError:@"输入的手机号有误"];
        return NO;
    }
    
    return YES;
}

-(BOOL)isValidVerifyCode {
    if (!self.smsIdStr) {
        [CC_NoticeView showError:@"请获取验证码"];
        return NO;
    }
    
    NSString *verifyCodeStr = self.verifyCodeTF.inputTextField.text;
    if (verifyCodeStr.length < 1) {
        [CC_NoticeView showError:@"请输入验证码"];
        return NO;
    }
    
    if(verifyCodeStr.length < 6){
        [CC_NoticeView showError:@"请输入六位数字验证码"];
        return NO;
    }
    
    if (![self isPureInt:verifyCodeStr]) {
        [CC_NoticeView showError:@"请输入六位数字验证码"];
        return NO;
    }
    
    return YES;
}

- (BOOL)isPureInt:(NSString *)str{
    
    NSScanner *scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - interaction
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickGetVerifyCodeButton:(UIButton *)button {
    
    //1.检查手机号
    if(![self isValidPhoneNumber]){ return ; }
    
    //2.请求
    if (KKVerifyPhoneNoTypeForPwdReset == self.type) {
        [self requestLoginVerifyCode];
    }else{
        [self requestVerifyCode];
    }
}

-(void)clickConfirmButton:(UIButton *)sender {
    
    //1. 手机号
    if(![self isValidPhoneNumber]){
        return ;
    }
    
    //2. 验证码
    if(![self isValidVerifyCode]){
        return ;
    }
    
    //3. 请求验证
    if (KKVerifyPhoneNoTypeForPwdReset == self.type) {
        [self requestLoginVerify];
    }else{
        [self requestVerify];
    }
    
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
        [button setTitleColor:COLOR_HEX(0xfc5447) forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }else{
        button.enabled = NO;
        [button setTitle:[NSString stringWithFormat:@"%lds",(long)self.leftTime] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_HEX(0x666666) forState:UIControlStateNormal];
    }
}


#pragma mark - request
#pragma mark login
/** 请求获取login验证码 */
-(void)requestLoginVerifyCode {
    //1.准备参数
    NSString *cellStr = self.phoneNoTF.inputTextField.text;
    
    //2.请求
    WS(weakSelf);
    LoginKitCellSmsServiceTool *sTool = [[LoginKitCellSmsServiceTool alloc]initWithType:LoginKitCellSmsTypeLoginPwdReset cell:cellStr extraParamDic:nil];
    [sTool sendSmsAtView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (responseDic) {
            weakSelf.smsIdStr = [NSString stringWithFormat:@"%@",responseDic[@"smsId"]];
            [weakSelf startTimer:responseDic];
        }
    }];
}

/** 请求login验证 */
-(void)requestLoginVerify {
    //1.准备参数
    NSString *cellStr = self.phoneNoTF.inputTextField.text;
    NSString *verifyCodeStr = self.verifyCodeTF.inputTextField.text;
    
    //2.请求
    LoginKitCellSmsServiceTool *sTool = [[LoginKitCellSmsServiceTool alloc]initWithType:LoginKitCellSmsTypeLoginPwdReset cell:cellStr extraParamDic:nil];
    WS(weakSelf);
    [sTool verifySmsWithCheckCode:verifyCodeStr smsId:self.smsIdStr verifyCellSign:nil randomStr:nil atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        //3.2其他验证成功
        weakSelf.randomStr = [NSString stringWithFormat:@"%@",responseDic[@"randomString"]];
        weakSelf.verifyCellSignStr = [NSString stringWithFormat:@"%@",responseDic[@"verifyCellSign"]];
        [weakSelf pushPwdSetVC];
    }];
}

#pragma mark other
/** 请求获取验证码 */
-(void)requestVerifyCode {
    
    NSString *cellStr=self.phoneNoTF.inputTextField.text;
    
    NSString *serviceStr = @"";
    switch (self.type) {
        case KKVerifyPhoneNoTypeForPhoneNoReset:
            serviceStr = @"MODIFY_BIND_CELL_SEND_NEW_CELL_SMS";
            break;
        case KKVerifyPhoneNoTypeForPayPwdReset:
            serviceStr = @"FIND_ACCOUNT_PASSWORD_BY_CELL_SEND_SMS_ACK";
            break;
        default:
            break;
    }
    if (serviceStr.length < 1) {
        return ;
    }
    
    //1.参数
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    //service
    [para safeSetObject:serviceStr forKey:@"service"];
    //cell
    [para setObject:cellStr forKey:@"cell"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            if ([error isEqualToString:@"手机号格式错误"]) {
                [CC_NoticeView showError:@"请输入正确的手机号"];
            }else {
                [CC_NoticeView showError:error];
            }
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            if (responseDic) {
                self.smsIdStr = [NSString stringWithFormat:@"%@",responseDic[@"smsId"]];
                [self startTimer:responseDic];
            }
        }
    }];
}

/** 请求验证 */
-(void)requestVerify {
    
    NSString *phoneNoStr = self.phoneNoTF.inputTextField.text;
    NSString *verifyCodeStr = self.verifyCodeTF.inputTextField.text;
    NSString *serviceStr = @"";
    switch (self.type) {
        case KKVerifyPhoneNoTypeForPhoneNoReset:
            serviceStr = @"MODIFY_BIND_CELL_VERIFY_NEW_CELL_SMS";
            break;
        case KKVerifyPhoneNoTypeForPayPwdReset:
            serviceStr = @"FIND_ACCOUNT_PASSWORD_BY_CELL_VALIDTE_SMS_ACK";
            break;
        default:
            break;
    }
    if (serviceStr.length < 1) {
        return;
    }
    //1.参数
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    //service
    [para safeSetObject:serviceStr forKey:@"service"];
    //cell
    [para safeSetObject:phoneNoStr forKey:@"cell"];
    //checkCode
    [para safeSetObject:verifyCodeStr forKey:@"validateCode"];
    //smsId
    [para safeSetObject:self.smsIdStr forKey:@"smsId"];
    
    //重置绑定手机号,需要多两个参数
    if (self.type == KKVerifyPhoneNoTypeForPhoneNoReset) {
        //verifyCellSign
        [para safeSetObject:self.verifyCellSignStr forKey:@"verifyCellSign"];
        //randomString
        [para safeSetObject:self.randomStr forKey:@"randomString"];
    }
    
    //3.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            BOOL isSuccess = [responseDic[@"success"] boolValue];
            if (responseDic && isSuccess) {
                
                //3.1 是换绑手机号
                if (self.type == KKVerifyPhoneNoTypeForPhoneNoReset) {
                    [CC_NoticeView showError:@"换绑成功"];
                    if([responseDic[@"jumpLogin"] boolValue]){
                      
                    }else{
                        [self popForSuccessBindNewPhoneNo];
                    }
                    return ;
                }
                //3.2其他验证成功
                self.randomStr = [NSString stringWithFormat:@"%@",responseDic[@"randomString"]];
                self.verifyCellSignStr = [NSString stringWithFormat:@"%@",responseDic[@"verifyCellSign"]];
                [self pushPwdSetVC];
            }
            
        }
    }];
}

#pragma mark - jump

-(void)pushPwdSetVC {
    KKPwdSetVC *pwdVC;
    
    switch (self.type) {
        case KKVerifyPhoneNoTypeForPhoneNoReset:
            pwdVC = [[KKPwdSetVC alloc] initWithType:KKPwdSetTypeForPwd];
            break;
        case KKVerifyPhoneNoTypeForPwdReset:
            pwdVC = [[KKPwdSetVC alloc] initWithType:KKPwdSetTypeForPwd];
            break;
        case KKVerifyPhoneNoTypeForPayPwdReset:
            pwdVC = [[KKPwdSetVC alloc] initWithType:KKPwdSetTypeForPayPwdReset];
            break;
        default:
            break;
    }
    
    
    if (pwdVC) {
        pwdVC.randomString = self.randomStr;
        pwdVC.verifyCellSign = self.verifyCellSignStr;
        pwdVC.smsIdString = self.smsIdStr;
        pwdVC.smsStr = self.verifyCodeTF.inputTextField.text;
        pwdVC.cell = self.phoneNoTF.inputTextField.text;
        [self.navigationController pushViewController:pwdVC animated:YES];
    }
}

/** 成功绑定新手机号后的pop */
-(void)popForSuccessBindNewPhoneNo {
    
}
@end
