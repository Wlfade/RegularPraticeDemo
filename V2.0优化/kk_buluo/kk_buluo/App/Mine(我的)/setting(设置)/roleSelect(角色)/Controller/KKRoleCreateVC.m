//
//  KKRoleCreateVC.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRoleCreateVC.h"
#import "KKRoleSelectVC.h"

//view
//#import "KKLoginTF.h"
//MLKit
#import "LoginKitRoleServiceTool.h"

@interface KKRoleCreateVC (){
    CGFloat _leftSpace;
    CGFloat _topSpace;
}
@property(nonatomic,weak) UITextField *nameTextField;
@property (nonatomic, weak) DGButton *confirmButton;
@end

@implementation KKRoleCreateVC


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

#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:20];
    _topSpace = [ccui getRH:10];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"创建新角色"];
    
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
        [weakSelf.view endEditing:YES];
        [weakSelf requestCreateRole];
    }];
}

- (void)setupUI{
    WS(weakSelf);
    
    //1.inputV
    UIView *topInputV = [[UIView alloc]init];
    topInputV.backgroundColor = UIColor.whiteColor;
    
    CGFloat topSpace = _topSpace;
    [self.view addSubview:topInputV];
    [topInputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.naviBar.mas_bottom).mas_offset(topSpace);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([ccui getRH:47]);
    }];
    
    
    //2.textField
    UITextField *nameTf = [[UITextField alloc]init];
    self.nameTextField = nameTf;
    nameTf.placeholder = @"请输入昵称";
    nameTf.font = Font([ccui getRH:15]);
    [nameTf addTarget:self action:@selector(nameDidChanged:) forControlEvents: UIControlEventEditingChanged];
    nameTf.backgroundColor = UIColor.whiteColor;
    
    CGFloat leftSpace = _leftSpace;
    [topInputV addSubview:nameTf];
    [nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark tool
-(void)updateComfirmButtonStatus {
    if (self.nameTextField.text.length < 2 ||
        self.nameTextField.text.length > 12) {
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
}


#pragma mark - UITextField输入改变
-(void)nameDidChanged:(UITextField *)textField {
    NSInteger pwdMaxLength = 12;
    //1.最大长度限制
    if (textField.text.length > pwdMaxLength) {
        textField.text = [textField.text substringToIndex:pwdMaxLength];
    }
    
    [self updateComfirmButtonStatus];
}

#pragma mark - request
-(void)requestCreateRole {
    NSString *nickName = self.nameTextField.text;
    
    LoginKitRoleServiceTool *sTool = [[LoginKitRoleServiceTool alloc]initWithExtraParamDic:nil];
    
    WS(weakSelf);
    [sTool roleCreateWithLoginName:nickName asDefaultUser:NO asCurrentUser:NO atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        [CC_NoticeView showError:@"创建成功"];
         NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (weakSelf.asDefaultRoleLogin) {
            [KKRoleSelectVC requestLoginWithUserId:responseDic[@"createUserId"] asDefault:YES];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
