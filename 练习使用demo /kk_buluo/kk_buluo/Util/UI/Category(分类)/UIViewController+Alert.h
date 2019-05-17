//
//  UIViewController+Alert.h
//
//  Created by david on 2018/11/29.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PPAlert)

#pragma mark - 警告框 提醒
-(void)alertWithTitle:(NSString *)title message:(NSString *)message;
-(void)alertWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration;

#pragma mark - 警告框 操作
-(void)alert:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions;

-(void)alert:(UIAlertControllerStyle)style Title:(NSString *)title titleFontSize:(float)titleFontSize message:(NSString *)message messageFontSize:(float)messageFontSize actions:(NSArray<UIAlertAction *> *)actions;
- (CGFloat)labelTextAttributed:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;
/**
 lastVC
 
 @param vc 最后停留的vc
 @param destVC 来自哪一个vc
 */
- (void)lastVC:(UIViewController *)vc fromWhereClassVC:(Class)destVC;
@end
