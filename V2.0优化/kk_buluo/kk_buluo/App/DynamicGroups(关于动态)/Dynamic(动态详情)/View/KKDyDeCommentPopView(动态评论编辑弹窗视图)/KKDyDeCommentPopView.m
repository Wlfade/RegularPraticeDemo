//
//  KKDyDeCommentPopView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/23.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDeCommentPopView.h"

#import "GEmotionView.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

//工具
#import "DGImagePickerManager.h"
#import "KKDisplayPhotoView.h" //图片


static CGFloat const kEmotionViewHeigh = 250; //表情键盘高度
static CGFloat const contentBgViewNormalH = 80;

static CGFloat const operationViewH = 40;
static CGFloat const editViewNormalH = 33;

@interface KKDyDeCommentPopView ()
<
GEmotionDelegate,
UITextViewDelegate,
DGImagePickerManagerDelegate
>
/** 展示所属的控制器 */
@property (nonatomic,strong)UIViewController *viewController;
/** 灰色背景视图 */
@property (nonatomic,weak)UIView *grayBackGroundView;
/** 主要的内容功能视图 */
@property (nonatomic,weak)UIView *contentBgView;
/** 白色边框视图的编辑背景视图 */
@property (nonatomic,weak)UIView *editView;
/** 文字输入内容 */
@property (nonatomic,weak) DGTextView *freeTextView;

/** 文字输入内容 */
//@property (nonatomic,weak) UITextView *freeTextView;
/** 发送按钮 */
@property (nonatomic,weak)DGButton *rightItemBtn;
/** 图片内容视图 */
@property (nonatomic,strong) KKDisplayPhotoView *photoV; //
/** 功能视图 */
@property (nonatomic,weak)UIView *operaBgView;
/** 键盘是否处于显示状态 */
@property (nonatomic,assign) BOOL isKeyboardShowing;
/** emoji键盘 */
@property (nonatomic, weak) GEmotionView *emotionView ;
/** 是否展现emoji键盘当键盘正在显示 */
@property (nonatomic,assign) BOOL wantToShowEmotionOnKeyBoardingShowing;
/** 表情按钮 */
@property (nonatomic,weak) CC_Button *emotionButton;
/** 相册管理工具 */
@property (nonatomic,strong) DGImagePickerManager *imagePickerMgr;
/** 图片数组 */
@property (nonatomic,strong) NSMutableArray *freePicArr;
/** 是否有图片数据 */
@property (nonatomic,assign) BOOL isHasImage;

@property (nonatomic,assign) BOOL needImage; //是否需要发送图片功能 同时转发功能和 文字也是一样的显示

@property (nonatomic,strong) NSString *placeStr; //是否需要发送图片功能 同时转发功能和 文字也是一样的显示


- (CGFloat)maxTextCount;

@end

static const NSInteger maxPicCount = 1;

//static const CGFloat maxTextCount = MAXFLOAT;

static const CGFloat maxDefaultTextCount = 10.0;


@implementation KKDyDeCommentPopView

- (CGFloat)maxTextCount{
    if ([self.delegate respondsToSelector:@selector(maxTextCountInKKDyDeCommentPopView:)]) {
        return [self.delegate maxTextCountInKKDyDeCommentPopView:self];
    }else{
        return maxDefaultTextCount;
    }
}

-(DGImagePickerManager *)imagePickerMgr {
    if (!_imagePickerMgr) {
        _imagePickerMgr = [[DGImagePickerManager alloc]initWithMaxImageCount:1];
        _imagePickerMgr.delegate = self;
    }
    return _imagePickerMgr;
}
-(NSMutableArray *)freePicArr {
    if (!_freePicArr) {
        _freePicArr = [NSMutableArray array];
    }
    return _freePicArr;
}
//+ (instancetype)KKDyDeCommentPopViewShow:(UIViewController *)viewController{
//    KKDyDeCommentPopView *commentView = [[KKDyDeCommentPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    commentView.viewController = viewController;
//    [[NSNotificationCenter defaultCenter] addObserver:commentView selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:commentView selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
//    
//    [commentView creatSubView];
//    
//    [commentView setupEmotionView];
//    
//    [viewController.view addSubview:commentView];
//    
//    
//    return commentView;
//}


//+ (instancetype)KKDyDeCommentPopViewShow:(UIViewController *)viewController isNeedImage:(BOOL)needImage{
+ (instancetype)KKDyDeCommentPopViewShow:(UIViewController *)viewController isNeedImage:(BOOL)needImage withPlaceString:(NSString *)placeStr{
    KKDyDeCommentPopView *commentView = [[KKDyDeCommentPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    commentView.viewController = viewController;
    
    commentView.needImage = needImage;
    
    commentView.placeStr = placeStr ? placeStr : @"输入内容";
    
    [[NSNotificationCenter defaultCenter] addObserver:commentView selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:commentView selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    [commentView creatSubView];
    
    [commentView setupEmotionView];
    
    [viewController.view addSubview:commentView];
    
    [commentView.freeTextView becomeFirstResponder];

    return commentView;
}
- (void)creatSubView{
    UIView *grayBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    grayBackGroundView.backgroundColor = [UIColor blackColor];
    grayBackGroundView.userInteractionEnabled = YES;
    grayBackGroundView.alpha = 0.3;
    self.grayBackGroundView = grayBackGroundView;
    [self addSubview:grayBackGroundView];
    UIView *contentBgView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT -contentBgViewNormalH, SCREEN_WIDTH, contentBgViewNormalH)];
    contentBgView.backgroundColor = rgba(249, 249, 249, 1);
    
    self.contentBgView = contentBgView;
    
    [self addSubview:contentBgView];
    
    //创建编辑视图子视图
    [self creatEditSubView:contentBgView];
    
    //底部的操作视图
    UIView *operaBgView = [[UIView alloc]initWithFrame:CGRectMake(0,contentBgViewNormalH - operationViewH, SCREEN_WIDTH, operationViewH)];
    self.operaBgView = operaBgView;
    
    [contentBgView addSubview:operaBgView];
    
    [self creatOperationView:operaBgView];


}

/**
 创建编辑视图
 */
- (void)creatEditSubView:(UIView *)contentBgView{
    CGFloat textViewWidth = SCREEN_WIDTH - 30 - 50;
    UIView *editView = [[UIView alloc]initWithFrame:CGRectMake(10, 7, textViewWidth, editViewNormalH)];
    editView.backgroundColor = [UIColor whiteColor];
    editView.layer.borderWidth = 1;
    editView.layer.cornerRadius = 3;
    editView.layer.borderColor = rgba(218, 218, 218, 1).CGColor;
    self.editView = editView;
    [contentBgView addSubview:editView];
    
    DGTextView *freeTextV = [[DGTextView alloc]init];
//    freeTextV.backgroundColor = [UIColor redColor];
    freeTextV.font = [UIFont systemFontOfSize:14];
//    freeTextV.placeholder = @"输入内容";
    freeTextV.placeholder = self.placeStr;
//    freeTextV.layer.borderColor = rgba(218, 218, 218, 1).CGColor;
//    freeTextV.layer.borderWidth = 1;
//    freeTextV.layer.cornerRadius = 3;

    freeTextV.frame = CGRectMake(2, 2, textViewWidth - 4, 29);
    self.freeTextView = freeTextV;
    freeTextV.minTextH = 29;
    freeTextV.maxTextH = 80;
    freeTextV.needFrameChange = YES;
    freeTextV.delegate = self;
    
    [editView addSubview:freeTextV];
    
//    [contentBgView addSubview:freeTextV];
    WS(weakSelf);
    [freeTextV textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        SS(strongSelf);

//        [strongSelf refreshContentViewFrame:textHeight];
        [strongSelf refreshContentViewFrame:textHeight withIsHasImage:self.isHasImage];
    }];
    
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"发送" titleColor:UIColor.whiteColor];
    [rightItemBtn setNormalBgColor:COLOR_BLUE selectedBgColor:COLOR_BLUE];
    rightItemBtn.selected = NO;
    rightItemBtn.layer.cornerRadius = 2.0;
    rightItemBtn.layer.masksToBounds = YES;
    self.rightItemBtn = rightItemBtn;
    [contentBgView addSubview:rightItemBtn];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(editView.mas_right).offset(10);
//        make.top.mas_equalTo(16);
        make.bottom.mas_equalTo(editView.mas_bottom).offset(-3);
        make.width.mas_equalTo([ccui getRH:50]);
        make.height.mas_equalTo([ccui getRH:24]);
    }];
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        
        [weakSelf commentPopView];
    }];
}

//创建功能视图
- (void)creatOperationView:(UIView *)contentBgView{
    WS(weakSelf);

    if (_needImage) {
        UIButton *transmitBtn = [[UIButton alloc]init];
        [transmitBtn setImage:[UIImage imageNamed:@"comment_uncheck_icon"] forState:UIControlStateNormal];
        [transmitBtn setImage:[UIImage imageNamed:@"comment_check_icon"] forState:UIControlStateSelected];
        [transmitBtn addTarget:self action:@selector(transmitAction:) forControlEvents:UIControlEventTouchUpInside];
        
        transmitBtn.adjustsImageWhenDisabled = NO;
        transmitBtn.adjustsImageWhenHighlighted = NO;
        
        [contentBgView addSubview:transmitBtn];
        
        [transmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(contentBgView.mas_left).offset(10);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(20);
        }];
        
        DGLabel *textLabel = [DGLabel labelWithText:@"同时转发" fontSize:[ccui getRH:14] color:rgba(153, 153, 153, 1)];
        [contentBgView addSubview:textLabel];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(contentBgView.mas_left).offset(40);
            make.centerY.mas_equalTo(contentBgView.mas_centerY);
            
        }];
    }
    
    CC_Button *emtionBtn = [[CC_Button alloc]init];
    [emtionBtn setImage:[UIImage imageNamed:@"emoji_icon"] forState:UIControlStateNormal];
    self.emotionButton = emtionBtn;
    [contentBgView addSubview:emtionBtn];
    
    [emtionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contentBgView.mas_right).offset(-10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];
    //点击
    [emtionBtn addTappedBlock:^(UIButton *button) {
//        button.selected = !button.selected;
        button.selected = YES;
        [weakSelf showEmotionView:button.selected];
    }];
    
    if (_needImage) {
        CC_Button *openImage = [[CC_Button alloc]init];
        [openImage setImage:[UIImage imageNamed:@"comment_image_icon"] forState:UIControlStateNormal];
        [contentBgView addSubview:openImage];
        
        [openImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(emtionBtn.mas_left).offset(-10);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(20);
        }];
        //点击
        [openImage addTappedBlock:^(UIButton *button) {
            [weakSelf presentImagePickerViewController];
        }];

    }
}
- (void)transmitAction:(UIButton *)sender{
    NSLog(@"%d",sender.selected);
    self.isNeedTransmit = sender.selected = !sender.selected;
}
- (KKDisplayPhotoView *)photoV{
    if (!_photoV) {
        WS(weakSelf);
        _photoV = [[KKDisplayPhotoView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
        CGRect photoVremoveBtnFrame = _photoV.removeButton.frame;
        photoVremoveBtnFrame.origin.x = 40 - 10;
        photoVremoveBtnFrame.size.width = photoVremoveBtnFrame.size.height = 15;
        _photoV.removeButton.frame = photoVremoveBtnFrame;
        [_photoV.removeButton addTappedBlock:^(UIButton *button) {
            [self->_freePicArr removeAllObjects];
            self.isHasImage = NO;
//            [weakSelf refreshTheImageView:self.isHasImage];
            
            [weakSelf refreshContentViewFrame:self->_freeTextView.frame.size.height withIsHasImage:self->_isHasImage];
        }];
    }
    return _photoV;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self cancelAction];
//    UITouch *touch = [touches ]
    
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:_containerView];
    
    CGPoint p = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.contentBgView.frame, p)) {
        [self cancelAction];
    }
    
    
    
//    //1.撤销键盘
//    if (self.isKeyboardShowing) {
//        [self endEditing:YES];
//    }
//    //2.撤销emotionView
//    if (!self.emotionView.hidden) {
//        self.emotionButton.selected = NO;
//        [self showEmotionView:NO];
//    }
}
- (void)cancelAction{
    [KKDyDeCommentPopView hideWithViewController:self.viewController withCompletion:^{
        
    }];
}

+ (void)hideWithViewController:(UIViewController *)controller withCompletion:(void(^)(void))completion{
    for (KKDyDeCommentPopView *childView in controller.view.subviews) {
        if ([childView isKindOfClass:[self class]]) {
            //            [self removeFromSuperview];
            [childView setUpHiddentAnimation:^{
                if (completion) {
                    completion();
                }
            }];
        }
    }
}
- (void)setUpHiddentAnimation:(void(^)(void))completion{
    //    [self removeFromSuperview];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //        self.transform = CGAffineTransformMakeTranslation(0, self.height);
        
        
        //        self.menu.transform = CGAffineTransformMakeTranslation(0, self.menu.height);
        [self setViewNil];
    } completion:^(BOOL finished) {
        //        [blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
    if (completion) {
        completion();
    }
}
- (void)setViewNil{
    [self.grayBackGroundView removeFromSuperview];
    self.grayBackGroundView = nil;
}

#pragma mark - notification
/** 打开键盘 通知*/
-(void)openKeyboard:(NSNotification*)notification{
    self.isKeyboardShowing = YES;
    //0.不显示emotion
    CGFloat keyboardH = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect contentBgViewFrame = self.contentBgView.frame;
    contentBgViewFrame.origin.y = (SCREEN_HEIGHT-keyboardH) -contentBgViewFrame.size.height;
    self.contentBgView.frame = contentBgViewFrame;
    
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
    CGRect contentBgViewFrame = self.contentBgView.frame;
    contentBgViewFrame.origin.y =(SCREEN_HEIGHT + bottomVH)-contentBgViewFrame.size.height;
    self.contentBgView.frame = contentBgViewFrame;
}

- (void)commentPopView{
    NSMutableString *freeContentStr = [[NSMutableString alloc]initWithFormat:@"%@",[self.freeTextView.textStorage getPlainString]];
    
    if ([self.delegate respondsToSelector:@selector(KKDyDeCommentPopViewDidSend:mutString:)]) {
        [self endEditing:YES];
        
        if (self.isHasImage == YES) {
            [self requestUploadPictures:self.freePicArr withComplete:^(NSMutableString *string) {
                [freeContentStr appendString:string];
                
                [self.delegate KKDyDeCommentPopViewDidSend:self mutString:freeContentStr];
            }];
        }else{
            [self.delegate KKDyDeCommentPopViewDidSend:self mutString:freeContentStr];
        }
    }
}
/** 上传图片 */
- (void)requestUploadPictures:(NSArray *)picArr withComplete:(void(^)(NSMutableString *))complete{
    
    //1.设置参数
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    //service
    [paramDic setObject:@"IMAGE_TEMP_UPLOAD" forKey:@"service"];
    //2.请求
    MaskProgressHUD *progressHud = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getLastWindow]];
    progressHud.titleStr =@"发布中...";
    
    [[CC_HttpTask getInstance]uploadImages:picArr url:[KKNetworkConfig currentUrl] params:paramDic imageScale:0.1 reConnectTimes:3 finishBlock:^(NSArray<NSString *> *errorStrArr, NSArray<ResModel *> *modelArr)
     {
         [progressHud stop];
         if (errorStrArr.count>0) {
             [CC_NoticeView showError:@"图片上传失败"];
             
         }else{
             NSMutableString *picStr = [NSMutableString string];
             for (ResModel *res in modelArr) {
                 NSDictionary *responseDic = res.resultDic;
                 NSLog(@"%@",responseDic);
                 NSString *fileName = responseDic[@"response"][@"fileName"];
//                 [picStr appendFormat:@"<upload_image file_name=\"%@\">[图片]</upload_image>",fileName];
                 [picStr appendFormat:@"<upload_image file_name=\"%@\"></upload_image>",fileName];

             }
             complete(picStr);
         }
     }];
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
    
    [self addSubview:emotionV];
    [emotionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0) ;
        make.bottom.mas_equalTo(iPhoneX ? -34 : 0);
        make.height.mas_equalTo(kEmotionViewHeigh) ;
    }];
}

//显示emotion表情
- (void)showEmotionView:(BOOL)show {
    self.emotionView.hidden = !show;
    self.emotionView.alpha = 0.2;
    
    //0.keyboard正显示着,却要显示emotion
    if (self.isKeyboardShowing && show) {
        self.wantToShowEmotionOnKeyBoardingShowing = YES;
        [self endEditing:YES];
    }
    
    //1. 配置键盘动画(多减去0.7,作为分界线)
    CGFloat bottomVH = show ? -kEmotionViewHeigh - 0.7 : 0;
    if (iPhoneX) {
        bottomVH -= 34.0;
    }

    CGRect contentBgViewFrame = self.contentBgView.frame;
    contentBgViewFrame.origin.y = (SCREEN_HEIGHT+bottomVH)- contentBgViewFrame.size.height;
    self.contentBgView.frame = contentBgViewFrame;

    
    //2.启动动画
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
        self.emotionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.wantToShowEmotionOnKeyBoardingShowing = NO;
        
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

#pragma mark  插入表情
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
//        NSInteger caninputlen = self.lengthConfig.normal.maxContentLength - allCount;
//        NSInteger caninputlen = 10 - allCount;
        NSInteger caninputlen = self.maxTextCount - allCount;


        
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
        
    }
    else{
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

/** 总字符 数量 */
- (NSInteger)totalStrCount:(UITextView *)textView{
    NSInteger emotionLength = (NSInteger)[textView.textStorage getEmotionStrCount];
    NSInteger orderStrLength = (NSInteger)[self.freeTextView.textStorage getOrderStrCount];
    return emotionLength + orderStrLength + textView.text.length;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//
//    UITextRange *selectedRange = [textView markedTextRange];
//    //获取高亮部分内容
//    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
//
//    //如果有高亮且当前字数开始位置小于最大限制允许输入
//    if (selectedRange && pos) {
//        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
//        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
//        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
////        if (offsetRange.location < self.maxTextCount) {
////            return YES;
////        }
////        else{
////            return NO;
////        }
//
//        if (endOffset < self.maxTextCount) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
//
//    NSInteger allCount = [self totalStrCount:textView] + text.length;
//    //
////    NSInteger caninputlen = self.lengthConfig.normal.maxContentLength - allCount;
////    NSInteger caninputlen = 10 - allCount;
//    NSInteger caninputlen = self.maxTextCount - allCount;
//
//
//
//    if (caninputlen >= 0) {
//        return YES;
//    }else{
//        NSInteger len = text.length + caninputlen;
//        //防止当text.leng + caninputlen < 0 时，使得rg.length 为一个非法最大正数出错
//        NSRange rg = {0,MAX(len, 0)};
//        if (rg.length > 0) {
//            NSString *s = @"";
//            //判断是否只普通的字符或asc码（对中文和表情返回NO）
//            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
//            if (asc) {
//                s = [text substringWithRange:rg]; //因为是ascII 码直接取就可以了不会错
//            }
//            else{
//                __block NSInteger idx = 0;
//                __block NSString *trimString = @""; //截取出的字符串
//                //使用字符串遍历，这个方法能准确知道每个emoji是占一个Unicode 还是两个
//                [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
//                    NSInteger steplen = substring.length;
//                    if (idx >= rg.length) {
//                        *stop = YES; //取出所需要就break,提高效率
//                        return ;
//                    }
//                    trimString = [trimString stringByAppendingString:substring];
//                    idx = idx + steplen; //这里变化了，使用了字串占的长度来作为步长
//                }];
//                s = trimString;
//            }
//            //rang 是指从光标处进行替换处理（注意如果执行此句后面放回的是YES会触发didChange事件）
//            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        }
//        return NO;
//
//    }
//}

/** 判断textView文本长度 是否符合规则 */
-(void)textViewDidChange:(UITextView *)textView{
    //    if (!self.confirmButton.selected) {
    //        self.confirmButton.selected = YES;
    //        self.confirmButton.userInteractionEnabled = YES;
    //    }
    
//    NSInteger maxCount = self.lengthConfig.normal.maxContentLength;
    
    NSInteger maxCount = self.maxTextCount;
    
    
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
}
/** 表情的个数 */
-(NSInteger)emotionCount:(UITextView *)textView {
    return (NSInteger)[textView.textStorage getEmotionCount];
}

#pragma mark DGImagePickerManagerDelegate
-(void)manager:(DGImagePickerManager *)mgr didSlectedImages:(NSArray<UIImage *> *)seletedImages{
    
    for (NSInteger i = 0; i < seletedImages.count; i ++) {
        UIImage *image = [seletedImages objectAtIndex:i];
        image = [image compressToMaxKbSize:4000];
        [self.freePicArr addObject:image];
    }
    
    if (self.freePicArr.count > 0) {
        self.isHasImage = YES;
    }else{
        self.isHasImage = NO;
    }
    
//    [self refreshTheImageView::self.isHasImage];
    [self refreshContentViewFrame:self.freeTextView.frame.size.height withIsHasImage:self.isHasImage];
}
#pragma mark 刷新内容视图的布局
- (void)refreshContentViewFrame:(CGFloat)freeTextVH withIsHasImage:(BOOL)isHasImage{
    //修改内容编辑视图的frame
    CGRect frame = self.freeTextView.frame;
    frame.size.height = freeTextVH;
    self.freeTextView.frame = frame;
    
    //修改编辑的框的frame
    frame = self.editView.frame;
    if (self.isHasImage) {
        frame.size.height = freeTextVH + 4 + 40;
    }else{
        frame.size.height = freeTextVH + 4;
    }
    self.editView.frame = frame;
    
    //修改整体的灰色内容编辑视图frame
    frame = self.contentBgView.frame;
    CGFloat bottom = CGRectGetMaxY(frame);
    
    frame.size.height = CGRectGetMaxY(self.editView.frame) + operationViewH;
    CGFloat Y = bottom - frame.size.height;
    frame.origin.y = Y;
    
    self.contentBgView.frame = frame;
    
    //修改内容操作视图frame
    frame = self.operaBgView.frame;
    
    frame.origin.y = self.contentBgView.frame.size.height - frame.size.height;
    self.operaBgView.frame = frame;
    
    if (isHasImage) {
        //添加图片内容并布局
        [_editView addSubview:self.photoV];
        CGRect photoVFrame = self.photoV.frame;
        photoVFrame.origin.y = self.editView.frame.size.height - photoVFrame.size.height;
        self.photoV.frame = photoVFrame;
        self.photoV.photoImageView.image = self.freePicArr[0];
    }else{
        [self.photoV removeFromSuperview];
        self.photoV = nil;
    }
}
/** present跳转imagePickerVC */
-(void)presentImagePickerViewController {
    //1.当前图片数
    NSInteger currentPicCount = self.freePicArr.count;
    
    //自从scrollViewScrollToFitPosition使用后,跳转imagePickerVC之前需要关闭keyboard,以避免scrollView的contentOffset设置造成的布局bug
    //不用撤销emotionView,因为它只受1>对应btn点击操控,2>openKeyborder通知发话操控
    [self endEditing:YES];
    
    //2.过滤
    if (currentPicCount >= maxPicCount) {
        [CC_NoticeView showError:[NSString stringWithFormat:@"最多选择%ld张图片",maxPicCount]];
        return ;
    }
    //3.设置最多图片数, 跳转选图片
    self.imagePickerMgr.maxImageCount = maxPicCount - currentPicCount;
    [self.imagePickerMgr presentImagePickerByVC:self.viewController];
}
@end
