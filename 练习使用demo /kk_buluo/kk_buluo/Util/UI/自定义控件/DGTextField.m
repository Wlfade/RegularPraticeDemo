//
//  DGTextField.m
//  DGTool
//
//  Created by jczj on 2018/11/2.
//  Copyright © 2018年 david. All rights reserved.
//

#import "DGTextField.h"

@interface DGTextField ()

@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation DGTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
         [self onInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame textFont:(CGFloat)font  textColor:(UIColor *)color bagTextColor:(UIColor *)bagColor  textAlignment:(NSTextAlignment)alignment
{
    
    self = [super initWithFrame:frame];
    if (self) {
//        [self onInit];
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        [self setTextColor:color];
        [self setValue:bagColor forKeyPath:@"_placeholderLabel.textColor"];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textAlignment = alignment;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.keyboardType = UIKeyboardTypeDefault;
        self.font = [UIFont systemFontOfSize:font];
        self.returnKeyType = UIReturnKeyDone;
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self onInit];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)onInit {
    [self addKeyboardNotifications];
    _movingView = [UIApplication sharedApplication].keyWindow;
    _originalFrame = CGRectZero;
}

- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow: (NSNotification *)notification {
    if (self.isFirstResponder) {
        CGPoint relativePoint = [self convertPoint: CGPointZero toView: [UIApplication sharedApplication].keyWindow];
        
        CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        CGFloat overstep = CGRectGetHeight(self.frame) + relativePoint.y + keyboardHeight - CGRectGetHeight([UIScreen mainScreen].bounds);
        overstep += self.offset;
        
        if (CGRectEqualToRect(self.originalFrame, CGRectZero)) {
            self.originalFrame = self.movingView.frame;
        }
        
        if (overstep > 0) {
            CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            CGRect frame = self.originalFrame;
            frame.origin.y -= overstep;
            [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
                self.movingView.frame = frame;
            } completion: nil];
        }
    }
}

- (void)keyboardWillHide: (NSNotification *)notification {
    if (self.isFirstResponder) {
        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
            self.movingView.frame = self.originalFrame;
        } completion: nil];
        self.originalFrame = CGRectZero;
    }
}



@end
