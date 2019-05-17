//
//  KKEditGroupMemoViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/21.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKEditGroupMemoViewController.h"

@interface KKEditGroupMemoViewController ()<UITextViewDelegate>
@property (nonatomic, weak) DGTextView *textView;
@property (nonatomic, weak) UILabel *wordCountLabel;
@property (nonatomic, weak) UIButton *confirmButton;
@end

@implementation KKEditGroupMemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupUI];
}

#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"修改群公告"];
    
    //2.rightItem
    DGButton *rightItemBtn = [DGButton btnWithFontSize:[ccui getRH:14] title:@"确定" titleColor:UIColor.whiteColor];
    [rightItemBtn setNormalBgColor:COLOR_LIGHT_BLUE selectedBgColor:COLOR_BLUE];
    rightItemBtn.selected = YES;
    rightItemBtn.userInteractionEnabled = YES;
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
    /// 底部白色View
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, [ccui getRH:10] + STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, [ccui getRH:200])];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    //1.textView
    DGTextView *textV = [[DGTextView alloc]init];
    self.textView = textV;
    textV.delegate = self;
    if (![HHObjectCheck isEmpty:self.myGroup.notice]) {
        textV.text = self.myGroup.notice;
    }else{
        textV.placeholder = @"请输入新的群公告";
    }
    textV.placeholderColor = rgba(199, 199, 199, 1);
    textV.textColor = COLOR_BLACK_TEXT;
    textV.font = Font([ccui getRH:15]);
    [textV setDoneInputAccessoryView];
    
    [whiteView addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(-[ccui getRH:10]);
        make.bottom.mas_equalTo(-[ccui getRH:25]);
    }];
    
    //2.wordCount
    DGLabel *wordCountL = [DGLabel labelWithText:@"0/200" fontSize:[ccui getRH:12] color:rgba(199, 199, 199, 1)];
    
    wordCountL.text = [NSString stringWithFormat:@"%ld/200",textV.text.length];
    
    self.wordCountLabel = wordCountL;
    [whiteView addSubview:wordCountL];
    [wordCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:15]);
        make.bottom.mas_equalTo(-[ccui getRH:10]);
    }];
}

#pragma mark - textView
- (void)textViewDidChange:(UITextView *)textView {
    
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    if (!newText.length) {
        //1.输入处理
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
        }
        NSString *text = textView.text;
        
        //2.字数统计
        self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/200",text.length];
    }
    
    //3.更改确认按钮状态
    if (textView.text.length > 0) {
        self.confirmButton.selected = YES;
        self.confirmButton.userInteractionEnabled = YES;
    }else{
        self.confirmButton.selected = YES;
        self.confirmButton.userInteractionEnabled = YES;
    }
}

#pragma mark - interaction
- (void)clickConfirmButton:(UIButton *)btn {
    WS(weasSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GROUP_NOTICE_MODIFY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setValue:self.myGroup.groupId forKey:@"groupId"];
    [params setValue:self.textView.text forKey:@"notice"];
    [params setValue:self.myGroup.groupName forKey:@"groupName"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_GROUP_NOTICE object:nil];
            [weasSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}
@end
