//
//  MaskProgressBlackBackHUD.h
//  HHSLive
//
//  Created by 杜文杰 on 2017/6/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaskProgressHUD.h"

@interface MaskProgressBlackBackHUD : UIView
@property (nonatomic,strong) MaskProgressHUD *activityProHUD;

// 默认的带有背景的loading
+(instancetype)defaultBackBlackHUDFrame:(CGRect)rect;

+(instancetype)hudStartAnimatingAndAddToView:(UIView *)view;

-(void)stop;
@end
