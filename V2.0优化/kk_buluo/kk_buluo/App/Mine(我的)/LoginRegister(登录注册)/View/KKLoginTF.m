//
//  KKLoginTF.m
//  KKTribe
//
//  Created by lidaoyuan on 2018/7/13.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "KKLoginTF.h"

CGFloat KKLoginTF_leftSpace = 5;

@interface KKLoginTF ()

@end

@implementation KKLoginTF

#pragma mark - life circle


#pragma mark - UI
-(void)setupSubviews {
    
    self.backgroundColor = UIColor.whiteColor;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    //1.itemV
    UIView *itemV;
    //1.1 icon
    if (KKLoginTfItemTypeIcon == self.itemType) {
        self.iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(KKLoginTF_leftSpace, 0, 20*SCREEN_WIDTH_SCALE_6, 20*SCREEN_WIDTH_SCALE_6)];
        self.iconImgV.top = (selfHeight - self.iconImgV.height) /2.0;
        [self addSubview:self.iconImgV];
        itemV = self.iconImgV;
        
    }else {//1.2 itemLabel
        self.itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(KKLoginTF_leftSpace, 0, 60, 20)];
        self.itemLabel.textColor = COLOR_HEX(0x999999);
        self.itemLabel.font = [UIFont systemFontOfSize:12*SCREEN_WIDTH_SCALE_6];
        self.itemLabel.textAlignment = NSTextAlignmentLeft;
        self.itemLabel.top = (selfHeight-20)/2.0;
        [self addSubview:self.itemLabel];
        itemV = self.itemLabel;
    }
    
    //2.输入textField
    self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(itemV.right + KKLoginTF_leftSpace, 0, selfWidth - CGRectGetMaxX(itemV.frame) - KKLoginTF_leftSpace, self.height)];
    self.inputTextField.textColor = [UIColor whiteColor];
    self.inputTextField.font = [UIFont systemFontOfSize:13];
    self.inputTextField.backgroundColor = [UIColor clearColor];
    self.inputTextField.textColor = [UIColor blackColor];
    [self addSubview:self.inputTextField];
    
    //3.sepLine
    self.separateLine = [[UIView alloc] initWithFrame:CGRectMake(10, selfHeight - 2, selfWidth - 20, 1)];
    self.separateLine.backgroundColor = COLOR_HEX(0xEEEEEE);
    [self addSubview:self.separateLine];
    
    //4.tap
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
    [self addGestureRecognizer:tapGr];
}


-(void)setupWithItem:(NSString *)itemStr placeholder:(NSString *)placeholder {
    //1.item
    if (![HHObjectCheck isEmpty:itemStr]) {
        if (KKLoginTfItemTypeIcon == self.itemType) {
            self.iconImgV.image = [UIImage imageNamed:itemStr];
        }else{
            self.itemLabel.text = itemStr;
        }
    }
    //2.placeholder
    NSAttributedString *aStr = [[NSAttributedString alloc]initWithString:placeholder attributes:@{NSForegroundColorAttributeName : rgba(224, 224, 224, 1), NSFontAttributeName : [UIFont systemFontOfSize:13] }];
    self.inputTextField.attributedPlaceholder = aStr;
}

#pragma mark - setter
-(void)setRightView:(UIView *)rightView {
    
    //1.移除之前的rightVieiw
    if(_rightView){
        [_rightView removeFromSuperview];
    }
    //2.赋值
    _rightView = rightView;

    //3.add处理
    rightView.right = self.width - KKLoginTF_leftSpace;
    rightView.top = (self.height - rightView.height)/2;
    [self addSubview:rightView];
    self.inputTextField.width = CGRectGetMinX(rightView.frame) - 5 - CGRectGetMinX(self.inputTextField.frame);
}

-(void)setItemType:(KKLoginTfItemType)itemType {
    _itemType = itemType;
    [self setupSubviews];
}


#pragma mark - interaction
- (void)tapSelf {
    [self.inputTextField becomeFirstResponder];
}
 

@end
