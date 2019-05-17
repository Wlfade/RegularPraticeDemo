//
//  KKSettingVC.m
//  Rainbow
//
//  Created by david on 2019/1/10.
//  Copyright © 2019 gwh. All rights reserved.
//

#import "KKSettingVC.h"
#import "KKRoleSelectVC.h"
#import "KKPwdMgrVC.h"
#import "KKRealNameVerifyVC.h"
#import "KKAboutUsVC.h"

//三方
#import "SDImageCache.h"

@interface KKSettingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _leftSpace;
    CGFloat _topSpace;
    CGFloat _cellHeight;
}

@property (nonatomic,strong)NSArray *cellTitleArr;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) DGButton *logoutButton;

@end

@implementation KKSettingVC

#pragma mark - lazy load
-(NSArray *)cellTitleArr {
    if (!_cellTitleArr) {
        _cellTitleArr = @[@"切换角色",@"密码管理",@"实名认证",@"清理缓存",@"推送通知",@"提示音开关",@"关于KK部落"];
    }
    return _cellTitleArr;
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
    [self.tableView reloadData];
}

#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:20];
    _topSpace = [ccui getRH:10];
    _cellHeight = [ccui getRH:50];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"设置"];
}

-(void)setupUI {
    
    CGFloat h = SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT -_topSpace - HOME_INDICATOR_HEIGHT;
    UITableView *tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT+_topSpace, SCREEN_WIDTH, h) style:UITableViewStylePlain];
    self.tableView = tableV;
    [self.view addSubview:tableV];
    
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = self.view.backgroundColor;
    
    //tableFooterView
    DGButton *logoutBtn = [DGButton btnWithFontSize:[ccui getRH:16] bold:NO title:@" 退出登录" titleColor:UIColor.redColor bgColor:UIColor.whiteColor];
    self.logoutButton = logoutBtn;
    logoutBtn.frame = CGRectMake([ccui getRH:10],[ccui getRH:60], SCREEN_WIDTH - 2*[ccui getRH:10], [ccui getRH:44]);
    [logoutBtn setImage:Img(@"set_logout") forState:UIControlStateNormal];
    logoutBtn.layer.cornerRadius = 4;
    logoutBtn.layer.masksToBounds = YES;
    
    WS(weakSelf);
    [logoutBtn addClickBlock:^(DGButton *btn) {
        [weakSelf showAlertForLogout];
    }];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:200])];
    footView.backgroundColor = self.view.backgroundColor;
    
    [footView addSubview:logoutBtn];
    tableV.tableFooterView = footView;
}

#pragma mark tool
-(UISwitch *)createSwitch {
    UISwitch *sw = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, [ccui getRH:53], [ccui getRH:32])];
    sw.onTintColor = rgba(42, 62, 255, 1);
    sw.tintColor = rgba(239, 239, 239, 1);
    //sw.transform = CGAffineTransformMakeScale(0.85,0.85);
    return sw;
}

#pragma mark - interaction
-(void)switchActionForNotifacation:(UISwitch *)sw {
    [KKRCloudMgr shareInstance].canPushNotification = sw.isOn;
}

-(void)switchActionForWarningTone:(UISwitch *)sw {
    [KKRCloudMgr shareInstance].canPlayAlertSound = sw.isOn;
}


#pragma mark - delegate
#pragma mark tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    //1.获取cell
    static NSString *cellId = @"setttingCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
        cell.textLabel.textColor = COLOR_BLACK_TEXT;
        cell.textLabel.font = Font([ccui getRH:15]);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);
        
        cell.detailTextLabel.font = Font([ccui getRH:15]);
        cell.detailTextLabel.textColor = COLOR_BLACK_TEXT;
    }
    
    //2.设置cell
    NSString *title = self.cellTitleArr[row];
    cell.textLabel.text = self.cellTitleArr[row];
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //2.1 accessoryView
    //实名认证
    if ([title isEqualToString:@"实名认证"]) {

        if([KKUserInfoMgr shareInstance].userInfoModel.certNo.length < 1){
            cell.detailTextLabel.textColor = UIColor.redColor;
            cell.detailTextLabel.text = @"未实名";
        }else{
            cell.detailTextLabel.textColor = COLOR_BLACK_TEXT;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[KKUserInfoMgr shareInstance].userInfoModel.realName,[KKUserInfoMgr shareInstance].userInfoModel.certNo];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else if ([title isEqualToString:@"推送通知"]){
        
        UISwitch *sw = [self createSwitch];
        sw.on = [KKRCloudMgr shareInstance].canPushNotification;
        [sw addTarget:self action:@selector(switchActionForNotifacation:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }else if ([title isEqualToString:@"提示音开关"]){
        
        UISwitch *sw = [self createSwitch];
        sw.on = [KKRCloudMgr shareInstance].canPlayAlertSound;
        [sw addTarget:self action:@selector(switchActionForWarningTone:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }
    
    //3.return
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    NSString *detailTitle = cell.detailTextLabel.text;
    
    //2.确定vc
    if ([title isEqualToString:@"切换角色"]) {
        vc = [[KKRoleSelectVC alloc]init];
        
    }else if ([title isEqualToString:@"密码管理"]) {
        vc = [[KKPwdMgrVC alloc]init];
        
    }else if ([title isEqualToString:@"实名认证"]) {
        if ([detailTitle isEqualToString:@"未实名"]){
            vc = [[KKRealNameVerifyVC alloc]init];
        }
        
    }else if ([title isEqualToString:@"清理缓存"]) {
        [self showAlertForClearMemory];
        return;
        
    }else if ([title isEqualToString:@"关于KK部落"]) {
        vc = [[KKAboutUsVC alloc]init];
    }
    
    
    //3.跳转
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - alert
-(void)showAlertForClearMemory {
    
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CC_NoticeView showError:@"清理完成"];
                });
            }];
        });
        [[KKRCloudMgr shareInstance] rcClearAllCache];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"提示" message:@"确定清理缓存吗？" actions:@[actionCancel,actionYes]];
}

-(void)showAlertForLogout {
    
    //1.action
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[KKUserInfoMgr shareInstance] logoutAndSetNil:nil];
        
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_HEX(0x666666) forKey:@"titleTextColor"];
    
    //2.alert
    [self alert:UIAlertControllerStyleAlert Title:@"提示" message:@"确定退出登录吗？" actions:@[actionCancel,actionYes]];
}

@end

