//
//  MenuItem.m
//  01-微博动画（启动动画）
//
//  Created by 王玲峰 on 2017/11/15.
//  Copyright © 2017年 王玲峰. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem
+(instancetype)itemWithTitle:(NSString *)title withImage:(UIImage *)image{
    MenuItem *item = [[self alloc]init];
    
    item.title = title;
    item.image = image;
    
    return item;

}
+(instancetype)itemWithTitle:(NSString *)title withImage:(UIImage *)image withSelectedImage:(UIImage *)selectedImage{
    MenuItem *item = [[self alloc]init];
    
    item.title = title;
    item.image = image;
    item.selectedImage = selectedImage;
    
    return item;
}
@end
