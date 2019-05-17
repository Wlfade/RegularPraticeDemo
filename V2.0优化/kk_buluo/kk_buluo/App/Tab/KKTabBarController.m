//
//  KKTabBarController.m
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKTabBarController.h"
#import "BaseNavigationController.h"

//#import "KKMainViewController.h"
#import "KKDynamicManagerViewController.h"

#import "KKChatListVC.h"
#import "KKContactViewController.h"
#import "KKMineViewController.h"
#import "KKDiscoverVC.h"
//view
#import "UITabBar+Lottie.h"

@interface KKTabBarController ()<UINavigationControllerDelegate,UITabBarControllerDelegate>

@end

@implementation KKTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        [self setupTabNavi];
        [self setupChildViewControllers];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - UI
-(void)setupTabNavi {
    ///.tab
    //解决从二级页面返回tarBarItem跳动的问题
    [[UITabBar appearance] setTranslucent:NO];
    self.tabBar.tintColor = COLOR_BLACK_TEXT;
    
    ///2.navi
    NSDictionary *textAttributes = @{NSFontAttributeName : Font(19), NSForegroundColorAttributeName : COLOR_BLACK_TEXT};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];//title字体属性
    [[UINavigationBar appearance] setTintColor:COLOR_BLACK_TEXT];//返回图标,文字的颜色
    //[[UINavigationBar appearance] setBarTintColor:COLOR_HEX(0x0099ff)];//背景色
    
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];//不显示返回按钮的文字
    
    UIImage *naviBackImage = [UIImage imageNamed:@"navi_back_gray"];
    [[UINavigationBar appearance] setBackIndicatorImage:naviBackImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:naviBackImage];
}

- (void)setupChildViewControllers {

    ///1.childVC
    // 首页
//    KKMainViewController *mainVC = [[KKMainViewController alloc] init];
    KKDynamicManagerViewController *mainVC = [[KKDynamicManagerViewController alloc] init];
//    mainVC.contentScrollViewHeigh = SCREEN_HEIGHT - TAB_BAR_HEIGHT;
    mainVC.contentScrollViewHeigh = SCREEN_HEIGHT - TAB_BAR_HEIGHT;

    mainVC.topY = STATUS_BAR_HEIGHT;
    
//    mainVC.tabBarItem.image = [[UIImage imageNamed:@"tab_home_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    mainVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //如果不设置图片, 下边设的title不显示
    mainVC.tabBarItem.image = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    mainVC.tabBarItem.selectedImage = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    mainVC.tabBarItem.title = @"首页";
    
    
    // 聊天
    NSArray *displayTypes = @[@(ConversationType_PRIVATE),
                              @(ConversationType_DISCUSSION),
                              @(ConversationType_CHATROOM),
                              @(ConversationType_GROUP),
                              @(ConversationType_PUBLICSERVICE)];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    NSArray *collectionTypes = @[@(ConversationType_CUSTOMERSERVICE),
                                 @(ConversationType_SYSTEM),
                                 @(ConversationType_PUSHSERVICE),
                                 @(ConversationType_APPSERVICE)];
    KKChatListVC *chatListVC = [[KKChatListVC alloc] initWithDisplayConversationTypes:displayTypes collectionConversationType:collectionTypes];
//    chatListVC.tabBarItem.image = [[UIImage imageNamed:@"tab_chat_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    chatListVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_chat_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chatListVC.tabBarItem.image = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    chatListVC.tabBarItem.selectedImage = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    chatListVC.tabBarItem.title = @"聊天";
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:chatListVC selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
    
    // 发现
    KKDiscoverVC *discoverVC = [[KKDiscoverVC alloc] init];
    discoverVC.tabBarItem.image = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    discoverVC.tabBarItem.selectedImage = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    discoverVC.tabBarItem.title = @"发现";
    
    // 通讯录
    KKContactViewController *contactVC = [[KKContactViewController alloc] init];
//    contactVC.tabBarItem.image = [[UIImage imageNamed:@"tab_contact_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    contactVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_contact_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactVC.tabBarItem.image = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    contactVC.tabBarItem.selectedImage = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    contactVC.tabBarItem.title = @"通讯录";
    
    // 我的
    KKMineViewController *mineVC = [[KKMineViewController alloc] init];
//    mineVC.tabBarItem.image = [[UIImage imageNamed:@"tab_mine_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.image = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    mineVC.tabBarItem.selectedImage = [UIImage imageWithColor:UIColor.clearColor size:CGSizeMake(10, 10)];
    mineVC.tabBarItem.title = @"我的";
    
    
    //添加childVC
    self.viewControllers = @[
                             [[BaseNavigationController alloc] initWithRootViewController:mainVC],
                             [[BaseNavigationController alloc] initWithRootViewController:chatListVC],
                             [[BaseNavigationController alloc] initWithRootViewController:discoverVC],
                             [[BaseNavigationController alloc] initWithRootViewController:contactVC],
                             [[BaseNavigationController alloc] initWithRootViewController:mineVC]
                             ];
    
    for (BaseNavigationController *viewController in self.viewControllers) {
        viewController.delegate = self;
    }
    
    ///2. lottie
    [self setupTabLottieView];
    [self.tabBar animationLottieImage:0];
}

- (void)setupTabLottieView {
    [self.tabBar addLottieImage:0 lottieName:@"tab_home"];
    [self.tabBar addLottieImage:1 lottieName:@"tab_chat"];
    [self.tabBar addLottieImage:2 lottieName:@"tab_discover"];
    [self.tabBar addLottieImage:3 lottieName:@"tab_contact"];
    [self.tabBar addLottieImage:4 lottieName:@"tab_mine"];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //不隐藏, 由viewcontroller自己决定navigationBar的隐藏显示
    //[navigationController setNavigationBarHidden:NO animated:YES];
    
    viewController.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([self.tabBar.items containsObject:item]) {
        NSInteger index = [self.tabBar.items indexOfObject:item];
        [self.tabBar animationLottieImage:(int)index];
    }
}

@end
