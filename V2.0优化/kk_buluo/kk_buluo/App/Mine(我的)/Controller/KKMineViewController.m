//
//  KKMineViewController.m
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMineViewController.h"
#import "KKLoginVC.h"
#import "KKRegisterVC.h"
#import "KKSettingVC.h"
#import "KKUserInfoCompleteVC.h"
#import "KKUserFeedbackVC.h"
#import "KKMyWebAppListViewController.h"
#import "KKMyQRCodeViewController.h" //我的二维码
//view
#import "KKMineTableHeaderView.h"
//model
#import "KKUserHomeModel.h"

@interface KKMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _cellHeight;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) KKMineTableHeaderView *mineTableHeaderView;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) KKUserHomeModel *userHomeModel;

@end

@implementation KKMineViewController

#pragma mark - lazy load
-(NSArray *)arr {
    if (!_arr) {
        _arr = @[@"我的二维码",@"我的应用",@"用户反馈",@"设置"];
    }
    return _arr;
}

-(KKMineTableHeaderView *)mineTableHeaderView {
    if (!_mineTableHeaderView) {
        CGFloat headerViewH = iPhoneX ? [ccui getRH:287+24] : [ccui getRH:287];
        _mineTableHeaderView = [[KKMineTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewH)];
    }
    return _mineTableHeaderView;
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
    
    [self requstMyInfo];
    [[KKUserInfoMgr shareInstance] requestUserInfo:nil];
}


#pragma mark - UI
-(void)setDimension {
    _cellHeight = [ccui getRH:50];
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeClear];
}

-(void)setupUI {
    
    //1.创建tableView
    UITableView *tableV = [[UITableView alloc]init];
    self.tableView = tableV;
    if (@available(iOS 11.0, *)) {
        tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //tableHeaderV
    tableV.tableHeaderView = self.mineTableHeaderView;
    
    //tableFooterV
    tableV.tableFooterView = [[UIView alloc]init];
}


#pragma mark  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
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
    NSString *title = self.arr[row];
    cell.textLabel.text = title;
    cell.textLabel.textColor = COLOR_HEX(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:[ccui getRH:15]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if([title isEqualToString:@"我的二维码"]){
        UIImageView *imgV = [[UIImageView alloc]initWithImage:Img(@"mine_icon_qrCode")];
        [cell.contentView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-[ccui getRH:1]);
            make.width.height.mas_equalTo(15);
        }];
    }
    
    //3.return
    return cell;
}

#pragma mark  UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *title = self.arr[indexPath.row];
    UIViewController *vc;
    if ([title isEqualToString:@"设置"]) {
        vc = [[KKSettingVC alloc]init];
    }else if ([title isEqualToString:@"完善信息"]) {
        vc = [[KKUserInfoCompleteVC alloc]init];
    }else if ([title isEqualToString:@"用户反馈"]) {
        vc = [[KKUserFeedbackVC alloc]init];
    }else if ([title isEqualToString:@"我的二维码"]) {
        [self presentMyQRcodeVC];
    }else if ([title isEqualToString:@"我的应用"]) {
        vc = [[KKMyWebAppListViewController alloc]init];
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

#pragma mark - request
-(void)requstMyInfo {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_HOME_INDEX" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error atView:self.view];
            
        }else{
            
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            self.userHomeModel = [KKUserHomeModel mj_objectWithKeyValues:responseDic];
            self.mineTableHeaderView.model = self.userHomeModel;
        }
    }];
}


#pragma mark - jump
-(void)presentMyQRcodeVC{
    KKMyQRCodeViewController *myQRCodeVC = [[KKMyQRCodeViewController alloc]initWithType:QRCodeTypeUSER withId:nil];
    [self presentViewController:myQRCodeVC animated:YES completion:nil];
}


@end
