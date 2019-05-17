//
//  KKPwdModifyVC.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKPwdModifyVC.h"
#import "KKVerifyPhoneNoVC.h"
//view
#import "KKLoginTF.h"
//MLKit
#import "LoginKitPwdServiceTool.h"

static const NSInteger pwdMaxLength = 20;
static const NSInteger pwdMinLength = 6;
static const NSInteger payPwdLength = 6;

@interface KKPwdModifyVC ()
{
    CGFloat _leftSpace;
    CGFloat _topSpace;
}

@property (nonatomic, weak) KKLoginTF *oldPwdTF;
@property (nonatomic, weak) KKLoginTF *pwdTF;
@property (nonatomic, weak) KKLoginTF *repeatPwdTF;
@property(nonatomic,assign) KKPwdModifyType type;
@property (nonatomic,weak) DGButton *confirmButton;

@end

@implementation KKPwdModifyVC

#pragma mark - life circle
-(instancetype)initWithType:(KKPwdModifyType)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self setNaviBarTitle:@"修改密码"];
    
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
    CGFloat textFieldHeight = [ccui getRH:47];;
    NSArray *newPwdPlaceHolders = @[@"请输入新密码,6-20位区分大小写",@"请输入6位数字密码"];
    
    //1.头部背景图.
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT+_topSpace, SCREEN_WIDTH, textFieldHeight*3)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    //2.旧密码
    KKLoginTF *oldPwdTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(_leftSpace, 0, whiteView.width - 2*_leftSpace, textFieldHeight)];
    self.oldPwdTF = oldPwdTf;
    [whiteView addSubview:oldPwdTf];
    
    oldPwdTf.itemType = KKLoginTfItemTypeIcon;
    [oldPwdTf setupWithItem:@"login_icon_lock" placeholder:@"请输入旧密码"];
    oldPwdTf.inputTextField.secureTextEntry=YES;
    [oldPwdTf.inputTextField addTarget:self action:@selector(oldPwdChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //3.新密码
   KKLoginTF *newPwdTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(oldPwdTf.left, oldPwdTf.bottom,oldPwdTf.width, oldPwdTf.height)];
    self.pwdTF = newPwdTf;
    [whiteView addSubview:newPwdTf];
    
    newPwdTf.itemType = KKLoginTfItemTypeIcon;
    [newPwdTf setupWithItem:@"login_icon_lock" placeholder:newPwdPlaceHolders[self.type]];
    newPwdTf.inputTextField.secureTextEntry=YES;
    [newPwdTf.inputTextField addTarget:self action:@selector(newPwdChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    //4.重复新密码
    KKLoginTF *repeatPwdTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(oldPwdTf.left, newPwdTf.bottom,oldPwdTf.width, oldPwdTf.height)];
    self.repeatPwdTF = repeatPwdTf;
    [whiteView addSubview:repeatPwdTf];
    
    
    repeatPwdTf.itemType = KKLoginTfItemTypeIcon;
    [repeatPwdTf setupWithItem:@"login_icon_lock" placeholder:@"请再次输入新密码"];
    repeatPwdTf.inputTextField.secureTextEntry=YES;
    repeatPwdTf.separateLine.hidden = YES;
    [repeatPwdTf.inputTextField addTarget:self action:@selector(repeatPwdChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //5.textField键盘设置
    if (self.type == KKPwdModifyTypeForPayPwd) {
        [self.oldPwdTF.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.pwdTF.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.repeatPwdTF.inputTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    //6.忘记密码
    UIButton *forgetPwsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwsButton.frame = CGRectMake(0, whiteView.bottom +[ccui getRH:5] , [ccui getRH:80], [ccui getRH:20]);
    forgetPwsButton.right = SCREEN_WIDTH - _leftSpace;
    [self.view addSubview:forgetPwsButton];
    
    [forgetPwsButton setTitleColor:COLOR_HEX(0x2a6fe0) forState:UIControlStateNormal];
    forgetPwsButton.titleLabel.font=[ccui getRFS:14];
    [forgetPwsButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwsButton addTarget:self action:@selector(clickForgetPwdButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark tool
/** 更新NextStepButton的状态 */
-(void)updateConfirmButtonStatus {
    
    //1. 验证
    if(self.oldPwdTF.inputTextField.text.length < 1
       || self.pwdTF.inputTextField.text.length < 1
       || self.repeatPwdTF.inputTextField.text.length < 1){
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.可点击
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
    return ;
}


#pragma mark - UITextField相关
-(void)oldPwdChanged:(UITextField *)tf {
    
    if(self.type == KKPwdModifyTypeForPwd){
        if (tf.text.length > pwdMaxLength) {
            tf.text = [tf.text substringToIndex:pwdMaxLength];
        }
    }
    
    //2.去空格
    tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //3.确认按钮状态
    [self updateConfirmButtonStatus];
}
-(void)newPwdChanged:(UITextField *)tf {
    if(self.type == KKPwdModifyTypeForPwd){
        if (tf.text.length > pwdMaxLength) {
            tf.text = [tf.text substringToIndex:pwdMaxLength];
        }
    }
    
    //2.去空格
    tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //3.确认按钮状态
    [self updateConfirmButtonStatus];
}

-(void)repeatPwdChanged:(UITextField *)tf {
    if(self.type == KKPwdModifyTypeForPwd){
        if (tf.text.length > pwdMaxLength) {
            tf.text = [tf.text substringToIndex:pwdMaxLength];
        }
    }
    
    //2.去空格
    tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //3.确认按钮状态
    [self updateConfirmButtonStatus];
}

#pragma mark - interaction
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickForgetPwdButton:(UIButton *)sender{
    
    [self pushToVerifyPhoneNoVC];
}

-(void)clickConfirmButton:(UIButton *)sender{
    
    //1.检查
    if(![self checkPwdAndRepeatPwd]){ return ;}
    
    //2.发请求
    if (self.type == KKPwdModifyTypeForPwd) {
        [self requestModifyPwd];
    }
}


#pragma mark tool
-(BOOL)checkPwdAndRepeatPwd {
    
    NSString *oldPwdStr = self.oldPwdTF.inputTextField.text;
    NSString *pwdStr = self.pwdTF.inputTextField.text;
    NSString *repeatPwdStr = self.repeatPwdTF.inputTextField.text;
    
    //1.过滤
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
    if (self.type==KKPwdModifyTypeForPwd) {
        
        NSString *noticeStr = [NSString stringWithFormat:@"请输入%ld-%ld位的密码",pwdMinLength,pwdMaxLength];
        
        if (oldPwdStr.length<pwdMinLength ||
            oldPwdStr.length>pwdMaxLength) {
            [CC_NoticeView showError:noticeStr];
            return NO;
        }
        if (pwdStr.length<pwdMinLength ||
            pwdStr.length>pwdMaxLength) {
            [CC_NoticeView showError:noticeStr];
            return NO;
        }
        if (repeatPwdStr.length < pwdMinLength ||
            repeatPwdStr.length>pwdMaxLength) {
            [CC_NoticeView showError:noticeStr];
            return NO;
        }
        
    }else{
        
        NSString *noticeStr = [NSString stringWithFormat:@"请输入%ld位的密码",payPwdLength];
        
        if (oldPwdStr.length != payPwdLength) {
            [CC_NoticeView showError:noticeStr];return NO;
        }
        if (pwdStr.length != payPwdLength) {
            [CC_NoticeView showError:noticeStr];return NO;
        }
        if (repeatPwdStr.length != payPwdLength) {
            [CC_NoticeView showError:noticeStr];return NO;
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
- (void)requestModifyPwd{
    
    NSString *oldPwdStr = self.oldPwdTF.inputTextField.text;
    NSString *pwdStr = self.pwdTF.inputTextField.text;
    
    LoginKitPwdServiceTool *sTool = [[LoginKitPwdServiceTool alloc]initWithExtraParamDic:nil];
    WS(weakSelf);
    [sTool changePwd:pwdStr oldPwd:oldPwdStr atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
        [weakSelf.view endEditing:YES];
        [weakSelf popAction];
    }];
}


#pragma mark - jump
-(void)pushToVerifyPhoneNoVC {
    KKVerifyPhoneNoType type= self.type==KKPwdModifyTypeForPwd ? KKVerifyPhoneNoTypeForPwdReset : KKVerifyPhoneNoTypeForPayPwdReset;
    KKVerifyPhoneNoVC *verifyPhoneNoVC = [[KKVerifyPhoneNoVC alloc]initWithType:type];
    [self.navigationController pushViewController:verifyPhoneNoVC animated:YES];
}


-(void)popAction {
    
    NSInteger toIndex = 0;
    if (self.navigationController.viewControllers.count > 1) {
        toIndex = 1;//设置页
    }
    
    UIViewController *toVC = self.navigationController.viewControllers[toIndex];
    [CC_NoticeView showError:@"密码重置成功" atView:toVC.view];
    [self.navigationController popToViewController:toVC animated:YES];
}

@end
