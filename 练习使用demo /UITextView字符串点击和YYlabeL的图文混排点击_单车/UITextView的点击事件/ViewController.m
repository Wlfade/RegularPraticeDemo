//
//  ViewController.m
//  UITextView的点击事件
//
//  Created by 单车 on 2018/11/29.
//  Copyright © 2018 单车. All rights reserved.
//

#import "ViewController.h"
#import "NSAttributedString+YYText.h"
#import "YYLabel.h"

@interface ViewController ()
<UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatClickYYLabel];

}
//可点击的YYlabel
- (void)creatClickYYLabel{

    YYLabel *nickName = [[YYLabel alloc]init];
    nickName.frame = CGRectMake(100, 100, 100, 100);
    nickName.font = [UIFont systemFontOfSize:13];
    nickName.userInteractionEnabled = YES;
    nickName.numberOfLines = 0;
    [self.view addSubview:nickName];

    NSString *userNameStr = @"用户名字fefeefefefefefeeeeeeeeeeeeeeeee";
    //用户名
    NSMutableAttributedString *userName = [[NSMutableAttributedString alloc]initWithString:userNameStr attributes:@{
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:13]

                                                                                                        }];
    //用户名 的点击触发
    __weak typeof(self) weakSelf = self;
    [userName yy_setTextHighlightRange:NSMakeRange(0, userNameStr.length) color:[UIColor redColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"名字被点击");
        [weakSelf showAlertView:@"昵称"];
    }];

    UIImage *autherImage = [UIImage imageNamed:@"作者"];
    autherImage = [UIImage imageWithCGImage:autherImage.CGImage scale:2 orientation:UIImageOrientationUp];

    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:autherImage contentMode:UIViewContentModeCenter attachmentSize:autherImage.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];

    [attachText yy_setTextHighlightRange:NSMakeRange(0, attachText.length) color:[UIColor redColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"作者图片被点击");
        [weakSelf showAlertView:@"作者图片被点击"];
    }];

    //加标签
    [userName appendAttributedString:attachText];

    //赋值
//    timeLabel.attributeUserName = userName;
    nickName.attributedText = userName;
}

//普通的textView
- (void)normalText{
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.font = [UIFont systemFontOfSize:20];
//    textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
//    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;

    textView.editable = NO;
    textView.text = @"\r\n我的手机号不是： 13888888888 \r\n\r\n"
    "我的博客刚刚在线网址： www.xxxxxx.com \r\n\r\n"
    "我的邮箱： worldligang@163.com \r\n\r\n";
    [self.view addSubview:textView];

}
//创建可点击文字
- (void)creatClickText{
    UITextView *retextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 500)];
    retextView.dataDetectorTypes = UIDataDetectorTypeNone;
    retextView.backgroundColor = [UIColor purpleColor];
    retextView.delegate = self;
    retextView.editable = NO;
    retextView.scrollEnabled = NO;

    //textView的内边距修改
    retextView.textContainer.lineFragmentPadding = 0;

    retextView.textContainerInset = UIEdgeInsetsZero;

    [self.view addSubview:retextView];


    NSArray *strings = @[@"测试文字1",@"测试文字2",@"测试文字3"];
    NSString *content = [strings componentsJoinedByString:@""];

    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:[UIColor redColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:14]
                                 };

    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:content attributes:attributes];

    NSRange rang0 = [content rangeOfString:strings[0]];
    NSRange rang1 = [content rangeOfString:strings[1]];
    NSRange rang2 = [content rangeOfString:strings[2]];

    [attributeStr addAttributes:@{
                                  NSFontAttributeName:[UIFont systemFontOfSize:16],
                                  NSForegroundColorAttributeName:[UIColor yellowColor]
                                  } range:rang1];

    [attributeStr addAttributes:@{
                                  NSFontAttributeName:[UIFont systemFontOfSize:14],
                                  NSForegroundColorAttributeName:[UIColor blueColor]
                                  } range:rang2];

    // 1.必须要用前缀（firstPerson，secondPerson），随便写但是要有

    // 2.要有后面的方法，如果含有中文，url会无效，所以转码



    NSString *valueString2 = [[NSString stringWithFormat:@"personal2://%@",strings[2]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    [attributeStr addAttribute:NSLinkAttributeName value:valueString2 range:rang2];

    retextView.attributedText = attributeStr;
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([[URL scheme] isEqualToString:@"personal2"]) {
        NSString *titleString = [NSString stringWithFormat:@"你点击了第二个文字:%@",[URL host]];
        NSLog(@"%@",titleString);
        return NO;
    }
    return YES;
}

- (void)showAlertView:(NSString *)string{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
