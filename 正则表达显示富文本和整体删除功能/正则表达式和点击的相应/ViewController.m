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
    
    
    NSString *summary = [NSString stringWithFormat:@"比如服务端给的数据的形式是这样的:转发的带有表情的hsummary《登录协议》 eiigehiji bh打开几个国际沙列个"];


    
    _originalTextView.text = summary;
    
    
    
    //1.先将内容转化成一个富文本 字体、颜色、段落什么的
    self.outAttSummary = [self getAttributedStringAndHeightWithString:summary withTextFont:[UIFont systemFontOfSize:16] withTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] withLineSpace:0  wihthImageFont:16];
    
    
    //4.再改一下登录协议的颜色
    self.outAttSummary = [self makeRegularSpecailStringMutStr:self.outAttSummary withSpecialString:@"《登录协议》 "];

    
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




//处理一个特殊的字符完成正则
- (NSMutableAttributedString *)makeRegularSpecailStringMutStr:(NSMutableAttributedString *)summaryMutStr withSpecialString:(NSString *)specialStr{
    NSArray *rangeArrays = [self getTopicRangeArray:summaryMutStr withNeedJudge:NO withSpecialString:@"《登录协议》 "];
    
    //遍历
    for (NSString *tempRameStr in rangeArrays) {
        NSRange tmpRange = NSRangeFromString(tempRameStr);
       
        [summaryMutStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:tmpRange];
    }
    return summaryMutStr;
}
- (NSArray *)getTopicRangeArray:(NSAttributedString *)attributedString withNeedJudge:(BOOL)isNeed withSpecialString:(NSString *)specialStr{

    NSAttributedString *traveAStr = attributedString;
    
    __block NSMutableArray *rangeArray = [NSMutableArray array];
    static NSRegularExpression *iExpression;
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
//        //检索正则到这个
//        NSArray *rangeArray = [self getTopicRangeArray:self.editableTextView.attributedText withNeedJudge:YES withSpecialString:@"《登录协议》"];
//
//        if ([rangeArray count]) {
//            for (NSInteger i = 0; i < rangeArray.count; i++) {
//                NSRange tmpRange = NSRangeFromString(rangeArray[i]);
//                if ((range.location + range.length) == (tmpRange.location + tmpRange.length) || !range.location) {
//                    _changeRange = NSMakeRange(range.location, text.length);
//                    _isChanged = YES;
//                    return YES;
//                }else{
//                    _changeRange = range;
//                    _isChanged = YES;
//                }
//            }
//        } else {
//            // 话题在第一个删除后 重置text color
//            if (!range.location) {
//                _changeRange = NSMakeRange(range.location, text.length);
//                _isChanged = YES;
//                return YES;
//            }
//        }
        _changeRange = NSMakeRange(range.location, text.length);
        _isChanged = YES;
        return YES;
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
        NSRange range = textView.selectedRange;
        
        
        textView.attributedText = tmpAString;

        range = textView.selectedRange;
        
        
        textView.selectedRange = NSMakeRange(_changeRange.location + _changeRange.length, 0);
        
        _isChanged = NO;
    }
}


@end
