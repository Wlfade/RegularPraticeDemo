//
//  ScanViewController.h
//  LotteryOrderSystem
//
//  Created by adu on 2018/6/20.
//  Copyright © 2018 杭州鼎代. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController

/** 提示Label */
@property(nonatomic,strong)UILabel *reminderL;

//获取的扫描结果字符串 处理方法
- (void)makeTheResultDict:(NSDictionary *)resultDict;

//获取的扫描结果字符串的是否为通过的 处理方法
-(BOOL)judgeValidityQRUrlStr:(NSString *)urlString;

- (void)startTimerAndScan;

//presentAlert弹窗
-(void)presentAlertWithTitle:(NSString *)title msg:(NSString *)msg hasAction:(BOOL)hasAction;
@end
