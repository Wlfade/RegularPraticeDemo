//
//  KKAddFriendSearchView.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKAddFriendSearchView.h"
#import "JCValidation.h"

@interface KKAddFriendSearchView()<UITextFieldDelegate>

@end

@implementation KKAddFriendSearchView{
    UIImageView *clearImage;
    UITextField *inputTF;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self configSubView];
    }
    return self;
}

-(void)configSubView{
    
    UIView *inputView = [self getInputView];
    [self addSubview:inputView];
    
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(inputView.right, 0, [ccui getRH:59], self.height)];
    cancelLabel.textColor = RGB(51, 51, 51);
    cancelLabel.text = @"取消";
    cancelLabel.font = [UIFont systemFontOfSize:13];
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cancelLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
    cancelLabel.userInteractionEnabled = YES;
    [cancelLabel addGestureRecognizer:tap];
}

-(UIView *)getInputView{
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, [ccui getRH:10], [ccui getRH:309], [ccui getRH:30])];
    inputView.centerY = self.centerY;
    inputView.backgroundColor = RGB(244, 244, 244);
    
    UIImageView *leftGraySearchImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_friedn_left_gray_search"]];
    leftGraySearchImage.frame = CGRectMake([ccui getRH:5], [ccui getRH:8], [ccui getRH:14], [ccui getRH:14]);
    [inputView addSubview:leftGraySearchImage];
    
    inputTF = [[UITextField alloc] initWithFrame:CGRectMake(leftGraySearchImage.right+[ccui getRH:4], 0, [ccui getRH:249], inputView.height)];
    inputTF.font = [UIFont systemFontOfSize:14];
    inputTF.keyboardType = UIKeyboardTypeNumberPad;
    inputTF.textColor = RGB(102, 102, 102);
    inputTF.placeholder = @"请输入关键字或手机号";
    [inputView addSubview:inputTF];
    [inputTF becomeFirstResponder];
    inputTF.delegate = self;

    clearImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_friend_right_clear"]];
    clearImage.frame = CGRectMake(inputTF.right, 0, [ccui getRH:34], inputView.height);
    clearImage.contentMode = UIViewContentModeCenter;
    [inputView addSubview:clearImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearTextfield:)];
    clearImage.userInteractionEnabled = YES;
    [clearImage addGestureRecognizer:tap];
    
    return inputView;
}

-(void)cancelClick:(UITapGestureRecognizer *)gesture{
    self.cancelClick();
}

-(void)clearTextfield:(UITapGestureRecognizer *)gesture{
    inputTF.text = @"";
    self.textChangeBlock(@"");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == inputTF) {
        if (inputTF.text.length < 11) {
            if(string.length == 0){
                self.textChangeBlock([inputTF.text substringToIndex:inputTF.text.length-1]);
            }else{
                self.textChangeBlock([inputTF.text stringByAppendingString:string]);
            }
            return YES;
        }
        //so easy
        else if (inputTF.text.length >= 11) {
            if(string.length == 0){
                self.textChangeBlock([textField.text substringToIndex:10]);
                return YES;
            }
            self.textChangeBlock([textField.text substringToIndex:11]);
            return NO;
        }
    }
    return YES;
}
@end
