//
//  KKPwdSetVC.m
//  kk_buluo
//
//  Created by david on 2018/7/16.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "KKPwdSetVC.h"
#import "KKLoginVC.h"
#import "KKRootContollerMgr.h"
//view
#import "KKLoginTF.h"
//tool
#import "KKUserInfoMgr.h"
//MLKit
#import "LoginKitPwdServiceTool.h"


@interface KKPwdSetVC (){
    CGFloat _leftSpace;
    CGFloat _topSpace;
}

@property (nonatomic,weak) UIView *topView;
@property (nonatomic, weak) KKLoginTF *pwdTF;
@property (nonatomic, weak) KKLoginTF *repeatTF;
@property (nonatomic,weak) UIButton *confirmButton;

@property(nonatomic,assign) KKPwdSetType type;
@property (nonatomic,strong)NSArray *pwdPlaceHolders;
@property (nonatomic,strong)NSArray *repeatPlaceHolders;

@end

@implementation KKPwdSetVC

static const NSInteger pwdMaxLength = 20;
static const NSInteger pwdMinLength = 6;
static const NSInteger payPwdLength = 6;

#pragma mark - lazy load
-(NSArray *)pwdPlaceHolders {
    if (!_pwdPlaceHolders) {
        _pwdPlaceHolders = @[@"请输入新密码,6-20位区分大小写",@"请输入6位数字密码",@"请输入6位数字密码"];
    }
    return _pwdPlaceHolders;
}

-(NSArray *)repeatPlaceHolders {
    if (!_repeatPlaceHolders) {
        _repeatPlaceHolders = @[@"请再次输入密码",@"请再次输入新密码",@"请再次输入新密码"];
    }
    return _repeatPlaceHolders;
}

#pragma mark - life circle
-(instancetype)initWithType:(KKPwdSetType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_HEX(0xebebeb);
    
    [self setDimension];
    [self setupNavi];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:20];
    _topSpace = [ccui getRH:10];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    NSArray *titleArray = @[@"找回密码",@"设置密码",@"找回密码"];
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
    
    //1.topV
    CGFloat grayLineH = [ccui getRH:1];
    CGFloat tfH = [ccui getRH:47];
    CGFloat topViewH = grayLineH + tfH*2;
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT+_topSpace, SCREEN_WIDTH, topViewH)];
    self.topView = topV;
    topV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topV];
    
    //2.pwd
    KKLoginTF *pwdTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(_leftSpace, 0, topV.width - 2*_leftSpace, tfH)];
    self.pwdTF = pwdTf;
    [topV addSubview:pwdTf];
    
    pwdTf.itemType = KKLoginTfItemTypeIcon;
    [pwdTf setupWithItem:@"login_icon_lock" placeholder:self.pwdPlaceHolders[self.type]];
    [pwdTf.inputTextField addTarget:self action:@selector(pwdChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //3.repeatPwd
    KKLoginTF *repeatTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(_pwdTF.left, tfH+grayLineH,_pwdTF.width, tfH)];
    self.repeatTF = repeatTf;
    [topV addSubview:repeatTf];
    
    repeatTf.itemType = KKLoginTfItemTypeIcon;
    [repeatTf setupWithItem:@"login_icon_lock" placeholder:self.repeatPlaceHolders[self.type]];
    repeatTf.separateLine.hidden = YES;
    [repeatTf.inputTextField addTarget:self action:@selector(repeadPwdChanged:) forControlEvents:UIControlEventEditingChanged];

    
    //4.textField格式
    [self setTextFieldType];
}

#pragma mark tool
-(void)setTextFieldType {
    //1.安全输入
    self.pwdTF.inputTextField.secureTextEntry = YES;
    self.repeatTF.inputTextField.secureTextEntry = YES;
    
    
    //2.键盘
    if (self.type==KKPwdSetTypeForPayPwd || self.type==KKPwdSetTypeForPayPwdReset) {
        self.pwdTF.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.repeatTF.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        self.pwdTF.inputTextField.keyboardType = UIKeyboardTypeDefault;
        self.repeatTF.inputTextField.keyboardType = UIKeyboardTypeDefault;
    }
}

/** 更新NextStepButton的状态 */
-(void)updateConfirmButtonStatus {
    //1. 验证
    if(self.pwdTF.inputTextField.text.length < 1
       || self.repeatTF.inputTextField.text.length < 1){
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.可点击
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
}

#pragma mark - UITextField相关
-(void)pwdChanged:(UITextField *)tf {
    //1.最大长度限制
    if (self.type == KKPwdSetTypeForPwd) {
        if (tf.text.length > pwdMaxLength) {
            tf.text = [tf.text substringToIndex:pwdMaxLength];
        }
    }
    
    //2.去空格
    tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //3.确认按钮状态
    [self updateConfirmButtonStatus];
}

-(void)repeadPwdChanged:(UITextField *)tf {
    //1.最大长度限制
    if (self.type == KKPwdSetTypeForPwd) {
        if (tf.text.length > pwdMaxLength) {
            tf.text = [tf.text substringToIndex:pwdMaxLength];
        }
    }
    
    //2.去空格
    tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //3.确认按钮状态
    [self updateConfirmButtonStatus];
}

#pragma mark - 点击
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickConfirmButton:(UIButton *)sender {
    //1.检查
    if(![self checkPwdAndRepeatPwd]){ return; }
    //2.发请求
    switch (self.type) {
        case KKPwdSetTypeForPwd:
            [self requestSetPwd];
            break;
        case KKPwdSetTypeForPayPwd:
            
            break;
        case KKPwdSetTypeForPayPwdReset:
            
            break;
            
        default:
            break;
    }
}

#pragma mark tool
-(BOOL)checkPwdAndRepeatPwd {
    
    //1.验证
    NSString *pwdStr=_pwdTF.inputTextField.text;
    NSString *repeatPwdStr=self.repeatTF.inputTextField.text;
    
    //1.1 不一致
    if (![pwdStr isEqualToString:repeatPwdStr]) {
        [CC_NoticeView showError:@"两次密码输入不一致"];
        return NO;
    }
    
    //1.2 不能是纯标点符号
    if ([self isNoNumberOrLetter:pwdStr] || [self isNoNumberOrLetter:repeatPwdStr]) {
        [CC_NoticeView showError:@"密码只能包括字母、数字和特殊字符"];
        return NO;
    }
    
    //1.3 不符合规则
    if (self.type == KKPwdSetTypeForPayPwdReset ||
        self.type == KKPwdSetTypeForPayPwd) {
        
        if (pwdStr.length!=payPwdLength ||
            repeatPwdStr.length!=payPwdLength) {
            NSString *noticeStr = [NSString stringWithFormat:@"请输入%ld位的密码",(long)payPwdLength];
            [CC_NoticeView showError:noticeStr];
            return NO;
        }
    }
    
    if (self.type == KKPwdSetTypeForPwd) {
        
        if (pwdStr.length<pwdMinLength ||
            pwdStr.length>pwdMaxLength ||
            repeatPwdStr.length<pwdMinLength ||
            repeatPwdStr.length>pwdMaxLength) {
            
            NSString *noticeStr = [NSString stringWithFormat:@"请输入%ld-%ld位的密码",(long)pwdMinLength,(long)pwdMaxLength];
            [CC_NoticeView showError:noticeStr];
            return NO;
        }
    }
    
    //2.符合规则
    return YES;
}

/** 没有数字和字母 */
- (BOOL)isNoNumberOrLetter:(NSString *)str {
    if (str.length == 0){
        return NO;
    }
    NSString *regex =@"[^a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];
}



#pragma mark - request

- (void)requestSetPwd {
    
    NSString *pwd = self.pwdTF.inputTextField.text;
    
    LoginKitPwdServiceTool *sTool = [[LoginKitPwdServiceTool alloc]initWithExtraParamDic:nil];
    
    [sTool changePwdByCell:self.cell pwd:pwd verifyCellSign:self.verifyCellSign randomStr:self.randomString atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        //成功
        [CC_NoticeView showError:@"密码重置成功"];
        [KKRootContollerMgr loadLoginAsRootVC];
    }];
}



#pragma mark - jump

/** 成功设置密码后的pop */
-(void)popForSuccessSetPwd {
    NSInteger toIndex = 0;
    if (self.navigationController.viewControllers.count > 1) {
        toIndex = 1;//设置页
    }
    
    UIViewController *toVC = self.navigationController.viewControllers[toIndex];
    [CC_NoticeView showError:@"修改成功" atView:toVC.view];
    [self.navigationController popToViewController:toVC animated:YES];
}

@end

