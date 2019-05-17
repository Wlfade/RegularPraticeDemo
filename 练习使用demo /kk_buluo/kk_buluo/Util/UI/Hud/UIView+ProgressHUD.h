//
//  UIView+ProgressHUD.h
//  HHSLive
//
//  Created by 郦道元  on 2017/8/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaskProgressHUD;
@class MaskProgressBlackBackHUD;
@interface UIView (ProgressHUD)


@property(nonatomic,strong)MaskProgressHUD *maskProgressHUD;
@property(nonatomic,strong)MaskProgressBlackBackHUD *maskProgressBlackBackHUD;


-(void)showMaskProgressHUD;

-(void)showMaskProgressHUDWithTitle:(NSString *)title;

-(void)hiddenMaskProgressHUD;

-(void)showMaskProgressHUDInWindow;

-(void)hiddenMaskProgressHUDInWindow;



// --默认带有背景的loading--  //

-(void)showMaskProgressBlackBackHUD;
-(void)hiddenMaskProgressBlackBackHUD;


//-(void)showMaskProgressHUDWithTitle:(NSString *)title;


//-(void)showMaskProgressBlackBackHUDInWindow;
//
//-(void)hiddenMaskProgressHUDInWindow;



@end
