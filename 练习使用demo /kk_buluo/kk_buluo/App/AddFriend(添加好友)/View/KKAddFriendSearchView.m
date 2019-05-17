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

@implementation KKAddFriendSearchView

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
    
    _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(leftGraySearchImage.right+[ccui getRH:4], 0, [ccui getRH:249], inputView.height)];
    _inputTF.font = [UIFont systemFontOfSize:14];
    _inputTF.keyboardType = UIKeyboardTypeNumberPad;
    _inputTF.textColor = RGB(51, 51, 51);
    _inputTF.placeholder = @"请输入关键字或手机号";
    [inputView addSubview:_inputTF];
    [_inputTF becomeFirstResponder];
    _inputTF.delegate = self;

    _clearImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_friend_right_clear"]];
    _clearImage.frame = CGRectMake(_inputTF.right, 0, [ccui getRH:34], inputView.height);
    _clearImage.contentMode = UIViewContentModeCenter;
    [inputView addSubview:_clearImage];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearTextfield:)];
    _clearImage.userInteractionEnabled = YES;
    [_clearImage addGestureRecognizer:tap];
    
    return inputView;
}

-(void)cancelClick:(UITapGestureRecognizer *)gesture{
    self.cancelClick();
}

-(void)clearTextfield:(UITapGestureRecognizer *)gesture{
    _inputTF.text = @"";
    self.textChangeBlock(@"");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _inputTF) {
        if (_inputTF.text.length < 11) {
            if(string.length == 0){
                self.textChangeBlock([_inputTF.text substringToIndex:_inputTF.text.length-1]);
            }else{
                self.textChangeBlock([_inputTF.text stringByAppendingString:string]);
            }
            return YES;
        }
        //so easy
        else if (_inputTF.text.length >= 11) {
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
