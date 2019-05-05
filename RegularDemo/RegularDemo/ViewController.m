//
//  ViewController.m
//  RegularDemo
//
//  Created by 单车 on 2019/4/9.
//  Copyright © 2019 单车. All rights reserved.
//

/*
 比如服务端给的数据的形式是这样的:
 转发的带有表情的summary
 <img src="https://img.kkbuluo.net/images/emojis/hongdan.png" alt="hongdan" class="face"/>
 <img src="https://img.kkbuluo.net/images/emojis/heidan.png" alt="heidan" class="face"/>
 
 把其中的数据转换成 emoji 重新插入变换 成可变的字符串
 */

#import "ViewController.h"
#import "EmojiTextAttachment.h"

@interface ViewController ()

@property (nonatomic,weak) UILabel *summaryLabel;

@property (nonatomic,weak) UILabel *reSummaryLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *summary = [NSString stringWithFormat:@"比如服务端给的数据的形式是这样的:转发的带有表情的summary<img src=\"https://img.kkbuluo.net/images/emojis/hongdan.png\" alt=\"hongdan\" class=\"face\"/> <img src=\"https://img.kkbuluo.net/images/emojis/heidan.png\" alt=\"heidan\" class=\"face\"/>"];
    
    UILabel *summaryLabel =
    ({
        UILabel *summaryLabel = [[UILabel alloc]init];
        summaryLabel.numberOfLines = 0;
        summaryLabel.backgroundColor = [UIColor redColor];
        summaryLabel.frame = CGRectMake(20, 100, 200, 100);
        summaryLabel.font = [UIFont systemFontOfSize:12];
        summaryLabel.textAlignment = NSTextAlignmentRight;
        
        
        
        summaryLabel.text = summary;
        
        self.summaryLabel = summaryLabel;
        
        
        summaryLabel;
    });
    
    [self.view addSubview:summaryLabel];
    
    UILabel *reSummaryLabel = ({
        UILabel *reSummaryLabel = [[UILabel alloc]init];
        reSummaryLabel.numberOfLines = 0;
        reSummaryLabel.backgroundColor = [UIColor yellowColor];
        reSummaryLabel.font = [UIFont systemFontOfSize:12];
        reSummaryLabel.frame = CGRectMake(20, 300, 200, 100);
        reSummaryLabel.textAlignment = NSTextAlignmentRight;
        self.reSummaryLabel = reSummaryLabel;
        
        
        reSummaryLabel;
    });
    [self.view addSubview:reSummaryLabel];
    
    
    
    NSMutableArray *mutarr = [self remakeTheSummaryString];
    
    
    NSMutableAttributedString *attSummary=[[NSMutableAttributedString alloc] initWithString:summary];
    [attSummary addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0,attSummary.length)];
    
    NSUInteger totalLengthChanged = 0;
    for (NSDictionary *dict in mutarr) {
        NSTextCheckingResult *item = dict[@"item"];
        
        NSRange range = [item range];
        
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
            attachment.emojiSize = 20;
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
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 4 ;
    [attSummary addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attSummary.length)] ;
    
    reSummaryLabel.attributedText = attSummary;
    
}
- (NSMutableArray *)remakeTheSummaryString{
    
    NSString *summary = [NSString stringWithFormat:@"比如服务端给的数据的形式是这样的:转发的带有表情的summary<img src=\"https://img.kkbuluo.net/images/emojis/hongdan.png\" alt=\"hongdan\" class=\"face\"/> <img src=\"https://img.kkbuluo.net/images/emojis/heidan.png\" alt=\"heidan\" class=\"face\"/>"];
    
    
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
    NSLog(@"%@",resultArray);
    
    //这是一个简单的替换 对项目没有什么实质的作用
    NSString* resultString = [regex stringByReplacingMatchesInString:summary options:NSMatchingReportProgress range:NSMakeRange(0, [summary length]) withTemplate:@"图片"];
    
    NSLog(@"%@",resultString);
    
    return resultArray;
}

@end
