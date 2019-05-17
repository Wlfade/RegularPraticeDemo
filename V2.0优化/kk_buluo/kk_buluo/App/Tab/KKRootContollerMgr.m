//
//  KKRootContollerMgr.m
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRootContollerMgr.h"
#import "KKTabBarController.h"
#import "BaseNavigationController.h"
#import "KKLoginVC.h"

@implementation KKRootContollerMgr

#pragma mark - life circle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static KKRootContollerMgr *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark -
+ (void)loadRootVC:(nullable NSDictionary *)launchOptions {

    if([KKUserInfoMgr isLogin]){
        [self loadLTabAsRootVC];
    }else {
        [self loadLoginAsRootVC];
    }
    
}

+ (void)loadLoginAsRootVC {
    KKLoginVC *loginVC = [[KKLoginVC alloc] init];
    BaseNavigationController *loginNavi = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self setRootViewController:loginNavi];
}


+ (void)loadLTabAsRootVC {
    KKTabBarController *tabBarController = [[KKTabBarController alloc] init];
    [self setRootViewController:tabBarController];
}


#pragma mark -
+ (void)setRootViewController:(UIViewController *)viewController {
    //1.获取当前rootVC
    UIViewController *rootVC = [self rootViewController];
    
    //2.获取presentedVC层级
    NSMutableArray<UIViewController*> *tmpArray;
    while (rootVC.presentedViewController != nil) {
        UIViewController *topVC = rootVC.presentedViewController;
        rootVC = topVC;
        [tmpArray insertObject:rootVC atIndex:0];
    }
    //3.将presentedVC层级中的vc移除
    for (int i=0; i<tmpArray.count; i++) {
        UIViewController *vc = tmpArray[i];
        [vc dismissViewControllerAnimated:NO completion:nil];
    }
    
    //4.将rootVC的view移除
    [rootVC.view removeFromSuperview];

    //5.设置新的rootVC
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    window.rootViewController = viewController;
}

+ (UIViewController *)rootViewController {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    if (window) {
        UIViewController *rootVC = [window rootViewController];
        return rootVC;
    }
    return nil;
}


@end
