//
//  KKDynamicPublishController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicPublishController.h"
//控制器
#import "UIViewController+KKImagePicker.h"

#import "DGTextView.h"

#import "KKDisplayPhotoView.h"

//工具
#import "DGImagePickerManager.h"

#import "GEmotionView.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

#import "SUBJECT_CREATE_BEFORE_QUERY.h"
#import "KKSubjectLengthConfig.h"

#define kEmotionViewHeigh       (250)


static const NSInteger rowPhotoCount = 3; //一行排版的数量
static const NSInteger photoW = 100;
static const NSInteger maxPicCount = 9;

@interface KKDynamicPublishController ()
<
DGImagePickerManagerDelegate,
GEmotionDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextViewDelegate
>
@property (nonatomic, weak) DGButton *confirmButton;

//文字输入内容
@property (nonatomic,weak) DGTextView *freeTextView;
//加图片按钮
@property (nonatomic,strong) CC_Button *addBtn;
//图片数组
@property (nonatomic,strong) NSMutableArray *freePicArr;


//相册管理工具
@property (nonatomic,strong) DGImagePickerManager *imagePickerMgr;//相册
//放置图片的父视图
@property (nonatomic,strong) UIView *freePicView;
//图片宽度
@property (nonatomic,assign) CGFloat gap;

//bottomView
@property (nonatomic,weak) UILabel *countLabel;
//bottomView
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,weak) CC_Button *emotionButton;//表情按钮

@property (nonatomic,assign) BOOL isKeyboardShowing;

//表情
@property (nonatomic, weak) GEmotionView *emotionView ;

@property (nonatomic,assign) BOOL wantToShowEmotionOnKeyBoardingShowing;

@property (nonatomic,strong) KKSubjectLengthConfig *lengthConfig;

@end

static CGFloat const imageMax = 4000;

@implementation KKDynamicPublishController

- (CC_Button *)addBtn{
    if (!_addBtn) {
        _addBtn = [[CC_Button alloc]initWithFrame:CGRectMake(0, 0, photoW, photoW)];
        WS(weakSelf);
        [_addBtn addTappedBlock:^(UIButton *button) {
            [weakSelf.view endEditing:YES];
            
            [weakSelf pickImageWithCompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
                NSLog(@"一张图片");
                image = [image compressToMaxKbSize:imageMax];
                [weakSelf.freePicArr addObject:image];
                [weakSelf refreshImagesView:weakSelf.freePicView];
            } withPictures:^{
                [weakSelf presentImagePickerViewController];
            }];
        }];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"subject_addPic_bg"] forState:UIControlStateNormal];
        [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }else{
        _addBtn.frame = CGRectMake(0, 0, photoW, photoW);
    }
    return _addBtn;
}
- (void)viewDidLoad {
    [self setupNavi];
    
    self.gap = (SCREEN_WIDTH - 20 - rowPhotoCount*photoW)/(rowPhotoCount-1);
    
    [super viewDidLoad];

    [self creatSubView];
    //2.加keyboard通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    WS(weakSelf);
    [SUBJECT_CREATE_BEFORE_QUERY requestSubjectComplete:^(KKSubjectLengthConfig * _Nonnull lengthConfig) {
//        lengthConfig.normal.maxContentLength = 100;
        
        weakSelf.lengthConfig = lengthConfig;
        //字数label初始化赋值
//        weakSelf.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",lengthConfig.normal.maxContentLength,lengthConfig.normal.maxContentLength];
        weakSelf.countLabel.text = [NSString stringWithFormat:@"0/%ld",lengthConfig.normal.maxContentLength];
    }];
}

-(void)setupNavi {
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"发动态"];
    

    //2.rightItem
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"发布" titleColor:UIColor.whiteColor];
    [rightItemBtn setNormalBgColor:COLOR_BG selectedBgColor:COLOR_BLUE];
    self.confirmButton = rightItemBtn;
    rightItemBtn.selected = NO;
    rightItemBtn.userInteractionEnabled = NO;

    rightItemBtn.layer.cornerRadius = 2.0;
    rightItemBtn.layer.masksToBounds = YES;

    [self.naviBar addSubview:rightItemBtn];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-9);
        make.width.mas_equalTo([ccui getRH:50]);
        make.height.mas_equalTo([ccui getRH:24]);
    }];

    [rightItemBtn addTarget:self action:@selector(pubAction:) forControlEvents:UIControlEventTouchUpInside];
    rightItemBtn.clickTimeInterval = 2.0;

}
- (void)pubAction:(DGButton *)sender{
    sender.selected = YES;
    sender.enabled = NO;
    [self publishAction];
}
- (void)creatSubView{
    DGTextView *freeTextV = [[DGTextView alloc]init];
//    freeTextV.scrollEnabled = NO;
    freeTextV.needFrameChange = YES;
    freeTextV.delegate = self;
    self.freeTextView = freeTextV;
    freeTextV.font = [UIFont systemFontOfSize:16];
    freeTextV.placeholder = @"这一刻的想法";
    [self.view addSubview:freeTextV];
    
    [freeTextV textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = self->_freeTextView.frame;
        frame.size.height = textHeight;
        self->_freeTextView.frame = frame;
    }];
    freeTextV.frame = CGRectMake(10, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH - 20, 80);
    freeTextV.minTextH = 80;
//    [freeTextV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left).offset(10);
//        make.right.mas_equalTo(self.view.mas_right).offset(-10);
//        make.top.mas_equalTo(self.view.mas_top).offset(STATUS_AND_NAV_BAR_HEIGHT);
//        make.height.mas_equalTo(@80);
//    }];
    
    UIView *dyImagesView = [[UIView alloc]init];

    self.freePicView = dyImagesView;
    [self.view addSubview:dyImagesView];
    
    [self.freePicView addSubview:self.addBtn];
    
    [self.freePicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(freeTextV.mas_bottom).offset(5);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(photoW);
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

#pragma mark - notification
/** 打开键盘 通知*/
-(void)openKeyboard:(NSNotification*)notification{
    self.isKeyboardShowing = YES;
    //0.不显示emotion
//    self.emotionButton.selected = NO;
    self.emotionView.hidden = YES;
    
    CGFloat keyboardH = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardH);
    }];
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    CGFloat maxH = SCREEN_HEIGHT - (STATUS_AND_NAV_BAR_HEIGHT + keyboardH + 44 + 20 + 100);
    
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


/** present跳转imagePickerVC */
-(void)presentImagePickerViewController {
    //1.当前图片数
    NSInteger currentPicCount = self.freePicArr.count;

    //自从scrollViewScrollToFitPosition使用后,跳转imagePickerVC之前需要关闭keyboard,以避免scrollView的contentOffset设置造成的布局bug
    //不用撤销emotionView,因为它只受1>对应btn点击操控,2>openKeyborder通知发话操控
    [self.view endEditing:YES];

    //2.过滤
    if (currentPicCount >= maxPicCount) {
        [CC_NoticeView showError:[NSString stringWithFormat:@"最多选择%ld张图片",maxPicCount]];
        return ;
    }
    //3.设置最多图片数, 跳转选图片
    self.imagePickerMgr.maxImageCount = maxPicCount - currentPicCount;
    [self.imagePickerMgr presentImagePickerByVC:self];
}

-(NSMutableArray *)freePicArr {
    if (!_freePicArr) {
        _freePicArr = [NSMutableArray array];
    }
    return _freePicArr;
}

-(DGImagePickerManager *)imagePickerMgr {
    if (!_imagePickerMgr) {
        _imagePickerMgr = [[DGImagePickerManager alloc]initWithMaxImageCount:5];
        _imagePickerMgr.delegate = self;
    }
    return _imagePickerMgr;
}
#pragma mark DGImagePickerManagerDelegate
-(void)manager:(DGImagePickerManager *)mgr didSlectedImages:(NSArray<UIImage *> *)seletedImages{
    
    
    for (NSInteger i = 0; i < seletedImages.count; i ++) {
        UIImage *image = [seletedImages objectAtIndex:i];
        image = [image compressToMaxKbSize:imageMax];
        [self.freePicArr addObject:image];
    }
        
    [self refreshImagesView:self.freePicView];
    
}
- (void)refreshImagesView:(UIView *)pictureV{
    //1.获取对应images和view
    NSMutableArray *currentPicArr;

    if (self.freePicView == pictureV) {
        currentPicArr = self.freePicArr;
    }
    
    //2.更新布局约束
    //2.1计算高度
    CGFloat pictureVH = (currentPicArr.count / rowPhotoCount + 1) * photoW;
    
    //2.3更新pictureV高度约束
    [pictureV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(pictureVH);
    }];
    
    //3.清空subViews
    for (UIView *subview in pictureV.subviews) {
        [subview removeFromSuperview];
    }
    
    //4.过滤, 没图片的情况
    if (currentPicArr.count == 0) {
        [pictureV addSubview:self.addBtn];
        return;
    }
    
    //5.添加subViews
    WS(weakSelf);
//    CGFloat originX = 10;
    CGFloat originX = 0;

    for (NSInteger i=0; i<currentPicArr.count; i++) {
        CGFloat photoVY = (i/rowPhotoCount) * photoW;
        CGFloat photoVX = originX + (i % rowPhotoCount) * photoW;
        CGRect frame = CGRectMake(photoVX, photoVY, photoW, photoW);
        
        KKDisplayPhotoView *photoV = [[KKDisplayPhotoView alloc]initWithFrame:frame];
        [pictureV addSubview:photoV];
        
        photoV.photoImageView.image = currentPicArr[i];
        [photoV.removeButton addTappedBlock:^(UIButton *button) {
            [currentPicArr removeObjectAtIndex:i];
            [weakSelf refreshImagesView:pictureV];
        }];
    }
    
    //6.过滤, 达到最大图片张数,不显示addBtn
    if (currentPicArr.count >= 9) {
        return ;
    }else{
        //7.addBtn
        CGFloat addBtnX = originX + (currentPicArr.count % rowPhotoCount) * photoW;
        CGFloat addBtnY = (currentPicArr.count / rowPhotoCount) * photoW + 5;
        [pictureV addSubview:self.addBtn];
        CGRect addFrame = self.addBtn.frame;
        addFrame.origin.x = addBtnX;
        addFrame.origin.y = addBtnY;
        self.addBtn.frame = addFrame;
    }
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
        bottomVH -= 34.0;
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
//        self.emotionButton.selected = NO;
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
        NSInteger caninputlen = self.lengthConfig.normal.maxContentLength - allCount;

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
    
//    [textView textChanged:nil];
}
/** 表情的字符串长度 */
- (NSInteger)emotionStrLength:(UITextView *)textView{
    return [textView.textStorage getEmotionStrCount];
}

/** 表情的个数 */
-(NSInteger)emotionCount:(UITextView *)textView {
    return (NSInteger)[textView.textStorage getEmotionCount];
}

/** 已经输入总字符 数量 */
- (NSInteger)totalStrCount:(UITextView *)textView{
    NSInteger emotionLength = (NSInteger)[textView.textStorage getEmotionStrCount];
    NSInteger orderStrLength = (NSInteger)[self.freeTextView.textStorage getOrderStrCount];
    NSInteger allCount = emotionLength + orderStrLength + textView.text.length;
    if (allCount > 0) {
        self.confirmButton.selected = YES;
        self.confirmButton.userInteractionEnabled = YES;
    }else{
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
    }
    
    return allCount;
}

///** 判断textView文本长度 是否符合规则 */
//-(BOOL)judgeTextViewLength:(UITextView *)textView {
//
//    NSInteger minLength = 0;
//    NSInteger maxLength = 0;
//    NSInteger totalLength = [self totalStrCount:textView];
//
////    minLength = self.payMinHiddenContentLength;
////    maxLength = self.payMaxHiddenContentLength;
//    minLength = minLength < 1 ? 1 : minLength;
//    maxLength = maxLength < 1 ? 5000 : maxLength;
//    //1.3 提示
//    if (totalLength < minLength) {
////        [CC_NoticeView showError:[NSString stringWithFormat:@"付费费内容最少%ld个字",minLength]];
//        [CC_NoticeView showError:[NSString stringWithFormat:@"内容不能为空"]];
//
//        return NO;
//    }else if (totalLength > maxLength){
//        [CC_NoticeView showError:[NSString stringWithFormat:@"内容最多%ld个字",maxLength]];
//        return NO;
//    }
//
//    //3. 合法
//    return YES;
//}



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
//                [picStr appendFormat:@"<upload_image file_name=\"%@\">[图片]</upload_image>",fileName];
                 [picStr appendFormat:@"<upload_image file_name=\"%@\"></upload_image>",fileName];
            }
            complete(picStr);
        }
    }];
}


/**
 请求评论细节部分
 */
- (void)publishAction{
    if (self.freePicArr.count>0) {
//        [self requestUploadPictures:[NSArray arrayWithArray:self.freePicArr]];
        [self requestUploadPictures:[NSArray arrayWithArray:self.freePicArr] withComplete:^(NSMutableString *string) {
            [self requestCommentDetail:string];
        }];
    }else{
        [self requestCommentDetail:nil];
    }
}
- (void)requestCommentDetail:(NSMutableString *)pictStr
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"SUBJECT_CREATE" forKey:@"service"];
    
//    [params setObject:[KKUserInfoMgr shareInstance].userId forKey:@"postChannelId"];
    
    [params setObject:@"USER_TOPIC" forKey:@"postPosition"];
    
    [params setObject:@"NORMAL" forKey:@"objectType"];
    
    NSMutableString *freeContentStr = [[NSMutableString alloc]initWithFormat:@"%@",[self.freeTextView.textStorage getPlainString]];
    if (pictStr) {
        [freeContentStr appendString:pictStr];
    }

    [params setObject:freeContentStr forKey:@"content"];
    
    MaskProgressHUD *progressHud = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getLastWindow]];
    progressHud.titleStr =@"发布中...";
    [CC_HttpTask getInstance].httpTimeoutInterval = 30;
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        [progressHud stop];
        
        self.confirmButton.enabled = YES;

        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            [CC_NoticeView showError:@"发表成功"];
            
            [self.view endEditing:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.block) {
                    self.block();
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
