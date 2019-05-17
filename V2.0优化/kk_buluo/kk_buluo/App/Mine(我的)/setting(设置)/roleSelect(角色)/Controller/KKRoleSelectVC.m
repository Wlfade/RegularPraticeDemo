//
//  KKRoleSelectVC.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRoleSelectVC.h"
#import "KKRoleCreateVC.h"
#import "KKRootContollerMgr.h"
//view
#import "KKRoleSelectTableViewCell.h"

//MLKit
#import "LoginKitRoleServiceTool.h"

#define kRoleSelectCellId  @"KKRoleSelectTableViewCell"

@interface KKRoleSelectVC () <UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _leftSpace;
    CGFloat _topSpace;
    CGFloat _cellHeight;
}
//topNoticeV
@property (nonatomic, weak) UIView *noticeView;
//tableV
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,copy) NSMutableArray *rolesMutArr;
@property(nonatomic,copy)NSString *selectedUserId;
@property (nonatomic, copy) NSString *currentDefaultUserId;

//bottomV
@property (nonatomic, weak) DGButton *defaultRoleButton;
@property (nonatomic, weak) DGButton *confirmButton;
@end

@implementation KKRoleSelectVC

#pragma mark - lazy load
-(NSMutableArray *)rolesMutArr {
    if (!_rolesMutArr) {
        _rolesMutArr = [NSMutableArray array];
    }
    return _rolesMutArr;
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
    
    [self requestRoles];
}


#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:20];
    _topSpace = [ccui getRH:10];
    _cellHeight = [ccui getRH:47];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"选择角色"];
    
    //2.rightItem
    CGFloat rightItemBtnW = [ccui getRH:60];
    CC_Button *rightItemBtn = [[CC_Button alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-rightItemBtnW, STATUS_BAR_HEIGHT, rightItemBtnW, 44)];
    rightItemBtn.titleLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
    [rightItemBtn setTitle:@"创建" forState:UIControlStateNormal];
    [rightItemBtn setTitleColor:RGBA(14, 138, 225, 1) forState:UIControlStateNormal];
    [self.naviBar addSubview:rightItemBtn];
    
    //rightImgV
    CGFloat rightImgViewW = [ccui getRH:13];
    UIImageView *rightImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_icon_role_add"]];
    rightImgV.frame = CGRectMake(rightItemBtn.left-5,STATUS_BAR_HEIGHT + (44-rightImgViewW)/2, rightImgViewW, rightImgViewW);
    [self.naviBar addSubview:rightImgV];
    
    
    WS(weakSelf);
    [rightItemBtn addTappedOnceDelay:2.0 withBlock:^(UIButton *button) {
        [weakSelf pushToRoleCreateVC];
    }];
}

- (void)setupUI{
    WS(weakSelf);
    
    //1.noticeV
    [self setupNoticeView];
    
    //2.bottomV
    UIView *bottomV = [[UIView alloc]init];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([ccui getRH:110]);
    }];
    [self setupBottomView:bottomV];
    
    //3.tableV
    UITableView *tableV = [[UITableView alloc]init];
    self.tableView = tableV;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.backgroundColor = self.view.backgroundColor;
    [tableV registerClass:[KKRoleSelectTableViewCell class] forCellReuseIdentifier:kRoleSelectCellId];
    [self.view addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.noticeView.mas_bottom).mas_offset([ccui getRH:0]);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomV.mas_top);
    }];
}


-(void)setupBottomView:(UIView *)sView {
    WS(weakSelf);
    
    CGFloat leftSpace = [ccui getRH:40];
    CGFloat roleBtnW = [ccui getRH:14];
    //1.角色
    //1.1 btn
    DGButton *defaultRoleBtn = [[DGButton alloc]init];
    self.defaultRoleButton = defaultRoleBtn;
    [defaultRoleBtn setNormalBgImg:Img(@"checkmark_onlyCircle_gray") selectedBgImg:Img(@"checkmark_round_blueBg")];
    defaultRoleBtn.selected = YES;
    [defaultRoleBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickDefaultRoleButton:btn];
    }];
    [sView addSubview:defaultRoleBtn];
    [defaultRoleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(leftSpace);
        make.width.height.mas_equalTo(roleBtnW);
    }];

    //1.2 label
    DGLabel *roleLabel = [DGLabel labelWithText:@" 默认使用该角色登录" fontSize:[ccui getRH:12] color:COLOR_HEX(0xA6A6A6)];
    [roleLabel addTapWithTimeInterval:0 tapBlock:^(NSInteger tag) {
         [weakSelf clickDefaultRoleButton:defaultRoleBtn];
    }];
    [sView addSubview:roleLabel];
    [roleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(defaultRoleBtn.mas_right).mas_offset(2);
        make.centerY.mas_equalTo(defaultRoleBtn);
    }];
    

    //2.确定按钮
    DGButton *confirmBtn = [DGButton btnWithFontSize:[ccui getRH:16] title:@"确定" titleColor:UIColor.whiteColor];
    [confirmBtn setNormalBgColor:rgba(204, 217, 252, 1) selectedBgColor:rgba(61, 82, 245, 1)];
    self.confirmButton = confirmBtn;
    confirmBtn.selected = NO;
    confirmBtn.userInteractionEnabled = NO;
    [confirmBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickConfirmButton:btn];
    }];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.top.mas_equalTo(roleLabel.mas_bottom).mas_offset([ccui getRH:23]);
        make.height.mas_equalTo([ccui getRH:44]);
    }];
}

-(UIView *)setupNoticeView {
    //1.notice
    CGFloat noticeViewH = [ccui getRH:50];
    UIView *noticeV = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, noticeViewH)];
    self.noticeView = noticeV;
    [self.view addSubview:noticeV];
    
    //2.noticeImgV
    CGFloat noticeImgViewH = [ccui getRH:16];
    UIImageView *noticeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(_leftSpace, (noticeViewH-noticeImgViewH)/2, noticeImgViewH, noticeImgViewH)];
    noticeImgV.image = [UIImage imageNamed:@"login_icon_exclamation"];
    [noticeV addSubview:noticeImgV];
    
    //3.noticeL
    CGFloat noticeLabelH = 20;
    UILabel *noticeL = [[UILabel alloc]initWithFrame:CGRectMake(noticeImgV.right+[ccui getRH:5], (noticeViewH-noticeLabelH)/2, SCREEN_WIDTH-noticeImgV.right-_leftSpace, noticeLabelH)];
    noticeL.textColor = COLOR_HEX(0x666666);
    noticeL.text = @"选择后，您可在“设置”菜单切换角色";
    noticeL.font = [UIFont systemFontOfSize:[ccui getRH:15]];
    [noticeV addSubview: noticeL];
    
    //4.
    return noticeV;
}

#pragma mark - interaction

-(void)clickConfirmButton:(UIButton *)btn {
    if (self.selectedUserId.length > 0) {
        [KKRoleSelectVC requestLoginWithUserId:self.selectedUserId asDefault:self.defaultRoleButton.selected];
    }
}

-(void)clickDefaultRoleButton:(UIButton *)btn {
    btn.selected = !btn.selected;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rolesMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    //1.获取cell
    KKRoleSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoleSelectCellId forIndexPath:indexPath];
    
    //2.设置
    NSDictionary *roleDic = self.rolesMutArr[row];
    cell.nameStr = roleDic[@"loginName"];
    if([roleDic[@"forbidden"] boolValue]){
        cell.nameStr = [roleDic[@"loginName"] stringByAppendingString:@"(停用)"];
    }
    if ([self.currentDefaultUserId isEqualToString:roleDic[@"userId"]]) {
        cell.isDefaultRole = YES;
    }else{
        cell.isDefaultRole = NO;
    }
    
    //3.return
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSInteger row = indexPath.row;
//    KKRoleSelectTableViewCell *cell = (KKRoleSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (cell.selected) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        self.selectedUserId = @"";
//    }else{
//        self.selectedUserId = self.rolesMutArr[row][@"userId"];
//    }
    
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.停用
    NSInteger row = indexPath.row;
    NSDictionary *roleDic = self.rolesMutArr[row];
    if([roleDic[@"forbidden"] boolValue]){
        [CC_NoticeView showError:@"该角色已被停用，不可切换"];
        return nil;
    }
    
    KKRoleSelectTableViewCell *cell = (KKRoleSelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.selectedUserId = @"";
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return nil;
    }else{
        self.selectedUserId = self.rolesMutArr[row][@"userId"];
        self.confirmButton.selected = YES;
        self.confirmButton.userInteractionEnabled = YES;
    }
    
    return indexPath;
}

#pragma mark - request
- (void)requestRoles {
    
    LoginKitRoleServiceTool *sTool = [[LoginKitRoleServiceTool alloc]initWithExtraParamDic:nil];
    
    [sTool roleListAtView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
        NSDictionary *userSelectInfoDic = resModel.resultDic[@"response"][@"userSelectInfo"];
        self.currentDefaultUserId = userSelectInfoDic[@"defaultUserId"];
        
        [self.rolesMutArr removeAllObjects];
        [self.rolesMutArr addObjectsFromArray:userSelectInfoDic[@"userSimples"]];

        [self.tableView reloadData];
    }];
    
}


/**
 选择角色登录
 
 @param userId 选择登录的角色Id
 @param asDefault 是否重置默认角色
 */
+ (void)requestLoginWithUserId:(NSString *)userId asDefault:(BOOL)asDefault {
    
    LoginKitRoleServiceTool *sTool = [[LoginKitRoleServiceTool alloc]initWithExtraParamDic:nil];
    
    [sTool roleLoginWithUserId:userId asDefaultUser:asDefault atView:nil mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
        [CC_NoticeView showError:@"登录成功"];
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        
        //1.用户信息
        NSDictionary *userInfoDic = responseDic[@"loginUserInfo"];
        [KKUserInfoMgr shareInstance].userId = userInfoDic[@"userId"];
        [KKUserInfoMgr shareInstance].userInfoModel.loginName = userInfoDic[@"loginName"];
        [KKUserInfoMgr shareInstance].userInfoModel.userLogoUrl = userInfoDic[@"userLogoUrl"];
        
        //2.user签名
        NSDictionary *userDic = responseDic[@"userPlatformLogin"];
        [[KKNetworkConfig shareInstance] saveUserInfo:@{
                                                        kNetConfig_id : userDic[@"userId"],
                                                        kNetConfig_loginKey : userDic[@"loginKey"],
                                                        kNetConfig_signKey  : userDic[@"signKey"],
                                                        kNetConfig_cryptKey : userDic[@"cryptKey"]
                                                        }];
        
        //3.重置rootVC
        [KKRootContollerMgr loadRootVC:nil];
    }];
}


#pragma mark - jump
- (void)pushToRoleCreateVC{
    //1.如果所有角色被停用了
    BOOL allRoleForbidden = YES;
    for (NSDictionary *roleDic in self.rolesMutArr) {
        if (![roleDic[@"forbidden"] boolValue]) {
            allRoleForbidden = NO;
        }
    }
    
    //2.跳转
    KKRoleCreateVC *createVC = [[KKRoleCreateVC alloc]init];
    createVC.asDefaultRoleLogin = allRoleForbidden;
    [self.navigationController pushViewController:createVC animated:YES];
}

@end
