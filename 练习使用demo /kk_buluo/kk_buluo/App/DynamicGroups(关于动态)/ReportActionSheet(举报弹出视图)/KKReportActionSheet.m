//
//  KKReportActionSheet.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKReportActionSheet.h"

@implementation KKReportActionSheet
+ (void)KKReportActionSheetPersent:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择举报类型"message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"暴恐违禁"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"恶意推广"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"政治敏感"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"低俗辱骂"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"色情污秽"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"欺诈骗钱"style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
        
    }];
    [alertController addAction:action];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [alertController addAction:action5];
    [alertController addAction:cancelAction];
    
    [viewControllerToPresent presentViewController:alertController animated:flag completion:completion];
}
//举报发送到服务端
-(void)userReportRequest:(NSString *)reportContent
{
    //    GAlertView *gAlert = [[GAlertView alloc] initGAlertWithTitle:@"举报成功！" andContent:@"平台将会在24小时内处理您的举报信息" andCancel:nil andOk:@"确定"];
    //    [self.view addSubview:gAlert];
}
@end
