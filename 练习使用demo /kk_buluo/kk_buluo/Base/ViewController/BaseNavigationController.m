//
//  BaseNavigationController.m
//  DGTool
//
//  Created by david on 2018/12/26.
//  Copyright © 2018 david. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"navi_back_gray"];
//    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navi_back_gray"];
}

#pragma mark rotate
-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

#pragma mark - StatusBar

-(UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;//之前这里是self.visibleViewController;
    /*
     这里若写为visibleViewController,会导致此naviVC进行present去展示pVC,在dismiss时,更新的是pVC的状态栏,
     只有在naviVC的viewDidLoad之后调用[self setNeedsStatusBarAppearanceUpdate]才会调用naviVC的zVC的状态栏
     */
}

-(UIViewController *)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

#pragma mark - push pop
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    

//    if (self.viewControllers.count != 0 ) {
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonDidClick)];
//    }
//    [self updateNavigationBarAppearanceForViewController:viewController];
    
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count >= 2) {
        UIViewController *viewController = self.viewControllers[self.viewControllers.count - 2];
        
        //[self updateNavigationBarAppearanceForViewController:viewController];
    }
    
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    return viewController;
}


#pragma mark - backBtn
- (void)leftBarButtonDidClick {
    if (self) {
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark - NavigationBarAppearance
- (void)updateNavigationBarAppearanceForViewController:(UIViewController *)controller {
    
    UIStatusBarStyle statusBarStyle = controller.preferredStatusBarStyle;
    switch (statusBarStyle) {
        case UIStatusBarStyleDefault:
            self.navigationBar.barTintColor = UIColor.whiteColor;
            self.navigationBar.tintColor = UIColor.blackColor;
            self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor};
            break;
        case UIStatusBarStyleLightContent:
            self.navigationBar.barTintColor = UIColor.blackColor;
            self.navigationBar.tintColor = UIColor.whiteColor;
            self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
            break;
        default:
            break;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
