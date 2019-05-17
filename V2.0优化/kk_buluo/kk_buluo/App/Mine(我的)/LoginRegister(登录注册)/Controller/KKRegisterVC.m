//
//  KKRegisterVC.m
//  kk_buluo
//
//  Created by david on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRegisterVC.h"
#import "KKUserInfoCompleteVC.h"
#import "KKLoginVC.h"
//view
#import "DGItemView.h"
#import "KKLoginTF.h"
#import "KKAccountAlertView.h"
//MLKit
#import "LoginKitPwdServiceTool.h"

static const NSInteger register_nickNameMaxLength = 12;
static const NSInteger register_pwdMaxLength = 20;
static const NSInteger register_pwdMinLength = 6;

@interface KKRegisterVC ()<KKAccountAlertViewDelegate,DGItemViewDelegate>{
    CGFloat _leftSpace;
}

@property (nonatomic, weak) DGItemView *itemView;
@property (nonatomic,weak) KKLoginTF *pwdTF;
@property (nonatomic,weak) KKLoginTF *repeatPwdTF;
@property (nonatomic,weak) KKLoginTF *nickNameTF;
@property (nonatomic,weak) UIButton *defaultRoleButton;

@property (nonatomic,weak) DGButton *confirmButton;
@end


@implementation KKRegisterVC

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    //1.bg
    UIImageView *bgImgV = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    
    //2.itemV
    [self setupItemView];
    
    //3.昵称
    KKLoginTF *nickNameTF = [[KKLoginTF alloc] initWithFrame:CGRectMake(_leftSpace, self.itemView.bottom + [ccui getRH:25], SCREEN_WIDTH-_leftSpace*2, textFieldH)];
    self.nickNameTF = nickNameTF;
    [self.view addSubview:nickNameTF];
    nickNameTF.backgroundColor = UIColor.whiteColor;
    nickNameTF.itemType = KKLoginTfItemTypeLabel;
    [nickNameTF setupWithItem:@"昵称" placeholder:@"请输入"];
    nickNameTF.inputTextField.keyboardType = UIKeyboardTypeDefault;
    nickNameTF.inputTextField.font = [ccui getRFS:14];
    [nickNameTF.inputTextField addTarget:self action:@selector(nickNameDidChange:) forControlEvents: UIControlEventEditingChanged];
    
    //3.pwd
    KKLoginTF *pwdTF = [[KKLoginTF alloc] initWithFrame:CGRectMake(nickNameTF.left, nickNameTF.bottom+[ccui getRH:25], nickNameTF.width, textFieldH)];
    self.pwdTF = pwdTF;
    [self.view addSubview:pwdTF];
    pwdTF.backgroundColor = UIColor.whiteColor;
    pwdTF.itemType = KKLoginTfItemTypeLabel;
    [pwdTF setupWithItem:@"密码" placeholder:@"请输入"];
    pwdTF.inputTextField.secureTextEntry = YES;
    pwdTF.inputTextField.keyboardType = UIKeyboardTypeDefault;
    pwdTF.inputTextField.font = [ccui getRFS:14];
    [pwdTF.inputTextField addTarget:self action:@selector(pwdDidChanged:) forControlEvents: UIControlEventEditingChanged];
    
    //4.repeadPwd
    KKLoginTF *repeatPwdTF = [[KKLoginTF alloc] initWithFrame:CGRectMake(pwdTF.left, pwdTF.bottom+[ccui getRH:25], pwdTF.width, textFieldH)];
    self.repeatPwdTF = repeatPwdTF;
    [self.view addSubview:repeatPwdTF];
    repeatPwdTF.backgroundColor = UIColor.whiteColor;
    repeatPwdTF.itemType = KKLoginTfItemTypeLabel;
    [repeatPwdTF setupWithItem:@"确认密码" placeholder:@"请输入"];
    repeatPwdTF.inputTextField.secureTextEntry = YES;
    repeatPwdTF.inputTextField.keyboardType = UIKeyboardTypeDefault;
    repeatPwdTF.inputTextField.font = [ccui getRFS:14];
    [repeatPwdTF.inputTextField addTarget:self action:@selector(repeatPwdDidChange:) forControlEvents: UIControlEventEditingChanged];
    
    
    //5.角色
    //5.1 btn
    UIButton *defaultRoleBtn = [[UIButton alloc]initWithFrame:CGRectMake([ccui getRH:10]+_leftSpace, repeatPwdTF.bottom + [ccui getRH:24], [ccui getRH:14], [ccui getRH:14])];
    defaultRoleBtn.hidden = YES;
    self.defaultRoleButton = defaultRoleBtn;
    [self.view addSubview:defaultRoleBtn];
    
    [defaultRoleBtn setBackgroundImage:[UIImage imageNamed:@"checkmark_onlyCircle_gray"] forState:UIControlStateNormal];
    [defaultRoleBtn setBackgroundImage:[UIImage imageNamed:@"checkmark_round_blueBg"] forState:UIControlStateSelected];
    defaultRoleBtn.selected = YES;
    [defaultRoleBtn addTarget:self action:@selector(clickUserDefaultRoleButton) forControlEvents:UIControlEventTouchUpInside];
    
    //5.2 label
    UILabel *roleLabel = [[UILabel alloc]initWithFrame:CGRectMake(defaultRoleBtn.right+3, defaultRoleBtn.top, 150,defaultRoleBtn.height)];
    roleLabel.hidden = YES;
    roleLabel.textAlignment = NSTextAlignmentLeft;
    roleLabel.font = [ccui getRFS:12];
    roleLabel.textColor = COLOR_HEX(0xA6A6A6);
    roleLabel.text = @" 使用默认角色登录";
    [self.view addSubview:roleLabel];
    //tap
    roleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRoleLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUserDefaultRoleButton)];
    [roleLabel addGestureRecognizer:tapRoleLabel];
    
    
    //6.注册
    DGButton *confirmBtn = [DGButton btnWithFontSize:[ccui getRH:16] title:@"注册" titleColor:UIColor.whiteColor];
    [confirmBtn setNormalBgColor:rgba(204, 217, 252, 1) selectedBgColor:rgba(61, 82, 245, 1)];
    confirmBtn.frame = CGRectMake(pwdTF.left,defaultRoleBtn.bottom+[ccui getRH:20], SCREEN_WIDTH - 2*pwdTF.left, [ccui getRH:55]);
    self.confirmButton = confirmBtn;
    [self.view addSubview:confirmBtn];
    
    confirmBtn.selected = NO;
    confirmBtn.userInteractionEnabled = NO;
    [confirmBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickConfirmButton:btn];
    }];
    
}

-(void)setupItemView {
    
    DGItemView *itemV = [[DGItemView alloc]initWithFrame:CGRectMake(_leftSpace, [ccui getRH:80], [ccui getRH:45], [ccui getRH:30])];
    self.itemView = itemV;
    [self.view addSubview:itemV];
    
    itemV.backgroundColor = [UIColor clearColor];
    itemV.normalFont = Font(14) ;
    itemV.selectedFont = FontB(15);//要在title1前面
    itemV.titleArr = @[@"注册"];
    itemV.normalColor = rgba(153, 153, 153, 1);
    itemV.selectedColor = rgba(51, 51, 51, 1);
    itemV.delegate = self;
    itemV.indicatorImage = Img(@"item_scrollLine");
    itemV.indicatorColor = UIColor.greenColor;
    itemV.indicatorScale = 0.6;
}



#pragma mark tool
/** 更新NextStepButton的状态 */
-(void)updateConfirmButtonStatus {
    
    //1. 验证
    if(self.pwdTF.inputTextField.text.length < 1 ||
       self.repeatPwdTF.inputTextField.text.length < 1 ||
       self.nickNameTF.inputTextField.text.length < 1){
        _confirmButton.selected = NO;
        _confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.可点击
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
    return ;
}

#pragma mark - UITextField输入改变
-(void)pwdDidChanged:(UITextField *)tf {
    //1.最大长度限制
    
    if (tf.text.length > register_pwdMaxLength) {
        tf.text = [tf.text substringToIndex:register_pwdMaxLength];
    }
    
    
    //2.去空格
    tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //3.确认按钮状态
    [self updateConfirmButtonStatus];
}

-(void)repeatPwdDidChange:(UITextField *)tf {
    //1.最大长度限制
    
    if (tf.text.length > register_pwdMaxLength) {
        tf.text = [tf.text substringToIndex:register_pwdMaxLength];
    }
    
    //2.去空格
    tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //3.确认按钮状态
    [self updateConfirmButtonStatus];
}

-(void)nickNameDidChange:(UITextField *)tf {
    //1.最大长度限制
    if (tf.text.length > register_nickNameMaxLength) {
        tf.text = [tf.text substringToIndex:register_nickNameMaxLength];
    }
    //2.确认按钮状态
    [self updateConfirmButtonStatus];
}

#pragma mark - interaction
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


-(void)clickUserDefaultRoleButton {
    self.defaultRoleButton.selected = !self.defaultRoleButton.selected;
}

-(void)clickConfirmButton:(UIButton *)sender {
    if([self checkPwdAndRepeatPwd]){
        [self requestRegister];
    }
}

#pragma mark tool
-(BOOL)checkPwdAndRepeatPwd {
    
    NSString *pwdStr=self.pwdTF.inputTextField.text;
    NSString *repeatPwdStr=self.repeatPwdTF.inputTextField.text;
    
    //1.不一致
    if (![pwdStr isEqualToString:repeatPwdStr]) {
        [CC_NoticeView showError:@"两次密码输入不一致"];
        return NO;
    }
    
    //2.不能是纯标点符号
    if ([self isNoNumberOrLetter:pwdStr] || [self isNoNumberOrLetter:repeatPwdStr]) {
        [CC_NoticeView showError:@"密码只能包括字母、数字和特殊字符"];
        return NO;
    }
    
    //3.不符合规则
    if (pwdStr.length < register_pwdMinLength ||
        pwdStr.length > register_pwdMaxLength ||
        repeatPwdStr.length < register_pwdMinLength ||
        repeatPwdStr.length > register_pwdMaxLength) {
        
        NSString *noticeStr = [NSString stringWithFormat:@"请输入%ld-%ld位的密码",(long)register_pwdMinLength,(long)register_pwdMaxLength];
        [CC_NoticeView showError:noticeStr];
        return NO;
    }
    
    //4.符合
    [self.view endEditing:YES];
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



#pragma mark - delegate
-(void)AccountAlertViewButtonClickPassValue:(UIButton *)button AccountAlertView:(UIView *)AccountAlertView {
}

#pragma mark DGItemViewDelegate
-(BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index {
    
    return YES;
}

#pragma mark - request
-(void)requestRegister {
    
    WS(weakSelf);
    
    LoginKitPwdServiceTool *sTool = [[LoginKitPwdServiceTool alloc]initWithExtraParamDic:nil];
    NSString *pwdStr = self.pwdTF.inputTextField.text;
    NSString *nickName = self.nickNameTF.inputTextField.text;
    [sTool registerWithCell:self.cell pwd:pwdStr loginName:nickName checkCode:self.checkCode verifyCellSign:self.verifyCellSign randomStr:self.randomStr atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        [weakSelf requestLogin];
    }];
}

/** 请求 登录 */
-(void)requestLogin {
    
    WS(weakSelf);
    [[LoginKit getInstance] loginWithCell:self.cell pwd:self.pwdTF.inputTextField.text useDefaultUser:YES extraParamDic:nil atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
        [CC_NoticeView showError:@"注册成功"];
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if([KKLoginVC handleLoginSuccess:responseDic needSelectRole:NO]){
            [weakSelf pushtToUserInfoCompleteVC];
        }else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}


#pragma mark - jump
-(void)pushtToUserInfoCompleteVC {
    KKUserInfoCompleteVC *vc = [[KKUserInfoCompleteVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
