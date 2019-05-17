//
//  TransStringToHtmlString.m
//  JCZJ
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TransStringToHtmlString.h"

@implementation TransStringToHtmlString

+ (NSAttributedString *)getHtmlAttributedStringWithString:(NSString *)textStr{
    //1.转换为mAttributedStr
    NSString *origHtml=[NSString stringWithFormat:@"%@",textStr?textStr:@""];;
    origHtml=[origHtml stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSMutableAttributedString *htmlString = [[NSMutableAttributedString alloc] initWithData:[origHtml dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    
    //2.addAttribute
    [htmlString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,htmlString.length)];
    [htmlString addAttribute:NSForegroundColorAttributeName value:RGB(121, 121, 121) range:NSMakeRange(0,htmlString.length)];
    [htmlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0,htmlString.length)];
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing=5;
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,htmlString.length)];
    
    //3.return
    return htmlString;
}
+ (float)getHtmlHeightWithString:(NSString *)textStr{

    NSString *htmlStr = [self getHtmlAttributedStringWithString:textStr].string;
    
    NSMutableAttributedString *mAttributedStr = [[NSMutableAttributedString alloc] initWithString: htmlStr ? htmlStr : @"" attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14] }];
    CGRect rect = [mAttributedStr boundingRectWithSize:(CGSize){SCREEN_WIDTH-20, CGFLOAT_MAX}options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size.height;
}


@end
