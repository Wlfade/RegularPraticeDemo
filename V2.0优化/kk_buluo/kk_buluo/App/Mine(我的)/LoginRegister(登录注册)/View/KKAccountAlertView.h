//
//  BBAccountAlertView.h
//  BananaBall
//
//  Created by 万耀辉 on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKAccountAlertViewDelegate <NSObject>


- (void)AccountAlertViewButtonClickPassValue:(UIButton *)button AccountAlertView:(UIView *)AccountAlertView;

@end

@interface KKAccountAlertView : UIView

@property (nonatomic, weak) id <KKAccountAlertViewDelegate> delegate;

/** 桌面View */
@property (nonatomic,weak)UIView *destView;

-(id)initWithTitleString:(NSString *)titleString Second:(NSString *)secondString third:(NSString *)thirdString ButtonContent:(NSString *)buttString;

@end
