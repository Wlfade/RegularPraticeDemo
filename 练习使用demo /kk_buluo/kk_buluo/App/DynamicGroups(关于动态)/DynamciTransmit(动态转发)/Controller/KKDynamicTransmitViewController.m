//
//  KKDynamicTransmitViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicTransmitViewController.h"
//-----------view
#import "DGTextView.h"
#import "GEmotionView.h"
#import "KKDynamicCardView.h"

//-----------Tool
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

#import "SUBJECT_CREATE_BEFORE_QUERY.h"

#import "KKSubjectLengthConfig.h"

#import "GTMNSString+HTML.h"

static CGFloat const kEmotionViewHeigh = 250;
@interface KKDynamicTransmitViewController ()
<GEmotionDelegate,UITextViewDelegate>


//文字输入内容
@property (nonatomic,weak) DGTextView *freeTextView;
/** 动态转发名片视图 */
@property (nonatomic, weak) KKDynamicCardView *dynamicCardView;

//bottomView
@property (nonatomic,weak) UILabel *countLabel;

//bottomView
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,weak) CC_Button *emotionButton;//表情按钮

@property (nonatomic,assign) BOOL isKeyboardShowing;

//@property (nonatomic,strong) NSMutableAttributedString *defaultText; //文本框中默认显示文字

@property (nonatomic,strong) NSAttributedString *defaultText; //文本框中默认显示文字

//表情
@property (nonatomic, weak) GEmotionView *emotionView ;

@property (nonatomic,assign) BOOL wantToShowEmotionOnKeyBoardingShowing;

@property (nonatomic, weak) DGButton *confirmButton;

@property (nonatomic,strong) KKSubjectLengthConfig *lengthConfig;

@property (nonatomic,assign) BOOL isStart;

@end

@implementation KKDynamicTransmitViewController
#pragma mark lazy

/**
 
 <(img|IMG)(.*?)(/>|></img>|>)
 解释： < 开始 img 或  IMG 后面跟很多的单字符 ？ 改变 限定符的贪婪 以 /> 或 ></img> 或 >  结尾 的一个正则表达式
 创建正则表达式对象
 pattern 模式正则匹配模式
 options 正则匹配选项
 */
//赋值
- (void)setDynamicWholeItem:(KKDynamicWholeItem *)dynamicWholeItem{
    _dynamicWholeItem = dynamicWholeItem;
    if (dynamicWholeItem.isTransmitSubject) {
        NSString *oriStr = @"//@";
        NSString *name = dynamicWholeItem.dynamicHeadItem.userName;
        
        
        NSString *summaryString = [NSString stringWithFormat:@"%@%@：%@",oriStr,name,_dynamicWholeItem.dynamicTextItem.summary];
        
        
        self.defaultText = [self handleEmoji:summaryString withRegexPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" withSeparatKeyStr:@"alt"];
        
    }
}
- (void)setSelfDefineText:(NSString *)selfDefineText{
    _selfDefineText = selfDefineText;
    
    self.defaultText = [self handleEmoji:selfDefineText withRegexPattern:@"<(emotion)(.*?)(</emotion>)" withSeparatKeyStr:@"image_alt"];
}
/*
 比如服务端给的数据的形式是这样的:
 转发的带有表情的summary
 <img src="https://img.kkbuluo.net/images/emojis/hongdan.png" alt="hongdan" class="face"/>
 <img src="https://img.kkbuluo.net/images/emojis/heidan.png" alt="heidan" class="face"/>
 
 <emotion image_name="hongdan.png" image_alt="hongdan">hongdan</emotion>
 <emotion image_name="hongdan.png" image_alt="hongdan">hongdan</emotion>
 
 把其中的数据转换成 emoji 重新插入变换 成可变的字符串
 */
//重新处理服务端给的数据转换成自己要的数据结构

#pragma mark - private 处理表情
-(NSAttributedString *)handleEmoji:(NSString *)contentStr withRegexPattern:(NSString *)pattern withSeparatKeyStr:(NSString *)keyStr{
    if (!contentStr) {
        return [NSAttributedString new];
    }
    
    NSMutableArray *mutarr = [self reRegexString:contentStr withRegexPattern:pattern withSeparatKeyStr:keyStr];
    
    NSMutableAttributedString *attSummary=[[NSMutableAttributedString alloc] initWithString:contentStr];
    [attSummary addAttribute:NSFontAttributeName value:[ccui getRFS:16] range:NSMakeRange(0,attSummary.length)];
    
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
        //长度变了 就是 检索到的 范围的字符变成了一个表情 长度变成了 1 少的长度 就是 原来长度 - 1
        NSUInteger lengthChanged = range.length - 1;
        //一共少了的长度
        totalLengthChanged += lengthChanged;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 4 ;
    [attSummary addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attSummary.length)] ;
    
    return attSummary;
}

- (NSMutableArray *)reRegexString:(NSString *)summary withRegexPattern:(NSString *)pattern withSeparatKeyStr:(NSString *)keyStr{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    
    /*
     在指定options和range模式下匹配指定string，通过正则匹配返回一个匹配结果的数组
     
     NSMatchingReportCompletion ：找到任何一个匹配串后都回调一次block
     */
    NSArray *result = [regex matchesInString:summary options:NSMatchingReportCompletion range:NSMakeRange(0, summary.length)];
    
    for (NSTextCheckingResult *item in result) {
        //截取一个范围的字符串
        NSString *imgHtml = [summary substringWithRange:[item rangeAtIndex:0]]; //取最长的
        
        NSArray *tmpArray = nil;
        NSString *keyStringTypeOne = [NSString stringWithFormat:@"%@=\"",keyStr];
        NSString *keyStringTypeTwo = [NSString stringWithFormat:@"%@=",keyStr];
        
        if ([imgHtml rangeOfString:keyStringTypeOne].location != NSNotFound) {
            //将字符串分为两段
            tmpArray = [imgHtml componentsSeparatedByString:keyStringTypeOne];
        } else if ([imgHtml rangeOfString:keyStringTypeTwo].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:keyStringTypeTwo];
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
    
    
    NSString* resultString = [regex stringByReplacingMatchesInString:summary options:NSMatchingReportProgress range:NSMakeRange(0, [summary length]) withTemplate:@"图片"];
    
    NSLog(@"%@",resultString);
    
    return resultArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavi];
    
    [self creatSubView];
    //2.加keyboard通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    WS(weakSelf);
    [SUBJECT_CREATE_BEFORE_QUERY requestSubjectComplete:^(KKSubjectLengthConfig * _Nonnull lengthConfig) {
        
//        lengthConfig.transmitContentLength = 20;
        
        weakSelf.lengthConfig = lengthConfig;
        
        [weakSelf textViewDidChange:weakSelf.freeTextView];
    }];
}

/** 创建导航栏 */
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"转发动态"];
    
    //2.rightItem
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"发布" titleColor:UIColor.whiteColor];
    
    [rightItemBtn setNormalBgColor:COLOR_BLUE selectedBgColor:COLOR_BLUE];
    
    rightItemBtn.layer.cornerRadius = 2.0;
    rightItemBtn.layer.masksToBounds = YES;
    
    self.confirmButton = rightItemBtn;
    [self.naviBar addSubview:rightItemBtn];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-9);
        make.width.mas_equalTo([ccui getRH:50]);
        make.height.mas_equalTo([ccui getRH:24]);
    }];
    
    WS(weakSelf);
    rightItemBtn.clickTimeInterval = 2.0;
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        if ([weakSelf judgeTextViewLength:self->_freeTextView]) {
            [weakSelf requestCommentDetail];
        }
    }];
}
- (void)creatSubView{
    
    DGTextView *freeTextV = ({
        DGTextView *freeTextV = [[DGTextView alloc]init];
        freeTextV.needFrameChange = YES;
        freeTextV.delegate = self;
        self.freeTextView = freeTextV;
        freeTextV.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:freeTextV];
        
        if (self.defaultText) {
            self.isStart = YES;
            freeTextV.placeholder = @"这一刻的想法";
            self.freeTextView.attributedText = self.defaultText;
            
        }else{
            self.isStart = NO;
            freeTextV.placeholder = @"这一刻的想法";
            
        }
        
        freeTextV.frame = CGRectMake(10, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH - 20, 80);
        freeTextV.minTextH = 80;
//        freeTextV.minTextH = 40;

        
        [freeTextV textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            CGRect frame = self->_freeTextView.frame;
            frame.size.height = textHeight;
            self->_freeTextView.frame = frame;
            
            //            CGRect dynamicCardViewFrame = self.dynamicCardView.frame;
            //            dynamicCardViewFrame.origin.y = frame.origin.y + frame.size.height + 10;
            //            self->_dynamicCardView.frame = dynamicCardViewFrame;
        }];
        
        freeTextV;
    });
    [freeTextV becomeFirstResponder];
    
    
    
    KKDynamicCardView *dynamicCardView = ({
        KKDynamicCardView *dynamicCardView = [[KKDynamicCardView alloc]init];
        //        dynamicCardView.frame = CGRectMake(0, freeTextV.bottom + 10, SCREEN_WIDTH, 60);
        self.dynamicCardView = dynamicCardView;
        if (self.dynamicWholeItem) {
            dynamicCardView.dyCardItem = self.dynamicWholeItem.dynamicCardItem;
        }
        dynamicCardView;
    });
    
    [self.view addSubview:dynamicCardView];
    //    dynamicCardView.frame = CGRectMake(0, freeTextV.bottom + 10, SCREEN_WIDTH, 60);
    [dynamicCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(freeTextV.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(60);
    }];
    
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.font = [UIFont systemFontOfSize:12];
    countLabel.textColor = rgba(102,102,102,1);
    countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel = countLabel;
    [self.view addSubview:countLabel];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = COLOR_BG;
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(@44);
    }];
    
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomView.mas_top);
        make.right.mas_equalTo(bottomView.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@100);
    }];
    
    CC_Button *emtionBtn = [[CC_Button alloc]init];
    self.emotionButton = emtionBtn;
    [emtionBtn setImage:[UIImage imageNamed:@"emoji_icon"] forState:UIControlStateNormal];
    [bottomView addSubview:emtionBtn];
    
    [emtionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-16);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(21);
    }];
    
    WS(weakSelf);
    //点击
    [emtionBtn addTappedBlock:^(UIButton *button) {
        button.selected = !button.selected;
        [weakSelf showEmotionView:button.selected];
    }];
    
    [self setupEmotionView];
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (self.isStart == YES) {
        UITextRange * range = textView.selectedTextRange;
        UITextPosition * start = [textView positionFromPosition:range.start inDirection:UITextLayoutDirectionLeft offset:textView.text.length];
        if (start) {
            [textView setSelectedTextRange:[textView textRangeFromPosition:start toPosition:start]];
        }
        self.isStart = NO;
    }else{
        return;
    }
}

#pragma mark - notification
/** 打开键盘 通知*/
-(void)openKeyboard:(NSNotification*)notification{
    self.isKeyboardShowing = YES;
    //0.不显示emotion
    self.emotionButton.selected = NO;
    self.emotionView.hidden = YES;
    
    CGFloat keyboardH = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardH);
    }];
    
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    CGFloat maxH = SCREEN_HEIGHT - (STATUS_AND_NAV_BAR_HEIGHT + keyboardH + 44 + 20 + 60);
    
    self.freeTextView.maxTextH = ceil(maxH);
    
}

/** 关闭键盘 通知*/
-(void)closeKeyboard:(NSNotification*)notification{
    self.isKeyboardShowing = NO;
    
    //0. 显示keyboard时, 点击显示emotion而关闭键盘; 这时不需要动画,直接return
    if (self.wantToShowEmotionOnKeyBoardingShowing) {
        return ;
    }
    //1.配置键盘动画
    CGFloat bottomVH = iPhoneX ? -34 : 0;
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomVH);
    }];
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
}

//显示emotion表情
- (void)showEmotionView:(BOOL)show {
    self.emotionView.hidden = !show;
    self.emotionView.alpha = 0.2;
    
    //0.keyboard正显示着,却要显示emotion
    if (self.isKeyboardShowing && show) {
        self.wantToShowEmotionOnKeyBoardingShowing = YES;
        [self.view endEditing:YES];
    }
    
    //1. 配置键盘动画(多减去0.7,作为分界线)
    CGFloat bottomVH = show ? -kEmotionViewHeigh - 0.7 : 0;
    
    if (iPhoneX) {
        bottomVH = -34.0;
    }
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomVH);
    }];
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    //2.启动动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        self.emotionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.wantToShowEmotionOnKeyBoardingShowing = NO;
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //1.撤销键盘
    if (self.isKeyboardShowing) {
        [self.view endEditing:YES];
    }
    //2.撤销emotionView
    if (!self.emotionView.hidden) {
        self.emotionButton.selected = NO;
        [self showEmotionView:NO];
    }
}

#pragma mark emotionView
- (void)setupEmotionView{
    GEmotionView *emotionV = [[GEmotionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250) GEmotion:GEmotionTypeNormal];
    self.emotionView = emotionV;
    emotionV.delegate = self ;
    emotionV.hidden = YES ;
    
    //加一个tap,拦截touchesBegan:
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [emotionV addGestureRecognizer:tap];
    
    [self.view addSubview:emotionV];
    [emotionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0) ;
        make.bottom.mas_equalTo(iPhoneX ? -34 : 0);
        make.height.mas_equalTo(kEmotionViewHeigh) ;
    }];
}


#pragma mark  GEmotionDelegate
- (void)GEmotionTapped:(NSDictionary *)infoDic{
    //1.判断当前textView
    DGTextView *currentTextV = self.freeTextView;
    
    //2.插入富文本
    [self insertEmotionToTextView:currentTextV dictionary:infoDic];
    
    //3.滚动到合适位置
    [currentTextV scrollRangeToVisible:NSMakeRange(currentTextV.attributedText.length, 1)];
}
#pragma mark 插入表情
- (void)insertEmotionToTextView:(DGTextView *)textView dictionary:(NSDictionary *)infoDic{
    NSUInteger currentLocation = textView.selectedRange.location;
    //------------- 添加表情 -------------
    if (infoDic) {
        //1. Create emoji attachment
        EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
        
        //Set tag and image
        emojiTextAttachment.infoDic=infoDic;
        NSString *imageName = [infoDic objectForKey:@"imageName"];
        emojiTextAttachment.image = [UIImage imageNamed:imageName];
        emojiTextAttachment.emojiName = imageName;
        emojiTextAttachment.emojiTag = [NSString stringWithFormat:@"<emotion image_name=\"%@\" image_alt=\"%@\">%@</emotion>",[NSString stringWithFormat:@"%@.png",imageName],imageName,imageName];
        emojiTextAttachment.emojiSize=20;
        
        //2.Insert emoji image
        //textView.text.length 是带富文本的长度
        //textView.text 仅仅是文本
        if (currentLocation > textView.text.length) {
            currentLocation = textView.text.length;
        }
        
        
        NSInteger allCount = [self totalStrCount:textView];
        
        //剩余的字数
        NSInteger caninputlen = self.lengthConfig.transmitContentLength - allCount;
        
        if (caninputlen >= imageName.length) {
            //插入字符串
            [textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment] atIndex:currentLocation];
        }else{
            return;
        }
        
        //3.更新range
        textView.font = [UIFont systemFontOfSize:16];
        currentLocation++;
        NSRange range;
        range.location = currentLocation;
        range.length = 0;
        textView.selectedRange = range;
        
        //4.如果text.length小于5, 调用KKTextView的通知方法,
        //用于去掉placeHolderLabel, 因为加表情(富文本)不会调用UITextViewTextDidChangeNotification方法
//        if (textView.text.length < 5) {
//            [textView textChanged:nil];
//        }
        [textView textChanged:nil];
        
    }else{
        //------------- 删除表情 -----------
        if (textView.attributedText.length > 0) {
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
            
            currentLocation = textView.attributedText.length;
            if (currentLocation >= 1) {
                NSRange backward = NSMakeRange(currentLocation - 1, 1);
                [attributedStr deleteCharactersInRange:backward];
                currentLocation--;
            }
            
            textView.attributedText = attributedStr;
        }
    }
    [self textViewDidChange:textView];
}
/** 表情的数量 */
- (NSInteger)emotionStrCount:(UITextView *)textView{
    return (NSInteger)[textView.textStorage getEmotionStrCount];
}
/** 表情的个数 */
-(NSInteger)emotionCount:(UITextView *)textView {
    return (NSInteger)[textView.textStorage getEmotionCount];
}

/** 总字符 数量 */
- (NSInteger)totalStrCount:(UITextView *)textView{
    NSInteger emotionLength = (NSInteger)[textView.textStorage getEmotionStrCount];
    NSInteger orderStrLength = (NSInteger)[self.freeTextView.textStorage getOrderStrCount];
    
    NSInteger allCount = emotionLength + orderStrLength + textView.text.length;
    
    
    return allCount;
}

/** 判断textView文本长度 是否符合规则 */
-(BOOL)judgeTextViewLength:(UITextView *)textView {
    
    //    NSInteger minLength = 0;
    //    NSInteger maxLength = 0;
    //    NSInteger totalLength = [self totalStrCount:textView];
    
    //    minLength = self.payMinHiddenContentLength;
    //    maxLength = self.payMaxHiddenContentLength;
    //    minLength = minLength < 1 ? 1 : minLength;
    //    maxLength = maxLength < 1 ? 5000 : maxLength;
    //    //1.3 提示
    //    if (totalLength < minLength) {
    //        [CC_NoticeView showError:[NSString stringWithFormat:@"付费费内容最少%ld个字",minLength]];
    //        return NO;
    //    }else if (totalLength > maxLength){
    //        [CC_NoticeView showError:[NSString stringWithFormat:@"付费内容最多%ld个字",maxLength]];
    //        return NO;
    //    }
    
    //3. 合法
    return YES;
}

#pragma mark 判断字符串是否能输入

//-(void)textViewDidChange:(UITextView *)textView{
//    NSInteger allCount = [self totalStrCount:textView];
//    NSLog(@"%ld",allCount);
//
//    NSString *countStr = [NSString stringWithFormat:@"%ld/%ld", allCount,self.lengthConfig.transmitContentLength];
//    self.countLabel.text = countStr;
//
//}
- (void)textViewDidChange:(UITextView *)textView{
    
    NSInteger maxCount = self.lengthConfig.normal.maxContentLength;
    
    NSInteger emotionCount = [self emotionCount:textView];
    
    //NSInteger emotionStrLength = [self emotionStrLength:textView];
    
    NSInteger totalCount = [self totalStrCount:textView];
    
    //1.输入处理
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    //新text为空 且 长度超标
    if (newText.length < 1 && totalCount > maxCount ) {
        //1.1 无自定义表情
        if (emotionCount < 1) {
            textView.attributedText = [textView.attributedText attributedSubstringFromRange:NSMakeRange(0, maxCount)];
            
        }else {//1.2 有自定义表情
            //循环处理每次减少一个长度
            //因为表情可能在前边,超出的部分是多个文字
            while (totalCount > maxCount) {
                textView.attributedText = [textView.attributedText attributedSubstringFromRange:NSMakeRange(0, textView.attributedText.length-1)];
                totalCount = [self totalStrCount:textView];
            }
        }
    }
    
    //2.字数统计
    NSInteger finalCount = [self totalStrCount:textView];
    NSString *countStr = [NSString stringWithFormat:@"%ld/%ld",finalCount, maxCount];
    self.countLabel.text = countStr;
    
}

//转发话题创建
- (void)requestCommentDetail
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"TRANSMIT_CREATE_SUBJECT" forKey:@"service"];
    
    
    if (self.dynamicWholeItem.dynamicCardItem.deleted == YES) {
        [CC_NoticeView showError:@"该动态已被删除，不可转发"];
        return;
    }else{
        [params setObject:self.dynamicWholeItem.dynamicCardItem.subjectId forKey:@"subjectId"];
    }
    
    NSMutableString *freeContentStr = [[NSMutableString alloc]initWithFormat:@"%@",[self.freeTextView.textStorage getPlainString]];
    
    
    if ([HHObjectCheck isEmpty:freeContentStr]) {
        [params setObject:@"转发文章" forKey:@"content"];
    }else{
        [params setObject:freeContentStr forKey:@"content"];
    }
    
    [params setObject:@"USER_TOPIC" forKey:@"postPosition"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            [CC_NoticeView showError:@"发表成功"];
            [self.view endEditing:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            self.dynamicWholeItem.dynamicOperationItem.transmitCount += 1;
                
                if (self.transBlock) {
                    self.transBlock(self.dynamicWholeItem);
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
