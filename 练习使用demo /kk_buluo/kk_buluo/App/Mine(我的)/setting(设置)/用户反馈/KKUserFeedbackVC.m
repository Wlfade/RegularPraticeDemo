//
//  KKUserFeedbackVC.m
//  kk_buluo
//
//  Created by david on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKUserFeedbackVC.h"


@interface KKUserFeedbackVC ()<UITextFieldDelegate,UITextViewDelegate>
{
    CGFloat _leftSpace;
    CGFloat _commonFontSize;
    UIColor *_placeholderColor;
    NSInteger _maxWordCount;
}
@property (nonatomic, weak) DGTextView *textView;
@property (nonatomic, weak) UILabel *wordCountLabel;

@property (nonatomic, weak) UITextField *cellTextField;

@property (nonatomic, weak) UIButton *confirmButton;
@end

@implementation KKUserFeedbackVC


#pragma mark - lazy load


#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self setupNavi];
    [self setupUI];
}

#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:15];
    _commonFontSize = [ccui getRH:15];
    _placeholderColor = rgba(199, 199, 199, 1);
    _maxWordCount  = 200;
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"用户反馈"];
    
    //2.rightItem
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"发送" titleColor:UIColor.whiteColor];
    [rightItemBtn setNormalBgColor:COLOR_LIGHT_BLUE selectedBgColor:COLOR_BLUE];
    rightItemBtn.selected = NO;
    rightItemBtn.userInteractionEnabled = NO;
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
        [weakSelf clickConfirmButton:btn];
    }];
}

-(void)setupUI {

    CGFloat leftSpace = _leftSpace;
    WS(weakSelf);
    //1.displayV
    UIView *displayV = [[UIView alloc]init];
    displayV.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:displayV];
    [displayV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.naviBar.mas_bottom).mas_offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([ccui getRH:315]);
    }];
    
    //2.问题和意见
    //2.1 title
    DGLabel *titleL = [DGLabel labelWithText:@"问题和意见" fontSize:_commonFontSize color:COLOR_BLACK_TEXT];
    [displayV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace+2);
        make.top.mas_equalTo([ccui getRH:10]);
    }];
    
    //2.2 feedBackBorderV
    UIView *feedBackBorderV = [[UIView alloc]init];
    feedBackBorderV.layer.cornerRadius = 3.0;
    feedBackBorderV.layer.masksToBounds = YES;
    feedBackBorderV.layer.borderColor = rgba(231, 231, 231, 1).CGColor;
    feedBackBorderV.layer.borderWidth = 1.0;
    [displayV addSubview:feedBackBorderV];
    [feedBackBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).mas_offset([ccui getRH:5]);
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo([ccui getRH:180]);
    }];
    
    //textV
    [self setupTextView:feedBackBorderV];
    
    //3.联系方式
    //3.1 title
    DGLabel *cellTitleL = [DGLabel labelWithText:@"联系方式" fontSize:_commonFontSize color:COLOR_BLACK_TEXT];
    [displayV addSubview:cellTitleL];
    [cellTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace+2);
        make.top.mas_equalTo(feedBackBorderV.mas_bottom).mas_offset([ccui getRH:15]);
    }];
    
    //3.2 cellBorderV
    UIView *cellBorderV = [[UIView alloc]init];
    cellBorderV.layer.cornerRadius = 3.0;
    cellBorderV.layer.masksToBounds = YES;
    cellBorderV.layer.borderColor = rgba(231, 231, 231, 1).CGColor;
    cellBorderV.layer.borderWidth = 1.0;
    [displayV addSubview:cellBorderV];
    [cellBorderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cellTitleL.mas_bottom).mas_offset([ccui getRH:5]);
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo([ccui getRH:40]);
    }];
    
    //cellTextField
    UITextField *cellTf = [self createTextFieldWithPlaceHolder:@"请输入您的联系方式(手机号)"];
    self.cellTextField = cellTf;
    [cellTf addTarget:self action:@selector(cellDidChanged:) forControlEvents: UIControlEventEditingChanged];
    [cellBorderV addSubview:cellTf];
    [cellTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(-[ccui getRH:10]);
        make.top.bottom.mas_equalTo(0);
    }];
}


-(void)setupTextView:(UIView *)sView {
    //1.textView
    DGTextView *textV = [[DGTextView alloc]init];
    self.textView = textV;
    textV.delegate = self;
    textV.placeholder = @"请描述您的问题与意见";
    textV.placeholderColor = _placeholderColor;
    textV.textColor = COLOR_BLACK_TEXT;
    textV.font = Font(_commonFontSize);
    [textV setDoneInputAccessoryView];
    
    [sView addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(-[ccui getRH:10]);
        make.bottom.mas_equalTo(-[ccui getRH:25]);
    }];
    
    //2.wordCount
    NSString *wordContStr = [NSString stringWithFormat:@"0/%ld",_maxWordCount];
    DGLabel *wordCountL = [DGLabel labelWithText:wordContStr fontSize:[ccui getRH:12] color:_placeholderColor];
    self.wordCountLabel = wordCountL;
    [sView addSubview:wordCountL];
    [wordCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:15]);
        make.bottom.mas_equalTo(-[ccui getRH:10]);
    }];
}

#pragma mark tool
-(void)updateComfirmButtonStatus {
    if (self.textView.text.length < 1 ||
        self.cellTextField.text.length < 1) {
        self.confirmButton.selected = NO;
        self.confirmButton.userInteractionEnabled = NO;
        return ;
    }
    
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
}

/** 创建制定font,color的textField */
- (UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder{
    //1.创建
    UITextField *tf = [[UITextField alloc]init];
    
    //2.设置attributedPlaceholder
    UIFont *font = [UIFont systemFontOfSize:_commonFontSize];
    NSAttributedString *aStr = [[NSAttributedString alloc]initWithString:placeHolder attributes:@{NSForegroundColorAttributeName : _placeholderColor, NSFontAttributeName : font}];
    tf.attributedPlaceholder = aStr;
    
    //3.设置
    tf.font = font;
    tf.textColor = COLOR_DARK_GRAY_TEXT;
    tf.textAlignment = NSTextAlignmentLeft;
    tf.returnKeyType = UIReturnKeyDone;
    tf.delegate = self;
    //tf.userInteractionEnabled = NO;
    
    //4.return
    return tf;
}



#pragma mark - interaction
-(void)clickConfirmButton:(UIButton *)btn {
    if ([self checkCellValidity:self.cellTextField.text]) {
        [self requstFeedBack];
    }
}

#pragma mark tool
/** 检查手机号有效性 */
-(BOOL)checkCellValidity:(NSString *)cellStr {
    
    //1.为空
    if(cellStr.length == 0) {
        [CC_NoticeView showError:@"请输入手机号"];
        return NO;
    }
    
    //2. 位数不符
    if(cellStr.length != 11) {
        [CC_NoticeView showError:@"请输入正确的手机号"];
        return NO;
    }
    
    //3.手机号验证
    NSString *regex = @"^[1][0-9]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:cellStr]) {
        [CC_NoticeView showError:@"请输入正确的手机号"];
        return NO;
    }
    
    //4.有效
    return YES;
}

#pragma mark - delegate
#pragma mark UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView {
    
    NSInteger maxWordCount = _maxWordCount;
    //1.输入处理
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    if (!newText.length) {
        if (textView.text.length > maxWordCount) {
            textView.text = [textView.text substringToIndex:maxWordCount];
        }

    }
 
    //2.字数统计
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,(long)maxWordCount];
    
    //3.更改确认按钮状态
    [self updateComfirmButtonStatus];
}


#pragma mark textField变化
-(void)cellDidChanged:(UITextField *)textField {
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
    [self updateComfirmButtonStatus];
}

#pragma mark - notification


#pragma mark - request
-(void)requstFeedBack {
    
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD stop];
        [CC_NoticeView showError:@"提交成功"];
    });
}


#pragma mark - jump




@end
