//
//  KKScaneViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKScaneViewController.h"

#import "KKPersonalPageController.h"

#import "KKMyQRCodeViewController.h"

@interface KKScaneViewController ()

@end

@implementation KKScaneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *myQrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [myQrCodeBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
//    myQrCodeBtn.titleLabel.font = [ccui getRFS:14];
//    [myQrCodeBtn setTitleColor:RGB(42, 62, 255) forState:UIControlStateNormal];
//
//    [myQrCodeBtn addTarget:self action:@selector(myQRcodeAction) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:myQrCodeBtn];
//
//    [myQrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.reminderL.mas_bottom).offset(10);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];
    
}
//这里可以重写判断 做处理 父类是 不是此APP域名的 二维码 无法识别
/** 验证二维码urlStr的有效性 */
-(BOOL)judgeValidityQRUrlStr:(NSString *)urlString {
    
    NSString *appDomainStr = [KKNetworkConfig shareInstance].domainStr;
    NSURL *appDomainStrUrl = [NSURL URLWithString:appDomainStr];
    NSString *appHostName = appDomainStrUrl.host;
    
    NSURL *resultUrl = [NSURL URLWithString:urlString];
    NSString *hostName = resultUrl.host;
    
    if ([hostName isEqualToString:appHostName]) {
        return YES;
    }else{
//        [self presentAlertWithTitle:@"提示" msg:@"无法识别该链接-1001" hasAction:YES];
        if ([self judgeIsUrl:urlString]) {
            NSString *openURL = urlString;
            
            
            NSURL *URL = [NSURL URLWithString:openURL];
            
            /**
             ios 10 以后使用  openURL: options: completionHandler:
             这个函数异步执行，但在主队列中调用 completionHandler 中的回调
             openURL:打开的网址
             options:用来校验url和applicationConfigure是否配置正确，是否可用。
             唯一可用@{UIApplicationOpenURLOptionUniversalLinksOnly:@YES}。
             不需要不能置nil，需@{}为置空。
             ompletionHandler:如不需要可置nil
             **/
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:URL options:@{} completionHandler:^(BOOL success) {
                    
                }];
            } else {
                /**
                 ios 9 之前使用
                 openURL:打开的网址
                 **/
                [[UIApplication sharedApplication]openURL:URL];
            }
            
            [self startTimerAndScan];
        }
        else{
           [self presentAlertWithTitle:@"提示" msg:@"识别失败" hasAction:YES];
        }
        return NO;
    }
}


#pragma mark - 判断字符串是否为URL地址
- (BOOL)judgeIsUrl:(NSString *)url{
    
    if(self == nil) {
        return NO;
    }
    if (url.length>4 && [[url substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}
//这里必须重写对数据的处理操作和交互
- (void)makeTheResultDict:(NSDictionary *)resultDict{

    NSString *objectIdStr = resultDict[@"objectId"];
    NSString *objectType = resultDict[@"objectType"];

    if([objectType isEqualToString:@"GROUP"]){
        NSString *expireTime = resultDict[@"expireTime"];
        if ([self isvalidabel:expireTime]) {
            [self dealwithTheDic:objectIdStr withType:objectType];
        }else{
            return;
        }
    }else{
        [self dealwithTheDic:objectIdStr withType:objectType];
    }
}
//处理逻辑
- (void)dealwithTheDic:(NSString *)objectIdStr withType:(NSString *)objectType{
    if (![HHObjectCheck isEmpty:objectIdStr] && ![HHObjectCheck isEmpty:objectType]) {
        
        KKPersonalPageController *personalPageVC = [[KKPersonalPageController alloc]init];
        
        if ([objectType isEqualToString:@"GUILD"]) {
            personalPageVC.personalPageType = PERSONAL_PAGE_GUILD;
        }else if([objectType isEqualToString:@"GROUP"]){
            personalPageVC.personalPageType = PERSONAL_PAGE_GROUP;
            
        }else if([objectType isEqualToString:@"USER"]){
            if ([objectIdStr isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
                personalPageVC.personalPageType = PERSONAL_PAGE_OWNER;
            }else{
                personalPageVC.personalPageType = PERSONAL_PAGE_OTHER;
            }
        }
        
        personalPageVC.userId = objectIdStr;
        [self.navigationController pushViewController:personalPageVC animated:YES];
        
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        NSLog(@"%@",mArr);
        
        [mArr removeObjectAtIndex:mArr.count -2];
        self.navigationController.viewControllers = mArr;
        
    }else{
        [CC_NoticeView showError:@"识别失败"];
    }
}
//判断时间是否有效
- (BOOL)isvalidabel:(NSString *)expireTime{
 
    NSMutableString *lateDate = [[NSMutableString alloc]initWithString:expireTime];
//    [lateDate appendString:@"000000"];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];//hh:12小时制,
    
    //将当前的时区时间String再转成标准的NSDate，转换后的时间是为格林威治时间，这样统一标准后才能用 timeIntervalSinceData比较
    NSDate *date = [dateFormat dateFromString:lateDate];
    
    NSLog(@"date:%@", date);
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSDate *locaeDatenow = [datenow  dateByAddingTimeInterval: interval];
    
    NSComparisonResult result = [localeDate compare:locaeDatenow];
    int ci;
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;
            break;
            //date02=date01
        case NSOrderedSame: ci=0;
            break;
        default:
            break;
    }
    NSLog(@"%d",ci);
    
    if (ci == 1 || ci == 0) {
        [self presentAlertWithTitle:@"提示" msg:@"该二维码已失效" hasAction:YES];
        return NO;
    }
    return YES;
}
//-(void)myQRcodeAction{
//    KKMyQRCodeViewController *myQRCodeVC = [[KKMyQRCodeViewController alloc]initWithType:QRCodeTypeUSER withId:nil];
//    [self presentViewController:myQRCodeVC animated:YES completion:nil];
//}
- (void)dealloc{
    
}
@end
