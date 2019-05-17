//
//  MenuItem.h
//  01-微博动画（启动动画）
//
//  Created by 王玲峰 on 2017/11/15.
//  Copyright © 2017年 王玲峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MenuItem : NSObject
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIImage *selectedImage;
@property (nonatomic,assign)BOOL isSelected; //是否为选中状态

@property (nonatomic,strong)void(^cleckBlock)(void);

//跳转的控制器
@property (nonatomic,strong)Class destVC;

+(instancetype)itemWithTitle:(NSString *)title withImage:(UIImage *)image;

+(instancetype)itemWithTitle:(NSString *)title withImage:(UIImage *)image withSelectedImage:(UIImage *)selectedImage;
@end
