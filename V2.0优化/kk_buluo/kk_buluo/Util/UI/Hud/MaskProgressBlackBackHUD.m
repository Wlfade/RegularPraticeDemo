//
//  MaskProgressBlackBackHUD.m
//  HHSLive
//
//  Created by 杜文杰 on 2017/6/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MaskProgressBlackBackHUD.h"

@implementation MaskProgressBlackBackHUD
+(instancetype)hudStartAnimatingAndAddToView:(UIView *)view
{
    MaskProgressBlackBackHUD *blackBackView = [[MaskProgressBlackBackHUD alloc] initWithFrame:view.bounds];
    blackBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:.01];
    [view addSubview:blackBackView];
    
    blackBackView.activityProHUD = [MaskProgressHUD hudStartAnimatingAndAddToView:blackBackView];
    return blackBackView;
}

+(instancetype)defaultBackBlackHUDFrame:(CGRect)rect
{
    MaskProgressBlackBackHUD *blackBackView = [[MaskProgressBlackBackHUD alloc] initWithFrame:rect];
    blackBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:.01];
    
    blackBackView.activityProHUD = [MaskProgressHUD hudStartAnimatingAndAddToView:blackBackView];
    return blackBackView;
}


-(void)stop
{
    [self.activityProHUD  stop];
    [self removeFromSuperview];
}
@end
