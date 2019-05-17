//
//  SubjectsWebView.h
//  JCZJ
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef  void (^FinishCallbackBlock)(NSString *errorString);

@interface SubjectsWebView : WKWebView<WKNavigationDelegate>

@property (nonatomic,copy)FinishCallbackBlock finishCallbackBlock;

- (void)loadWebWithHtmlStr:(NSString *)htmlStr withFinishCallbackBlock:(void (^)(NSString *))block;

@end
