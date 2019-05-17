//
//  KKDynamicTextItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicTextItem.h"
#import "KKReMakeDictionary.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+YYText.h"

@implementation KKDynamicTextItem
- (void)mj_keyValuesDidFinishConvertingToObject{
    
    self.titleHeight = 0;
    if (self.title) {
        NSDictionary *titleAttdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.title withTextFont:[UIFont boldSystemFontOfSize:17] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
        self.outAttTitle = [titleAttdict objectForKey:@"html"];
        NSNumber *titleHeight = titleAttdict[@"height"];

        self.titleHeight = titleHeight.floatValue;
    }
    
//    NSDictionary *attdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.summary withTextFont:[UIFont systemFontOfSize:16] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
//    self.outAttSummary = [attdict objectForKey:@"html"];
//    NSNumber *height = attdict[@"height"];
    
    
    
    NSString *summary = [NSString stringWithFormat:@"比如服务端给的数据的形式是这样的:转发的带有表情的hsummary<img src=\"https://img.kkbuluo.net/images/emojis/hongdan.png\" alt=\"hongdan\" class=\"face\"/> <img src=\"https://img.kkbuluo.net/images/emojis/heidan.png\" alt=\"heidan\" class=\"face\"/>《登录协议》eiigehiji bh<user userid=1234567 name=\"昵称\" class=\"nickname\"/>"];
    
//    <img src=\"https://img.kkbuluo.net/images/emojis/hongdan.png\" alt=\"hongdan\" class=\"face\"/>
    
//    NSMutableArray *mutarr = [self remakeTheSummaryString];
    
    

    
    //        reSummaryLabel.attributedText = attSummary;
    self.outAttSummary = [self getAttributedStringAndHeightWithString:summary withTextFont:[UIFont systemFontOfSize:16] withTextColor:RGB(51, 51, 51) withLineSpace:0 withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:linkStr];
    [self.outAttSummary addAttribute:NSLinkAttributeName value:@"login://" range:[[self.outAttSummary string] rangeOfString:@"《登录协议》"]];

    
    NSArray *rangeArrays = [self getAtRangeArray:self.outAttSummary];
    NSLog(@"%@",rangeArrays);
    
    NSUInteger totalLengthChanged = 0;

    //遍历
    for (NSDictionary *dict in rangeArrays) {
        NSTextCheckingResult *item = dict[@"item"];
        //正则后的结果
        NSRange range = [item range];
        //正则的图片名字
        NSString *nickName = dict[@"name"];
        
        NSAttributedString *nameAttString = [[NSAttributedString alloc]initWithString:nickName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                                                            NSForegroundColorAttributeName : [UIColor greenColor]}];
        
        //获取现在需要改变的字符串的为止  新的起点 = 原来的起点 - 之前少了的长度
        NSRange newRange = NSMakeRange(range.location - totalLengthChanged, range.length);
        //可变字符串替换字符串
        [self.outAttSummary replaceCharactersInRange:newRange withAttributedString:nameAttString];
        //长度变了 就是 检索到的 范围的字符变成了一个表情 长度变成了 1 的长度 就是 原来长度 - 1
        NSUInteger lengthChanged = range.length - nickName.length;
        //一共少了的长度
        totalLengthChanged += lengthChanged;
    }

    
//    self.outAttSummary = [self getAttributedStringAndHeightWithString:self.summary withTextFont:[UIFont systemFontOfSize:16] withTextColor:RGB(51, 51, 51) withLineSpace:0 withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
    
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX);

    CGRect summaryRect = [self.outAttSummary boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
    
    CGSize summarySize = summaryRect.size;
    //    NSString *height = [NSString stringWithFormat:@"%f",summarySize.height]?:@"0";
    NSNumber *height = [NSNumber numberWithFloat:summarySize.height];
    
//    NSNumber *height = @50;

    
    
    if (self.textMaxHeight) {
        if (height.floatValue > self.textMaxHeight) {
            height = @(self.textMaxHeight);
        }
    }
    if (_summary) {
        self.summaryHeight = height.floatValue + 5;
    }else{
        self.summaryHeight = 0;
    }
    self.dyTextHeight = _titleHeight + _summaryHeight;
    
}
-(NSMutableAttributedString *)getAttributedStringAndHeightWithString:(NSString *)textStr
                                                         withTextFont:(UIFont *)textFont
                                                        withTextColor:(UIColor *)textColor
                                                         withLineSpace:(CGFloat)lineSpace
                                                          withMaxWith:(CGFloat)maxWidth
                                                        withMaxHeight:(CGFloat)maxHeight
                                                wihthImageFont:(CGFloat)fontFloat{

    //获取一个正则表达式处理后的几个结果数组
    NSMutableArray *mutarr = [self remakeTheSummaryString:textStr];
    
    //生成可变字符串
    NSMutableAttributedString *attSummary=[[NSMutableAttributedString alloc] initWithString:textStr];
    
    //可变字符串设置字体大小
    [attSummary addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0,attSummary.length)];
    
    //可变字符串设置字体颜色
    [attSummary addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0,attSummary.length)];


    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    //行间距 4
    paraStyle.lineSpacing = lineSpace;
    //设置段落格式
    [attSummary addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attSummary.length)] ;
    
    
    NSUInteger totalLengthChanged = 0;
    
    //遍历
    for (NSDictionary *dict in mutarr) {
        NSTextCheckingResult *item = dict[@"item"];
        //正则后的结果
        NSRange range = [item range];
        //正则的图片名字
        NSString *imageName = dict[@"src"];
        
        UIImage *image = [UIImage imageNamed:imageName];
        
        if (!image) {
            continue;
        }
        
        EmojiTextAttachment *attachment = ({
            EmojiTextAttachment *attachment = [EmojiTextAttachment new];
            attachment.image = image;
            attachment.emojiName = imageName;
            attachment.emojiTag = [NSString stringWithFormat:@"<emotion image_name=\"%@\" image_alt=\"%@\">%@</emotion>",[NSString stringWithFormat:@"%@.png",imageName],imageName,imageName];
            attachment.emojiSize = fontFloat;
            attachment;
        });
        
        
        //将emoj转换成可变字符串
        NSAttributedString *imageAttrString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //获取现在需要改变的字符串的为止  新的起点 = 原来的起点 - 之前少了的长度
        NSRange newRange = NSMakeRange(range.location - totalLengthChanged, range.length);
        //可变字符串替换字符串
        [attSummary replaceCharactersInRange:newRange withAttributedString:imageAttrString];
        //长度变了 就是 检索到的 范围的字符变成了一个表情 长度变成了 1 的长度 就是 原来长度 - 1
        NSUInteger lengthChanged = range.length - 1;
        //一共少了的长度
        totalLengthChanged += lengthChanged;
    }
    
    [attSummary yy_setTextHighlightRange:NSMakeRange(0, 1) color:[UIColor redColor] backgroundColor:[UIColor yellowColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"1被点击");
    }];

    return attSummary;
    
}

//@的正则表达式
//- (NSArray *)getAtRangeArray:(NSAttributedString *)attributedString {
////    NSAttributedString *traveAStr = attributedString ?:_textView.attributedText;
//    NSAttributedString *traveAStr = attributedString;
//
//    __block NSMutableArray *rangeArrays = [NSMutableArray array];
//    static NSRegularExpression *iExpression;
//    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:0 error:NULL];
//    [iExpression enumerateMatchesInString:traveAStr.string
//                                  options:0
//                                    range:NSMakeRange(0, traveAStr.string.length)
//                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                                   NSRange resultRange = result.range;
//                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
//                                   [rangeArrays addObject:NSStringFromRange(result.range)];
//
////                                   if ([attributedDict[NSForegroundColorAttributeName] isEqual:UIColorHex(527ead)]) {
////                                       [rangeArrays addObject:NSStringFromRange(result.range)];
////                                   }
//                               }];
//    return rangeArrays;
//}
- (NSArray *)getAtRangeArray:(NSAttributedString *)summary {
    //    NSAttributedString *traveAStr = attributedString ?:_textView.attributedText;
    NSAttributedString *traveAStr = summary;
    
    __block NSMutableArray *rangeArrays = [NSMutableArray array];
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"<(user)(.*?)(/>|>)" options:0 error:NULL];
    
    NSArray *result = [iExpression matchesInString:summary.string options:NSMatchingReportCompletion range:NSMakeRange(0, summary.length)];

    for (NSTextCheckingResult *item in result) {
        //截取一个范围的字符串
        NSString *imgHtml = [summary.string substringWithRange:[item rangeAtIndex:0]]; //取最长的
        NSLog(@"%@",imgHtml);
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"name=\""].location != NSNotFound) {
            //将字符串分为两段
            tmpArray = [imgHtml componentsSeparatedByString:@"name=\""];
        } else if ([imgHtml rangeOfString:@"name="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"name="];
        }
        
        if (tmpArray.count >= 2) {
            //取后半段
            NSString *src = tmpArray[1];
            
            //搜索字符串中的\符号
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                //截取字符串到某个下标z为止
                src = [src substringToIndex:loc];
                
                NSDictionary *dict = @{@"item":item,@"name":src};
                
                [rangeArrays addObject:dict];
            }
        }
    }
    
    return rangeArrays;
}
//表情的正则表达式
- (NSMutableArray *)remakeTheSummaryString:(NSString *)summary{
    
//    NSString *summary = [NSString stringWithFormat:@"比如服务端给的数据的形式是这样的:转发的带有表情的summary<img src=\"https://img.kkbuluo.net/images/emojis/hongdan.png\" alt=\"hongdan\" class=\"face\"/> <img src=\"https://img.kkbuluo.net/images/emojis/heidan.png\" alt=\"heidan\" class=\"face\"/>"];
    
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    /**
     
     <(img|IMG)(.*?)(/>|></img>|>)
     解释： < 开始 img 或  IMG 后面跟很多的单字符 ？ 改变 限定符的贪婪 以 /> 或 ></img> 或 >  结尾 的一个正则表达式
     创建正则表达式对象
     pattern 模式正则匹配模式
     options 正则匹配选项
     */
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    /*
     在指定options和range模式下匹配指定string，通过正则匹配返回一个匹配结果的数组
     
     NSMatchingReportCompletion ：找到任何一个匹配串后都回调一次block
     */
    NSArray *result = [regex matchesInString:summary options:NSMatchingReportCompletion range:NSMakeRange(0, summary.length)];
    
    for (NSTextCheckingResult *item in result) {
        //截取一个范围的字符串
        NSString *imgHtml = [summary substringWithRange:[item rangeAtIndex:0]]; //取最长的
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"alt=\""].location != NSNotFound) {
            //将字符串分为两段
            tmpArray = [imgHtml componentsSeparatedByString:@"alt=\""];
        } else if ([imgHtml rangeOfString:@"alt="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"alt="];
        }
        
        if (tmpArray.count >= 2) {
            //取后半段
            NSString *src = tmpArray[1];
            
            //搜索字符串中的\符号
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                //截取字符串到某个下标z为止
                src = [src substringToIndex:loc];
                
                NSDictionary *dict = @{@"item":item,@"src":src};
                
                [resultArray addObject:dict];
            }
        }
    }
    
    return resultArray;
}


@end
