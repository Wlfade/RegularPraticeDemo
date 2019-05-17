//
//  MiSearchBar.h
//  miSearch
//
//  Created by miicaa_ios on 16/8/3.
//  Copyright (c) 2016年 xuxuezheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MiSearchReturnDelegate<NSObject>
//协议方法实现弹出视图字符串的回传 写一个协议方法
- (void)searchReturnText:(NSString *)text;

@end
@interface MiSearchBar : UISearchBar
@property (strong, nonatomic) UITextField *searchTextField;

//根据协议写一个代理 用于传值 ARC 中代理属性必须使用weak 属性 防止循环引用
@property (nonatomic,weak)id<MiSearchReturnDelegate>resultStrDelegate;

-(id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

@end
