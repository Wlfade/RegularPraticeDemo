//
//  KKReMakeDictionary.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKReMakeDictionary.h"

@implementation KKReMakeDictionary
/* 根据传入的 键数组 从对应的字典中取出数据 然后组成新的字典返回 key 与服务端给的保持一致 赋值给模型*/
+ (NSDictionary *)makeTheDictWithKeys:(NSArray *)keys
             fromTheOriginalDictonary:(NSDictionary *)dictionary{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        id value = dictionary[key];
        if (value) {
            [tempDict setValue:value forKey:key];
        }
    }
    NSDictionary *resulDic = [NSDictionary dictionaryWithDictionary:tempDict];
    
    return resulDic;
}

/**
 传入键值数组 取出 元素 赋值新字典替换键值 形成新字典
 
 @param oriKeys 目标字典中的键值数组
 @param transKeys 转换的键值数组
 @param dictionary 目标字典
 @return 新字典
 */
+ (NSDictionary *)makeTheDictWithOriginalKeys:(NSArray *)oriKeys
                            withTransMakeKeys:(NSArray *)transKeys
                     fromTheOriginalDictonary:(NSDictionary *)dictionary{
    NSInteger oriCount = oriKeys.count;
    NSInteger tranCount = transKeys.count;
    
    NSInteger count = oriCount<=tranCount? oriCount : tranCount;
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < count; i ++) {
        NSString *oriKey = oriKeys[i];
        NSString *transKey = transKeys[i];
        
        id value = dictionary[oriKey];
        if (value) {
            [tempDict setValue:value forKey:transKey];
        }
    }
    NSDictionary *resulDic = [NSDictionary dictionaryWithDictionary:tempDict];
    return resulDic;
}


/**
 通过text 转一个可变字符串
 @param textStr 内容
 @param textFont 字体大小
 @param textColor 颜色
 @param maxWidth 最大宽度
 @param maxHeight 最大高度
 @param fontFloat 图片大小
 @return 返回一个 带有内容 和 高度的字典
 */
+ (NSMutableDictionary *)getHtmlAttributedStringAndHeightWithString:(NSString *)textStr
                                                       withTextFont:(UIFont *)textFont
                                                      withTextColor:(UIColor *)textColor
                                                        withMaxWith:(CGFloat)maxWidth
                                                      withMaxHeight:(CGFloat)maxHeight
                                                     wihthImageFont:(CGFloat)fontFloat{
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    
    NSMutableDictionary *newDic=[[NSMutableDictionary alloc]init];
    
    NSString *origHtml=[NSString stringWithFormat:@"%@ ",textStr?textStr:@""];
    origHtml=[NSString stringWithFormat:@"%@",origHtml];
    
    
    NSString *formatStr = [NSString stringWithFormat:@" width=\"%lf\" height=\"%lf\" style=\"vertical-align:-20%%\" alt=",fontFloat,fontFloat];
    
    //替换字符串
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@" alt=" withString:formatStr];
    
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"</h1>" withString:@""];
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"<h1 style = \"color:blue\">" withString:@""];

    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSMutableAttributedString *htmlString = [[NSMutableAttributedString alloc] initWithData:[origHtml dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    [htmlString addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0,htmlString.length)];
    [htmlString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0,htmlString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    paragraphStyle.lineSpacing=4;
//    paragraphStyle.maximumLineHeight = 30.0f;
    paragraphStyle.maximumLineHeight = 18.0f;
    
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,htmlString.length)];
    [htmlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0,htmlString.length)];
    
    
#warning -25
    //    NSString *newStr=[NSString stringWithFormat:@"%@",origHtml];
    //    CC_AttributedStr *at;
    //    newStr=[at cutHtmlTagFromStr:newStr withTagName:@"img" toStr:@"图" trimSpace:YES];
    CGRect summaryRect = [htmlString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
    CGSize summarySize = summaryRect.size;
    //    NSString *height = [NSString stringWithFormat:@"%f",summarySize.height]?:@"0";
    NSNumber *height = [NSNumber numberWithFloat:summarySize.height];
    
    [newDic setObject:height forKey:@"height"];
    if (htmlString==nil) {
        [newDic setObject:[[NSMutableAttributedString alloc] initWithString:@""] forKey:@"html"];
    }else
    {
        [newDic setObject:htmlString forKey:@"html"];
    }
    
    return newDic;
}
+ (NSMutableDictionary *)getHtmlAttributedStringAndHeightWithString:(NSString *)textStr
                                                       withTextFont:(UIFont *)textFont
                                                      withTextColor:(UIColor *)textColor
                                                        withMaxWith:(CGFloat)maxWidth
                                                      withMaxHeight:(CGFloat)maxHeight
                                                     wihthImageFont:(CGFloat)fontFloat
                                                   withLineSpaceing:(CGFloat)lineSpace{
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    
    NSMutableDictionary *newDic=[[NSMutableDictionary alloc]init];
    
    NSString *origHtml=[NSString stringWithFormat:@"%@ ",textStr?textStr:@""];
    origHtml=[NSString stringWithFormat:@"%@",origHtml];
    
    
    NSString *formatStr = [NSString stringWithFormat:@" width=\"%lf\" height=\"%lf\" style=\"vertical-align:-20%%\" alt=",fontFloat,fontFloat];
    
    //替换字符串
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@" alt=" withString:formatStr];
    
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSMutableAttributedString *htmlString = [[NSMutableAttributedString alloc] initWithData:[origHtml dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    [htmlString addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0,htmlString.length)];
    [htmlString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0,htmlString.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    paragraphStyle.lineSpacing=lineSpace;
    //    paragraphStyle.maximumLineHeight = 30.0f;
    paragraphStyle.maximumLineHeight = 18.0f;
    
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,htmlString.length)];
    [htmlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0,htmlString.length)];
    
    
#warning -25
    //    NSString *newStr=[NSString stringWithFormat:@"%@",origHtml];
    //    CC_AttributedStr *at;
    //    newStr=[at cutHtmlTagFromStr:newStr withTagName:@"img" toStr:@"图" trimSpace:YES];
    CGRect summaryRect = [htmlString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
    CGSize summarySize = summaryRect.size;
    //    NSString *height = [NSString stringWithFormat:@"%f",summarySize.height]?:@"0";
    NSNumber *height = [NSNumber numberWithFloat:summarySize.height];;
    
    [newDic setObject:height forKey:@"height"];
    if (htmlString==nil) {
        [newDic setObject:[[NSMutableAttributedString alloc] initWithString:@""] forKey:@"html"];
    }else
    {
        [newDic setObject:htmlString forKey:@"html"];
    }
    
    return newDic;
    
}
@end
