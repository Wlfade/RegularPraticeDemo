//
//  KKMoreInfoViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMoreInfoViewController.h"
#import "KKWebAppMoreInfo.h"
@interface KKMoreInfoViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation KKMoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"更多资料"];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT)];
    _textView.editable = NO;
    [self.view addSubview:_textView];
    [self requestWebAppMoreInfoData];
}
- (void)requestWebAppMoreInfoData {
    WS(weakSelf)
    [KKWebAppService shareInstance].appId = self.appInfo.ID;
    [KKWebAppService requestWebAppMoreInfoDataSuccess:^(KKWebAppMoreInfo * _Nonnull moreInfo) {
        NSString *centent = [NSString stringWithFormat:@"\n\n\n%@\n%@\n\n\n%@\n%@\n\n\n%@\n%@\n\n\n%@\n%@\n\n\n%@\n%@\n\n\n%@\n%@\n\n",@"开发者", moreInfo.creator, @"服务及数据由以下网址提供", moreInfo.applicationUrl, @"用户隐私及数据提示", moreInfo.statement,@"服务类目", moreInfo.catagor, @"名称记录", moreInfo.record, @"服务声明", moreInfo.userPrivacy];
        weakSelf.textView.text = centent;
        weakSelf.textView.font = [ccui getRFS:17];
        weakSelf.textView.textColor = COLOR_BLACK_TEXT;
    }];
}
@end
