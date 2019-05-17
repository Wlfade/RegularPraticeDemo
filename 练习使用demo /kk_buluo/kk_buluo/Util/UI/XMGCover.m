//
//  XMGCover.m
//  04- 小码哥彩票
//
//  Created by 王玲峰 on 2018/1/9.
//  Copyright © 2018年 王玲峰. All rights reserved.
//

#import "XMGCover.h"
@implementation XMGCover

+(void)show{
    XMGCover *cover = [[XMGCover alloc]initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    [[AppDelegate sharedAppDelegate].window addSubview:cover];
  //  [[UIApplication sharedApplication].keyWindow addSubview:cover];
}
+(void)showWithClear{
    XMGCover *cover = [[XMGCover alloc]initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor clearColor];

    [[AppDelegate sharedAppDelegate].window addSubview:cover];
}
+(void)hidden{
    for (UIView *childView in [AppDelegate sharedAppDelegate].window.subviews) {
        if([childView isKindOfClass:self]){
            [childView removeFromSuperview];
        }
    }
}
+(instancetype)showIn{
    XMGCover *cover = [[XMGCover alloc]initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;

    [[AppDelegate sharedAppDelegate].window addSubview:cover];
   // [[UIApplication sharedApplication].keyWindow addSubview:cover];

    return cover;
}
@end
