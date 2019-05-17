//
//  SubmitView.m
//  JCZJ
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//
#import "AppDelegate.h"
#import "SubmitView.h"

@implementation SubmitView
@synthesize textString,myImageType;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIView *submitView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    submitView.backgroundColor=RGBA(0, 0, 0, .7);
    [self addSubview:submitView];
    
    UIImageView *submitImageView=[[UIImageView alloc]initWithFrame:CGRectMake(submitView.frame.size.width/2-25, 20, 50, 50)];
    if (myImageType==CheckMark) {
        submitImageView.image=[UIImage imageNamed:@"弹窗-勾"];
    }else if (myImageType==YellowStar){
        submitImageView.image=[UIImage imageNamed:@"弹窗-已收藏"];
    }else if (myImageType==FakeStar){
        submitImageView.image=[UIImage imageNamed:@"弹窗-取消收藏"];
    }else if (myImageType==Fork){
        submitImageView.image=[UIImage imageNamed:@"弹窗-叉"];
    }
    
    [submitView addSubview:submitImageView];
    
    UILabel *submitLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.frame.size.width, 40)];
    submitLabel.backgroundColor=[UIColor clearColor];
    submitLabel.textColor=[UIColor whiteColor];
    submitLabel.font=[UIFont systemFontOfSize:14];
    submitLabel.textAlignment=NSTextAlignmentCenter;
    [submitView addSubview:submitLabel];
    submitLabel.text=textString;
    submitLabel.numberOfLines=2;
    
    [submitView.layer setMasksToBounds:YES];
    [submitView.layer setCornerRadius:4]; //设置矩形四个圆角半径
    
    submitView.alpha=0;
    [UIView animateWithDuration:.5f animations:^{
        submitView.alpha=1;
    } completion:^(BOOL finished) {
        double delayInSeconds = 1.5;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [UIView animateWithDuration:.5f animations:^{
                submitView.alpha=0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
        
    }];
    
}


@end
