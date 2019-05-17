//
//  UIViewController+Alert.m
//
//  Created by david on 2018/11/29.
//  Copyright © 2018 david. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <objc/runtime.h>

static const char *associatedAlertKey = "associatedAlertKey";

@implementation UIViewController (PPAlert)

#pragma mark - 关联对象
-(void)setAssociatedAlert:(UIAlertController *)alert{
    objc_setAssociatedObject(self, associatedAlertKey, alert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)associatedAlert {
    UIAlertController *alert = objc_getAssociatedObject(self, associatedAlertKey);
    return alert;
}


#pragma mark - 警告框 提醒
-(void)alertWithTitle:(NSString *)title message:(NSString *)message{
    [self alertWithTitle:title message:message duration:1.0f];
}

/** 显示警告框 */
-(void)alertWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration{
    //1.创建AlertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //设置关联对象
    [self setAssociatedAlert:alert];
    
    
    if(title.length){
        NSMutableAttributedString *attributedTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedTitleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, title.length)];
        [alert setValue:attributedTitleStr forKey:@"attributedTitle"];
    }
    
    if (message.length) {
        NSMutableAttributedString *attributedMsgStr = [[NSMutableAttributedString alloc] initWithString:message];
        [attributedMsgStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, message.length)];
        [alert setValue:attributedMsgStr forKey:@"attributedMessage"];
    }
    
    //2.显示AlertController
    [self presentViewController:alert animated:YES completion:nil];
    
    //3.定时收起警告框
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(performDismiss) userInfo:nil repeats:NO];
}

/** 收起警告框 */
-(void) performDismiss{
    UIAlertController *alert = [self associatedAlert];
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 警告框 操作
-(void)alert:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions{
    
    [self alert:style Title:title titleFontSize:17.0 message:message messageFontSize:15 actions:actions];
}

-(void)alert:(UIAlertControllerStyle)style Title:(NSString *)title titleFontSize:(float)titleFontSize message:(NSString *)message messageFontSize:(float)messageFontSize actions:(NSArray<UIAlertAction *> *)actions{
    //1.创建AlertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    //title
    if(title.length){
        NSMutableAttributedString *attributedTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedTitleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:titleFontSize] range:NSMakeRange(0, title.length)];
        [alert setValue:attributedTitleStr forKey:@"attributedTitle"];
    }
    //message
    if (message.length) {
        NSMutableAttributedString *attributedMsgStr = [[NSMutableAttributedString alloc] initWithString:message];
        [attributedMsgStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:messageFontSize] range:NSMakeRange(0, message.length)];
        [alert setValue:attributedMsgStr forKey:@"attributedMessage"];
    }
    
    //2.添加action
    for (NSInteger i=0; i<actions.count; i++) {
        [alert addAction:actions[i]];
    }
    
    //3.显示AlertController
    [self presentViewController:alert animated:YES completion:nil];
}
- (CGFloat)labelTextAttributed:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    if (!text) {
        return 0;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle};
    return [[[NSAttributedString alloc]initWithString:text attributes:attributes] boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}

/**
 lastVC

 @param vc 最后的VC 去哪里
 @param destVC 第一个vc 从哪里来
 */
- (void)lastVC:(UIViewController *)vc fromWhereClassVC:(Class)destVC{
    UINavigationController *navigationVC = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    /// 遍历导航控制器中的控制器
    for (UIViewController *vc in navigationVC.viewControllers) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:destVC]) {
            break;
        }
    }
    [viewControllers addObject:vc];
    /// 把控制器重新添加到导航控制器
    [navigationVC setViewControllers:viewControllers animated:YES];
    self.navigationController.viewControllers = viewControllers;
}
@end
