//
//  KKAboutUsVC.m
//  kk_buluo
//
//  Created by david on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKAboutUsVC.h"

@interface KKAboutUsVC ()

@end

@implementation KKAboutUsVC
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"关于我们"];
}

-(void)setupUI {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //1.icon
    CGFloat iconW = [ccui getRH:83];
    CGFloat iconOriginY = STATUS_AND_NAV_BAR_HEIGHT + [ccui getRH:80];
    UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iconW)/2, iconOriginY, iconW, iconW)];
    iconImgV.image = [UIImage imageNamed:@"kklogo"];
    [self.view addSubview:iconImgV];
    
    //2.nameLabel
    CGFloat appNameLabelW = [ccui getRH:120];
    UILabel *appNameL = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-appNameLabelW)/2, iconImgV.bottom+[ccui getRH:10], appNameLabelW, 20)];
    [self.view addSubview:appNameL];
    
    appNameL.font = [ccui getRFS:16];
    appNameL.textAlignment = NSTextAlignmentCenter;
    appNameL.textColor = RGB(6, 6, 6);
    appNameL.text = appName;
    
    //3.VersionL
    CGFloat versionLabelW = [ccui getRH:80];
    UILabel *versionL = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-versionLabelW)/2, appNameL.bottom+[ccui getRH:10], versionLabelW, 15)];
    [self .view addSubview:versionL];
    
    versionL.font = [ccui getRFS:14];
    versionL.textAlignment = NSTextAlignmentCenter;
    versionL.textColor = RGB(102, 102, 102);
    versionL.text = [NSString stringWithFormat:@"V%@",appVersion];
}

@end
