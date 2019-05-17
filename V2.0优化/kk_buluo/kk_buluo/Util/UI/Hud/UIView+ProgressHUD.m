//
//  UIView+ProgressHUD.m
//  HHSLive
//
//  Created by 郦道元  on 2017/8/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIView+ProgressHUD.h"
#import "MaskProgressHUD.h"
#import "MaskProgressBlackBackHUD.h" 
const char hh_mask_progress_hud_key;
const char bb_mask_progress_black_back_hud_key;

@implementation UIView (ProgressHUD)

// 无背景的loading
-(MaskProgressHUD *)maskProgressHUD
{
    
    MaskProgressHUD *maskProgress = objc_getAssociatedObject(self, &hh_mask_progress_hud_key);
    if (maskProgress == nil) {
        maskProgress = [MaskProgressHUD defaultMaskProgressHUD];
        [self setMaskProgressHUD:maskProgress];
    }
    return maskProgress;
}

-(void)setMaskProgressHUD:(MaskProgressHUD *)maskProgressHUD{
    [self willChangeValueForKey:@"maskProgressHUD"];
    objc_setAssociatedObject(self, &hh_mask_progress_hud_key, maskProgressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"maskProgressHUD"];
}


// 有背景的loading
-(MaskProgressBlackBackHUD *)maskProgressBlackBackHUD
{

    MaskProgressBlackBackHUD *maskProgressBlackBackHud = objc_getAssociatedObject(self, &bb_mask_progress_black_back_hud_key);
    if (maskProgressBlackBackHud == nil) {
        maskProgressBlackBackHud = [MaskProgressBlackBackHUD defaultBackBlackHUDFrame:self.bounds];
        [self setMaskProgressBlackBackHUD:maskProgressBlackBackHud];
    }
    return maskProgressBlackBackHud;
}

-(void)setMaskProgressBlackBackHUD:(MaskProgressBlackBackHUD *)maskProgressBlackBackHUD{
    [self willChangeValueForKey:@"maskProgressBlackBackHUD"];
    objc_setAssociatedObject(self, &bb_mask_progress_black_back_hud_key, maskProgressBlackBackHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"maskProgressBlackBackHUD"];
}






-(void)showMaskProgressHUD
{
    [self.maskProgressHUD setCenter:self.center];
    [self addSubview:self.maskProgressHUD];
}

-(void)showMaskProgressHUDWithTitle:(NSString *)title
{
    [self.maskProgressHUD setCenter:self.center];
    [self.maskProgressHUD setTitleStr:title];
    [self addSubview:self.maskProgressHUD];
}

-(void)hiddenMaskProgressHUD
{
    [self.maskProgressHUD stop];
    [self setMaskProgressHUD:nil];
}
-(void)showMaskProgressHUDInWindow{
    [self.maskProgressHUD setCenter:self.lastWindow.center];
    [self.lastWindow addSubview:self.maskProgressHUD];

}

-(void)hiddenMaskProgressHUDInWindow{
    [self.maskProgressHUD stop];
    [self setMaskProgressHUD:nil];
}


// 带有背景的loading
-(void)showMaskProgressBlackBackHUD
{
    [self addSubview:self.maskProgressBlackBackHUD];
}



-(void)hiddenMaskProgressBlackBackHUD
{
    [self.maskProgressHUD stop];
    [self.maskProgressBlackBackHUD removeFromSuperview];
    [self setMaskProgressBlackBackHUD:nil];
}



-(UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            window.hidden = NO;
        return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

@end
