//
//  KKUserInfoEditVC.m
//  kk_buluo
//
//  Created by david on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKUserInfoEditVC.h"
#import "DGImagePickerManager.h"
#import <AFNetworking/AFNetworking.h>

@interface KKUserInfoEditVC ()<UITextFieldDelegate,UITextViewDelegate,DGImagePickerManagerDelegate>
{
    CGFloat _topHeaderViewHeight;
    CGFloat _inputItemHeight;
    CGFloat _inputTextViewHeight;
    CGFloat _commonFontSize;
    CGFloat _wordCountFontSize;
    
    UIColor *_placeholderColor;
}
@property (nonatomic, weak) DGButton *confirmButton;
@property (nonatomic, weak) UIScrollView *scrollView;
//top
@property (nonatomic, weak) UIImageView *headIconImageView;
//inputV
@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UITextField *sexTextField;
@property (nonatomic, weak) UITextField *birthTextField;
@property (nonatomic, weak) UITextField *locationTextField;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *wordCountLabel;
//bottomV
@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, assign) BOOL logoModifySuccess;
@property (nonatomic, assign) BOOL userInfoModifySuccess;
@property (nonatomic,strong) DGImagePickerManager *imagePickerMgr;//相册
@property (nonatomic, assign) BOOL isKeyboardShowing;

@end

@implementation KKUserInfoEditVC

#pragma mark - lazy load
-(DGImagePickerManager *)imagePickerMgr {
    if (!_imagePickerMgr) {
        _imagePickerMgr = [[DGImagePickerManager alloc]initWithMaxImageCount:1];
        _imagePickerMgr.delegate = self;
    }
    return _imagePickerMgr;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self requestUserInfo];
    
    //keyboard通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)dealloc {
    
    //注销keyboard通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - UI

-(void)setupUI {
    [self setDimension];
    [self setupNavi];
    [self setupScrollView];
}

-(void)setDimension {
    _topHeaderViewHeight = [ccui getRH:153];
    _inputItemHeight = [ccui getRH:63];
    _inputTextViewHeight = [ccui getRH:120];
    _commonFontSize = [ccui getRH:15];
    _wordCountFontSize = [ccui getRH:12];
    
    _placeholderColor = rgba(199, 199, 199, 1);
}

-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"编辑资料"];
    
    //2.rightItem
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"确定" titleColor:UIColor.whiteColor];
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


/** 设置ScrollView */
- (void)setupScrollView {
    //1.创建
    UIScrollView *scrollV = [[UIScrollView alloc]init];
    self.scrollView = scrollV;
    scrollV.showsVerticalScrollIndicator = NO;
    
    //2.布局
    WS(weakSelf);
    [self.view addSubview:scrollV];
    CGFloat bottomSpace = HOME_INDICATOR_HEIGHT;
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.naviBar.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomSpace);
    }];
    
    //3.tap
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView:)];
    [scrollV addGestureRecognizer:tapGr];
    
    //4.subviews
    [self setupScrollViewSubviews];
}

-(void)setupScrollViewSubviews {
    //1.topHeaderV
    CGFloat topHeaderH = _topHeaderViewHeight;
    UIView *topHeaderV = [[UIView alloc]init];
    topHeaderV.backgroundColor = self.view.backgroundColor;
    [self.scrollView addSubview:topHeaderV];
    [topHeaderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(topHeaderH);
    }];
    
    [self setupTopHeaderView:topHeaderV];
    
    //2.inputV
    CGFloat inputH = 4*_inputItemHeight + _inputTextViewHeight;
    UIView *inputV = [[UIView alloc]init];
    inputV.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:inputV];
    [inputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topHeaderV.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(inputH);
    }];
    [self setupInputView:inputV];
    
    //3.bottom
    UIView *bottomV = [[UIView alloc]init];
    self.bottomView = bottomV;
    [self.scrollView addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputV.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

/** 设置 头像view */
-(void)setupTopHeaderView:(UIView *)view {
    //1.headIconBtn
    CGFloat headIconW = [ccui getRH:102];
    UIImageView *headIconImgV = [[UIImageView alloc]initWithImage:Img(@"userLogo_defualt")];
    self.headIconImageView = headIconImgV;
    headIconImgV.contentMode = UIViewContentModeScaleAspectFill;
    headIconImgV.userInteractionEnabled = YES;
    headIconImgV.layer.cornerRadius = headIconW/2.0;
    headIconImgV.layer.masksToBounds = YES;
    [view addSubview:headIconImgV];
    [headIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.width.mas_equalTo(headIconW);
    }];
    
    UITapGestureRecognizer *headIconTapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadIconImageView:)];
    [headIconImgV addGestureRecognizer:headIconTapGr];
    
    //2.cameraImg
    UIImageView *caremaImgV = [[UIImageView alloc]initWithImage:Img(@"icon_camera")];
    [view addSubview:caremaImgV];
    [caremaImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headIconImgV.mas_right).mas_offset(-[ccui getRH:10]);
        make.bottom.mas_equalTo(headIconImgV.mas_bottom);
        make.width.height.mas_equalTo([ccui getRH:22]);
    }];
}

/** 设置 输入view */
-(void)setupInputView:(UIView *)view {
    //1.角色
    UIView *nameV = [self addItemViewToView:view after:nil height:_inputItemHeight];
    self.nameTextField = [self setupItemView:nameV title:@"角色名" placeHolder:@"未设置" hasArrow:NO];
    
    
    //2.性别
    UIView *sexV = [self addItemViewToView:view after:nameV height:_inputItemHeight];
    self.sexTextField = [self setupItemView:sexV title:@"性别" placeHolder:@"未知" hasArrow:NO];
    
    //3.生日
    UIView *birthV = [self addItemViewToView:view after:sexV height:_inputItemHeight];
    self.birthTextField = [self setupItemView:birthV title:@"生日" placeHolder:@"未设置" hasArrow:NO];
    
    //4.地区
    UIView *locationV = [self addItemViewToView:view after:birthV height:_inputItemHeight];
    self.locationTextField = [self setupItemView:locationV title:@"地区" placeHolder:@"未设置" hasArrow:NO];
    
    //5.介绍
    UIView *memoV = [self addItemViewToView:view after:locationV height:_inputTextViewHeight];
    [self setupItemView:memoV title:@"介绍" placeHolder:@"" hasArrow:NO];
    [self setupTextViewItem:memoV];
    
}

-(void)setupTextViewItem:(UIView *)sView {
    //1.textView
    DGTextView *textV = [[DGTextView alloc]init];
    self.textView = textV;
    textV.delegate = self;
    textV.placeholder = @"介绍下自己";
    textV.placeholderColor = _placeholderColor;
    textV.textColor = COLOR_BLACK_TEXT;
    textV.font = Font(_commonFontSize);
    [textV setDoneInputAccessoryView];
    
    CGFloat textViewH = _inputTextViewHeight;
    [sView addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo([ccui getRH:92]);
        make.right.mas_equalTo(-[ccui getRH:15]);
        make.bottom.mas_equalTo(-[ccui getRH:25]);
        make.height.mas_equalTo(textViewH);
    }];
    
    //2.wordCount
    DGLabel *wordCountL = [DGLabel labelWithText:@"0/100" fontSize:_wordCountFontSize color:_placeholderColor];
    self.wordCountLabel = wordCountL;
    [sView addSubview:wordCountL];
    [wordCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:15]);
        make.bottom.mas_equalTo(-[ccui getRH:10]);
    }];
    
}


#pragma mark tool
-(UIView *)addItemViewToView:(UIView *)sView after:(UIView *)topView height:(CGFloat )height {
    UIView *view = [[UIView alloc]init];
    [sView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (topView) {
            make.top.mas_equalTo(topView.mas_bottom);
        }else{
            make.top.mas_equalTo(0);
        }
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    return view;
}

/** 普通的itemView */
- (UITextField *)setupItemView:(UIView *)view title:(NSString *)title placeHolder:(NSString *)placeHolder hasArrow:(BOOL)hasArrow{
    
    view.backgroundColor = UIColor.whiteColor;
    CGFloat leftS = [ccui getRH:15];
    CGFloat tfLeftS = [ccui getRH:100];
    CGFloat arrowRightS = [ccui getRH:15];
    
    //1.itemL
    CGFloat itemH = _inputItemHeight;
    CGFloat itemLabelH = 30;
    DGLabel *itemL = [DGLabel labelWithText:title fontSize:_commonFontSize color:COLOR_BLACK_TEXT];
    [view addSubview:itemL];
    [itemL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftS);
        make.top.mas_equalTo((itemH-itemLabelH)/2.0);
    }];
    
    //2.textField
    UITextField *textF = [self createTextFieldWithPlaceHolder:placeHolder];
    [view addSubview:textF];
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tfLeftS);
        make.centerY.mas_equalTo(0);
    }];
    
    //3.arrow
    if(hasArrow){
        UIImageView *arrowImgV = [self createRightArrowImageView];
        [view addSubview:arrowImgV];
        [arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-arrowRightS);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    //4.grayLine
    if (![title isEqualToString:@"介绍"]) {
        [self addGrayLineTo:view];
    }
    
    //5.return
    return textF;
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
    tf.userInteractionEnabled = NO;
    
    //4.return
    return tf;
}

/** 创建 >箭头imageView */
- (UIImageView *)createRightArrowImageView {
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_gray"]];
    imgV.userInteractionEnabled = NO;
    return imgV;
}

/** 给view添加grayLine */
- (void)addGrayLineTo:(UIView *)view {
    CGFloat leftSpace = [ccui getRH:15];
    
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = RGBA(245, 246, 248, 1);
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}


/** 更新NextStepButton的状态 */
-(void)updateConfirmButtonStatus {
    
    //1. 验证
//    if(1){
//        self.confirmButton.selected = NO;
//        self.confirmButton.userInteractionEnabled = NO;
//        return ;
//    }
    
    //2.可点击
    self.confirmButton.selected = YES;
    self.confirmButton.userInteractionEnabled = YES;
    return ;
}


#pragma mark - interaction

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/** tap点击ScrollView */
- (void)tapScrollView:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

-(void)tapHeadIconImageView:(UITapGestureRecognizer *)gr {
    [self.imagePickerMgr presentImagePickerByVC:self];
}

-(void)clickConfirmButton:(UIButton *)sender {
    self.logoModifySuccess = NO;
    self.userInfoModifySuccess = NO;
    [self requstModifyUserInfo];
    [self requstModifyUserLogo];
}

#pragma mark - delegate
#pragma mark UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView {
    
    NSInteger maxWordCount = 100;
    
    //1.输入处理
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    if (!newText.length) {
        if (textView.text.length > maxWordCount) {
            textView.text = [textView.text substringToIndex:maxWordCount];
        }
    }
    
    //2.字数统计
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,maxWordCount];
   
    //3.更改确认按钮状态
    if (!self.confirmButton.selected) {
        self.confirmButton.selected = YES;
        self.confirmButton.userInteractionEnabled = YES;
    }
}




#pragma mark DGImagePickerManagerDelegate
-(void)manager:(DGImagePickerManager *)mgr didSlectedImages:(NSArray<UIImage *> *)seletedImages {
    
    self.headIconImageView.image = seletedImages.lastObject;
    
    //2.更改确认按钮状态
    if (!self.confirmButton.selected) {
        self.confirmButton.selected = YES;
        self.confirmButton.userInteractionEnabled = YES;
    }
}


#pragma mark - notication
/** 打开键盘 通知*/
-(void)openKeyboard:(NSNotification*)notification{
    self.isKeyboardShowing = YES;
    
    //1. 配置键盘动画
    CGFloat keyboardH = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardH);
    }];
    
    NSInteger option = [notification.userInfo [UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat showH = SCREEN_HEIGHT-STATUS_AND_NAV_BAR_HEIGHT-keyboardH;
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height-showH);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }];
}

/** 关闭键盘 通知*/
-(void)closeKeyboard:(NSNotification*)notification{
    self.isKeyboardShowing = NO;
    
    //1.配置键盘动画
    CGFloat bottomSpace = HOME_INDICATOR_HEIGHT;
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottomSpace);
    }];
    
    CGFloat duration = [notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger option = [notification.userInfo [UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}



#pragma mark - request
/** 请求用户信息 */
-(void)requestUserInfo {
    
    WS(weakSelf);
    [[KKUserInfoMgr shareInstance] requestUserInfo:^{
        
        KKUserInfoModel *userInfoModel = [KKUserInfoMgr shareInstance].userInfoModel;
        NSString *birthdayStr = userInfoModel.birthday;
        if (birthdayStr.length > 10) {
            birthdayStr = [birthdayStr substringToIndex:10];
        }
        
        [weakSelf.headIconImageView sd_setImageWithURL:Url(userInfoModel.userLogoUrl) placeholderImage:Img(@"userLogo_defualt")];
        weakSelf.nameTextField.text = userInfoModel.loginName;
        weakSelf.sexTextField.text = userInfoModel.sex.message;
        weakSelf.birthTextField.text = birthdayStr;
        weakSelf.locationTextField.text = userInfoModel.location;
        weakSelf.textView.text = userInfoModel.userMemo;
        weakSelf.wordCountLabel.text = [NSString stringWithFormat:@"%ld/100",userInfoModel.userMemo.length];
    }];
}

/** 请求 修改用户memo */
-(void)requstModifyUserInfo {
    
    //0.未登录过滤
    if (![KKUserInfoMgr isLogin]) { return; }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_INFO_MODIFY" forKey:@"service"];
    [params safeSetObject:self.textView.text forKey:@"memo"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error];
        }else{
            weakSelf.userInfoModifySuccess = YES;
            [weakSelf attemptToPop];
        }
    }];
}

/** 请求 修改用户头像 */
-(void)requstModifyUserLogo {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_LOGO_EDIT" forKey:@"service"];
    
    //2.请求
    UIImage *img = self.headIconImageView.image;
    img = [img compressToMaxKbSize:4000];
   
    WS(weakSelf);
    [[CC_HttpTask getInstance] uploadImages:@[img] url:[KKNetworkConfig currentUrl] params:params imageScale:1.0 reConnectTimes:3 finishBlock:^(NSArray<NSString *> *errorStrArr, NSArray<ResModel *> *modelArr) {
        if (modelArr.count) {
            weakSelf.logoModifySuccess = YES;
            [weakSelf attemptToPop];
        }
    }];
}


#pragma mark - jump
-(void)attemptToPop {
    
    if (self.logoModifySuccess && self.userInfoModifySuccess) {
        [[KKRCloudMgr shareInstance] updateUserInfo:[KKUserInfoMgr shareInstance].userId];
        [self.navigationController popViewControllerAnimated:YES];
        [CC_NoticeView showError:@"修改成功"];
    }
}


@end
