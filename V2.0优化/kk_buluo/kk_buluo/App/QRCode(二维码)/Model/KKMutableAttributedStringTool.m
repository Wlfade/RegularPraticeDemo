//
//  KKMutableAttributedStringTool.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMutableAttributedStringTool.h"

@implementation KKMutableAttributedStringTool
+ (NSMutableAttributedString *)makeTheStrings:(NSArray *)strings withColors:(NSArray *)colors withFonts:(NSArray *)fonts{
    NSString *string = [strings componentsJoinedByString:@""];
    NSMutableAttributedString *notStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSInteger count = strings.count;
    for (int i = 0; i<count; i ++) {
        NSRange range = [string rangeOfString:strings[i]];
        [notStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:range];
        [notStr addAttribute:NSFontAttributeName value:fonts[i] range:range];
    }
    
    return notStr;
}
+ (NSMutableAttributedString *)makeTheStrings:(NSArray *)strings withColors:(NSArray *)colors withFonts:(NSArray *)fonts withDeleteLineIndex:(NSInteger)index{
    NSString *string = [strings componentsJoinedByString:@""];
    NSMutableAttributedString *notStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSInteger count = strings.count;
    for (int i = 0; i<count; i ++) {
        NSRange range = [string rangeOfString:strings[i]];
        [notStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:range];
        [notStr addAttribute:NSFontAttributeName value:fonts[i] range:range];
        if (i == index) {
            [notStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle)  range:range];
        }
    }
    return notStr;
}

+ (NSAttributedString *)makeTextAttachmentWithImagName:(NSString *)imageName withImageSize:(CGSize )imageSize{
    //设置Attachment
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    //使用一张图片作为Attachment数据
    attachment.image = [UIImage imageNamed:imageName];
    
    //    attachment.image = [UIImage imageNamed:@"join_chat_icon"];
    //这里bounds的x值并不会产生影响
    attachment.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    return imgStr;
}

@end
