//
//  KKPwdMgrVC.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKPwdMgrVC.h"
#import "KKPwdModifyVC.h"
#import "KKVerifyPhoneNoVC.h"

@interface KKPwdMgrVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _leftSpace;
    CGFloat _topSpace;
}

@property(nonatomic,assign) KKPwdMgrType type;

@property(nonatomic,strong) NSArray *cellTitleArr;

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation KKPwdMgrVC

#pragma mark - lazy load
-(NSArray *)cellTitleArr {
    if (!_cellTitleArr) {
        
        BOOL hasSetPayPwd = [KKUserInfoMgr shareInstance].userInfoModel.accountPasswordSet;
        
        if (self.type == KKPwdMgrTypeForPayPwd) {
            if (hasSetPayPwd) {
                _cellTitleArr = @[@"修改密码",@"找回密码"];
            }else{
                _cellTitleArr = @[@"设置支付密码"];
            }
            
        }else{
            _cellTitleArr = @[@"修改密码",@"找回密码"];
        }
    }
    
    return _cellTitleArr;
}

#pragma mark - life circle
-(instancetype)initWithType:(KKPwdMgrType)type {
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
    [self setNaviBarTitle:@"密码管理"];
}

-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT+_topSpace, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT-_topSpace) style:UITableViewStylePlain];
    self.tableView = tableV;
    [self.view addSubview:tableV];
    
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = self.view.backgroundColor;
    
    //tableFooterV
    tableV.tableFooterView = [[UIView alloc]init];
}

#pragma mark - uitableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitleArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    //1.获取cell
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    //2.设置cell
    cell.textLabel.text = self.cellTitleArr[row];
    cell.textLabel.textColor = COLOR_HEX(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:[ccui getRH:15]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //3.return
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.获取cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    
    //2.确定vc
    UIViewController *vc;
    if ([title isEqualToString:@"修改密码"]) {
        KKPwdModifyType type = self.type==KKPwdMgrTypeForPwd ? KKPwdModifyTypeForPwd : KKPwdModifyTypeForPayPwd;
        KKPwdModifyVC *modifyVC = [[KKPwdModifyVC alloc]initWithType:type];
        vc = modifyVC;

    }else if ([title isEqualToString:@"找回密码"]){
        KKVerifyPhoneNoType type = self.type==KKPwdMgrTypeForPwd ? KKVerifyPhoneNoTypeForPwdReset : KKVerifyPhoneNoTypeForPayPwdReset;
        KKVerifyPhoneNoVC *verifyPhoneNoVC = [[KKVerifyPhoneNoVC alloc]initWithType:type];
        vc = verifyPhoneNoVC;

    }else if ([title isEqualToString:@"设置支付密码"]){
//        vc = [[KKPwdSetVC alloc]initWithType:KKPwdSetTypeForPayPwd];
    }
    
    //3.跳转
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
