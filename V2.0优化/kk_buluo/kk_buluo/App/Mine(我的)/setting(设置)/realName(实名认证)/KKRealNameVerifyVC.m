//
//  KKRealNameVerifyVC.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRealNameVerifyVC.h"
#import "KKProtocolVC.h"
//view
#import "KKLoginTF.h"
//MLKit
#import "LoginKit.h"

@interface KKRealNameVerifyVC (){
    CGFloat _leftSpace;
    CGFloat _topSpace;
}

//inputView
@property (nonatomic, weak) UIView *topInputView;
@property (nonatomic, weak) KKLoginTF *nameTF;
@property (nonatomic, weak) KKLoginTF *idCardNoTF;
//reminder提醒
@property (nonatomic,weak) UIView *realNameReminderView;
@property (nonatomic,copy) NSString *realNameReminderStr;
//协议
@property (nonatomic,weak) UIView *protocolView;
@property (nonatomic,weak) UIButton *realNameProtocolButton;
//确定
@property (nonatomic,weak) UIButton *confirmButton;

@end

@implementation KKRealNameVerifyVC
#pragma mark - lazy load

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BG;
    
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
    [self setNaviBarTitle:@"实名认证"];
    
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
    
    //1.topInputV
    CGFloat grayLineH = [ccui getRH:1];
    CGFloat tfH = [ccui getRH:47];
    CGFloat topViewH = grayLineH + tfH*2;
    UIView *topV = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT+_topSpace, SCREEN_WIDTH, topViewH)];
    self.topInputView = topV;
    topV.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topV];
    
    //2.pwd
    KKLoginTF *nameTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(_leftSpace, 0, topV.width - 2*_leftSpace, tfH)];
    self.nameTF = nameTf;
    [topV addSubview:nameTf];
    nameTf.itemType = KKLoginTfItemTypeLabel;
    [nameTf setupWithItem:@"姓名:" placeholder:@"请输入姓名"];
    [nameTf.inputTextField addTarget:self action:@selector(nameChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //3.idCardNoTf
    KKLoginTF *idCardNoTf = [[KKLoginTF alloc]initWithFrame:CGRectMake(self.nameTF.left, tfH+grayLineH,self.nameTF.width, tfH)];
    self.idCardNoTF = idCardNoTf;
    [topV addSubview:idCardNoTf];
    idCardNoTf.itemType = KKLoginTfItemTypeLabel;
    [idCardNoTf setupWithItem:@"证件号:" placeholder:@"请输入身份证号"];
    idCardNoTf.separateLine.hidden = YES;
    
    [self.idCardNoTF.inputTextField addTarget:self action:@selector(idCardNoChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //4.实名
    CGFloat originY = topV.bottom;
    [self setupRealNameProtocol:originY+[ccui getRH:8]];
    originY = self.protocolView.bottom;
}

/** 返回值是RealNameReminderView的高度, */
-(CGFloat)setupRealNameReminderView{
    CGFloat w = SCREEN_WIDTH - _leftSpace *2;
    CGFloat h;
    CGFloat topSpace = [ccui getRH:12];
    CGFloat originY = self.topInputView.bottom;
    UIFont *font = [UIFont systemFontOfSize:[ccui getRH:13]];
    CGFloat reminderH = [self.realNameReminderStr boundingRectWithSize:CGSizeMake(w, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    h = topSpace + reminderH;
    
    //1.清空subView
    for(UIView *subview in self.realNameReminderView.subviews){
        [subview removeFromSuperview];
    }
    
    //2.realNameV创建
    if (self.realNameReminderView == nil) {
        UIView *realNameV = [[UIView alloc]initWithFrame:CGRectMake(_leftSpace, originY, w, h)];
        self.realNameReminderView = realNameV;
        [self.view addSubview:realNameV];
    }else{
        self.realNameReminderView.frame = CGRectMake(_leftSpace, originY, w, h);
    }
    
    //3. reminderLabel
    UILabel *reminderL = [[UILabel alloc]initWithFrame:CGRectMake(0, topSpace, w, reminderH)];
    reminderL.numberOfLines = 0;
    reminderL.font = font;
    reminderL.textColor = COLOR_GRAY_TEXT;
    reminderL.text = self.realNameReminderStr;
    [self.realNameReminderView addSubview:reminderL];
    
    //5.return
    return h;
}

-(void)setupRealNameProtocol:(CGFloat)originY{
    
    CGFloat h = [ccui getRH:14];
    
    UIView *protocolV = [[UIView alloc]initWithFrame:CGRectMake(_leftSpace, originY, SCREEN_WIDTH-2*_leftSpace, h)];
    self.protocolView = protocolV;
    [self.view addSubview:protocolV];
    
    //1.button
    UIButton *protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, h, h)];
    self.realNameProtocolButton = protocolBtn;
    protocolBtn.selected = YES;
    [protocolV addSubview:protocolBtn];
    
    [protocolBtn setBackgroundImage:[UIImage imageNamed:@"checkmark_round_blueBg"] forState:UIControlStateSelected];
    [protocolBtn setBackgroundImage:[UIImage imageNamed:@"checkmark_onlyCircle_gray"] forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(clickAcceptProtocolButton) forControlEvents:UIControlEventTouchUpInside];
    
    //2.同意label
    UIFont *font = [UIFont systemFontOfSize:[ccui getRH:13]];
    NSString *acceptText = @" 我已阅读并同意";
    CGFloat acceptLabelW = [acceptText boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width;
    UILabel *acceptL = [[UILabel alloc]initWithFrame:CGRectMake(protocolBtn.right, protocolBtn.top, acceptLabelW, protocolBtn.height)];
    acceptL.textAlignment = NSTextAlignmentLeft;
    acceptL.font = [UIFont systemFontOfSize:[ccui getRH:13]];
    acceptL.text = acceptText;
    acceptL.textColor = COLOR_HEX(0x999999);
    [protocolV addSubview:acceptL];
    //tap
    acceptL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAccept = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAcceptProtocolButton)];
    [acceptL addGestureRecognizer:tapAccept];
    
    //3.protocol
    NSString *protocolText = @"《服务协议》";
    CGFloat protocolLabelW = [protocolText boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size.width;
    UILabel *protocolL = [[UILabel alloc]initWithFrame:CGRectMake(acceptL.right, protocolBtn.top, protocolLabelW, protocolBtn.height)];
    protocolL.textAlignment = NSTextAlignmentLeft;
    protocolL.font = [UIFont systemFontOfSize:[ccui getRH:13]];
    protocolL.text = protocolText;
    protocolL.textColor = RGBA(14, 138, 225, 1);
    [protocolV addSubview:protocolL];
    
    //tap
    protocolL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapProtocol = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(requestRealNameProtocol:)];
    [protocolL addGestureRecognizer:tapProtocol];
}

#pragma mark tool

/** 更新NextStepButton的状态 */
-(void)updateConfirmButtonStatus {
    
    //1. 验证
    if(self.nameTF.inputTextField.text.length < 1
       || self.idCardNoTF.inputTextField.text.length < 1){
        _confirmButton.selected = NO;
        _confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    
    if (!self.realNameProtocolButton.selected) {
        _confirmButton.selected = NO;
        _confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    //2.可点击
    _confirmButton.selected = YES;
    _confirmButton.userInteractionEnabled = YES;
}

#pragma mark - UITextField相关
-(void)nameChanged:(UITextField *)tf {
    [self updateConfirmButtonStatus];
}

-(void)idCardNoChanged:(UITextField *)tf {
    NSString *str = tf.text;
    
    //1.输入内容过滤
    NSString *judgeStr = @"0123456789x";
    NSMutableString *mStr = [NSMutableString stringWithFormat:@""];
    for (NSInteger i=0; i<str.length; i++) {
        NSString *cStr = [str substringWithRange:NSMakeRange(i, 1)];
        if ([judgeStr containsString:cStr]) {
            [mStr appendString:cStr];
        }else if ([cStr isEqualToString:@"X"]){
            [mStr appendString:@"x"];
        }
    }
    tf.text = [mStr copy];
    
    //2.位数最多18位
    if (tf.text.length > 18) {
        tf.text = [tf.text substringToIndex:18];
    }
    
    //3.更新确认按钮状态
    [self updateConfirmButtonStatus];
}


-(BOOL)isValidName {
    NSString *name = self.nameTF.inputTextField.text;
    //1.判空
    if(name.length < 1){
        [CC_NoticeView showError:@"请输入姓名"];
        return NO;
    }
    
//    //2.格式 汉字和*
//    NSString *regex =@"[*\u4e00-\u9fa5]*";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    if(![pred evaluateWithObject:name]){
//        [CC_NoticeView showError:@"姓名不符合规范"];
//        return NO;
//    }
    
    //3.符合规范
    return YES;
}

-(BOOL)isValidIdCardNo {
    NSString *idCardNo = self.idCardNoTF.inputTextField.text;
    
    //1.位数判断
    if(idCardNo.length != 15 && idCardNo.length != 18){
        [CC_NoticeView showError:@"请输入正确的身份证号"];
        return NO;
    }
    
    //2.有x的情况
    if ([idCardNo containsString:@"x"]) {
        NSRange xStr = [idCardNo rangeOfString:@"x"];
        if (xStr.location != idCardNo.length-1) {
            [CC_NoticeView showError:@"请输入正确的身份证号"];
            return NO;
        }
    }
    
    //3.
    return YES;
}


#pragma mark - interaction

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)clickAcceptProtocolButton {
    self.realNameProtocolButton.selected = !self.realNameProtocolButton.selected;
    [self updateConfirmButtonStatus];
}

-(void)clickConfirmButton:(UIButton *)sender {
    
    //1.验证
    if (![self isValidName]) {
        return ;
    }
    if (![self isValidIdCardNo]) {
        return ;
    }
    
    //2.确认实名
    [self showAlertForRealNameVerifyConfirm];
    
}

#pragma mark - alert
/** alert确认实名 */
-(void)showAlertForRealNameVerifyConfirm {
    WS(weakSelf);
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requestRealName];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"实名认证信息提交后不可更改，确认提交吗？" actions:@[actionCancel,actionYes]];
}

/** alert跳过 */
-(void)showAlertForRealNameVerifySkip {
    WS(weakSelf);
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"继续实名认证" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"暂不认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"" message:@"未实名认证您将无法正常使用，是否确认跳过？" actions:@[actionCancel,actionYes]];
}


#pragma mark - request
/** 请求实名认证 初始化信息 */
-(void)requestRealNameInitData {
    
    //1.参数
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    //service
    [para safeSetObject:@"USER_IDENTITY_COMPLETE_INIT" forKey:@"service"];
    
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^(NSString *error, ResModel *resmodel) {
        
        if (error) {
            [CC_NoticeView showError:error];
        }else{
            //3.请求成功
            NSDictionary *responseDic = resmodel.resultDic[@"response"];
            if ([responseDic[@"success"] boolValue]) {
                self.realNameReminderStr = responseDic[@"memo"];
            }
        }
    }];
}

-(void)requestRealNameProtocol:(UITapGestureRecognizer *)tap {
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


/** 请求实名认证 初始化信息 */
-(void)requestRealName {
    
    NSString *nameStr = self.nameTF.inputTextField.text;
    NSString *certNoStr = self.idCardNoTF.inputTextField.text;
    
    WS(weakSelf);
    [[LoginKit getInstance] realName:nameStr certNo:certNoStr userId:[KKUserInfoMgr shareInstance].userId extraParamDic:nil atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        //请求成功
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if ([responseDic[@"success"] boolValue]) {
            
            [CC_NoticeView showError:@"认证成功" atView:self.view];
            [weakSelf.view endEditing:YES];
            //认证成功需要更新用户信息
            [[KKUserInfoMgr shareInstance] requestUserInfo:^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
}


#pragma mark - jump
-(void)pushToProtocolVC:(NSString *)contentStr{
    KKProtocolVC *protocolVC = [[KKProtocolVC alloc]init];
    protocolVC.content = contentStr;
    protocolVC.naviTitle = @"服务协议";
    [self.navigationController pushViewController:protocolVC animated:YES];
}



@end
