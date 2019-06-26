//
//  ViewController.m
//  正则表达式和点击的相应
//
//  Created by 单车 on 2019/5/20.
//  Copyright © 2019 单车. All rights reserved.
//

#import "ViewController.h"
#import "EmojiTextAttachment.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *originalTextView;

@property (weak, nonatomic) IBOutlet UITextView *changedTextView;

@property (weak, nonatomic) IBOutlet UITextView *editableTextView;

@property (nonatomic,strong) NSMutableAttributedString *outAttSummary;

//@property (nonatomic,strong) NSMutableArray *userRangeMutArr;

/// 光标位置
@property (assign, nonatomic) NSInteger cursorLocations;
/// 是否改变
@property (assign, nonatomic) BOOL isChanged;
/// 改变Range
@property (assign, nonatomic) NSRange changeRange;

@end

@implementation ViewController

/** userRangeMutArr */
//-(NSMutableArray *)userRangeMutArr{
//    if (_userRangeMutArr == nil) {
//        _userRangeMutArr = [NSMutableArray array];
//    }
//    return _userRangeMutArr;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _changedTextView.delegate = self;
    
    _changedTextView.editable = NO;
    _changedTextView.selectable = YES;
    _changedTextView.userInteractionEnabled = YES;
    
    
    _editableTextView.delegate = self;
    
    _editableTextView.editable = YES;
    _editableTextView.selectable = YES;
    _editableTextView.userInteractionEnabled = YES;
    
    
    NSString *summary = [NSString stringWithFormat:@"比如服务端给的数据的形式是这样的:转发的带有表情的hsummary<img src=\"https://img.kkbuluo.net/images/emojis/hongdan.png\" alt=\"hongdan\" class=\"face\"/> <img src=\"https://img.kkbuluo.net/images/emojis/heidan.png\" alt=\"heidan\" class=\"face\"/>《登录协议》eiigehiji bh<user userid=1234567 name=\"@昵称@\" class=\"nickname\"/>打开几个国际沙列个<user userid=773ig839u9fue9gu3 name=\"@新的昵称@\" class=\"nickname\"/>"];


    
    _originalTextView.text = summary;
    
    
    
    //1.先将内容转化成一个富文本 字体、颜色、段落什么的
    self.outAttSummary = [self getAttributedStringAndHeightWithString:summary withTextFont:[UIFont systemFontOfSize:16] withTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] withLineSpace:0  wihthImageFont:16];
    

    //2.将可变字符串通过方法 正则获取表情的数据 然后替换成表情字符串 拼接
    self.outAttSummary = [self makeEmojiFromeMutStr:self.outAttSummary withEmojiFont:16];
    
    //3.将可变将可变字符串通过方法 正则获取用户昵称的数据 然后替换成一个超链接 拼接
    self.outAttSummary = [self makeUserIdFromeMutStr:self.outAttSummary];
    
    //4.再改一下登录协议的颜色
    self.outAttSummary = [self makeRegularSpecailStringMutStr:self.outAttSummary withSpecialString:@"《登录协议》"];

    
    
    //4.获取高度
    CGFloat height = [self getSizeMaxWith:SCREEN_WIDTH - 20 andMaxHeigh:CGFLOAT_MAX withMutAttString:self.outAttSummary].height;
    
    NSLog(@"%f",height);
    
    _changedTextView.attributedText = self.outAttSummary;
    
    _editableTextView.attributedText = self.outAttSummary;
    
}
#pragma mark - 文本处理成富文本
/**
 生成一个转换了表情的可变字符串

 @param textStr 原内容
 @param textFont 文本大小
 @param textColor 文本颜色
 @param lineSpace 段落间隔
 @param fontFloat 字体大小
 @return 生成的可变的字符串
 */
-(NSMutableAttributedString *)getAttributedStringAndHeightWithString:(NSString *)textStr
                                                        withTextFont:(UIFont *)textFont
                                                       withTextColor:(UIColor *)textColor
                                                       withLineSpace:(CGFloat)lineSpace
                                                      wihthImageFont:(CGFloat)fontFloat{

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
    
    return attSummary;

}

- (CGSize)getSizeMaxWith:(CGFloat)maxWith andMaxHeigh:(CGFloat)maxHeigh withMutAttString:(NSMutableAttributedString *)attString{
    CGSize maxSize = CGSizeMake(maxWith, maxHeigh);
    
    CGRect summaryRect = [attString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil];
    
    CGSize summarySize = summaryRect.size;
    //    NSString *height = [NSString stringWithFormat:@"%f",summarySize.height]?:@"0";
//    NSNumber *height = [NSNumber numberWithFloat:summarySize.height];
    return summarySize;

}

#pragma mark - 表情富文本处理
//将富文本中的表情数据替换成表情后生成新的富文本
- (NSMutableAttributedString *)makeEmojiFromeMutStr:(NSMutableAttributedString *)summaryMutStr withEmojiFont:(CGFloat)emojiFloat{
    NSUInteger totalLengthChanged = 0;

    //获取一个正则表达式处理后的几个结果数组
    NSMutableArray *mutarr = [self remakeTheSummaryString:summaryMutStr];
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
            attachment.emojiSize = emojiFloat;
            attachment;
        });


        //将emoj转换成可变字符串
        NSAttributedString *imageAttrString = [NSAttributedString attributedStringWithAttachment:attachment];

        //获取现在需要改变的字符串的为止  新的起点 = 原来的起点 - 之前少了的长度
        NSRange newRange = NSMakeRange(range.location - totalLengthChanged, range.length);
        //可变字符串替换字符串
        [summaryMutStr replaceCharactersInRange:newRange withAttributedString:imageAttrString];
        //长度变了 就是 检索到的 范围的字符变成了一个表情 长度变成了 1 的长度 就是 原来长度 - 1
        NSUInteger lengthChanged = range.length - 1;
        //一共少了的长度
        totalLengthChanged += lengthChanged;
        
        
    }
    return summaryMutStr;
}
/**
 生成一个表情正则结果数组
 
 @param summary 原文内容
 @return 表情正则的内容的数组
 */
- (NSMutableArray *)remakeTheSummaryString:(NSMutableAttributedString *)summary{
    
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
    NSArray *result = [regex matchesInString:summary.string options:NSMatchingReportCompletion range:NSMakeRange(0, summary.length)];
    
    for (NSTextCheckingResult *item in result) {
        //截取一个范围的字符串
        NSString *imgHtml = [summary.string substringWithRange:[item rangeAtIndex:0]]; //取最长的
        
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

#pragma mark - 昵称富文本处理
//将富文本中的用户昵称替换成表情后生成新的富文本
- (NSMutableAttributedString *)makeUserIdFromeMutStr:(NSMutableAttributedString *)summaryMutStr{
    NSArray *rangeArrays = [self getAtRangeArray:summaryMutStr];

    NSUInteger totalLengthChanged = 0;

    //遍历
    for (NSDictionary *dict in rangeArrays) {
        NSTextCheckingResult *item = dict[@"item"];
        //正则后的结果
        NSRange range = [item range];
        //正则的用户昵称
        NSString *nickName = dict[@"name"];

        NSString *userid = dict[@"userId"];

        NSMutableAttributedString *nameAttString = [[NSMutableAttributedString alloc]initWithString:nickName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor greenColor]}];

        NSString *valueString1 = [[NSString stringWithFormat:@"userId://%@",userid] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [nameAttString addAttribute:NSLinkAttributeName value:valueString1 range:NSMakeRange(0, nameAttString.length)];
        [nameAttString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, nameAttString.length)];


        //获取现在需要改变的字符串的为止  新的起点 = 原来的起点 - 之前少了的长度
        NSRange newRange = NSMakeRange(range.location - totalLengthChanged, range.length);
        //可变字符串替换字符串
        [summaryMutStr replaceCharactersInRange:newRange withAttributedString:nameAttString];

        //长度变了 就是 检索到的 范围的字符变成了一个表情 长度变成了 1 的长度 就是 原来长度 - 1
        NSUInteger lengthChanged = range.length - nickName.length;
        //一共少了的长度
        totalLengthChanged += lengthChanged;
        
//        NSRange userIdRange = NSMakeRange(newRange.location, nameAttString.length);
//
//        [self.userRangeMutArr addObject:NSStringFromRange(userIdRange)];

    }
    return summaryMutStr;
}

/**
 生成一个昵称的正则的数据
 @param summary 数据
 @return 正则替换的数据
 */
- (NSArray *)getAtRangeArray:(NSAttributedString *)summary {
    //    NSAttributedString *traveAStr = attributedString ?:_textView.attributedText;
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
            //去 前半段id
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSString *userIdStr = tmpArray[0];
            NSUInteger loc = [userIdStr rangeOfString:@"="].location;
            if (loc != NSNotFound) {
                userIdStr = [userIdStr substringFromIndex:loc+1];
                //去除字符串中首位空格
                userIdStr = [userIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                [dict setObject:userIdStr forKey:@"userId"];
            }
            //取后半段
            NSString *src = tmpArray[1];
            
            //搜索字符串中的\符号
            loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                //截取字符串到某个下标z为止
                src = [src substringToIndex:loc];
                
                [dict setObject:src forKey:@"name"];
            }
            [dict setObject:item forKey:@"item"];
            [rangeArrays addObject:dict];
            
            
        }
    }
    
    return rangeArrays;
}

//处理一个特殊的字符完成正则
- (NSMutableAttributedString *)makeRegularSpecailStringMutStr:(NSMutableAttributedString *)summaryMutStr withSpecialString:(NSString *)specialStr{
    NSArray *rangeArrays = [self getTopicRangeArray:summaryMutStr withNeedJudge:NO withSpecialString:@"《登录协议》"];
    
    //遍历
    for (NSString *tempRameStr in rangeArrays) {
        NSRange tmpRange = NSRangeFromString(tempRameStr);
       
        [summaryMutStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:tmpRange];
    }
    return summaryMutStr;
}
- (NSArray *)getTopicRangeArray:(NSAttributedString *)attributedString withNeedJudge:(BOOL)isNeed withSpecialString:(NSString *)specialStr{
    //    NSAttributedString *traveAStr = attributedString ?: _textView.attributedText;
    NSAttributedString *traveAStr = attributedString;
    
    __block NSMutableArray *rangeArray = [NSMutableArray array];
    static NSRegularExpression *iExpression;
//    @"@(.*?)@" //用户名正则
//    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:@"《登录协议》" options:0 error:NULL];
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:specialStr options:0 error:NULL];

    [iExpression enumerateMatchesInString:traveAStr.string
                                  options:0
                                    range:NSMakeRange(0, traveAStr.string.length)
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                   NSRange resultRange = result.range;
                                   //获取这个富文本中的 属性信息
                                   NSDictionary *attributedDict = [traveAStr attributesAtIndex:resultRange.location effectiveRange:&resultRange];
                                   
                                   if (isNeed == YES) {
                                       if ([attributedDict[NSForegroundColorAttributeName] isEqual:[UIColor greenColor]]) {
                                           [rangeArray addObject:NSStringFromRange(result.range)];
                                       }
                                   }else{
                                       [rangeArray addObject:NSStringFromRange(result.range)];
                                   }
                                   
                                   
                                   
                               }];
    return rangeArray;
}
#pragma mark - textViewDelegate

//指定范围的内容与 URL 将要相互作用时激发该方法
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{

    if ([[URL scheme] isEqualToString:@"userId"]) {
        //        self.view.backgroundColor = [UIColor greenColor];
        NSString *userId = [NSString stringWithFormat:@"你点击了第二个文字:%@",[URL host]];
        NSLog(@"userId:%@",userId);

        return NO;
    }
    return YES;
}
//内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //删除功能
    if ([text isEqualToString:@""]) { // 删除
        NSArray *rangeArray = [self getTopicRangeArray:self.editableTextView.attributedText withNeedJudge:YES withSpecialString:@"《登录协议》"];
        
        for (NSInteger i = 0; i < rangeArray.count; i++) {
            NSRange tmpRange = NSRangeFromString(rangeArray[i]);
            if ((range.location + range.length) == (tmpRange.location + tmpRange.length)) {
                if ([NSStringFromRange(tmpRange) isEqualToString:NSStringFromRange(textView.selectedRange)]) {
                    // 第二次点击删除按钮 删除
//                    NSLog(@"打印前%@",self.userRangeMutArr);
//                    [self.userRangeMutArr removeObjectAtIndex:self.userRangeMutArr.count-1];
//                    NSLog(@"打印后%@",self.userRangeMutArr);
                    return YES;
                } else {
                    // 第一次点击删除按钮 选中
                    textView.selectedRange = tmpRange;
                    return NO;
                }
            }
        }
    }
    //添加功能
    else{
        NSArray *rangeArray = [self getTopicRangeArray:self.editableTextView.attributedText withNeedJudge:YES withSpecialString:@"《登录协议》"];

        if ([rangeArray count]) {
            for (NSInteger i = 0; i < rangeArray.count; i++) {
                NSRange tmpRange = NSRangeFromString(rangeArray[i]);
                if ((range.location + range.length) == (tmpRange.location + tmpRange.length) || !range.location) {
                    _changeRange = NSMakeRange(range.location, text.length);
                    _isChanged = YES;
                    return YES;
                }
            }
        } else {
            // 话题在第一个删除后 重置text color
            if (!range.location) {
                _changeRange = NSMakeRange(range.location, text.length);
                _isChanged = YES;
                return YES;
            }
        }
    }
    return YES;
}
//焦点发生改变
- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSArray *rangeArray = [self getTopicRangeArray:self.editableTextView.attributedText withNeedJudge:YES withSpecialString:@"《登录协议》"];
    BOOL inRange = NO;
    for (NSInteger i = 0; i < rangeArray.count; i++) {
        NSRange range = NSRangeFromString(rangeArray[i]);
        if (textView.selectedRange.location > range.location && textView.selectedRange.location < range.location + range.length) {
            inRange = YES;
            break;
        }
    }
    if (inRange) {
        textView.selectedRange = NSMakeRange(self.cursorLocations, textView.selectedRange.length);
        return;
    }
    self.cursorLocations = textView.selectedRange.location;
}
//内容发生改变编辑
- (void)textViewDidChange:(UITextView *)textView {
    if (_isChanged) {
        NSMutableAttributedString *tmpAString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [tmpAString setAttributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16] } range:_changeRange];
        textView.attributedText = tmpAString;
        _isChanged = NO;
    }
}


@end
