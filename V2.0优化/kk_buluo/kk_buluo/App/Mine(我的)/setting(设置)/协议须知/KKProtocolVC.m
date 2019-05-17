//
//  KKProtocolVC.m
//  kt_user
//
//  Created by 单车 on 2018/9/18.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "KKProtocolVC.h"
#import "TransStringToHtmlString.h"

@interface KKProtocolVC ()
/** 协议 */
@property (nonatomic,strong) UITextView *inforTextView;
@end

@implementation KKProtocolVC

#pragma mark - lazy load
- (UITextView *)inforTextView {
    if (!_inforTextView) {
        _inforTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH - 10, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT)];
        _inforTextView.backgroundColor = [UIColor clearColor];
        _inforTextView.editable = NO;
        _inforTextView.selectable = NO;
    }
    return _inforTextView;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:self.naviTitle];
    [self.view addSubview:self.inforTextView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - setter
- (void)setContent:(NSString *)content{
    _content = content;
    NSAttributedString *attributedStr = [TransStringToHtmlString getHtmlAttributedStringWithString:_content];
    self.inforTextView.attributedText = attributedStr;
}


@end
