//
//  KKWebAppViewController.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKWebAppViewController.h"
#import "KKWepAppAuthorizationView.h"
#import "KKWepAppAboutViewController.h"
#import "KKApplicationInfo.h"
#import "KKCloseWebAppView.h"
#import "KKWepAppAboutViewController.h"
#import <WebKit/WebKit.h>
#import "KKMyFriendViewController.h"
#import "KKChatAppMsgContent.h"
#import "KKChatVC.h"
#import "KKDiscoverVC.h"
#import "KKMyWebAppListViewController.h"
#import "KKPersonalPageController.h"
#import "KKChatSetGuildVC.h"
@interface KKWebAppViewController ()
<
KKAuthorizationViewDelegate,
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler
>
@property (nonatomic, strong) KKWepAppAuthorizationView *authorizationView;
@property (nonatomic, strong) WKWebView *wkwebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) KKApplicationInfo *applicationInfo;
@property (nonatomic, strong) KKCloseWebAppView *rightItem;
@end

@implementation KKWebAppViewController

#pragma mark - lazy load
- (KKWepAppAuthorizationView *)authorizationView {
    if (!_authorizationView) {
        _authorizationView = [[KKWepAppAuthorizationView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT)];
        _authorizationView.delegate = self;
        [_authorizationView.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.appInfo.logoUrl]];
    }
    return _authorizationView;
}

- (UIProgressView *)progressView
{
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT + 1, SCREEN_WIDTH, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建wkWebView
    [self createWkWebView];
    //2.进度条
    [self.view addSubview:self.progressView];
    //3.navi
    [self setupNavi];
    
    //4.scriptMsgHandler
    [self.wkwebView.configuration.userContentController addScriptMessageHandler:self name:@"showAuthView"];
    [self.wkwebView.configuration.userContentController addScriptMessageHandler:self name:@"requestUserAuthStatus"];
    
    //5.返回
    if ([self.wkwebView canGoBack]) {
        [self hideBackButton:NO];
    }else {
        [self hideBackButton:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    //1.移除观察者
    [self webViewRemoveObserver];
    
    //2.移除scriptMsgHandler
    WKUserContentController *userCC = self.wkwebView.configuration.userContentController;
    [userCC removeScriptMessageHandlerForName:@"showAuthView"];
    [userCC removeScriptMessageHandlerForName:@"requestUserAuthStatus"];
}


#pragma mark - UI
-(void)setupNavi {
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self requestAboutWebAppDetailDataFrom:@"normal"];
    
    //right button
    _rightItem = [[KKCloseWebAppView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 89 - 10, STATUS_BAR_HEIGHT, 89, 35)];
    
    //关闭按钮, 操作应用
    WS(weakSelf)
    _rightItem.webAppCloseBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _rightItem.webAppOperationBlock = ^{
        [weakSelf requestAboutWebAppDetailDataFrom:@"more"];
    };
}

- (void)createWkWebView {
    /// 创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    /// 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    /// 最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0.0;
    /// 设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    /// 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    /// 自适应屏幕的宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    /// 添加js调用
    [config.userContentController addUserScript:wkUserScript];
    /// 这个类主要用来做native与JavaScript的交互管理
    
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT) configuration:config];
    
    [self.view addSubview:_wkwebView];
    /// Load WebView
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.appInfo.cdnUrl]];
    [self.wkwebView loadRequest:request];
    
#if 0
    /// https://m.jd.com/
    /// http://192.168.2.132/home/test/thirdLogin.htm
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://m-user.kknew.net/home/test/thirdLogin.htm"]];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://m.jd.com/"]];
    [self.wkwebView loadRequest:request];
#endif
    
#if 0
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"k5" ofType:@"html"];
    [self.wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:bundleStr]]];
#endif
    
    // UI代理
    _wkwebView.UIDelegate = self;
    // 导航代理
    _wkwebView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _wkwebView.allowsBackForwardNavigationGestures = YES;
    
    // 添加监测网页加载进度的观察者
    [self webViewAddObserver];
    
}

#pragma mark - interaction
- (void)clickBackButton {
    if ([self.wkwebView canGoBack]) {
        [self.wkwebView goBack];
    }
}

- (void)closeButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 显示授权
 */
- (void)showAuthView {
    [self.view addSubview:self.authorizationView];
    self.authorizationView.webAppNameLabel.text = self.applicationInfo.name;
    [self.authorizationView.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.applicationInfo.logoUrl]];
}

/**
 显示关闭按钮
 */
- (void)showCloseButton {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(SCREEN_WIDTH - 40, STATUS_BAR_HEIGHT  + 10, 20, 20);
    [self.naviBar addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"webAppClose"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

/**
 展示操作视图 ,推荐给朋友", @"从我的应用移除", @"关于我的应用;
 */
- (void)showPopViewAction {
    WS(weakSelf)
    /// 这里判断应用是否添加
    NSArray *optionArray;
    if (self.applicationInfo.collect.integerValue == 0) {
        optionArray = @[@"推荐给朋友", @"添加到我的应用", @"关于应用"];
    }else {
        optionArray = @[@"推荐给朋友", @"从我的应用中移除", @"关于应用"];
    }
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray completion:^(NSInteger index) {
        if (index == 0) {
            [weakSelf pushToMyFriendListVC];
        }else if (index == 1){
            if ([optionArray[index] isEqualToString:@"添加到我的应用"]) {
                [weakSelf requestAddWebAppToCollection];
            }else {
                [weakSelf requestDeleteWebAppFromCollection];
            }
        }else if (index == 2){
            [self pushToWebAppAboutVC];
        }
    } cancel:^{
    }];
    [sheetView show];
}

#pragma mark - KVO
-(void)webViewAddObserver {
    [self.wkwebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:0
                        context:nil];
    // 添加监测网页标题title的观察者
    [self.wkwebView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

-(void)webViewRemoveObserver {
    //移除观察者
    [self.wkwebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkwebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
}

/**
 observeValueForKeyPath: 监听进度
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _wkwebView) {
        NSLog(@"网页加载进度 = %f",_wkwebView.estimatedProgress);
        self.progressView.progress = _wkwebView.estimatedProgress;
        if (_wkwebView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == _wkwebView){
        self.navigationItem.title = _wkwebView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - delegate
#pragma mark KKAuthorizationViewDelegate
- (void)authorizationViewDidSelectedReject {
    WS(weakSelf)
    /// 将结果返回给js
    /// NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"authorizationViewDidSelectedReject"];
    /// 给js传递一个拒绝的信息
    NSString *jsStr = [NSString stringWithFormat:@"callPermissionFalse()"];
    [self.wkwebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
        [weakSelf.authorizationView removeFromSuperview];
    }];
}

/**
 允许授权
 */
- (void)authorizationViewDidSelectedAgree{
    [self requestUserAuth];
}

#pragma mark WKScriptMessageHandler
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"showAuthView"]) {
        [self showAuthView];
    }else if ([message.name isEqual:@"requestUserAuthStatus"]){
        [self requestUserAuthStatus];
    }
}

/**
 toJSNotes

 @param notes 这是一段测试代码, 不用删除以后还可能用到
 */
- (void)toJSNotes:(NSString *)notes {
    NSString * jsStr = [NSString stringWithFormat:@"authStatus()"];
    [self.wkwebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
}
#pragma mark WKNavigationDelegate
/// 页面开始加载时调用, WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}

/// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
#if 0
    NSString *path = [[NSBundle mainBundle]pathForResource:@"data.txt" ofType:nil];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.wkwebView evaluateJavaScript:str completionHandler:nil];
#endif
    /// 页面加载完成之后, 判断按钮的隐藏状态, 之后进入的多层,才会显示按钮
    if ([self.wkwebView canGoBack]) {
        [self hideBackButton:NO];
    }else {
        [self hideBackButton:YES];
    }
}

/// 提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}

/// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}


#pragma mark - jump


/**
 跳转选择朋友页面
 */
- (void)pushToMyFriendListVC {
    WS(weakSelf);
    KKMyFriendViewController *myFriendVC = [[KKMyFriendViewController alloc]init];
    myFriendVC.selectedBlock = ^(KKContactUserInfo * _Nonnull userInfo) {
        [weakSelf sendContactCardTo:userInfo];
    };
    [self.navigationController pushViewController:myFriendVC animated:YES];
}




- (void)pushChatVCWithUserInfo:(KKContactUserInfo *)userInfo {
    KKChatVC *chatVC = [[KKChatVC alloc] init];
    chatVC.conversationType = ConversationType_PRIVATE;
    chatVC.targetId = userInfo.userId;
    chatVC.title = userInfo.loginName;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    if (self.fromWhere == KKDiscoverVCType) {
        [self lastVC:chatVC fromWhereClassVC:[KKDiscoverVC class]];
    }else if (self.fromWhere == KKMyWebAppListViewControllerType) {
        [self lastVC:chatVC fromWhereClassVC:[KKMyWebAppListViewController class]];
    }else if (self.fromWhere == KKPersonalPageControllerType) {
        [self lastVC:chatVC fromWhereClassVC:[KKPersonalPageController class]];
    }else if (self.fromWhere == KKChatSetGuildVCType){
        [self lastVC:chatVC fromWhereClassVC:[KKChatSetGuildVC class]];
    }else if (self.fromWhere == KKChatVCType) {
        [self lastVC:chatVC fromWhereClassVC:[KKPersonalPageController class]];
    }
}

-(void)pushToWebAppAboutVC {
    KKWepAppAboutViewController *aboutVC = [[KKWepAppAboutViewController alloc] init];
    aboutVC.fromWhere = self.fromWhere;
    aboutVC.appInfo = self.appInfo;
    [self.navigationController pushViewController:aboutVC animated:YES];
}

#pragma mark - request
/**
 请求当前应用的详细信息, 什么类型应用, 是否收藏
 */
- (void)requestAboutWebAppDetailDataFrom:(NSString *)from {
    [KKWebAppService shareInstance].appId = self.appInfo.ID;
    WS(weakSelf)
    if ([from isEqualToString:@"more"]) {
        [KKWebAppService requestAboutWebAppDetailDataSuccess:^(NSMutableArray * _Nonnull guildList, KKApplicationInfo * _Nonnull appInfo) {
            weakSelf.applicationInfo = appInfo;
            [weakSelf showPopViewAction];
        }];
    }else {
        [KKWebAppService requestAboutWebAppDetailDataSuccess:^(NSMutableArray * _Nonnull guildList, KKApplicationInfo * _Nonnull appInfo) {
            weakSelf.applicationInfo = appInfo;
            if (weakSelf.applicationInfo.inside.intValue == 1) {
                [weakSelf.naviBar addSubview:weakSelf.rightItem];
            }else {
                [weakSelf showCloseButton];
            }
            [weakSelf setNaviBarTitle:appInfo.name];
        }];
    }
}
/**
 添加进入我的应用
 */
- (void)requestAddWebAppToCollection {
    [KKWebAppService shareInstance].objectId = self.appInfo.ID;
    [KKWebAppService shareInstance].objectType = @"APPLICATION";
    [KKWebAppService requestWebAppAddToMyCollecttionSuccess:^{
    }];
}

/**
 删除应用从我的收藏
 */
- (void)requestDeleteWebAppFromCollection {
    [KKWebAppService shareInstance].objectId = self.appInfo.ID;
    [KKWebAppService shareInstance].objectType = @"APPLICATION";
    [KKWebAppService requestWebAppDeleteToMyCollecttionSuccess:^{
    }];
}

/**
 同意用户授权
 */
- (void)requestUserAuth {
    WS(weakSelf)
    [KKWebAppService shareInstance].appId = self.appInfo.ID;
    [KKWebAppService requestWebAppAuthSuccess:^(NSString * _Nonnull code) {
        /// Remove authView
        [weakSelf.authorizationView removeFromSuperview];
        /// 将结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"callPermissionSuccess('%@')", code];
        [weakSelf.wkwebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        }];
    }];
}

/**
 请求用户的授权应用状态
 */
- (void)requestUserAuthStatus {
    WS(weakSelf)
    [KKWebAppService shareInstance].appId = self.appInfo.ID;
    [KKWebAppService requestWebAppUserAuthStatusSuccess:^(NSString * _Nonnull authorize, NSString * _Nonnull code, NSString * _Nonnull authorizeIntro) {
        NSString *jsStr;
        /// 授权成功 authorize == 1 给js传code 否则传'空';
        if (authorize.integerValue == 0) {            
           jsStr = [NSString stringWithFormat:@"callPermissionSuccess('')"];
        }else {
           jsStr = [NSString stringWithFormat:@"callPermissionSuccess('%@')", code];
        }
        [weakSelf setAuthViewNotice:authorizeIntro];
        /// 将结果返回给js
        [weakSelf.wkwebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        }];
    } Fail:^(NSString * _Nonnull authorize) { }];
}


#pragma mark tool
/**
 setAuthViewNotice: 重新赋值授权视图的提示性文字, 比如: 允许授权将获取您的年龄 性别, 昵称等.

 @param notice 提示文字
 */
- (void)setAuthViewNotice:(NSString *)notice {
    if (!notice) {
        return;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:notice attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: [ccui getRH:20]],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    self.authorizationView.discriptionLabel.attributedText = string;
}

#pragma mark - 融云
- (void)sendContactCardTo:(KKContactUserInfo *)kUserInfo {
    //1.准备消息内容
    KKChatAppMsgContent *contactMsg = [[KKChatAppMsgContent alloc]init];
    contactMsg.idStr = _applicationInfo.ID;
    contactMsg.name = _applicationInfo.name;
    contactMsg.imgUrl = _applicationInfo.logoUrl;
    contactMsg.summary = _applicationInfo.descs;
    contactMsg.appUrl = _applicationInfo.cdnUrl;
    contactMsg.tagStr = @"推荐应用";
    //2.发送消息
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:kUserInfo.userId content:contactMsg pushContent:@"推荐应用" pushData:contactMsg.name success:^(long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf pushChatVCWithUserInfo:kUserInfo];
            [CC_NoticeView showError:@"推荐成功"];
        });
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:@"推荐失败,请重试"];
        });
    }];

}

@end
