//
//  KKCreateGroupViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/15.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKCreateGroupViewController.h"
#import "UIViewController+ImagePicker.h"


#import "KKSelectFriendsViewController.h"
@interface KKCreateGroupViewController ()<UIActionSheetDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIButton *groupHeaderButton;
@property (nonatomic, strong) DGTextView *groupNameTextView;
@property (nonatomic, strong) DGTextView *groupIntroduceTextView;
@property (nonatomic, strong) UIImage *isHaveImage;
@property (nonatomic, copy) NSString *logoFileName;
@property (nonatomic, strong) DGButton *createButton;
@end

@implementation KKCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"创建群部落"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createSubviews];
    });
    
    /// 创建
    _createButton = [DGButton btnWithFontSize:[ccui getRH:14] title:@"创建" titleColor:[UIColor whiteColor] bgColor:[UIColor colorWithRed:42/255.0 green:62/255.0 blue:255/255.0 alpha:1.0]];
    [self setButtonNormalColor:_createButton];
    _createButton.layer.borderWidth = 0.5;
    _createButton.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    [_createButton addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _createButton.frame = CGRectMake(SCREEN_WIDTH - [ccui getRH:60], STATUS_BAR_HEIGHT + 10, [ccui getRH:50], [ccui getRH:24]);
    _createButton.layer.cornerRadius = 2.5;
    _createButton.clipsToBounds = YES;
    self.createButton.userInteractionEnabled = NO;
    [self.naviBar addSubview:self.createButton];
    
}

#pragma mark - UI
- (void)createSubviews {
    /// 底部背景视图
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y>0?0:STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, [ccui getRH:208])];
    bottomImageView.image = [UIImage imageNamed:@"create_group_bg"];
    bottomImageView.userInteractionEnabled = YES;
    [self.view addSubview:bottomImageView];
    
    /// 群头像
    _groupHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _groupHeaderButton.frame = CGRectMake(SCREEN_WIDTH / 2 - [ccui getRH:62], [ccui getRH:31], [ccui getRH:131], [ccui getRH:125]);
    [_groupHeaderButton setImage:[UIImage imageNamed:@"create_group_header"] forState:UIControlStateNormal];
    [_groupHeaderButton addTarget:self action:@selector(selectImageAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomImageView addSubview:_groupHeaderButton];
    
    /// 群名字
    UILabel *groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:16], bottomImageView.origin.y + bottomImageView.frame.size.height + [ccui getRH:27], [ccui getRH:43], [ccui getRH:14])];
    groupNameLabel.font = [UIFont systemFontOfSize:[ccui getRH:14]];
    groupNameLabel.text = @"群名称";
    groupNameLabel.textColor = COLOR_DARK_GRAY_TEXT;
    groupNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:groupNameLabel];
    
    /// 群名称textView
    _groupNameTextView = [[DGTextView alloc] initWithFrame:CGRectMake([ccui getRH:83], bottomImageView.origin.y + bottomImageView.frame.size.height + [ccui getRH:17], SCREEN_WIDTH - [ccui getRH:83], [ccui getRH:28])];
    _groupNameTextView.placeholder = @"请输入群名字";
    _groupNameTextView.delegate = self;
    _groupNameTextView.placeholderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _groupNameTextView.font = [UIFont systemFontOfSize:[ccui getRH:15]];
    [self.view addSubview:_groupNameTextView];
    
    /// 实时监听
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(txtRemarkEditChanged:)
                                                name:UITextViewTextDidChangeNotification
                                              object:self.groupNameTextView];

    
    /// 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, groupNameLabel.origin.y + groupNameLabel.frame.size.height + [ccui getRH:19], SCREEN_WIDTH - [ccui getRH:30], 1)];
    line.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [self.view addSubview:line];

    /// 群简介
    UILabel *groupIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:16], line.origin.y + line.frame.size.height + [ccui getRH:11], [ccui getRH:43], [ccui getRH:14])];
    groupIntroduceLabel.text = @"群简介";
    groupIntroduceLabel.textColor = COLOR_DARK_GRAY_TEXT;
    groupIntroduceLabel.font = [UIFont systemFontOfSize:[ccui getRH:14]];
    groupIntroduceLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:groupIntroduceLabel];
    
    /// 群简介textView
    _groupIntroduceTextView = [[DGTextView alloc] initWithFrame:CGRectMake([ccui getRH:83], line.origin.y + line.frame.size.height + [ccui getRH:4], SCREEN_WIDTH - [ccui getRH:83 + 15], [ccui getRH:90])];
    _groupIntroduceTextView.placeholder = @"一句话介绍你的群?";
    _groupIntroduceTextView.placeholderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    _groupIntroduceTextView.font = [UIFont systemFontOfSize:[ccui getRH:15]];
    _groupIntroduceTextView.delegate = self;
    [self.view addSubview:_groupIntroduceTextView];
    
}
#pragma mark -
- (void)textViewDidChange:(UITextView *)textView {
    if (self.groupNameTextView == textView) {
        
    }else if (self.groupIntroduceTextView == textView) {
        if (textView.text.length > 100) {
            textView.text = [textView.text substringToIndex:100];
        }
    }
}

#pragma mark - 选择头像
- (void)selectImageAction {
    [self.groupNameTextView resignFirstResponder];
    [self.groupIntroduceTextView resignFirstResponder];
    WS(weakSelf)
    /// 这个方法选取的相册图片是可以裁剪的
    [self pickImageWithpickImageCutImageWithImageSize:CGSizeMake(400, 400) CompletionHandler:^(NSData *imageData, UIImage *image) {
        if (image != nil) {
            weakSelf.isHaveImage = image;
            [weakSelf.groupHeaderButton setImage:image forState:UIControlStateNormal];
            [weakSelf uploadImage];
            if (image && weakSelf.groupNameTextView.text.length != 0) {
                [weakSelf setButtonCanTapColor:weakSelf.createButton];
            }
        }else{
            [CC_NoticeView showError:@"图片获取失败"];
        }
    }];
}

- (void)txtRemarkEditChanged:(NSNotification *)obj {
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    if (toBeString) {
        [self setButtonCanTapColor:self.createButton];
        self.createButton.userInteractionEnabled = YES;
    }
    if (toBeString.length == 0) {
        [self setButtonNormalColor:self.createButton];
    }
}

- (void)setButtonNormalColor:(UIButton *)btn {
    [btn setTitleColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
}

- (void)setButtonCanTapColor:(UIButton *)btn {
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:42/255.0 green:62/255.0 blue:255/255.0 alpha:1.0];
}

/**
 uploadImage: 上传群头像
 */
- (void)uploadImage {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"IMAGE_TEMP_UPLOAD" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];

    /// 这里的方法名字需要 更新库之后改一下.
    [[CC_HttpTask getInstance] uploadImages:@[[_isHaveImage compressToMaxKbSize:4000]] url:[KKNetworkConfig currentUrl] params:params imageScale:1.0 reConnectTimes:3 finishBlock:^(NSArray<NSString *> *errorStrArr, NSArray<ResModel *> *modelArr) {
        ///
        NSDictionary *responseDic = modelArr.firstObject.resultDic[@"response"];
        weakSelf.logoFileName = responseDic[@"fileName"];
    }];
}

#pragma mark - Action
- (void)createButtonAction:(UIButton *)button {
    if (self.isHaveImage == nil) {
        [CC_NoticeView showError:@"请添加头像"];
        return;
    }
    if (_groupNameTextView.hasText == NO) {
        [CC_NoticeView showError:@"请输入群名字"];
        return;
    }else {
        if (_groupNameTextView.text.length < 2) {
            [CC_NoticeView showError:@"群名长度小于2"];
            return;
        }else if (_groupNameTextView.text.length > 10){
            [CC_NoticeView showError:@"群名长度大于10"];
            return;
        }
    }
    [self isExitGroupName];
}

/**
 isExitGroupName: 判断群名是否存在
 */
- (void)isExitGroupName {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_NAME_EXISTS_CONSULT" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:_groupNameTextView.text forKey:@"groupName"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (!str) {
            NSDictionary *dic = [resModel.resultDic objectForKey:@"response"];
            NSNumber *exists = dic[@"exists"];
            if (exists.integerValue == 1) {
                
                [CC_NoticeView showError:@"群名已经存在"];
            }else {
                KKSelectFriendsViewController *selectFriendsVC = [[KKSelectFriendsViewController alloc] init];
                selectFriendsVC.groupImageFileName = weakSelf.logoFileName;
                selectFriendsVC.groupName = weakSelf.groupNameTextView.text;
                selectFriendsVC.groupIntroduce = weakSelf.groupIntroduceTextView.text;
                [weakSelf.navigationController pushViewController:selectFriendsVC animated:YES];
            }
        }else {
            [CC_NoticeView showError:str];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.groupNameTextView resignFirstResponder];
    [self.groupIntroduceTextView resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
@end
