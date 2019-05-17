//
//  DGFont.m
//
//
//  Created by david on 2019/4/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "DGFont.h"

@implementation DGFont

+ (UIFont *)pingfangFontStyle:(PFFontStyle)fontStyle size:(CGFloat)fontSize {
    
    NSString *fontName = @"PingFangSC-Regular";
    switch (fontStyle) {
        case PFFontStyleMedium:
            fontName = @"PingFangSC-Medium";
            break;
        case PFFontStyleSemibold:
            fontName = @"PingFangSC-Semibold";
            break;
        case PFFontStyleLight:
            fontName = @"PingFangSC-Light";
            break;
        case PFFontStyleUltralight:
            fontName = @"PingFangSC-Ultralight";
            break;
        case PFFontStyleRegular:
            fontName = @"PingFangSC-Regular";
            break;
        case PFFontStyleThin:
            fontName = @"PingFangSC-Thin";
            break;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return font ? font : [UIFont systemFontOfSize:fontSize];
}

/**
 指定字体
 
 @param fontStyle 字体类型
 @param fontSize 字体大小
 @return 返回指定的字体
 */
+ (UIFont *)dgFontStyle:(DGFontStyle)fontStyle size:(CGFloat)fontSize {
    
    NSString *fontName = @"PingFangSC-Regular";
    switch (fontStyle) {
        case DGFontStyleFestivoLettersNo19:
            fontName = @"Festivo Letters No19";
            break;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return font ? font : [UIFont systemFontOfSize:fontSize];
}
@end
