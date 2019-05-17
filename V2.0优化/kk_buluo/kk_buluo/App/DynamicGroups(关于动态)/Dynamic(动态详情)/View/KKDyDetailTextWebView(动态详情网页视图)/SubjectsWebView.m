
//  SubjectsWebView.m
//  JCZJ
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//
#import "AppDelegate.h"
#import "SubjectsWebView.h"

#import "DPImagePinchView.h"
#import "ThirdWebViewController.h"
//#import "JumpApps.h"

@interface SubjectsWebView(){
    NSMutableSet *htmlStrSet;
    UIView *bgCoverView;
    NSMutableArray *imageUrlArray;
    UIScrollView *scrollerView;
    UIPageControl *pageControl;
    UIButton *saveBtn;
}

@end

@implementation SubjectsWebView
@synthesize finishCallbackBlock;

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        htmlStrSet=[[NSMutableSet alloc]init];
        imageUrlArray=[[NSMutableArray alloc]init];
        self.scrollView.scrollEnabled=NO;

        self.navigationDelegate = self;
    }
    return self;
}
- (void)loadWebWithHtmlStr:(NSString *)htmlStr withFinishCallbackBlock:(void (^)(NSString *))block{
    if ([HHObjectCheck isEmpty:htmlStr]) {
        block(@"empty");
    }else{
        [self loadHTMLString:htmlStr baseURL:[NSURL URLWithString:@"myhtml"]];
    }
    if (block) {
        self.finishCallbackBlock=block;
    }

    //    [self loadHTMLString:@"<p><iframe src=\"http://player.youku.com/embed/XMjc4MzE3ODk2NA==\"></iframe><br /></p>" baseURL:nil];
}

#pragma mark -webViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *path=[[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([path hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [path substringFromIndex:@"myweb:imageClick:".length];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"imageDataMid" withString:@"imageData"];
        if (bgCoverView) {
            //设置不隐藏，还原放大缩小，显示图片
            bgCoverView.hidden = NO;

            NSInteger index = [imageUrlArray indexOfObject:imageUrl];
            pageControl.currentPage = index;

            scrollerView.contentOffset = CGPointMake(index * (SCREEN_WIDTH - 20), 0);

            DPImagePinchView *imgScrollView =  [scrollerView viewWithTag:10000 + index ] ;
            UIImageView *imgView = imgScrollView.imageView  ;

            //            UIImageView *imgView = [_scrollerView viewWithTag:10000 + _pageControl.currentPage] ;
            if (imgView.image) {
                saveBtn.enabled = YES ;
            }else {
                saveBtn.enabled  = NO ;
            }

            [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[pageControl.currentPage]]  placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                saveBtn.enabled = YES ;

            }];

        } else{

            //            [self showBigImage:imageUrl];    //创建视图并显示图片
        }

        return NO;

    }
    else if ([path hasPrefix:@"http"]){

        {
            NSRange range = [path rangeOfString:@"userId="];//判断字符串是否包含
            if (range.location == NSNotFound) {
                if (navigationType == UIWebViewNavigationTypeLinkClicked) {

                    ThirdWebViewController *thirdWebVC = [[ThirdWebViewController alloc] init];
                    thirdWebVC.url = path;
                    UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [appRootVC pushViewController:thirdWebVC animated:YES];
                }else{
                    return YES;
                }

            }else{
                NSString *userId = [path substringFromIndex:range.location+7];
                if (userId.length>0) {
                    //                    PersonalPageViewController *personalVC = [[PersonalPageViewController alloc] init];
                    //
                    //                    personalVC.userId =  userId;
                    //                    UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    //                    [appRootVC pushViewController:personalVC animated:YES];
                }
            }
        }
        return NO;
    } else if ([path hasPrefix:@"file://myhtml/bizid"]||[path hasPrefix:@"file:///bizid"]){
        {
            NSRange range = [path rangeOfString:@"bizid="];//判断字符串是否包含
            if (range.location == NSNotFound) {
            }else{
                //                NSString *bizId = [path substringFromIndex:range.location+6];
                //                ZQXiManagerVC *managerVC = [[ZQXiManagerVC alloc]init];
                //
                //                managerVC.bizIdStr = bizId;
                //                managerVC.mangerType = COM;
                //                UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                //                [appRootVC pushViewController:managerVC animated:YES];

            }
            return NO;
        }
    }else if ([path hasPrefix:@"file://myhtml/btbizid"]||[path hasPrefix:@"file:///btbizid"]){
        {
            //            NSRange range = [path rangeOfString:@"btbizid="];//判断字符串是否包含
            //            if (range.location == NSNotFound) {
            //            }else{
            //                NSString *bizId = [path substringFromIndex:range.location+8];
            //
            //                LQRaceAnalysisViewController *anaysis=[[LQRaceAnalysisViewController alloc]init];
            //                anaysis.bizIdStr=bizId;
            //                anaysis.menuTypeStr=@"ANA";
            //                UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            //                [appRootVC pushViewController:anaysis animated:YES];
            //
            //            }
            return NO;
        }
    }
    else if ([path hasSuffix:@"finishloadhtml"]){

        return NO;
    }else if ([path hasPrefix:@"file://myhtml/createrUserId"]||[path hasPrefix:@"file:///createrUserId"]){
        NSArray *array = [path componentsSeparatedByString:@"&"];
        if ([array count]>1) {
        }

    }else if ([path hasPrefix:@"file://myhtml/notin91"]||[path hasPrefix:@"file:///notin91"]){
    }else if ([path hasPrefix:@"file://myhtml/floorTap"]||[path hasPrefix:@"file:///floorTap"]){

    }else if ([path hasPrefix:@"file://myhtml/appsPurchaseNo"]||[path hasPrefix:@"file:///appsPurchaseNo"]){

        NSString *isShow = [[NSUserDefaults standardUserDefaults]objectForKey:@"JumpBtnIsShow"];
        if ([isShow isEqualToString:@"0"]) {

            BBLOG (@"隐藏功能");
        }else if ([isShow isEqualToString:@"1"]){
            BBLOG (@"不隐藏功能");

            NSArray *array = [path componentsSeparatedByString:@"/"];
            if ([array count]>3) {
                NSMutableDictionary *typeDic=[[NSMutableDictionary alloc]init];
                NSString *dataGBK = [array[[array count]-1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [typeDic setObject:dataGBK forKey:@"message"];
                [typeDic setObject:array[[array count]-2] forKey:@"name"];
                //                [JumpApps jumpWithPlatformCreationType:typeDic andAppPurchaseNo:array[[array count]-3]];
            }

        }

    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    NSString *imageUrls = [webView stringByEvaluatingJavaScriptFromString:@"var images= document.querySelectorAll('img[src*=\"imageDataMidUrl\"],img[src*=\"image.resource\"]');\
                           var imageUrls = \"\";\
                           for(var i = 0; i < images.length; i++)\
                           {var image = images[i];\
                           imageUrls += image.src;imageUrls += \",\";}imageUrls.toString();"];

    //获得所有图片数组
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];

    if ([htmlStrSet containsObject:currentURL]) {
        BBLOG (@"已经加载过图片");
    }else {
        [htmlStrSet addObject:currentURL];

        if (imageUrls) {
            NSArray *arr = [imageUrls componentsSeparatedByString:@","];
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
            if (![[muArr lastObject] length]) {
                [muArr removeLastObject];
            }

            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (NSString *imageUrlMidStr in muArr) {

                [tempArr addObject:imageUrlMidStr];
            }
            [imageUrlArray addObject:tempArr];
        }

    }
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    webView.frame=CGRectMake(0, webView.frame.origin.y, SCREEN_WIDTH, height+10);
    [webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];

    self.frame=CGRectMake(0, self.frame.origin.y, SCREEN_WIDTH, webView.frame.size.height);

    if (finishCallbackBlock) {
        finishCallbackBlock(nil);
        finishCallbackBlock=nil;
    }

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if([error code] == NSURLErrorCancelled)
    {        return;

    }else{
        if (self.finishCallbackBlock) {
            self.finishCallbackBlock([NSString stringWithFormat:@"%@",error]);
            finishCallbackBlock=nil;
        }

    }
}
#pragma mark 显示大图片
- (void)showBigImage:(NSString *)imageUrl {
//    NSUInteger curIndex = 0;
//    BBLOG (@"点击的是第%zd个", curIndex);

    for (NSArray *arr in imageUrlArray) {
        if ([arr containsObject:imageUrl]) {

//            curIndex = [arr indexOfObject:imageUrl];
            break;
        }
    }

//    DPImageShowViewControl *viewControl = [[DPImageShowViewControl alloc] initWitImageUrlStrs:imageUrlArray[0] currentIndex:curIndex];
//    viewControl.modalPresentationStyle = UIModalPresentationCustom;
//    //    viewControl.transitioningDelegate = self;
//    [[self viewController] presentViewController:viewControl animated:NO completion:nil];

    return;

}
//获取view的controller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;
    
    NSString *path=[[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([path hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [path substringFromIndex:@"myweb:imageClick:".length];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"imageDataMid" withString:@"imageData"];
        if (bgCoverView) {
            //设置不隐藏，还原放大缩小，显示图片
            bgCoverView.hidden = NO;
            
            NSInteger index = [imageUrlArray indexOfObject:imageUrl];
            pageControl.currentPage = index;
            
            scrollerView.contentOffset = CGPointMake(index * (SCREEN_WIDTH - 20), 0);
            
            DPImagePinchView *imgScrollView =  [scrollerView viewWithTag:10000 + index ] ;
            UIImageView *imgView = imgScrollView.imageView  ;
            
            //            UIImageView *imgView = [_scrollerView viewWithTag:10000 + _pageControl.currentPage] ;
            if (imgView.image) {
                saveBtn.enabled = YES ;
            }else {
                saveBtn.enabled  = NO ;
            }
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrlArray[pageControl.currentPage]]  placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                saveBtn.enabled = YES ;
                
            }];
            
        } else{
            
            //            [self showBigImage:imageUrl];    //创建视图并显示图片
        }
        
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }
    else if ([path hasPrefix:@"http"]){
        
        {
            NSRange range = [path rangeOfString:@"userId="];//判断字符串是否包含
            if (range.location == NSNotFound) {
                if (navigationAction.navigationType == UIWebViewNavigationTypeLinkClicked) {
                    
                    ThirdWebViewController *thirdWebVC = [[ThirdWebViewController alloc] init];
                    thirdWebVC.url = path;
                    UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [appRootVC pushViewController:thirdWebVC animated:YES];
                }else{
                    decisionHandler(WKNavigationResponsePolicyAllow);
                }
                
            }else{
                NSString *userId = [path substringFromIndex:range.location+7];
                if (userId.length>0) {
                    //                    PersonalPageViewController *personalVC = [[PersonalPageViewController alloc] init];
                    //
                    //                    personalVC.userId =  userId;
                    //                    UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    //                    [appRootVC pushViewController:personalVC animated:YES];
                }
            }
        }
//        return NO;
    } else if ([path hasPrefix:@"file://myhtml/bizid"]||[path hasPrefix:@"file:///bizid"]){
        {
            NSRange range = [path rangeOfString:@"bizid="];//判断字符串是否包含
            if (range.location == NSNotFound) {
            }else{
                //                NSString *bizId = [path substringFromIndex:range.location+6];
                //                ZQXiManagerVC *managerVC = [[ZQXiManagerVC alloc]init];
                //
                //                managerVC.bizIdStr = bizId;
                //                managerVC.mangerType = COM;
                //                UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                //                [appRootVC pushViewController:managerVC animated:YES];
                
            }
            decisionHandler(WKNavigationResponsePolicyCancel);
        }
    }else if ([path hasPrefix:@"file://myhtml/btbizid"]||[path hasPrefix:@"file:///btbizid"]){
        {
            //            NSRange range = [path rangeOfString:@"btbizid="];//判断字符串是否包含
            //            if (range.location == NSNotFound) {
            //            }else{
            //                NSString *bizId = [path substringFromIndex:range.location+8];
            //
            //                LQRaceAnalysisViewController *anaysis=[[LQRaceAnalysisViewController alloc]init];
            //                anaysis.bizIdStr=bizId;
            //                anaysis.menuTypeStr=@"ANA";
            //                UINavigationController *appRootVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            //                [appRootVC pushViewController:anaysis animated:YES];
            //
            //            }
            decisionHandler(WKNavigationResponsePolicyCancel);
        }
    }
    else if ([path hasSuffix:@"finishloadhtml"]){
        
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else if ([path hasPrefix:@"file://myhtml/createrUserId"]||[path hasPrefix:@"file:///createrUserId"]){
        NSArray *array = [path componentsSeparatedByString:@"&"];
        if ([array count]>1) {
        }
        
    }else if ([path hasPrefix:@"file://myhtml/notin91"]||[path hasPrefix:@"file:///notin91"]){
    }else if ([path hasPrefix:@"file://myhtml/floorTap"]||[path hasPrefix:@"file:///floorTap"]){
        
    }else if ([path hasPrefix:@"file://myhtml/appsPurchaseNo"]||[path hasPrefix:@"file:///appsPurchaseNo"]){
        
        NSString *isShow = [[NSUserDefaults standardUserDefaults]objectForKey:@"JumpBtnIsShow"];
        if ([isShow isEqualToString:@"0"]) {
            
            BBLOG (@"隐藏功能");
        }else if ([isShow isEqualToString:@"1"]){
            BBLOG (@"不隐藏功能");
            
            NSArray *array = [path componentsSeparatedByString:@"/"];
            if ([array count]>3) {
                NSMutableDictionary *typeDic=[[NSMutableDictionary alloc]init];
                NSString *dataGBK = [array[[array count]-1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [typeDic setObject:dataGBK forKey:@"message"];
                [typeDic setObject:array[[array count]-2] forKey:@"name"];
                //                [JumpApps jumpWithPlatformCreationType:typeDic andAppPurchaseNo:array[[array count]-3]];
            }
            
        }
        
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
     [webView evaluateJavaScript:@"var images= document.querySelectorAll('img[src*=\"imageDataMidUrl\"],img[src*=\"image.resource\"]');\
                           var imageUrls = \"\";\
                           for(var i = 0; i < images.length; i++)\
                           {var image = images[i];\
                           imageUrls += image.src;imageUrls += \",\";}imageUrls.toString();" completionHandler:^(id _Nullable imageUrlsStr, NSError * _Nullable error) {
                               NSString *imageUrls = imageUrlsStr;
                               [webView evaluateJavaScript:@"document.documentElement.innerHTML" completionHandler:^(id _Nullable str, NSError * _Nullable error) {
                                   NSString *currentURL = str;
                                   if ([htmlStrSet containsObject:currentURL]) {
                                       BBLOG (@"已经加载过图片");
                                   }else {
                                       [htmlStrSet addObject:currentURL];
                                       
                                       if (imageUrls) {
                                           NSArray *arr = [imageUrls componentsSeparatedByString:@","];
                                           NSMutableArray *muArr = [NSMutableArray arrayWithArray:arr];
                                           if (![[muArr lastObject] length]) {
                                               [muArr removeLastObject];
                                           }
                                           
                                           NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                                           for (NSString *imageUrlMidStr in muArr) {
                                               
                                               [tempArr addObject:imageUrlMidStr];
                                           }
                                           [imageUrlArray addObject:tempArr];
                                       }
                                       
                                   }
                                   [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable heig, NSError * _Nullable error) {
                                       CGFloat height = [heig floatValue];
                                       webView.frame=CGRectMake(0, webView.frame.origin.y, SCREEN_WIDTH, height+10);
                                       [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
                                       [webView evaluateJavaScript:@"document.body.style.webkitTouchCallout='none';" completionHandler:nil];
                                       
                                       self.frame=CGRectMake(0, self.frame.origin.y, SCREEN_WIDTH, webView.frame.size.height);
                                       
                                       if (finishCallbackBlock) {
                                           finishCallbackBlock(nil);
                                           finishCallbackBlock=nil;
                                       }
                                   }];
                               }];
                               
                           }];
    
    //获得所有图片数组
    
    
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if([error code] == NSURLErrorCancelled)
    {        return;
        
    }else{
        if (self.finishCallbackBlock) {
            self.finishCallbackBlock([NSString stringWithFormat:@"%@",error]);
            finishCallbackBlock=nil;
        }
        
    }
}


-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if([error code] == NSURLErrorCancelled)
    {        return;
        
    }else{
        if (self.finishCallbackBlock) {
            self.finishCallbackBlock([NSString stringWithFormat:@"%@",error]);
            finishCallbackBlock=nil;
        }
        
    }
}


-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    // 被处理的证书
    NSURLCredential *credential = nil;
    
    //先导入证书
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"kkbuluonet" ofType:@".cer"]; //证书的路径
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
    NSArray *trustedCertificates = @[CFBridgingRelease(certificate)];
    
    //1)获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    //注意：这里将之前导入的证书设置成下面验证的Trust Object的anchor certificate
    SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)trustedCertificates);
    //2)SecTrustEvaluate会查找前面SecTrustSetAnchorCertificates设置的证书或者系统默认提供的证书，对trust进行验证
    
    SecTrustSetAnchorCertificatesOnly(trust, NO);
    
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess &&
        (result == kSecTrustResultProceed ||
         result == kSecTrustResultUnspecified)) {
            
            //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
            credential = [NSURLCredential credentialForTrust:trust];
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            
            
        }
    completionHandler(disposition,credential);
    
}


@end
